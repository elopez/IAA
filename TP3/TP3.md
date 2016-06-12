# Trabajo Práctico 3: Clasificador Naive Bayes

## Ejercicios 1 y 4
Se implementó un programa para resolver problemas de clasificación mediante *Naive Bayes*. El programa está realizado en `C++` y puede ser compilado de tres formas distintas, dependiendo de la funcionalidad deseada por el usuario.

 - Para realizar clasificaciones mediante aproximación de distribuciones normales:
   `g++ -O2 naivebayes.cpp -o naivebayes.norm` 
 - Para aproximar mediante histogramas:
   `g++ -O2 -DUSE_HIST naivebayes.cpp histogram.cpp -o naivebayes` 
 - Para aproximar mediante histogramas usando m-estimaciones:
   `g++ -O2 -DUSE_HIST -DUSE_M_ESTIMATE naivebayes.cpp histogram.cpp -o naivebayes` 

Para ver el modo de uso, basta con ejecutar el programa sin argumentos. Si se desea ocultar la información adicional que imprime el programa, se puede pasar también `-DNDEBUG` al momento de compilar.

## Ejercicio 2
Para este ejercicio, se repitió lo realizado en el punto 7 del trabajo práctico 1, esta vez utilizando el clasificador bayesiano con aproximación mediante distribuciones normales. Se procedió luego a [graficar los resultados][ej2-plot].

En la gráfica se puede observar cómo, para este tipo de problemas, *Naive Bayes* ofrece soluciones prácticamente ideales al momento de clasificar. Podemos también apreciar que los errores de prueba aumentan ligeramente a medida que se agregan dimensiones y se mantiene constante el número de puntos analizado. Esto se debe a que a mayor número de dimensiones, se tiene menos información para ajustar las aproximaciones de las distribuciones gaussianas, generando de esta forma un aumento en el error.

[ej2-plot]: out-ej2/plot.pdf

## Ejercicio 3
Se procedió a clasificar el dataset *dos elipses* y *espirales*, utilizando los mismos datos y tamaños de conjuntos que cuando fueron evaluados con redes neuronales. Se procedió luego a [graficar las predicciones obtenidas][ej3-plots] sobre los conjuntos de prueba, para visualizar la clasificación realizada.

Para el problema de los elipses, se obtuvo un 26% de error en entrenamiento y un 23,55% de error sobre el conjunto de pruebas. Este nivel de falla resulta muy alto, siendo que las redes neuronales podían conseguir un error del orden del 6% sobre el conjunto de pruebas para este *dataset*.

En cuanto al problema de las espirales anidadas, se obtuvo un error del 34% sobre el conjunto de entrenamiento, y de 42,35% sobre el conjunto de pruebas. Nuevamente el rendimiento del clasificador bayesiano resulta insuficiente; las redes neuronales alcanzaban errores del 9% dada una cantidad suficiente de neuronas en la capa oculta.

Esta incapacidad de resolver estos problemas es inherente al método de aproximación utilizado para calcular la probabilidad de cada variable. Al no estar los puntos distribuidos de forma normal, las probabilidades condicionales utilizadas por el clasificador no reflejan la realidad, y el método no logra clasificar los puntos de forma eficiente.

[ej3-plots]: out-ej3/points-plot.pdf

## Ejercicio 4, segunda parte
Vistos los resultados obtenidos en el ejercicio 3, se implementó la aproximación de probabilidades condicionales mediante el uso de histogramas. Este método permite modelar mejor problemas en donde los puntos no posean una distribución normal. Se procedió luego a reevaluar los problemas; para facilitar la comparación, fueron utilizados los mismos tamaños de conjuntos de validación que para redes neuronales. Se realizaron 20 ejecuciones para cada cantidad de *bins*, de 1 a 100, y se registraron las ejecuciones junto a su error medio. Se graficó luego el error para los tres conjuntos.

Para el problema de los dos elipses, el menor error en conjunto de validación se obtuvo con 17 *bins*, como se puede [apreciar en la gráfica][ej4-error-elipses]. En este caso, el error en entrenamiento fue de 10,4%, de 13,6% en validación y de 12,25% en prueba. La [gráfica de puntos][ej4-points-elipses] es también mucho más acertada que en el ejercicio 3.

En cuanto al problema de las espirales anidadas, se obtuvo el menor error en validación con el uso de 15 *bins*. El error en entrenamiento fue de 26,625%, en validación de 27,75% y en pruebas de 29,9%. En la [gráfica][ej4-error-espirales] de errores por cantidad de *bins* se puede apreciar que también ocurre sobreajuste, como en el problema de los elipses. La [gráfica de puntos][ej4-points-espirales] es bastante más acertada que en el ejercicio 3, pero dista aún de lo esperado.

En ambos casos, se ve claramente cómo aumentar el número de *bins* tiende a generar sobreajuste, siendo que estos resultan de muy pequeño tamaño y se vuelven útiles sólo para clasificar puntos cercanos a los observados.

Como conclusión, las clasificaciones obtenidas para este otro tipo de problemas mediante este método son mejores que las obtenidas en el ejercicio 3, pero siguen siendo inferiores a las que pueden obtenerse, por ejemplo, mediante redes neuronales. De todas maneras, dado que es un método computacionalmente más eficiente, puede ser útil para algunos problemas en los que no sea requerido un resultado óptimo.

[ej4-error-elipses]: out-ej4/bayes-errors-elipses.pdf
[ej4-error-espirales]: out-ej4/bayes-errors-espirales.pdf
[ej4-points-elipses]: out-ej4/points-elipses.pdf
[ej4-points-espirales]: out-ej4/points-espirales.pdf