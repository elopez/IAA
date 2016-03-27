#define _XOPEN_SOURCE
#define _GNU_SOURCE
#include <math.h>
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

long double librand_c_gen_uniform(void)
{
	return drand48();
}


struct normal_params {
	long double mu, sigma, u;
};

static long double P(long double mu, long double sigma, long double x)
{
	long double tmp = 1 / (sigma * sqrtl(2.0 * M_PIl));
	long double up = -powl(x-mu, 2) / (2 * powl(sigma, 2));
	tmp *= expl(up);
	return tmp;
}

void *librand_c_init_normal(long double mu_p, long double sigma_p)
{
	struct normal_params *p = malloc(sizeof(*p));
	p->mu = mu_p;
	p->sigma = sigma_p;
	p->u = P(mu_p, sigma_p, mu_p);
	return p;
}

long double librand_c_gen_normal(void *n)
{
	struct normal_params *p = n;
	long double mu = p->mu, sigma = p->sigma, u = p->u;

	for (;;) {
		long double y = librand_c_gen_uniform();
		long double x = librand_c_gen_uniform();
		x *= 12 * sigma;
		x -= 6 * sigma - mu;
		y *= u;

		if (P(mu, sigma, x) >= y) {
			return x;
		}
	}
}

void librand_c_destroy_normal(void *n)
{
	free(n);
}
