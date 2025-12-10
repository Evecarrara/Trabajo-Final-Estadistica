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

<img width="567" height="278" alt="image" src="https://github.com/user-attachments/assets/369a340a-3a31-4c73-99d2-2388449e1a4f" />

<img width="567" height="346" alt="image" src="https://github.com/user-attachments/assets/65a9dc40-d911-4e24-acef-cc63cd858efd" />

<img width="567" height="253" alt="image" src="https://github.com/user-attachments/assets/1dd495c3-8f1d-4fde-a0cd-30e8d07338fd" />

<img width="567" height="281" alt="image" src="https://github.com/user-attachments/assets/6d86d7d4-fbb8-4eae-8283-26ef2e948759" />

<img width="567" height="317" alt="image" src="https://github.com/user-attachments/assets/e1224a19-d9fd-4465-9b5a-3227b9fb0c3b" />

<img width="567" height="298" alt="image" src="https://github.com/user-attachments/assets/d2298ee9-55d2-44d2-bf78-954a5cbaed50" />

<img width="567" height="363" alt="image" src="https://github.com/user-attachments/assets/fedbe00b-143e-478c-bc81-500a32c1af34" />

<img width="567" height="344" alt="image" src="https://github.com/user-attachments/assets/1e6f9629-2464-42d5-abb6-070b03613205" />

<img width="567" height="347" alt="image" src="https://github.com/user-attachments/assets/5354cf6f-2a9c-4ca4-9c2a-0bd5a386c644" />


<img width="567" height="387" alt="image" src="https://github.com/user-attachments/assets/47b215c5-3b6f-4e9f-9aab-d830a3897ed1" />


<img width="567" height="351" alt="image" src="https://github.com/user-attachments/assets/dc1cf26b-4a0b-4a62-8d4f-449f5f29bb54" />

Análisis exploratorio y visualizaciones

En la etapa exploratoria se analizaron las variables más representativas del conjunto de datos:
•	price (precio): monto por noche del alojamiento.
•	room_type (tipo de habitación): categoría del espacio ofrecido.
•	number_of_reviews (número de reseñas): cantidad de comentarios recibidos por el alojamiento.
•	availability_365 (disponibilidad anual): número de días en los que el alojamiento estuvo disponible durante el año.
A través de histogramas y gráficos de barras se observó que:
•	La mayoría de los precios son bajos, aunque existen algunos alojamientos con valores extremadamente altos.
•	Los alojamientos completos (Entire home/apt) son los más frecuentes.
•	La distribución del número de reseñas está concentrada en valores bajos, con unos pocos alojamientos muy comentados.
•	La disponibilidad anual presenta variabilidad, con algunos alojamientos disponibles todo el año y otros muy pocos días.
Estos gráficos permiten visualizar la dispersión y los patrones generales del conjunto de datos, y constituyen la base para los análisis posteriores.

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/7e8b1045-b731-48ea-a7d4-bdc93272234e" />

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/7ffa38a7-32f8-4f7c-a6fe-15f922771e3a" />

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/1adfd624-d205-4441-a7ff-ccafbb49cd76" />

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/4e256ec5-ee4f-48ac-9d89-61cae0d4294e" />

Ajuste de distribuciones
Se analizó la forma de las distribuciones de las variables price y number_of_reviews con el objetivo de determinar qué tipo de modelo probabilístico las describe mejor.
Los resultados mostraron que:
•	El precio se asemeja a una distribución log-normal, lo que significa que la mayoría de los valores son bajos, mientras que unos pocos alcanzan montos muy altos.
•	El número de reseñas se ajusta razonablemente a una distribución Poisson, típica de variables que representan conteos o frecuencias de eventos.
Los gráficos generados permiten observar cómo las curvas teóricas (log-normal y Poisson) se superponen sobre las distribuciones empíricas, confirmando visualmente la adecuación de estos ajustes.

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/5fe091d2-7f2f-43f6-9d17-fe0a7444e966" />

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/fc0e48f1-3b23-4e50-b187-5771fe546a07" />

