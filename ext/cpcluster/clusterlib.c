/*
 *  bike01.c
 *  bike01c
 *
 *  Created by Eric Promislow on 12/10/2011.
 *  Copyright 2011 Eric Promislow. All rights reserved.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "clusterlib.h"
#include <sys/time.h> 

#define boolean int
#define TRUE 1
#define FALSE 0

// Local definitions

static void find_closest_points(MainObj_t *mainObj, int left, int right);
static void find_crossing_nbrs(MainObj_t *mainObj, int left, int mid, int right);

#define fcp_EPS ((double) 0.0000001)

static void nodeCombineCheck(MainObj_t *mainObj, Node *a, Node *b) {
    if (b - a <= 0) {
        fprintf(stderr, "**** Error with %d nodes: b:%p < a:%p\n", mainObj->currPointsSize, b, a);
    }
}

static void deletePointNode(MainObj_t *mainObj, Node *b) {
   int b_idx = (int) (b -  mainObj->p_points);
    if (b_idx < mainObj->currPointsSize - 1) {
        memmove(b, b + 1, sizeof(Node) * (mainObj->currPointsSize - (b_idx + 1)));
        
    }
    mainObj->currPointsSize -= 1;
}


/*
 * combinePointsLeft: given two consecutive points a and b,
 * merge info from b on to a, and get rid of node b.
 */
static void combinePointsLeft(MainObj_t *mainObj, Node *a, Node *b) {
    double  new_x_total, new_y_total;
    int total_members, total_crash_count;
    
    nodeCombineCheck(mainObj, a, b);
    total_members = a->num_members + b->num_members;
    total_crash_count = a->total_crash_count + b->total_crash_count;
    new_x_total = a->x_total + b->x_total;
    new_y_total = a->y_total + b->y_total;
    a->x = new_x_total / total_crash_count;
    a->y = new_y_total / total_crash_count;
    a->x_total = new_x_total;
    a->y_total = new_y_total;
    a->num_members = total_members;
    a->total_crash_count = total_crash_count;
    a->p_lastMember->p_next = b->p_members;
    a->p_lastMember = b->p_lastMember;
    deletePointNode(mainObj, b);
}

// This is trickier than combinePointsLeft.  Figure out the new node's x and y.
// If new x < (a + 1).x, do a combinePointsLeft.  Otherwise figure out where
// (new-x, new-y) belongs between loc(a) and loc(b).  Save new data.  Shift
// nodes loc(a + 1) ... loc(new) one to left.  Add new data at loc(new). Remove
// node b as usual.  Node a gets overwritten, and the duplicate of b after the
// memmove gets replaced with the new info.  Note so far no nodes were created
// or deleted.  Afterwards we delete node b by shifting the nodes to its right
// one to the left.

// Invariant: a < b
static void combinePoints(MainObj_t *mainObj, Node *a, Node *b) {
    double  new_x_total, new_y_total;
    double new_x, new_y;
    int total_members, total_crash_count;
    
    Cons *new_list = a->p_members;
    Cons *lastMember = b->p_lastMember;
    Node *targetNode = NULL;
    
    if (b - a == 1) {
        combinePointsLeft(mainObj, a, b);
        return;
    }
    nodeCombineCheck(mainObj, a, b);
    total_members = a->num_members + b->num_members;
    total_crash_count = a->total_crash_count + b->total_crash_count;
    new_x_total = a->x_total + b->x_total;
    new_y_total = a->y_total + b->y_total;
    new_x = new_x_total / total_crash_count;
    new_y = new_y_total / total_crash_count;
    if (new_x < a->x - fcp_EPS) {
       fprintf(stderr, "new_x:%g < a.x:%g at node %d\n", new_x, a->x, (int) (a - mainObj->p_points));
        new_x = a->x;
    } else if (new_x > b->x + fcp_EPS) {
       fprintf(stderr, "new_x:%g > b.x:%g at node %d\n", new_x, b->x, (int) (b - mainObj->p_points));
        new_x = b->x;
    }
    a->p_lastMember->p_next = b->p_members;
    for (targetNode = a; targetNode < b - 1; targetNode++) {
        if (targetNode->x <= new_x && (targetNode + 1)->x >= new_x) {
            break;
        }
    }
    if (targetNode - a > 0) {
        memmove(a, a + 1, sizeof(Node) * ((targetNode - a) + 1));
    }
    targetNode->x = new_x;
    targetNode->y = new_y;
    targetNode->x_total = new_x_total;
    targetNode->y_total = new_y_total;
    targetNode->num_members = total_members;
    targetNode->total_crash_count = total_crash_count;
    targetNode->p_members = new_list;
    targetNode->p_lastMember = lastMember;
    deletePointNode(mainObj, b);
}

static double dist(Node *a, Node *b) {
    double x = a->x - b->x;
    double y = a->y - b->y;
    return sqrt(x * x + y * y);
}

static boolean compare(MainObj_t *mainObj, Node *a, Node *b) {
    double d = dist(a, b);
    if (d < mainObj->currentClosestDist) {
        mainObj->currentClosestDist = d;
        mainObj->p_currentA = a;
        mainObj->p_currentB = b;
        return TRUE;
    }
    return FALSE;
}

