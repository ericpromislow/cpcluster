/*
 *  cpcluster.c
 *  cpcluster
 *
 *  Created by Eric Promislow on 12/11/2011.
 *  Copyright 2011 Eric Promislow. All rights reserved.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ruby.h>

#include "clusterlib.h"

static VALUE cluster_init(VALUE self) {
    return self;
}

static double calcDist(double x1, double x2, double y1, double y2) {
   double x = x1 - x2;
   double y = y1 - y2;
   return sqrt(x * x + y * y);
}

static VALUE cluster_group(VALUE self, VALUE rnodes, VALUE targetDistance, VALUE maxNumNodes) {
    // rnodes is an array of { x:float, y:float, id:int }
    int numPairs = (int) RARRAY_LEN(rnodes);
    size_t pointsMemorySize = (int) sizeof(Node) * numPairs;
    Cons *consCells = (Cons *) malloc(sizeof(Cons) * numPairs);
    Node *points;
    Node *orig_points;
    MainObj_t *p_mainObj;
    
    int i = 0, j;
    VALUE hash;
    Node *p;
    Cons *pc = consCells;
    VALUE x_href = ID2SYM(rb_intern("x"));
    VALUE y_href = ID2SYM(rb_intern("y"));
    VALUE id_href = ID2SYM(rb_intern("id"));
    VALUE ids_href = ID2SYM(rb_intern("ids"));
    VALUE idx_href = ID2SYM(rb_intern("idx"));
    VALUE numCrashes_href = ID2SYM(rb_intern("numCrashes"));
    // Locations of nearest and furthest points
    VALUE mx_href = ID2SYM(rb_intern("mx"));
    VALUE my_href = ID2SYM(rb_intern("my"));
    VALUE nx_href = ID2SYM(rb_intern("nx"));
    VALUE ny_href = ID2SYM(rb_intern("ny"));
    VALUE og_href = ID2SYM(rb_intern("og"));
    int numCrashes;
    VALUE numCrashesRb;
    
    int finalMemberCount;
    VALUE retArray;
    VALUE memberArrays;
    double d, min_dist, max_dist;
    int min_pt, max_pt;
    Node *p_memberPoint;
    
    int memberNum;
    VALUE r_memberId;

   if (!consCells) {
        fprintf(stderr, "Can't allocate %d bytes\n", (int) sizeof(MainObj_t));
        return Qnil;
    }
    points = (Node *) malloc(pointsMemorySize);
    if (!points) {
        fprintf(stderr, "Can't allocate %d bytes\n", (int) sizeof(MainObj_t));
        free(consCells);
        return Qnil;
    }
    orig_points = (Node *) malloc(pointsMemorySize);
    if (!orig_points) {
        fprintf(stderr, "Can't allocate %d bytes\n", (int) sizeof(MainObj_t));
        free(consCells);
        free(points);
        return Qnil;
    }
    p_mainObj = (MainObj_t *) malloc((int) sizeof(MainObj_t));
    if (!p_mainObj) {
       fprintf(stderr, "Can't allocate %d bytes\n", (int) sizeof(MainObj_t));
        free(consCells);
        free(orig_points);
        free(points);
        return Qnil;
    }

    p = points;
    for (i = 0; i < numPairs; i++, p++, pc++) {
        hash = rb_ary_entry(rnodes, i);
        p->x = NUM2DBL(rb_hash_aref(hash, x_href));
        p->y = NUM2DBL(rb_hash_aref(hash, y_href));
	if ((numCrashesRb = rb_hash_aref(hash, numCrashes_href)) != Qnil) {
	   numCrashes = NUM2INT(numCrashesRb);
	   p->x_total = numCrashes * p->x;
	   p->y_total = numCrashes * p->y;
	} else {
	   numCrashes = 1;
	   p->x_total = p->x;
	   p->y_total = p->y;
	}
        p->num_members = 1;
	p->total_crash_count = numCrashes;
        pc->num = NUM2INT(rb_hash_aref(hash, idx_href));
        pc->p_next = NULL;
        p->p_members = p->p_lastMember = pc;
    }
    memcpy(orig_points, points, pointsMemorySize);
    p_mainObj->p_points = points;
    p_mainObj->currPointsSize = numPairs;
    finalMemberCount = goClusterNodes(p_mainObj, points, numPairs,
                                          NUM2DBL(targetDistance),
                                          NUM2INT(maxNumNodes));
    // Construct the return array
    
    retArray = rb_ary_new2(finalMemberCount);
    // return an array of { x:x, y:y, members => array of members ids }
    p = points;
    // Now add the member #s to the final array, and also determine the
    // closest and furthest coordinates to the center of each cluster.
    for (i = 0; i < finalMemberCount; i++, p++) {
        hash = rb_hash_new();
        rb_ary_store(retArray, i, hash);
	numCrashes = p->total_crash_count;
        rb_hash_aset(hash, x_href, rb_float_new(p->x));
        rb_hash_aset(hash, y_href, rb_float_new(p->y));
        rb_hash_aset(hash, numCrashes_href, INT2NUM(numCrashes));
        memberArrays = rb_ary_new2(p->num_members);
        rb_hash_aset(hash, ids_href, memberArrays);
        pc = p->p_members;
	p_memberPoint = &orig_points[pc->num];
	min_dist = max_dist = calcDist(p_memberPoint->x, p->x, p_memberPoint->y, p->y);
	min_pt = max_pt = pc->num;
        for (j = 0; j < p->num_members; j++) {
            if (!pc) {
                fprintf(stderr, "Unexpected end of a member list -- expected %d, null found at %d\n",
                        p->num_members, j);
                break;
            }
            rb_ary_store(memberArrays, j, INT2NUM(pc->num));
	    if (j >= 1) {
	       p_memberPoint = &orig_points[pc->num];
	       d = calcDist(p_memberPoint->x, p->x, p_memberPoint->y, p->y);
	       if (d > max_dist) {
		  max_dist = d;
		  max_pt = pc->num;
	       } else if (d < min_dist) {
		  min_dist = d;
		  min_pt = pc->num;
	       }
	    }
            pc = pc->p_next;
        }
	if (pc) {
	   fprintf(stderr, "Member list mismatch, expected %d, have more",
		   p->num_members);
	}
	p_memberPoint = &orig_points[max_pt];
        rb_hash_aset(hash, mx_href, rb_float_new(p_memberPoint->x));
        rb_hash_aset(hash, my_href, rb_float_new(p_memberPoint->y));
	p_memberPoint = &orig_points[min_pt];
        rb_hash_aset(hash, nx_href, rb_float_new(p_memberPoint->x));
        rb_hash_aset(hash, ny_href, rb_float_new(p_memberPoint->y));
	
	memberNum = p_memberPoint->p_members->num;
	r_memberId = rb_hash_aref(rb_ary_entry(rnodes, memberNum), id_href);
        rb_hash_aset(hash, og_href, r_memberId);
        //rb_hash_aset(hash, og_href, INT2NUM(memberNum));
	//fprintf(stderr, "Setting og for node %d (id %d) to %d\n",
	//	i,
	//	NUM2INT(rb_hash_aref(rb_ary_entry(rnodes, i), id_href)),
	//	memberNum);
    }
    
    free(consCells);
    free(points);
    free(orig_points);
    free(p_mainObj);
    return retArray;
}

void Init_cpcluster (void)
{
    VALUE cClass;

    cClass = rb_define_class("Clusterer", rb_cObject);
    rb_define_method(cClass, "initialize", cluster_init, 0);
    rb_define_method(cClass, "cluster", cluster_group, 3);
}
