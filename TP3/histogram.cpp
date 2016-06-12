#include <algorithm>
#include <iostream>
#include <vector>
#include <tuple>

#include "histogram.h"

using namespace std;

/* Devuelve a que bin corresponde un punto */
int histogram::which(double x)
{
	if (x == max) /* el último bin es cerrado eg. [ .. ) [ .. ) [ .. ] */
		return bins - 1;
	return (x-min) / ((max-min)/bins);
}

/* Calcula el rango y cuenta los puntos de cada bin */
void histogram::compute(int nr)
{
	auto minmax = minmax_element(points.begin(), points.end());
	min = *minmax.first;
	max = *minmax.second;
	bins = nr;
	total = points.size();
	freq = vector<double>(bins);
	for (auto &p: points)
		freq[which(p)]++;
}

/* Imprime el histograma */
void histogram::show()
{
	for (auto &k: freq) {
		for (int j = 0; j < k; j++)
			cout << "*";
		cout << endl;
	}
}

/* Calcula la probabilidad de x según la distribución del histograma */
double histogram::dist(double x)
{
	if (total == 0 || x < min || x > max)
		return 0;
#ifdef USE_M_ESTIMATE
	return (freq[which(x)] + 1) / (double)(total + bins);
#else
	return freq[which(x)] / (double)total;
#endif
}