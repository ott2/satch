/*
   mygetc

   buffered version of getchar(), with one-character ungetc()
*/

#include <stdio.h>
#include <stdlib.h>

char c;	/* current character */
char ch = '\0';	/* single-character buffer */

#define INPUT_BUFFER_SIZE	8*1024
char mybuf[INPUT_BUFFER_SIZE];
char *C; /* current position in input buffer */
int inbuf = 0;

#ifdef DEBUG
int i = 0;	/* character counter */
#endif

FILE *INFILE;
FILE *OUTFILE;
#define STDERR stderr

int myeof() {
    return(('\0' == ch) && feof(INFILE));
}

void ERROR (char *e) {
#ifdef DEBUG
    fprintf(STDERR, "%s at character %d, quitting\n", e, i);
#else
    fprintf(STDERR, "%s, quitting\n", e);
#endif
    exit(-1);
}

/* buffered input, with one-character undo */
char mygetc(void) {
    char r = ch;

    if ('\0' != ch) {
	ch = '\0';
#ifdef DEBUG
	++i;
#endif
    } else {
	if (!inbuf) {
	    inbuf = fread(mybuf, 1, INPUT_BUFFER_SIZE, INFILE);
	    if (inbuf > 0) {
		C = mybuf;
		--inbuf;
		r = *C++;
#ifdef DEBUG
		++i;
#endif
	    } else {
		r = '\0';
	    }
	} else {
	    --inbuf;
	    r = *C++;
#ifdef DEBUG
	    ++i;
#endif
	}
    }
    return(r);
}

void myungetc(char c) {
/*
    if ('\0' != ch) {
	ERROR("trying to unget two characters in a row");
    } else {
    just assume we never try to unget two in a row:
*/
	ch = (int) c;
#ifdef DEBUG
	--i;
#endif
/*
    }
*/
}

/*
    example code:

    #define INPUT_BUFFER_SIZE	8*1024
    char mybuf[INPUT_BUFFER_SIZE];
    C = mybuf;
    int q = 0;

    c = mygetc();
    while ('\0' != c) {
	if ((' ' != c) && ('\n' != c)) {
	    switch (q) {
	    case 0:
		...
		break;
	    case 1:
		if ('/' == c) {
		    q = 10;
		} else {
		    myungetc(c);
		    // do something
		    q = 2;
		}
		break;
	    ...
	    default:
		ERROR("no such internal state");
		break;
	    }
	} // else: skip whitespace
	c = mygetc();
    }

*/

