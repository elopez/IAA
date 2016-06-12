#ifndef HISTOGRAM_H
#define HISTOGRAM_H

#include <vector>

using namespace std;

class histogram {
	/* Nro de bins */
	int bins;
	/* Rango */
	double min, max;
	/* Frecuencias */
	vector<double> freq;

	/* Puntos para computar */
	vector<double> points;
	/* Total de puntos */
	long long total = 0;

	/* Devuelve a que bin corresponde un punto */
	int which(double x);

public:
	/* Guarda un punto en el histograma */
	void record(double x) { points.push_back(x); }
	/* Calcula el rango y cuenta los puntos de cada bin */
	void compute(int nr);
	/* Calcula la probabilidad de x según la distribución del histograma */
	double dist(double x);
	/* Imprime el histograma */
	void show();
};

#endif