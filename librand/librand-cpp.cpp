#include <map>
#include <random>

#include "librand-internal.h"

using namespace std;

static mt19937 prng;
static uniform_real_distribution<long double> dist(0.0, 1.0);
static map<pair<long double, long double>, normal_distribution<long double>> norm;

void librand_cpp_seed(unsigned seed)
{
	random_device rd;
	prng = mt19937(seed ? seed : rd());
}

long double librand_cpp_gen_uniform(void)
{
	return dist(prng);
}

static pair<long double, long double> current_norm;
void librand_cpp_set_normal(long double mu, long double sigma)
{
	current_norm = make_pair(mu, sigma);
	norm[current_norm] = normal_distribution<long double>(mu, sigma);
}

long double librand_cpp_gen_normal(void)
{
	return norm[current_norm](prng);
}
