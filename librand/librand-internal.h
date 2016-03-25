#ifndef _LIBRAND_INTERNAL_H_
#define _LIBRAND_INTERNAL_H_

#ifdef __cplusplus
extern "C" {
#endif

void librand_c_seed(unsigned);
long double librand_c_gen(void);

#ifdef __cplusplus
}
#endif

void librand_cpp_seed(unsigned);
long double librand_cpp_gen(void);

#endif
