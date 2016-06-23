#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <random>
#include <string>
#include <unordered_map>
#include <vector>

#include "knn.h"

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

	DEBUG(cout << "Read data with " << datacols << " data columns, " << data.size() << " rows total" << endl << endl);

	return data;
}

template<typename T>
string knn_classify(T qty, vector<datapoint> &data, datapoint v, bool istrainset = false, bool isdistance = false)
{
	int points = data.size();
	vector<distpoint> dists(points);

	/* Calcular distancias a los n puntos */
	for (int i = 0; i < points; i++)
		dists[i] = { .dist = data[i] - v, .elem = i };

	int distsz = dists.size();
	int k;

	if (isdistance) {
		/* Buscar los elementos [0..k]. Si no hay ninguno usamos el mínimo. Necesitamos al menos
		 * un punto, o dos si estamos clasificando training set */
		sort(dists.begin(), dists.end());
		distpoint kdp = { (double)qty, (int)data.size() };
		auto endit = upper_bound(dists.begin() + istrainset + 1, dists.end(), kdp);
		k = distance(dists.begin(), endit);
		k = min(distsz, k);
	} else {
		/* Ignorar el mismo elemento en caso de que hagamos train error */
		k = qty + istrainset;
		k = min(distsz, k);

		/* Buscar los k menores. Si hay que ignorar el menor los ordenamos */
		nth_element(dists.begin(), dists.begin() + k, dists.end());
		if (istrainset)
			sort(dists.begin(), dists.begin() + k);
	}

	/* Contamos cuántos de esos k hay de cada clase */
	unordered_map<string, int> classes;
	for (int i = istrainset; i < k; i++)
		classes[data[dists[i].elem].elemclass]++;

	int best = classes.begin()->second;
	string elemclass = classes.begin()->first;

	/* Buscamos la clase más numerosa, y clasificamos como esa clase */
	for (auto &e: classes) {
		if (e.second > best) {
			best = e.second;
			elemclass = e.first;
		}
	}

	return elemclass;
}

pair<vector<vector<datapoint>>, vector<vector<datapoint>>> build_validation_sets(vector<datapoint> &data)
{
	vector<vector<datapoint>> train(5), val(5);

	/* Mezclamos los datos */
	random_device rng;
	mt19937 urng(rng());
	shuffle(data.begin(), data.end(), urng);

	/* Generamos 5 datasets (aprox. 80% test y 20% validación) */
	for (int i = 0; i < 5; i++) {
		size_t min = i*(data.size()/5), max = min + data.size()/5;

		for (size_t j = 0; j < data.size(); j++) {
			if (j >= min && j < max)
				val[i].push_back(data[j]);
			else
				train[i].push_back(data[j]);
		}
	}

	return { train, val };
}

pair<int, double> choose_best_k(vector<datapoint> data)
{
	vector<vector<datapoint>> train, val;
	tie(train, val) = build_validation_sets(data);

	int bestk = 1;
	long long bestcorrect = -1;
	double bestvalerror = 100;
	int abortcount = 0;

	for (size_t k = 1; k < data.size()/10; k++) {
		vector<pair<long long,int>> correct(5);

		/* Contamos las clasificaciones correctas para cada dataset */
		for (int i = 0; i < 5; i++) {
			correct[i] = make_pair(0, i);
			for (auto &v: val[i])
				correct[i].first += v.elemclass == knn_classify(k, train[i], v);
		}

		/* Elegimos la mediana de las 5 ejecuciones (3er elemento, indexado de 0)
		 * para calcular el error de validación */
		nth_element(correct.begin(), correct.begin()+2, correct.end());
		auto mean = *(correct.begin()+2);
		size_t setsz = val[mean.second].size();
		double valerror = 100 * (setsz - mean.first) / (double)setsz;

		/* Si este k clasifica mejor que los que ya analizamos, lo marcamos como tal.
		 * Caso contrario, si vemos 10 resultados con comparativamente menos del 90%
		 * de aciertos que el mejor k, dejamos de buscar un mejor k */
		if (mean.first > bestcorrect) {
			bestcorrect = mean.first;
			bestk = k;
			bestvalerror = valerror;
		} else if (1.0 * mean.first < 0.90 * bestcorrect) {
			abortcount++;
		} else {
			abortcount = 0;
		}

		if (abortcount > 10) {
			DEBUG(cout << "Error has grown too big, not looking any further" << endl);
			break;
		}

		DEBUG(cout << "Validation error for k = " << k << " is " << valerror << "%" << endl);
	}

	DEBUG(cout << "Best k is " << bestk << endl << endl);

	return { bestk, bestvalerror };
}

