#ifndef NAIVEBAYES_H
#define NAIVEBAYES_H

#include <vector>
#include <cmath>

using namespace std;

/* Dato leído */
struct datapoint {
	/* Vector de valores de las variables */
	vector<double> data;
	/* Etiqueta de clase */
	string elemclass;
};

/* Representación de una distribución normal */
struct normal_dist {
	/* Media y desvío estándar */
	double mean, stddev;
	/* Función de probabilidad */
	double dist(double x)
	{
		double tmp = 1 / (stddev * sqrt(2.0 * M_PI));
		double up = -pow(x-mean, 2) / (2 * pow(stddev, 2));
		tmp *= exp(up);
		return tmp;
	}
};

#endif