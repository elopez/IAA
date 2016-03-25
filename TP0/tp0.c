#define _GNU_SOURCE
#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <math.h>
#include <getopt.h>

#include <librand.h>

#include "names-files.h"

long double P(long double sigma, long double mu, long double x)
{
	long double tmp = 1 / (sigma * sqrtl(2.0 * M_PIl));
	long double up = -powl(x-mu, 2) / (2 * powl(sigma, 2));
	tmp *= expl(up);
	return tmp;
}

long double gen_point_under_P(long double sigma, long double mu)
{
	for (;;) {
		long double y = librand_gen();
		long double x = librand_gen();
		x *= 10 * sigma;
		x -= 5 * sigma - mu;

		if (P(sigma, mu, x) >= y) {
			return x;
		}
	}
}

void ejercicio_a(FILE *data, FILE *names, char *param)
{
	int d, n;
	long double c;

	if (param)
		sscanf(param, "%d%d%Lf", &d, &n, &c);
	else
		scanf("%d%d%Lf", &d, &n, &c);

	/* .data generation */

	long double sigma = c * sqrtl(d);

	for (int i = 0; i < n/2; i++) {
		for (int j = 0; j < d; j++) {
			fprintf(data, "%Lf, ", gen_point_under_P(sigma, 1));
		}
		fputs("0\n", data);
	}

	for (int i = 0; i < n/2; i++) {
		for (int j = 0; j < d; j++) {
			fprintf(data, "%Lf, ", gen_point_under_P(sigma, -1));
		}
		fputs("1\n", data);
	}

	/* .names generation */

	fputs(NAMES_CONTENT_A_B_HEAD, names);
	for (int i = 0; i < n; i++)
		fprintf(names, "c%d: continuous.\n", i);

}

void ejercicio_b(FILE *data, FILE *names, char *param)
{
	int d, n;
	long double c;

	if (param)
		sscanf(param, "%d%d%Lf", &d, &n, &c);
	else
		scanf("%d%d%Lf", &d, &n, &c);

	/* .data generation */

	long double sigma = c;

	for (int i = 0; i < n/2; i++) {
		fprintf(data, "%Lf, ", gen_point_under_P(sigma, 1));
		for (int j = 1; j < d; j++) {
			fprintf(data, "%Lf, ", gen_point_under_P(sigma, 0));
		}
		fputs("0\n", data);
	}

	for (int i = 0; i < n/2; i++) {
		fprintf(data, "%Lf, ", gen_point_under_P(sigma, -1));
		for (int j = 1; j < d; j++) {
			fprintf(data, "%Lf, ", gen_point_under_P(sigma, 0));
		}
		fputs("1\n", data);
	}

	/* .names generation */

	fputs(NAMES_CONTENT_A_B_HEAD, names);
	for (int i = 0; i < n; i++)
		fprintf(names, "c%d: continuous.\n", i);
}

struct point {
	long double x;
	long double y;
};

struct point gen_point_on_spiral(int s)
{
	struct point p;
	long double ro, theta, rocurvetop, rocurvebot;

	for (;;) {
		p.x = librand_gen() * 2.2 - 1.1;
		p.y = librand_gen() * 2.2 - 1.1;
		ro = sqrtl(powl(p.x, 2) + powl(p.y, 2));
		if (ro > 1)
			continue;
		theta = atan2l(p.y, p.x);

		int type = 0;
		rocurvebot = theta / (4 * M_PIl);
		rocurvetop = rocurvebot + 1.0/4.0;
		for (int i = 0; i < 3; i++) {
			if (ro > rocurvebot && ro < rocurvetop)
				type = 1;
			rocurvebot += 1.0/2.0;
			rocurvetop += 1.0/2.0;
		}

		if (type == s)
			return p;
	}
}

void ejercicio_c(FILE *data, FILE *names, char *param)
{
	int n;

	if (param)
		sscanf(param, "%d", &n);
	else
		scanf("%d", &n);

	/* .data generation */

	for (int i = 0; i < n/2; i++) {
		struct point p = gen_point_on_spiral(0);
		fprintf(data, "%Lf, %Lf, 0\n", p.x, p.y);
	}

	for (int i = 0; i < n/2; i++) {
		struct point p = gen_point_on_spiral(1);
		fprintf(data, "%Lf, %Lf, 1\n", p.x, p.y);
	}

	/* .names generation */

	fputs(NAMES_CONTENT_C, names);
}


int main(int argc, char **argv)
{
	int prng = RAND_ENGINE_CPP;
	unsigned seed = 0;
	char *ejercicio = NULL, *salida = NULL, *param = NULL;
	static struct option long_options[] = {
		{"ejercicio", required_argument, 0, 'e'},
		{"salida",    required_argument, 0, 'o'},
		{"param",     required_argument, 0, 'p'},
		{"prng",      required_argument, 0, 'r'},
		{"semilla",   required_argument, 0, 's'},
		{ /* sentinel */ }
	};


	int c, option_index = 0;
	while (1) {
		c = getopt_long(argc, argv, "e:o:p:r:s:",
				long_options, &option_index);

		/* Detect the end of the options. */
		if (c == -1)
			break;

		switch (c) {
		case 0:
		case '?':
			break;
		case 'e':
			ejercicio = strdup(optarg);
			break;
		case 'o':
			salida = strdup(optarg);
			break;
		case 'p':
			param = strdup(optarg);
			break;
		case 'r':
			if (!strcmp("cpp", optarg))
				prng = RAND_ENGINE_CPP;
			else if (!strcmp("c", optarg))
				prng = RAND_ENGINE_C;
			else
				fprintf(stderr, "PRNG no soportado, usando cpp por defecto\n");
			break;
		case 's': {
			sscanf(optarg, "%u", &seed);
			break;
		}
		default:
			abort();
		}
	}

	/* Seed PRNG with user supplied seed (or 0 meaning auto-seed) */
	librand_select(prng);
	librand_seed(seed);

	if (!ejercicio || !salida) {
		fprintf(stderr, "Por favor especifique ejercicio (-e) y prefijo de salida (-o)\n");
		return 1;
	}

	/* Create and open output files */
	FILE *data, *names;
	char filename[BUFSIZ];
	sprintf(filename, "%s.data", salida);
	data = fopen(filename, "w");
	sprintf(filename, "%s.names", salida);
	names = fopen(filename, "w");
	if (!data || !names) {
		fprintf(stderr, "Error abriendo archivos\n");
		return 1;
	}

	switch (*ejercicio) {
	case 'a':
		ejercicio_a(data, names, param);
		break;
	case 'b':
		ejercicio_b(data, names, param);
		break;
	case 'c':
		ejercicio_c(data, names, param);
		break;
	default:
		fprintf(stderr, "Ejercicio no existente\n");
	}

	fclose(data);
	fclose(names);

	free(ejercicio);
	free(salida);
	free(param);

	return 0;
}
