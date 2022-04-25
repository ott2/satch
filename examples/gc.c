#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "mygetc.h"

// int isint(int c) {
//     return (c >= '0') && (c <= '9'); // assume ASCII or similar
// }
int isint(int c) {
    return isdigit(c);
}

int readint() {
    char c;
    int v = 0;
    while (isint(c = mygetc())) {
        v = 10*v + (c-'0');
    }
    myungetc(c);
    return v;
}

void readrb() {
    char c;
    c = mygetc();
    if ('}' != c) { myungetc(c); }
}

void readlb() {
    char c;
    c = mygetc();
    if ('{' != c) { myungetc(c); }
}

int readcm() {
    char c;
    c = mygetc();
    if (',' != c) { myungetc(c); }
    return(c);
}

struct Edge {
    int vertex;
    struct Edge *next;
};
typedef struct Edge edge;

int linsearch( edge *p, int u ) {
    edge *cp = p;
    while (NULL != cp) {
        if (u == cp->vertex) {
            return(1);
        }
        cp = cp->next;
    }
    return(0);
}

#define MAXV 4000000
edge **e;

/* ignore case where edge is already present: just add it again */
void addedge( int u, int v ) {
    edge *p;
    p = malloc(sizeof(edge));
    if (NULL == p) {
        ERROR("cannot allocate memory when adding edge");
    }
    (*p).vertex = v;
    if (u > MAXV) {
        // should resize array e, for now just fail
        ERROR("cannot process more than MAXV vertices");
        p->next = NULL;
    } else {
        p->next = e[u-1];
    }
    e[u-1] = p;
}

int isedge(int u, int v ) {
    return( (u <= MAXV) && (linsearch(e[u-1],v)) );
}

void expect( char *s ) {
    char c;
    while ('\0' != *s) {
        c = mygetc();
        if ( myeof() ) {
            ERROR("reached EOF before seeing all of s");
        }
        if (c == *s)
            ++s;
    }
}

int main() {

    int u,v;
#ifdef DEBUG
    int cnt = 0;
#endif // DEBUG
    e = malloc(sizeof(struct Edge) * MAXV);
    if (NULL == e) {
        ERROR("cannot allocate memory for graph");
    }
    INFILE = stdin;
    OUTFILE = stdout;

    expect("letting E be ");
    readlb();
    while (!myeof()) {
        readlb();
        u = readint();
        readcm();
        v = readint();
        if (v < u) { int w = u; u = v; v = w; }
//        if (!isedge(u,v)) {
//            addedge(u,v);
//        }
        addedge(u,v); // add repeated edges multiply
        readrb();
        if ('}' == readcm()) break;
#ifdef DEBUG
        ++cnt;
        if (!(cnt % 1000000)) printf("%d-%d\n",u,v);
#endif // DEBUG
    }
    exit(0);

}

#ifdef DEBUG
// printf("%d\n",u);
//        printf("got here\n");
#endif // DEBUG
