# Introducción al Aprendizaje Automatizado

Trabajos prácticos hechos durante la cursada del primer semestre de 2016.

Web de la materia: https://sites.google.com/site/aprendizajeautomatizadounr

## [Trabajo Práctico 0]: Generación de datasets artificiales

El programa `TP0` permite generar datasets en el formato C4.5 según los requerimientos del trabajo práctico.
El programa toma las siguientes opciones, de las cuales `-e` y `-o` son obligatorias. Si no se provee
`-p` el programa leerá las opciones de la entrada estándar.

Opción                              | Descripción
------------------------------------|------------------------------------------------------------------------
`-e`, `--ejercicio (a | b | c)`     | Ejercicio a ejecutar
`-o`, `--salida archivo`            | Prefijo del archivo de salida
`-p`, `--param parámetros`          | Cadena de parámetros del ejercicio
`-r`, `--prng (c | cpp)`            | Selecciona el generador de números pseudoaleatorios a utilizar
`-s`, `--semilla num`               | Semilla a utilizar para el generador (0 fuerza el uso de una aleatoria)

El generador de números aleatorios C está seleccionado por defecto, y genera números uniformemente mediante la función
`drand48` de la librería estándar de C. Para la generación de números aleatorios en una distribución normal usa una
implementación propia que utiliza el método de rechazo mediante el generador uniforme.

El generador de números aleatorios CPP (C++) genera números uniformemente y en una distribución normal utilizando las
implementaciones disponibles en la librería estándar de C++: `mt19937` (Mersenne Twister), `uniform_real_distribution` y
`normal_distribution`.

Para compilar el trabajo práctico se deberá tener instalado `cmake` y los compiladores de C y C++. En sistemas Debian
o Ubuntu se pueden obtener ejecutando `sudo apt-get install build-essential cmake`. Luego ejecute `cmake . && make`
en el directorio que contiene `CMakeLists.txt` para generar binarios, que estarán disponibles en el directorio `bin/`.

[Trabajo Práctico 0]: https://web.archive.org/web/20160325223721/https://sites.google.com/site/aprendizajeautomatizadounr/Inicio/practicos/tp0

## [Trabajo Práctico 1]: Árboles de decisión

Este trabajo práctico insta al aprendizaje de árboles de decisión mediante el procesamiento de datos generados con el
programa `TP0` utilizando la herramienta C4.5, y su análisis crítico mediante gráficas y observación. Las respuestas y
gráficos elaborados pueden consultarse en [TP1/TP1.md](https://elopez.github.io/IAA/TP1/)

[Trabajo Práctico 1]: https://web.archive.org/web/20160417192238/https://sites.google.com/site/aprendizajeautomatizadounr/Inicio/practicos/tp1
