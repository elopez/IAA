#ifndef _LIBRAND_INTERNAL_H_
#define _LIBRAND_INTERNAL_H_

#ifdef __cplusplus
extern "C" {
#endif

/* C backend */
void librand_c_seed(unsigned);
long double librand_c_gen_uniform(void);
void librand_c_set_normal(long double, long double);
long double librand_c_gen_normal(void);

#ifdef __cplusplus
}
#endif

/* C++ backend */
void librand_cpp_seed(unsigned);
long double librand_cpp_gen_uniform(void);
void librand_cpp_set_normal(long double, long double);
long double librand_cpp_gen_normal(void);

#endif
