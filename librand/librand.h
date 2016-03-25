#ifndef _LIBRAND_H_
#define _LIBRAND_H_

#ifdef __cplusplus
extern "C" {
#endif

enum rand_types {
	RAND_ENGINE_CPP = 0,
	RAND_ENGINE_C   = 1,
	RAND_ENGINE_MAX
};

int librand_select(enum rand_types e);
void librand_seed(unsigned seed);
long double librand_gen(void);

#ifdef __cplusplus
}
#endif

#endif