static boolean compare_y(MainObj_t *mainObj, Node *a, Node *b) {
    if (fabs(a->y - b->y) >= mainObj->currentClosestDist) {
        return FALSE;
    }
    return compare(mainObj, a, b);
}

static void find_pair(MainObj_t *mainObj, double max_dist) {
    mainObj->currentClosestDist = max_dist;
    mainObj->p_currentA = mainObj->p_currentB = NULL;
    find_closest_points(mainObj, 0, mainObj->currPointsSize);
}

static void compare_all_pairs(MainObj_t *mainObj, int left, int right) {
    // At some point it's faster to just find the closest pair doing pairwise comparisions
    // over each pair.  We can be smart because if we know that two nodes exceed dmin
    // x-wise, there's no point continuing.  Also as usual, move from right to left
    // to minimize the # of nodes we have to shift over.
    
    double dmin = mainObj->currentClosestDist;
    Node *points = mainObj->p_points;
    int i, j;
    Node *a, *b;
    double left_x_min;

    if (dmin == 0) {
        return; // can't do better
    }
    for (i = right - 1; i >= left + 1; i--) {
        b = &points[i];
        left_x_min = b->x - dmin;
        for (j = i - 1; j >= left; j--) {
            a = &points[j];
            if (a->x < left_x_min) {
                // No point looking further with this left-hand point.
                break;
            } else if (compare_y(mainObj, a, b)) {
                //fprintf(stderr, "Old dmin: %f", dmin);
                dmin = mainObj->currentClosestDist;
                //fprintf(stderr, ", new dmin: %f\n", dmin);
                left_x_min = b->x - dmin;
            }
        }
    }
    
    
}
static void find_closest_points(MainObj_t *mainObj, int left, int right) {
    int mid;

    // right points one past the end of the array to simplify the math
    if (mainObj->currentClosestDist == 0) {
        return; // can't do better
    }
    if (right - left < 16) {
        // 16 gives good performance, about 25% below always going through this routine
        compare_all_pairs(mainObj, left, right);
        return;
    } 
    mid = (left + right + 1) / 2;
    find_closest_points(mainObj, mid, right); // look at the right side first, since we always shift nodes from the right.
    find_closest_points(mainObj, left, mid);
    find_crossing_nbrs(mainObj, left, mid, right);
}

static void find_crossing_nbrs(MainObj_t *mainObj, int left, int mid, int right) {
    // See wikipedia on Closest_pair_of_points_problem for the subtleties here.
    // mid is considered to be part of the right side.
    double dmin = mainObj->currentClosestDist;
    Node *points = mainObj->p_points;
    double mid_x = points[mid].x;
    double left_x_min = mid_x - dmin;
    int i, j;
    boolean stay  = TRUE;
    Node *a, *b;
    double right_x_max;
    
    if (dmin == 0) {
        return; // can't do better
    }
    // Now just do a smartish compare between each pair of points over the line.  
    // Start closer to the line, because if we have a shortest pair, it's likely there.
    // As soon as the horiz distance between a left-side point and a right-side point
    // > current dmin, give up on that left-side point.
    for (i = mid - 1; i >= left && stay; --i) {
        a = &points[i];
        if (a->x <= left_x_min) {
            break;
        }        
        right_x_max = a->x + dmin;
        for (j = mid; j < right && stay; j++) {
            b = &points[j];
            if (b->x >= right_x_max) {
                // No point looking further with this left-hand point.
                break;
            } else if (compare_y(mainObj, a, b)) {
               stay = mainObj->currentClosestDist > 0;
            }
        }
    }
}

static void cluster_by_distance(MainObj_t *mainObj, double target, int maxNumPoints) {
    int n = mainObj->currPointsSize;
    int num_points = n;
    int num_iters = 0;
    int i = 1;
    Node *points = mainObj->p_points;
    Node *a = &points[0], *b;
    //int last_i = 0;
    //int num_quick_clusters = 0, num_unique_clusters = 0;
    //double quick_target = target / 4;
    double dmin;
    double calcDmin;

    i = num_points - 1;
    a = &points[i];
    //int j;
    // Move from right to left so we move shorter segments first as nodes are collapsed.
    // First cluster together consecutive nodes that point to the same location.
    while (--i >= 0) {
        b = a;
        a = &points[i];
	if (a->x == b->x && a ->y == b->y) {
	   combinePointsLeft(mainObj, a, b);
	}
    }
    // Now do the recursive clustering
    while (TRUE) {
        num_iters += 1;
        find_pair(mainObj, 1.0e20);
        if (mainObj->currentClosestDist > target
            && (maxNumPoints == 0 
                || mainObj->currPointsSize <  maxNumPoints)) {
            break;
        }
        a = mainObj->p_currentA;
        b = mainObj->p_currentB;
        dmin = mainObj->currentClosestDist;
        calcDmin = dist(a, b);
        if (fabs(dmin - calcDmin) > fcp_EPS) {
            fprintf(stderr, "Sanity check failed: reported dmin:%g, calced dmin:%g, diff:%g\n",
                    dmin, calcDmin, fabs(dmin - calcDmin));
            fprintf(stderr, "a: %f,%f b: %f,%f\n",
                    a->x, a->y, b->x, b->y);
        }                
        combinePoints(mainObj, mainObj->p_currentA, mainObj->p_currentB);
        num_points -= 1;
    }
}

