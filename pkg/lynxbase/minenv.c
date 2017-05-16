#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <libgen.h>

static char *progname = NULL;

static void usage(void)
{
	fprintf(stderr, "usage: %s [-n VAR=NAME] PROG [ARGS]\n", progname);
	exit(1);
}

int main(int argc, char **argv)
{
	int c;

	progname = basename(*argv);

	if (argc < 2) usage();

	clearenv();
	putenv("HOME=/");
	putenv("SHELL=/bin/sh");
	putenv("UID=0");
	putenv("USER=root");
	putenv("PATH=/bin");

	opterr = 0;
	optind = 1;

	while ((c = getopt(argc, argv, "n:")) != -1) {
		switch (c) {
			case 'n':
				putenv(optarg);
				break;
			default: usage(); break;
		}
	}

	execvp(*(argv+optind), argv+optind);
	return 127;
}
