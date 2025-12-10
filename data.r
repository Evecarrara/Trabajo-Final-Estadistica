# ============================================================
# Trabajo Final - Análisis Airbnb Open Data <3 <3 Hecho con la poca estabilidad mental que me queda <3 <3
# ============================================================

# --- 1. Librerías ---
suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(forcats)
  library(scales)
  library(readr)
  library(janitor)
  library(MASS)
  library(tidyr)
})

# --- 2. Función para leer el dataset ---
read_dataset_airbnb <- function() {
  read_csv("software_trayectorias-main/datasets/Airbnb_Open_Data.csv",
           show_col_types = FALSE) |>
    clean_names()
}

# --- 3. Cargar los datos ---
airbnb <- read_dataset_airbnb()

# inspeccionar problemas de parseo
print(problems(airbnb))

# --- 4. Carpeta de salida ---
ruta_guardado <- "Trabajo final/Figuras"
if (!dir.exists(ruta_guardado)) dir.create(ruta_guardado, recursive = TRUE)

# --- 5. Exploración básica ---
cat("Dimensiones del dataset (filas, columnas):\n"); print(dim(airbnb))
cat("\nResumen estadístico / descriptivo (dataset completo):\n"); print(summary(airbnb))
cat("\nNombres limpios de columnas:\n"); print(names(airbnb))

# --- 6. Selección de variables y conversión de tipos ---
datos <- airbnb |>
  transmute(
    price = parse_number(price),
    room_type = room_type,
    number_of_reviews = suppressWarnings(as.integer(number_of_reviews)),
    availability_365 = suppressWarnings(as.integer(availability_365)),
    neighbourhood_group = suppressWarnings(as.character(neighbourhood_group))
  )

# --- 7. Clasificación de variables ---
cat("\n--- CLASIFICACIÓN DE VARIABLES ---\n")
cat("• price: Cuantitativa continua (positiva, monetaria)\n")
cat("• room_type: Categórica nominal (tipo de habitación)\n")
cat("• number_of_reviews: Cuantitativa discreta (conteo)\n")
cat("• availability_365: Cuantitativa continua (0–365 días)\n")

# --- 8. Gráficos exploratorios ---
grafico_precio <- ggplot(datos, aes(x = price)) +
  geom_histogram(bins = 50, fill = "skyblue", color = "white") +
  scale_x_continuous(labels = dollar_format(prefix = "$")) +
  labs(title = "Distribución de precios", x = "Precio por noche", y = "Frecuencia") +
  theme_minimal()
ggsave(filename = file.path(ruta_guardado, "grafico_precios.png"),
       plot = grafico_precio, width = 8, height = 5, dpi = 300)

grafico_room <- ggplot(datos, aes(x = room_type, fill = room_type)) +
  geom_bar() +
  labs(title = "Frecuencia por tipo de habitación", x = "Tipo de habitación", y = "Cantidad") +
  theme_minimal() + theme(legend.position = "none")
ggsave(filename = file.path(ruta_guardado, "grafico_tipos_habitacion.png"),
       plot = grafico_room, width = 8, height = 5, dpi = 300)

grafico_reviews <- ggplot(datos, aes(x = number_of_reviews)) +
  geom_histogram(bins = 40, fill = "orange", color = "white") +
  labs(title = "Distribución del número de reseñas", x = "Número de reseñas", y = "Frecuencia") +
  theme_minimal()
ggsave(filename = file.path(ruta_guardado, "grafico_reseñas.png"),
       plot = grafico_reviews, width = 8, height = 5, dpi = 300)

grafico_avail <- ggplot(datos, aes(x = availability_365)) +
  geom_histogram(bins = 40, fill = "lightgreen", color = "white") +
  labs(title = "Distribución de días disponibles por año", x = "Disponibilidad (días)", y = "Frecuencia") +
  theme_minimal()
ggsave(filename = file.path(ruta_guardado, "grafico_disponibilidad.png"),
       plot = grafico_avail, width = 8, height = 5, dpi = 300)

cat("\n✅ Gráficos exploratorios guardados en:\n", ruta_guardado, "\n")

