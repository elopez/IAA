# Trabajo Práctico 1: Árboles de decisión

## Ejercicio 4
Se generaron tres conjuntos de datos de entrenamiento utilizando el generador de espirales anidadas de la práctica 0, con 140, 700 y 3500 puntos respectivamente. A su vez, se generó un único conjunto de prueba con 10000 puntos. Al ejecutar C4.5 en dichos datos, se obtuvieron árboles de decisión con 3, 81 y 247 nodos respectivamente. Luego se usaron dichos árboles para clasificar los datos de prueba, y se realizaron tres gráficas con las clases obtenidas: [para 140][ej4-140-plot], [700][ej4-700-plot] y [3500][ej4-3500-plot] puntos.

Observando las gráficas podemos apreciar a simple vista que a mayor tamaño del conjunto de entrenamiento, mejor clasificación realiza el árbol de decisión. Los porcentajes de error calculados por C4.5 soportan esta observación, siendo que el árbol más pequeño clasifica incorrectamente el 44.8% de los valores del conjunto de prueba, mientras que el árbol mediano sólo erra en el 14.9% de los casos y el más grande lo hace solamente en el 7% de la muestra. Esto se debe a que una muestra más grande del espacio de estados provee más información sobre cada clase y permite crear un árbol de decisión más preciso.

[ej4-140-plot]: out-ej4/ej-4-data-140.pdf
[ej4-700-plot]: out-ej4/ej-4-data-700.pdf
[ej4-3500-plot]: out-ej4/ej-4-data-3500.pdf

## Ejercicio 5
Utilizando los generadores *a* ("diagonal") y *b* ("paralelo") de la práctica 0 se procedió a generar un total de doscientos cuarenta y dos conjuntos de datos con valores $C = 0.75$ y $d = 2$. Con cada generador se crearon:

 - 20 conjuntos de entrenamiento para cada una de las siguientes cantidades de elementos:
   $100, 200, 300, 500, 1000, 5000$;
 - 1 conjunto de prueba de tamaño 10000.

Luego se procedió a ejecutar C4.5 sobre todos los conjuntos de entrenamiento, utilizando la opción `-u` para evaluar a su vez los árboles generados sobre el conjunto de prueba correspondiente. Finalmente, se recolectaron los tamaños de árboles y valores de error porcentual reportados por C4.5 en los conjuntos de entrenamiento y prueba, tanto antes como después de realizar pruning de los árboles.

Con estos datos se generaron cuatro gráficas en función del tamaño de los conjuntos de entrenamiento, dos comparando los tamaños de los árboles [antes][ej5-size-before] y [después][ej5-size-after] del pruning, y otras dos evaluando los porcentajes de error de clasificación [antes][ej5-error-before] y [después][ej5-error-after] de podar los árboles.

Comparando ambas gráficas de error, se pueden observar ligeras diferencias causadas por el proceso de poda: luego de la poda, el error al clasificar los casos de entrenamiento es ligeramente superior, mientras que disminuye en el conjunto de prueba. En líneas generales, para ambos problemas se observa una reducción de los errores de clasificación sobre los casos de prueba, y un aumento de los mismos sobre el conjunto de entrenamiento, a medida que aumenta el tamaño de este último y se adquiere más información para elaborar el árbol.

Al comparar ambas gráficas de tamaño de árbol, podemos apreciar la eliminación de nodos que realiza el proceso de poda. A su vez, se observa como el tamaño del árbol requerido para clasificar el caso paralelo se mantiene prácticamente constante, mientras que el árbol para el problema diagonal crece a medida que se entrena con una mayor cantidad de nodos. Esto se debe a que en el primer caso se puede clasificar de forma óptima con sólo inspeccionar la primer variable, mientras que el caso diagonal requiere de un árbol más elaborado.

[ej5-error-before]: out-ej5/plot-error-before-prune.pdf
[ej5-error-after]: out-ej5/plot-error-after-prune.pdf
[ej5-size-before]: out-ej5/plot-size-before-prune.pdf
[ej5-size-after]: out-ej5/plot-size-after-prune.pdf

