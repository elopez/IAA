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

long double librand_cpp_gen(void)
{
	return dist(prng);
}
