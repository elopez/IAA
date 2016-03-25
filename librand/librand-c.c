#define _XOPEN_SOURCE
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include "librand-internal.h"

void librand_c_seed(unsigned seed)
{
	long fullseed = seed;
	if (!seed) {
		fullseed = time(NULL);
		fullseed |= clock() << 16;
		fullseed ^= getpid() << 8;
	}
	srand48(fullseed);
}

long double librand_c_gen(void)
{
	return drand48();
}
