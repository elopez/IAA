#define _XOPEN_SOURCE
#include <stdlib.h>
#include <time.h>

#include "librand-internal.h"

void librand_c_seed(unsigned seed)
{
	srand48(seed ? seed : (unsigned)time(NULL));
}

long double librand_c_gen(void)
{
	return drand48();
}
