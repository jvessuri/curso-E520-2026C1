#Importamos todo
setwd("C:/Users/jvess/ECON 520/repo-curso-2026/curso-E520-2026C1")
library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)
anac_2025 <- read_csv2("data/202512-informe-ministerio-actualizado-dic-final.csv")
anac_2024 <- read_csv2("data/202412-informe-ministerio-actualizado-dic-final.csv")
anac_2023 <- read_csv2("data/202312-informe-ministerio-actualizado-dic.csv")
anac_2022 <- read_csv2("data/202212-informe-ministerio-actualizado-dic-final.csv")
anac_2021 <- read_csv2("data/202112-informe-ministerio-actualizado-dic-final.csv")
anac_2020 <- read_csv2("data/202012-informe-ministerio-actualizado-dic-final.csv")
anac_2019 <- read_csv2("data/201912-informe-ministerio-actualizado-dic-final.csv")

glimpse(anac_2025)

limpiar_anac <- function(df, anio) {
  df |>
    mutate(across(everything(), as.character)) |>
    mutate(
      anio = anio,
      tipo_vuelo = factor(`Clase de Vuelo (todos los vuelos)`),
      clasif_vuelos = factor(`Clasificación Vuelo`),
      tipo_movimiento = factor(`Tipo de Movimiento`),
      aeropuerto = factor(Aeropuerto),
      origen_destino = factor(`Origen / Destino`),
      aerolinea = factor(`Aerolinea Nombre`),
      calidad_dato = factor(`Calidad dato`),
      aeronave = factor(Aeronave)
    )
}

anac_2019 <- limpiar_anac(anac_2019, 2019)
anac_2020 <- limpiar_anac(anac_2020, 2020)
anac_2021 <- limpiar_anac(anac_2021, 2021)
anac_2022 <- limpiar_anac(anac_2022, 2022)
anac_2023 <- limpiar_anac(anac_2023, 2023)
anac_2024 <- limpiar_anac(anac_2024, 2024)
anac_2025 <- limpiar_anac(anac_2025, 2025)


#Observamos lo ocurrido en la pandemia

anac_total <- bind_rows(anac_2019, anac_2020, anac_2021, anac_2022, anac_2023, anac_2024, anac_2025)

vuelos_por_anio <- anac_total |>
  group_by(anio) |>
  summarise(vuelos = n()) |>
  arrange(anio) |>
  mutate(
    cambio_pct_vuelos = (vuelos / lag(vuelos) - 1) * 100
  )

ggplot(vuelos_por_anio, aes(x = factor(anio), y = vuelos)) +
  geom_col(fill = "steelblue") +
  scale_y_continuous(
    labels = scales::label_number(scale = 1e-3)
  ) +
  labs(
    title = "Cantidad de vuelos por año",
    x = "Año",
    y = "Número de vuelos (en miles)"
  )

vuelos_por_anio

#1. En 2020 vemos una caida del 63,4% con respecto a 2019

base_2019 <- vuelos_por_anio |>
  filter(anio == 2019) |>
  pull(vuelos)

vuelos_por_anio <- vuelos_por_anio |>
  mutate(vs_2019 = (vuelos / base_2019 - 1) * 100)

vuelos_por_anio |>
  filter(vs_2019 >= 0)

#2. Recien en 2025 llegaste a niveles iguales o superiores de 2019

patrones <- anac_total |>
  group_by(anio, tipo_vuelo) |>
  summarise(vuelos = n()) |>
  group_by(anio) |>
  mutate(participacion = vuelos / sum(vuelos))

antes <- patrones |>
  filter(anio <= 2019) |>
  group_by(tipo_vuelo) |>
  summarise(prom_antes = mean(participacion), .groups = "drop")

despues <- patrones |>
  filter(anio >= 2023) |>
  group_by(tipo_vuelo) |>
  summarise(prom_despues = mean(participacion), .groups = "drop")

comparacion <- antes |>
  inner_join(despues, by = "tipo_vuelo") |>
  mutate(
    cambio_pct_tipos = (prom_despues / prom_antes - 1) * 100
  )

comparacion

#3. La tabla de generada muestra los cambios porcentuales en los tipos de vuelos.

