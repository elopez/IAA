#define _XOPEN_SOURCE
#define _GNU_SOURCE
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include "librand.h"
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

long double librand_c_gen_uniform(void)
{
	return drand48();
}


static long double mu, sigma;

void librand_c_set_normal(long double mu_p, long double sigma_p)
{
	mu = mu_p;
	sigma = sigma_p;
}

static long double P(long double x)
{
	long double tmp = 1 / (sigma * sqrtl(2.0 * M_PIl));
	long double up = -powl(x-mu, 2) / (2 * powl(sigma, 2));
	tmp *= expl(up);
	return tmp;
}

long double librand_c_gen_normal(void)
{
	for (;;) {
		long double y = librand_c_gen_uniform();
		long double x = librand_c_gen_uniform();
		x *= 10 * sigma;
		x -= 5 * sigma - mu;

		if (P(x) >= y) {
			return x;
		}
	}
}