## Ejercicio 6
Utilizando los generadores *a* ("diagonal") y *b* ("paralelo") de la práctica 0 se procedió a generar un total de doscientos diez conjuntos de datos con valor $d = 5$. Con cada generador se crearon:

 - 20 conjuntos de entrenamiento de 250 elementos para cada uno de los siguientes valores de $C$:
   $0.5, 1, 1.5, 2, 2.5$;
 - 1 conjunto de prueba de 10000 elementos para cada valor de $C$ listado anteriormente.

Luego se procedió a ejecutar C4.5 sobre todos los conjuntos de entrenamiento, utilizando la opción `-u` para evaluar a su vez los árboles generados sobre el conjunto de prueba correspondiente. Finalmente, se recolectaron los valores de error porcentual reportados por C4.5 en el conjunto de prueba luego de realizar pruning de los árboles.

Paralelamente, se implementaron dos clasificadores óptimos para el problema diagonal y paralelo. Para el primero, se clasificó a los puntos midiendo la distancia de los mismos a los centros de las dos nubes de puntos, y seleccionando como clase a la más cercana. Para el problema paralelo se decidió clasificar dividiendo el conjunto de puntos mediante la observación de la primer componente; siendo de una clase los puntos con $c1 < 0$ y de la otra los puntos con $c1 \ge 0$.

Para concluir, se realizó [una gráfica][ej6-error-after] en función del valor de $C$, con ambas curvas de error porcentual mínimo y error porcentual sobre el conjunto de pruebas. En la gráfica se puede apreciar que el error de clasificación obtenido mediante los árboles de C4.5 es siempre superior a los clasificadores ideales realizados. También se puede observar como, al aumentar el solapamiento de ambas clases, los puntos se vuelven más difíciles de clasificar en la zona de solapamiento, y el error aumenta con ambos métodos de clasificación. En esta gráfica también se aprecia cómo el caso paralelo es más sencillo de clasificar, siendo que su curva de error es bastante más cercana a la ideal que la curva del caso diagonal.

[ej6-error-after]: out-ej6/plot-error-after-prune.pdf

## Ejercicio 7
Nuevamente utilizando los generadores *a* y *b* de la práctica 0, se generaron un total de doscientos diez conjuntos de datos con valor $C = 0.78$. Con cada generador se crearon

 - 20 conjuntos de entrenamiento de 250 elementos para cada uno de los siguientes valores de $d$:
   $2, 4, 8, 16, 32$
 - 1 conjunto de prueba de 10000 elementos para cada valor de $d$ listado anteriormente

Luego se ejecutó C4.5 sobre todos los conjuntos de entrenamiento, utilizando la opción `-u` para evaluar a su vez los árboles generados sobre el conjunto de prueba correspondiente. Finalmente, se recolectaron los valores de error porcentual reportados por C4.5 en los conjuntos de entrenamiento y prueba luego de realizar pruning de los árboles. Con estos datos se realizó [una gráfica][ej7-error-after] en función del valor de $d$, con ambas curvas de error porcentual mínimo y error porcentual sobre el conjunto de pruebas.

En la gráfica se aprecia como el error disminuye en los conjuntos de entrenamiento al agregar más variables independientes. Esto se debe a que, dada la mayor cantidad de datos, el árbol termina sobreajustándose.  Este sobreajuste a su vez genera un aumento en el error al clasificar el conjunto de prueba. Este efecto es especialmente destacable en el caso diagonal, en el que cada nueva variable agrega dificultad en la clasificación mediante un árbol de decisión.

[ej7-error-after]: out-ej7/plot-error-after-prune.pdf

## Ejercicio 8
Para este ejercicio se descargaron los datos del problema XOR de la web de la materia. Mediante el uso de *R* [se graficaron todas las variables][ej8-plot] para su interpretación. Viendo que la clase queda determinada mediante el or exclusivo de los signos de las primeras dos variables, podemos clasificar correctamente todos los puntos mediante el siguiente árbol:

    x <= 0 :
    |   y <= 0 : 0
    |   y > 0  : 1
    x > 0 :
    |   y <= 0 : 1
    |   y < 0  : 0

 Sin embargo, al ejecutar C4.5 sobre este dataset, el programa no logra formar un árbol que clasifique los datos de forma satisfactoria. En su lugar, el programa recomienda clasificar todos los puntos como 0, logrando un error de clasificación del 50% para los casos de entrenamiento.

[ej8-plot]: out-ej8/xor.pdf