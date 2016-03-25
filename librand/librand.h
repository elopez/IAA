#ifndef _LIBRAND_H_
#define _LIBRAND_H_

#ifdef __cplusplus
extern "C" {
#endif

enum rand_types {
	/* C++-based implementation, featuring <random> primitives
	 * (Mersenne Twister, uniform_real_distribution and
	 * normal_distribution) */
	RAND_ENGINE_CPP,
	/* C-based implementation, featuring drand48() for uniformly
	 * distributed random numbers and discard method for normally
	 * distributed random numbers. */
	RAND_ENGINE_C,
	RAND_ENGINE_MAX
};

/* Select a PRNG backend */
int librand_select(enum rand_types e);

/* Seed the PRNG backend */
void librand_seed(unsigned seed);

/* Generate a random number, uniformly distributed in the [0,1] range */
long double librand_gen_uniform(void);

/* Configure mu and sigma for the normal distribution generator */
void librand_set_normal(long double, long double);

/* Generate a random number from the (mu, sigma) distribution */
long double librand_gen_normal(void);

#ifdef __cplusplus
}
#endif

#endif /* _LIBRAND_H_ */
