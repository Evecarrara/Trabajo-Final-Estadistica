# Trabajo-Final-Estadistica
Se desarrolla un análisis estadístico del conjunto de datos Airbnb Open Data, con el propósito de explorar patrones, contrastar hipótesis y construir un modelo que permita comprender mejor los factores asociados a los precios de los alojamientos.
El análisis se estructura en varias etapas: la exploración inicial del conjunto de datos, la evaluación de medidas descriptivas, la observación de distribuciones y patrones, el contraste de hipótesis estadísticas y la elaboración de un modelo lineal. Finalmente, se presentan conclusiones basadas en los hallazgos más relevantes.

Ejecución en Visual Studio Code
El procesamiento y análisis de los datos se realizaron mediante un script en R ejecutado desde Visual Studio Code.Las capturas incluidas en el informe corresponden a la terminal de ejecución, donde pueden observarse las diferentes etapas del análisis:
•	Carga de librerías necesarias (como dplyr, ggplot2, janitor y MASS).
•	Lectura del archivo CSV con los datos de Airbnb.
•	Limpieza y estandarización de nombres de columnas.
•	Visualización de las dimensiones del conjunto de datos, los nombres de las variables y los resúmenes estadísticos iniciales.
Estas imágenes permiten evidenciar el correcto funcionamiento del código y sirven como registro del proceso analítico completo.
<img width="567" height="343" alt="image" src="https://github.com/user-attachments/assets/189eb3c5-7d0d-4eca-a8bc-97d5c370717b" />



Conclusión final
El análisis exploratorio permitió identificar sesgos y patrones en variables clave como el precio, el tipo de habitación, el número de reseñas y la disponibilidad anual. El ajuste de distribuciones sugiere que los precios presentan un comportamiento compatible con una distribución log-normal, mientras que el número de reseñas se ajusta razonablemente a una distribución Poisson.
En el contraste de hipótesis se evidenciaron diferencias significativas en los precios según el tipo de habitación, así como una asociación entre el número de reseñas y el precio, resultados respaldados por las pruebas estadísticas aplicadas.
Por último, el modelo lineal, con el logaritmo del precio como variable respuesta, permitió cuantificar el efecto de los predictores seleccionados, mostrando que los alojamientos de Airbnb más caros suelen ser viviendas completas, tienen mayor cantidad de reseñas y suelen estar disponibles más días al año. En general, la mayoría de los precios son bajos, pero existen algunos alojamientos con valores considerablemente más altos. El modelo lineal contribuye a comprender cómo estos factores influyen en el precio de manera conjunta, confirmando la existencia de relaciones significativas dentro del conjunto de datos.

