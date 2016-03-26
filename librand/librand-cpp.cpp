#include <random>

#include "librand-internal.h"

using namespace std;

static mt19937 prng;
static uniform_real_distribution<long double> dist(0.0, 1.0);

void librand_cpp_seed(unsigned seed)
{
	random_device rd;
	prng = mt19937(seed ? seed : rd());
}

long double librand_cpp_gen_uniform(void)
{
	return dist(prng);
}

void *librand_cpp_init_normal(long double mu, long double sigma)
{
	return new normal_distribution<long double>(mu, sigma);
}

long double librand_cpp_gen_normal(void* n)
{
	normal_distribution<long double> *norm =
		static_cast<normal_distribution<long double> *>(n);
	return (*norm)(prng);
}

void librand_cpp_destroy_normal(void *n)
{
	normal_distribution<long double> *norm =
		static_cast<normal_distribution<long double> *>(n);
	delete norm;
}
