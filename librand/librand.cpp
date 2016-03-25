#include "librand.h"
#include "librand-internal.h"

rand_types engine = RAND_ENGINE_CPP;

extern "C" int librand_select(rand_types e)
{
	if (e < 0 || e >= RAND_ENGINE_MAX)
		return -1;

	engine = e;
	return 0;
}

extern "C" void librand_seed(unsigned seed)
{
	switch (engine) {
	case RAND_ENGINE_C:
		librand_c_seed(seed);
		break;
	default:
	case RAND_ENGINE_CPP:
		librand_cpp_seed(seed);
		break;
	}
}

extern "C" long double librand_gen_uniform(void)
{
	switch (engine) {
	case RAND_ENGINE_C:
		return librand_c_gen_uniform();
	default:
	case RAND_ENGINE_CPP:
		return librand_cpp_gen_uniform();
	}
}

extern "C" void librand_set_normal(long double mu, long double sigma)
{
	switch (engine) {
	case RAND_ENGINE_C:
		librand_c_set_normal(mu, sigma);
		break;
	default:
	case RAND_ENGINE_CPP:
		librand_cpp_set_normal(mu, sigma);
		break;
	}
}

extern "C" long double librand_gen_normal(void)
{
	switch (engine) {
	case RAND_ENGINE_C:
		return librand_c_gen_normal();
	default:
	case RAND_ENGINE_CPP:
		return librand_cpp_gen_normal();
	}
}