# --- 9. Medidas de posición y dispersión ---
datos_limpios <- datos |>
  drop_na(price, number_of_reviews, availability_365) |>
  filter(price > 0, number_of_reviews >= 0, availability_365 >= 0)

cat("\n--- MEDIDAS DE POSICIÓN Y DISPERSIÓN ---\n")
cat("\nPRICE:\n"); print(summary(datos_limpios$price)); cat("sd(price) = ", sd(datos_limpios$price), "\n")
cat("\nNUMBER_OF_REVIEWS:\n"); print(summary(datos_limpios$number_of_reviews)); cat("sd(number_of_reviews) = ", sd(datos_limpios$number_of_reviews), "\n")
cat("\nAVAILABILITY_365:\n"); print(summary(datos_limpios$availability_365)); cat("sd(availability_365) = ", sd(datos_limpios$availability_365), "\n")

# --- 10. Ajuste de distribuciones y estimación de parámetros ---
cat("\n--- AJUSTE DE DISTRIBUCIONES TEÓRICAS (MLE con MASS::fitdistr) ---\n")
price_validos <- datos_limpios$price[datos_limpios$price > 0]
ajuste_price <- fitdistr(price_validos, densfun = "lognormal")
cat("\nDistribución sugerida para 'price': Log-normal\n"); print(ajuste_price)

reviews_validos <- datos_limpios$number_of_reviews[datos_limpios$number_of_reviews >= 0]
ajuste_reviews <- fitdistr(reviews_validos, densfun = "Poisson")
cat("\nDistribución sugerida para 'number_of_reviews': Poisson\n"); print(ajuste_reviews)

p_ajuste_price <- ggplot(data.frame(price = price_validos), aes(x = price)) +
  geom_histogram(aes(y = ..density..), bins = 60, fill = "skyblue", color = "white") +
  stat_function(fun = dlnorm,
                args = list(meanlog = ajuste_price$estimate["meanlog"],
                            sdlog  = ajuste_price$estimate["sdlog"]),
                color = "red", linewidth = 1) +
  scale_x_continuous(labels = dollar_format(prefix = "$")) +
  labs(title = "Ajuste Log-normal a 'price'", x = "Precio", y = "Densidad") +
  theme_minimal()
ggsave(file.path(ruta_guardado, "ajuste_price_lognormal.png"),
       plot = p_ajuste_price, width = 8, height = 5, dpi = 300)

r_ajuste_reviews <- ggplot(data.frame(n = reviews_validos), aes(x = n)) +
  geom_histogram(aes(y = ..density..), bins = 40, fill = "orange", color = "white") +
  stat_function(fun = function(x) dpois(x, lambda = ajuste_reviews$estimate["lambda"]),
                color = "red", linewidth = 1) +
  labs(title = "Ajuste Poisson a 'number_of_reviews'",
       x = "Número de reseñas", y = "Densidad") +
  theme_minimal()
ggsave(file.path(ruta_guardado, "ajuste_reviews_poisson.png"),
       plot = r_ajuste_reviews, width = 8, height = 5, dpi = 300)

cat("\n✅ Ajustes y gráficos de distribuciones guardados en:\n", ruta_guardado, "\n")

# ============================================================
# CONSIGNA: CONTRASTE DE HIPÓTESIS (2 hipótesis) Y SALIDAS
# ============================================================

cat("\n--- CONTRASTES DE HIPÓTESIS ---\n")

# Hipótesis 1: Diferencia de medias de price entre 'Entire home/apt' y 'Private room'
datos_room <- datos_limpios |>
  filter(room_type %in% c("Entire home/apt", "Private room")) |>
  mutate(room_type = droplevels(factor(room_type)))
t_test_price <- t.test(price ~ room_type, data = datos_room)  # Welch
cat("\n[H1] t-test price ~ room_type (Entire vs Private):\n"); print(t_test_price)

# Alternativa no paramétrica (robustez)
wilcox_price <- wilcox.test(price ~ room_type, data = datos_room, exact = FALSE)
cat("\n[H1-alt] Wilcoxon price ~ room_type (robusto):\n"); print(wilcox_price)

