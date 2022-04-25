default:
	@echo "Run \"make gc\" to build, \"make debug\" to build debugging version"

debug:	gc-debug

gc:	mygetc.h mygetc.o gc.c
	$(CC) -o gc mygetc.o gc.c

gc-debug:	mygetc.h mygetc.o gc.c
	$(CC) -DDEBUG -c mygetc.c
	$(CC) -DDEBUG -o gc mygetc.o gc.c