Contraste de hipótesis
Se plantearon dos hipótesis principales:
1.	Hipótesis 1:
Existen diferencias significativas en el precio medio entre los alojamientos del tipo Entire home/apt y Private room.
o	Se aplicó una prueba t de Welch, que no asume varianzas iguales, y como alternativa robusta se utilizó la prueba no paramétrica de Wilcoxon.
o	Ambas pruebas indicaron diferencias estadísticamente significativas, lo que permite concluir que las viviendas completas suelen tener precios más altos que las habitaciones privadas.
2.	Hipótesis 2:
Existe una relación entre el número de reseñas y la disponibilidad anual.
o	Se aplicaron pruebas de correlación de Pearson y Spearman.
o	Los resultados mostraron una correlación positiva débil, lo que sugiere que los alojamientos con más reseñas tienden a estar disponibles más días al año, aunque la relación no es muy fuerte.
Los gráficos de boxplot y dispersión incluidos en el informe ilustran claramente estas conclusiones, mostrando las diferencias de precios y las tendencias entre reseñas y disponibilidad.
 
<img width="568" height="323" alt="image" src="https://github.com/user-attachments/assets/69fc91a4-f145-4d04-9cd8-7e42cdc298d3" />

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/94ef9db5-0c82-487f-b09b-2cceb8e1ce00" />

Modelo lineal
Con el fin de comprender mejor la influencia de las distintas variables sobre el precio, se ajustó un modelo lineal considerando el logaritmo del precio (log(price)) como variable dependiente, y como predictores el tipo de habitación, el número de reseñas y la disponibilidad anual.
El modelo mostró que:
•	El tipo de habitación es el factor más influyente: los alojamientos completos tienen un impacto positivo y significativo sobre el precio.
•	Tanto el número de reseñas como la disponibilidad anual también afectan el precio, aunque en menor medida.
•	Los gráficos de diagnóstico (residuos y QQ-plot) indican un comportamiento adecuado del modelo, lo que respalda la validez de los resultados dentro del contexto observacional.
En síntesis, el modelo permitió cuantificar cómo cada variable contribuye al precio, ofreciendo una visión más completa de las relaciones observadas.

<img width="568" height="355" alt="image" src="https://github.com/user-attachments/assets/7ea45f28-414c-47e1-8fc0-9040d8a60414" />

<img width="567" height="378" alt="image" src="https://github.com/user-attachments/assets/ff79f02e-d484-4463-a202-34ad7c8612c4" />

<img width="567" height="378" alt="image" src="https://github.com/user-attachments/assets/6b5fc4f7-9b72-4e16-92fd-5b19993ebd6a" />

Conclusión final
El análisis exploratorio permitió identificar sesgos y patrones en variables clave como el precio, el tipo de habitación, el número de reseñas y la disponibilidad anual. El ajuste de distribuciones sugiere que los precios presentan un comportamiento compatible con una distribución log-normal, mientras que el número de reseñas se ajusta razonablemente a una distribución Poisson.
En el contraste de hipótesis se evidenciaron diferencias significativas en los precios según el tipo de habitación, así como una asociación entre el número de reseñas y el precio, resultados respaldados por las pruebas estadísticas aplicadas.
Por último, el modelo lineal, con el logaritmo del precio como variable respuesta, permitió cuantificar el efecto de los predictores seleccionados, mostrando que los alojamientos de Airbnb más caros suelen ser viviendas completas, tienen mayor cantidad de reseñas y suelen estar disponibles más días al año. En general, la mayoría de los precios son bajos, pero existen algunos alojamientos con valores considerablemente más altos. El modelo lineal contribuye a comprender cómo estos factores influyen en el precio de manera conjunta, confirmando la existencia de relaciones significativas dentro del conjunto de datos.