#if 0
static int comparePoints(const void *a1, const void *b1) {
    Node *a = (Node *) a1;
    Node *b = (Node *) b1;
    double dx = a->x - b->x;
    double dy;
    
    if (dx < 0) return -1;
    else if (dx > 0) return 1;
    dy = a->y - b->y;
    return dy < 0 ? -1 : dy > 0 ? 1 : 0;
}
#endif

#if 0
static void prepareToClusterNodes(double xa[], int numPairs);

void launch() {
    static double xa[] = {
#include "data3.h"
    };
    int numPairs;
    int i;
    for (i = 0; fabs(xa[i]) > fcp_EPS ; i++) {
        // Nothing
    }
    numPairs = i / 2;
    prepareToClusterNodes(xa, numPairs);
}
#endif

int goClusterNodes(MainObj_t *p_mainObj, Node *points, int numPairs, double targetDistance, int maxNumNodes) {
    
    struct timeval a_timeval[2];
    struct timezone a_timezone[2];
    int finalSize;
    time_t       secs;
    suseconds_t    usecs;

    gettimeofday(&a_timeval[0], &a_timezone[0]);
    cluster_by_distance(p_mainObj, targetDistance, maxNumNodes);
    gettimeofday(&a_timeval[1], &a_timezone[1]);     
    secs = a_timeval[1].tv_sec - a_timeval[0].tv_sec;
    usecs = a_timeval[1].tv_usec - a_timeval[0].tv_usec;
    if (usecs < (suseconds_t) 0) {
        usecs += (suseconds_t) 1000000;
        secs -= 1;
    }
    finalSize = p_mainObj->currPointsSize;
    //printf("gcn: cluster %d => %d, time needed: %d secs, %d usec\n", numPairs, finalSize, secs, usecs);
    return finalSize;
}


#if 0
static void prepareToClusterNodes(double xa[], int numPairs) {
    int i;
    MainObj_t *p_mainObj;
    int numSuccessfullAllocs = 0;
    Cons *consCells;
    Node *points;
    struct timeval a_timeval[2];
    struct timezone a_timezone[2];
    time_t       secs;
    suseconds_t    usecs;
    
    printf("Got %d pairs \n", numPairs);
    p_mainObj = (MainObj_t *) malloc(sizeof(MainObj_t));
    if (!p_mainObj) {
        fprintf(stderr, "Can't allocate %d bytes\n", sizeof(MainObj_t));
        goto NO_MEM;
    }
    numSuccessfullAllocs = 1;
    consCells = (Cons *) malloc(sizeof(Cons) * numPairs);
    if (!consCells) {
        fprintf(stderr, "Can't allocate %d bytes\n", sizeof(MainObj_t));
        goto NO_MEM;
    }
    numSuccessfullAllocs |= 2;
    points = (Node *) malloc(sizeof(Node) * numPairs);
    if (!points) {
        fprintf(stderr, "Can't allocate %d bytes\n", sizeof(MainObj_t));
        goto NO_MEM;
    }
    numSuccessfullAllocs |= 4;
    
    for (i = 0; i < numPairs; i++) {
        Node *point = &points[i];
        Cons *cell;
	
        point->y = point->y_total = xa[2 * i];
        point->x =  point->x_total = xa[2 * i + 1];
        point->num_members = 1;
        cell = &consCells[i];
        point->p_lastMember = point->p_members = cell;
        cell->num = i;
        cell->p_next = NULL;
    }/*
     void
     qsort(void *base, size_t nel, size_t width,
     int (*compar)(const void *, const void *));
*/     
    qsort((void *) points, (size_t) numPairs, sizeof(Node), comparePoints);
    p_mainObj->p_points = points;
    p_mainObj->currPointsSize = numPairs;
    gettimeofday(&a_timeval[0], &a_timezone[0]);


    cluster_by_distance(p_mainObj, 0.03, 200);
    gettimeofday(&a_timeval[1], &a_timezone[1]);     
    secs = a_timeval[1].tv_sec - a_timeval[0].tv_sec;
    usecs = a_timeval[1].tv_usec - a_timeval[0].tv_usec;
    if (usecs < (suseconds_t) 0) {
        usecs += (suseconds_t) 1000000;
        secs -= 1;
    }
    printf("After clustering, we have %d nodes\n", p_mainObj->currPointsSize);
    printf("Time needed: %d secs, %d usec\n", secs, usecs);
	  /* a_timeval[1].tv_sec - a_timeval[0].tv_sec,
	   a_timeval[1].tv_usec - a_timeval[0].tv_usec);
       */
    
NO_MEM:
    if (numSuccessfullAllocs & 4) {
        free(points);
    }
    if (numSuccessfullAllocs & 2) {
        free(consCells);
    }
    if (numSuccessfullAllocs & 1) {
        free(p_mainObj);
    }
}
#endif
