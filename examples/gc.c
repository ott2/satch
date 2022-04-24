#include <stdio.h>
#include <stdlib.h>

int isint(int c) {
    return (c >= '0') && (c <= '9'); // assume ASCII or similar
}

int readint() {
    int c;
    int v = 0;
    while (isint(c = getchar())) {
        v = 10*v + (c-'0');
    }
    ungetc(c,stdin);
    return v;
}

void readrb() {
    int c;
    c = getchar();
    if ('}' != c) { ungetc(c,stdin); }
}

void readlb() {
    int c;
    c = getchar();
    if ('{' != c) { ungetc(c,stdin); }
}

int readcm() {
    int c;
    c = getchar();
    if (',' != c) { ungetc(c,stdin); }
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

// int maxv = 1000;
int maxv = 4000000;
edge **e;

void addedge( int u, int v ) {
    edge *p;
    p = malloc(sizeof(edge));
    if (NULL == p) {
        exit(2);
    }
    (*p).vertex = v;
    if (u > maxv) {
        // resize array e
        p->next = NULL;
    } else {
        p->next = e[u-1];
    }
    e[u-1] = p;
}

int isedge(int u, int v ) {
    return( (u <= maxv) && (linsearch(e[u-1],v)) );
}

void expect( char *s ) {
    int c;
    while ('\0' != *s) {
        c = getchar();
        if ( feof(stdin) ) {
            exit(2); // reached EOF before seeing all of s
        }
        if (c == *s)
            ++s;
    }
}

int main() {

    int u,v;
    int cnt = 0;
    e = malloc(sizeof(struct Edge) * maxv);
    if (NULL == e) {
        exit(2);
    }

    expect("letting E be ");
    readlb();
    while (!feof(stdin)) {
        readlb();
        u = readint();
// printf("%d\n",u);
        readcm();
        v = readint();
        if (v < u) { int w = u; u = v; v = w; }
        if (!isedge(u,v)) {
            addedge(u,v);
        }
        readrb();
        if ('}' == readcm()) break;
        ++cnt;
if (!(cnt % 1000000)) printf("%d-%d\n",u,v);
    }
    exit(0);

}

//        printf("got here\n");
