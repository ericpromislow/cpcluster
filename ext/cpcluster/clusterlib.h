/*
 *  bike01.h
 *  bike01c
 *
 *  Created by Eric Promislow on 12/10/2011.
 *  Copyright 2011 Eric Promislow. All rights reserved.
 *
 */

typedef struct Cons {
    int num;
    struct Cons *p_next;
} Cons;

// Each node has a location and a list of its members.  Point to the last member
// on the list so combining two lists is O(1).
typedef struct Node {
    double x, y;
    int num_members;
    int total_crash_count;
    Cons *p_members, *p_lastMember;
    double x_total, y_total;
} Node;

typedef struct MainObj_t {
    Node *p_points;
    int currPointsSize;    
    double currentClosestDist;
    Node *p_currentA, *p_currentB;
} MainObj_t;

void launch();
int goClusterNodes(MainObj_t *p_mainObj,
                   Node *points,
                   int numPairs,
                   double targetDistance,
                   int maxNumNodes);