# Hipótesis 2: Asociación lineal entre number_of_reviews y availability_365
cor_pearson <- cor.test(datos_limpios$number_of_reviews, datos_limpios$availability_365, method = "pearson")
cat("\n[H2] Correlación Pearson (reviews vs availability):\n"); print(cor_pearson)

cor_spearman <- cor.test(datos_limpios$number_of_reviews, datos_limpios$availability_365, method = "spearman", exact = FALSE)
cat("\n[H2-alt] Correlación Spearman (robusta a no normalidad):\n"); print(cor_spearman)

# Guardar figura de H1 (boxplot de price por room_type)
fig_h1 <- ggplot(datos_room, aes(x = room_type, y = price, fill = room_type)) +
  geom_boxplot(outlier.alpha = 0.3) +
  scale_y_continuous(labels = dollar_format(prefix = "$")) +
  labs(title = "Price por tipo de habitación", x = "Tipo de habitación", y = "Precio") +
  theme_minimal() + theme(legend.position = "none")
ggsave(file.path(ruta_guardado, "H1_boxplot_price_roomtype.png"),
       plot = fig_h1, width = 8, height = 5, dpi = 300)

# Guardar figura de H2 (dispersión con ajuste lineal)
fig_h2 <- ggplot(datos_limpios, aes(x = number_of_reviews, y = price)) +
  geom_point(alpha = 0.35) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "Relación entre reseñas y precio", x = "Número de reseñas", y = "Precio") +
  theme_minimal()
ggsave(file.path(ruta_guardado, "H2_scatter_reviews_price.png"),
       plot = fig_h2, width = 8, height = 5, dpi = 300)

# ============================================================
# CONSIGNA: MODELO LINEAL (1 hipótesis con ML)
# ============================================================

cat("\n--- MODELO LINEAL: log(price) ~ room_type + number_of_reviews + availability_365 ---\n")

ml_df <- datos_limpios |>
  mutate(
    log_price = log(price),
    room_type = droplevels(factor(room_type))
  ) |>
  drop_na(log_price, room_type, number_of_reviews, availability_365)

modelo_lineal <- lm(log_price ~ room_type + number_of_reviews + availability_365, data = ml_df)
cat("\nResumen del modelo lineal:\n"); print(summary(modelo_lineal))
cat("\nANOVA del modelo:\n"); print(anova(modelo_lineal))

# Diagnóstico del modelo: gráficos a archivo
png(file.path(ruta_guardado, "ML_diagnostico_residuos_vs_ajustados.png"), width = 900, height = 600)
plot(modelo_lineal, which = 1)
dev.off()

png(file.path(ruta_guardado, "ML_diagnostico_qqplot.png"), width = 900, height = 600)
plot(modelo_lineal, which = 2)
dev.off()

# Predicción marginal por room_type (medias ajustadas simples)
pred_grid <- ml_df |>
  group_by(room_type) |>
  summarise(
    number_of_reviews = median(number_of_reviews, na.rm = TRUE),
    availability_365 = median(availability_365, na.rm = TRUE),
    .groups = "drop"
  )

pred_grid$log_price_hat <- predict(modelo_lineal, newdata = pred_grid, type = "response")
pred_grid$price_hat <- exp(pred_grid$log_price_hat)

cat("\nPredicciones marginales por room_type (medianas de covariables):\n"); print(pred_grid)

fig_ml_room <- ggplot(pred_grid, aes(x = room_type, y = price_hat, fill = room_type)) +
  geom_col() +
  scale_y_continuous(labels = dollar_format(prefix = "$")) +
  labs(title = "Medias ajustadas de Price por Room Type", x = "Room Type", y = "Precio ajustado") +
  theme_minimal() + theme(legend.position = "none")
ggsave(file.path(ruta_guardado, "ML_price_hat_por_roomtype.png"),
       plot = fig_ml_room, width = 8, height = 5, dpi = 300)

cat("\n🎯 Fin del script.\n")


