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

extern "C" long double librand_gen(void)
{
	switch (engine) {
	case RAND_ENGINE_C:
		return librand_c_gen();
		break;
	default:
	case RAND_ENGINE_CPP:
		return librand_cpp_gen();
		break;
	}
}
