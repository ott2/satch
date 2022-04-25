/*
   mygetc

   buffered version of getchar(), with one-character ungetc()
*/

#ifdef DEBUG
int mychar_count;	/* input character counter */
#endif

FILE *INFILE;
FILE *OUTFILE;
#define STDERR stderr

void ERROR (char *e);

#define INPUT_BUFFER_SIZE	8*1024

int myeof();
char mygetc(void);
void myungetc(char c);
