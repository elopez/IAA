#ifndef KNN_H
#define KNN_H

#include <vector>
#include <string>
#include <cmath>
#include <cassert>

#ifdef USE_DIST
#define USE_DIST 1
#else
#define USE_DIST 0
#endif

#ifdef NDEBUG
#define DEBUG(...)
#else
#define DEBUG(...) __VA_ARGS__
#endif

/* Dato leído */
struct datapoint {
	/* Vector de valores de las variables */
	std::vector<double> data;
	/* Etiqueta de clase */
	std::string elemclass;
	/* (Distancia euclidea)^2 */
	double operator-(struct datapoint &p) {
		/* mismo espacio */
		assert(p.data.size() == data.size());

		double t = 0;
		for (size_t i = 0; i < data.size(); i++)
			t += pow(data[i] - p.data[i], 2);

		return t;
	}
};

struct distpoint {
	/* Distancia */
	double dist;
	/* Elemento */
	int elem;
	/* Comparador de distancias (para ordenar) */
	inline bool operator<(const distpoint& rhs) const {
		return dist < rhs.dist;
	}
};
#endif