pair<double, double> choose_best_d(vector<datapoint> data)
{
	vector<vector<datapoint>> train, val;
	tie(train, val) = build_validation_sets(data);

	/* d - distancia promedio de los puntos */
	double d = 0;
	for (auto &a: data)
		for (auto &b: data)
			d += sqrt(b-a);
	d /= pow(data.size(), 2);

	DEBUG(cout << "Mean point distance on train dataset: " << d << endl;)

	double bestd = d;
	long long bestcorrect = -1;
	double bestvalerror = 100;

	/* Valores para escalar la distancia promedio */
	vector<double> epochs({ 0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5, 10 });

	for (auto &e: epochs) {
		vector<pair<long long,int>> correct(5);

		/* Usamos una distancia (al cuadrado), escalada por e */
		double k = d * d * e;

		/* Contamos las clasificaciones correctas para cada dataset */
		for (int i = 0; i < 5; i++) {
			correct[i] = make_pair(0, i);
			for (auto &v: val[i])
				correct[i].first += v.elemclass == knn_classify(k, train[i], v, false, true);
		}

		/* Elegimos la mediana de las 5 ejecuciones (3er elemento, indexado de 0)
		 * para calcular el error de validación */
		nth_element(correct.begin(), correct.begin()+2, correct.end());
		auto mean = *(correct.begin()+2);
		size_t setsz = val[mean.second].size();
		double valerror = 100 * (setsz-mean.first) / (double)setsz;

		/* Si este k clasifica mejor que los que ya analizamos, lo marcamos como tal. */
		if (mean.first > bestcorrect) {
			bestcorrect = mean.first;
			bestd = k;
			bestvalerror = valerror;
		}

		DEBUG(cout << "Validation error for d = " << k << " is " << valerror << "%" << endl);
	}

	DEBUG(cout << "Best d is " << bestd << endl << endl);

	return { bestd, bestvalerror };
}

int main(int argc, char *argv[])
{
	ios::sync_with_stdio(false);

	if (argc < 3) {
		if (USE_DIST)
			cout << "Usage: " << argv[0] << " train.data test.data [test.predict [d]]" << endl;
		else
			cout << "Usage: " << argv[0] << " train.data test.data [test.predict [k]]" << endl;
		return 1;
	}

	string ftrain = argv[1];
	string ftest = argv[2];
	string fpredict = argv[3]?:"";

#ifdef USE_DIST
	double k = argc >= 5 ? strtod(argv[4], nullptr) : 0;
#else
	int k = argc >= 5 ? strtol(argv[4], nullptr, 0) : 0;
#endif

	auto train = read_data(ftrain);

	/* Abrimos archivo de predicciones si nos dieron un nombre */
	ofstream predict(fpredict);
	if (!predict && fpredict.length()) {
		cerr << "Error abriendo " << fpredict << endl;
		exit(EXIT_FAILURE);
	}

	/* Buscamos el K (o D) óptimo si el usuario no lo provee */
	double valerror = -1;
	if (!k && USE_DIST)
		tie(k, valerror) = choose_best_d(train);
	if (!k && !USE_DIST)
		tie(k, valerror) = choose_best_k(train);

	/* Evaluamos el error de entrenamiento */
	size_t traincorrect = 0;
	for (auto &p: train)
		traincorrect += p.elemclass == knn_classify(k, train, p, true, USE_DIST);

	/* Luego cargamos el conjunto de test y evaluamos el error sobre el mismo.
	 * Si el usuario lo solicitó, tambien guardamos las predicciones */
	auto test = read_data(ftest);
	size_t testcorrect = 0;
	for (auto &p: test) {
		string pclass = knn_classify(k, train, p, false, USE_DIST);
		testcorrect += p.elemclass == pclass;
		if (predict) {
			for (auto &e: p.data)
				predict << e << ", ";
			predict << pclass << '\n';
		}
	}

	double trainerror = 100.0 * (train.size() - traincorrect) / train.size();
	double testerror = 100.0 * (test.size() - testcorrect) / test.size();

	string how = valerror == -1 ? ", provided by user" : ", chosen via validation";
	if (USE_DIST)
		cout << "d used: " << k << how << endl;
	else
		cout << "k used: " << k << how << endl;

	cout << "Classification errors:" << endl;
	cout << "Train error: " << trainerror << '%' << endl;
	if (valerror != -1)
		cout << "Validation error: " << valerror << '%' << endl;
	cout << "Test error: " << testerror << '%' << endl;
}
