#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <unordered_map>
#include <algorithm>

#include "naivebayes.h"
#include "histogram.h"

using namespace std;

vector<datapoint> read_data(string filename)
{
	ifstream file(filename);
	if (!file) {
		cerr << "Error opening " << filename << endl;
		exit(EXIT_FAILURE);
	}

	/* Detectar cantidad de variables automáticamente (una por coma) */
	string line;
	getline(file, line);
	file.seekg(0);
	size_t datacols = count(line.begin(), line.end(), ',');

	/* Datos a devolver */
	vector<datapoint> data;

	/* Mientras haya una línea con datos, la leemos */
	double tmp;
	while (file >> tmp) {
		string elemclass;
		char c;

		vector<double> row(datacols, {tmp});
		for (size_t i = 1; i < datacols; i++)
			file >> c >> row[i];
		file >> c >> elemclass;
		data.push_back({row, elemclass});
	}

#ifndef NDEBUG
	cout << "Read data with " << datacols << " data columns, " << data.size() << " rows total" << endl;
	cout << endl;
#endif

	return data;
}

unordered_map<string, double> compute_apriori_probabilities(vector<datapoint> &data)
{
	unordered_map<string, long long> class_count;

	/* Contamos los elementos de cada clase */
	for (auto &point: data)
		class_count[point.elemclass]++;

	/* Las probabilidades a priori son #elem-clase / #total */
	unordered_map<string, double> probabilities;
	for (auto &c: class_count)
		probabilities[c.first] = (double)c.second / (double)data.size();

#ifndef NDEBUG
	cout << "A priori probabilities per class: " << endl;
	for (auto &p: probabilities)
		cout << " * " << p.first << ":\t" << p.second << endl;
	cout << endl;
#endif

	return probabilities;
}

unordered_map<string, vector<normal_dist>> approximate_normal_probabilities(vector<datapoint> &data)
{
	unordered_map<string, unordered_map<int, double>> sum, accum;
	unordered_map<string, long long> count;
	size_t ncols = data[0].data.size();

	/* Media - sumatoria / #elem */
	for (auto &p: data) {
		count[p.elemclass]++;
		for (size_t i = 0; i < p.data.size(); i++)
			sum[p.elemclass][i] += p.data[i];
	}

	/* Calculamos la media para cada clase */
	unordered_map<string, vector<normal_dist>> dist;
	for (auto &s: sum)
		for (size_t i = 0; i < ncols; i++)
			dist[s.first].push_back({ .mean = s.second[i] / (double) count[s.first] });

	/* Desviación estándar - sumatoria (m-d)**2 / (altura - 1) */
	for (auto &p: data)
		for (size_t i = 0; i < p.data.size(); i++)
			accum[p.elemclass][i] += pow(dist[p.elemclass][i].mean - p.data[i], 2);

	/* Calculamos la desviación estándar para cada clase */
	for (auto &s: accum)
		for (size_t i = 0; i < ncols; i++)
			dist[s.first][i].stddev = sqrt(s.second[i] / (double) (count[s.first]-1));

#ifndef NDEBUG
	cout << "Conditional probabilities per class: " << endl;
	for (auto &p: dist) {
		cout << "Class " << p.first << ":" << endl;
		int i = 0;
		for (auto &d: p.second)
			cout << " * v" << i++ << ":\tmu = " << d.mean << "\tsigma = " << d.stddev << endl;
	}
	cout << endl;
#endif

	return dist;
}

#ifdef USE_HIST
unordered_map<string, vector<histogram>> approximate_histogram_probabilities(vector<datapoint> &data, int bins)
{
	unordered_map<string, vector<histogram>> hist;
	size_t ncols = data[0].data.size();

	/* Separación de los datos para histogramas */
	for (auto &p: data) {
		hist[p.elemclass].resize(ncols);
		for (size_t i = 0; i < p.data.size(); i++)
			hist[p.elemclass][i].record(p.data[i]);
	}

	/* Generación de histogramas */
	for (auto &c: hist)
		for (auto &h: c.second)
			h.compute(bins);

#ifndef NDEBUG
	cout << "Histogram per class: " << endl;
	for (auto &p: hist) {
		cout << "Class " << p.first << ":" << endl;
		int i = 0;
		for (auto &d: p.second) {
			cout << " * v" << i++ << ':' << endl;
			d.show();
		}
	}
	cout << endl;
#endif

	return hist;
}
#endif

string naive_predict(vector<double> &data, unordered_map<string, double> &apriori,
		     NORMAL(unordered_map<string, vector<normal_dist>> &conditional)
		     HIST(unordered_map<string, vector<histogram>> &conditional))
{
	double best = numeric_limits<double>::lowest();
	string bestclass = apriori.begin()->first;

	/* Para cada clase, calculamos la probabilidad a posteriori y devolvemos la clase con mayor probabilidad
	 * Usamos log y suma en vez de directamente multiplicar las probabilidades para evitar underflow */
	for (auto &ap: apriori) {
		string thisclass = ap.first;
		double prob = log(ap.second);

		for (size_t i = 0; i < conditional[thisclass].size(); i++)
			prob += log(conditional[thisclass][i].dist(data[i]));

		if (prob > best) {
			best = prob;
			bestclass = thisclass;
		}
	}

	return bestclass;
}

int main(int argc, char *argv[])
{
	ios::sync_with_stdio(false);

	int enough_args = 3 HIST(+1);

	if (argc < enough_args) {
		NORMAL(cout << "Usage: " << argv[0] << " train.data test.data [test.predict]" << endl);
		HIST(cout << "Usage: " << argv[0] << " train.data test.data #bins [test.predict]" << endl);
		return 1;
	}

	string ftrain = argv[1];
	string ftest = argv[2];
	HIST(int bins = strtoul(argv[3], NULL, 0)?:10);
	HIST(string fpredict = argv[4]?:"");
	NORMAL(string fpredict = argv[3]?:"");

#ifndef NDEBUG
	cout << "Loading training set and evaluating error on classification" << endl;
#endif

	auto data = read_data(ftrain);
	auto apriori = compute_apriori_probabilities(data);
	NORMAL(auto conditional = approximate_normal_probabilities(data);)
	HIST(auto conditional = approximate_histogram_probabilities(data, bins);)

	/* Calculamos cuántos clasificamos bien por cada clase en el set de entrenamiento */
	long long good = 0;
	for (auto &p: data)
		good += p.elemclass == naive_predict(p.data, apriori, conditional);

	double trainerror = 100.0 * (data.size() - good) / data.size();

#ifndef NDEBUG
	cout << "Loading and classifying test set" << endl;
#endif

	/* Abrimos archivo de predicciones si nos dieron un nombre */
	ofstream predict(fpredict);
	if (!predict && fpredict.length()) {
		cerr << "Error abriendo " << fpredict << endl;
		exit(EXIT_FAILURE);
	}

	/* Luego cargamos el conjunto de test y evaluamos el error sobre el mismo.
	 * Si el usuario lo solicitó, tambien guardamos las predicciones*/
	data = read_data(ftest);
	good = 0;
	for (auto &p: data) {
		string pclass = naive_predict(p.data, apriori, conditional);
		good += p.elemclass == pclass;
		if (predict) {
			for (auto &e: p.data)
				predict << e << ", ";
			predict << pclass << '\n';
		}
	}

	double testerror = 100.0 * (data.size() - good) / data.size();

	cout << "Classification errors:" << endl;
	cout << "Train error: " << trainerror << '%' <<endl;
	cout << "Test error: " << testerror << '%' << endl;
}
