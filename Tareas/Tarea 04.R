library(ggplot2)
library(nycflights13)
library(tidyverse)

#1. In a single pipeline for each condition, find all flights that meet the condition:
#Had an arrival delay of two or more hours

flights |> 
  filter(dep_delay >= 120)

#Flew to Houston (IAH or HOU)

flights |>
  filter(dest == "HOU" | dest == "IAH" )

#Were operated by United, American, or Delta

?flights
flights |>
  filter(carrier == "UA" | carrier == "AA" | carrier == "DL")

#Departed in summer (July, August, and September)

flights |> 
  filter(month == 7 | month == 9 | month == 8)

#Arrived more than two hours late but didn’t leave late

flights |>
  filter(dep_delay == 0 & arr_delay > 120)

#Were delayed by at least an hour, but made up over 30 minutes in flight

?flights
flights |>
  filter(dep_delay >= 60 & (dep_delay - arr_delay) >= 30)

#2. Sort flights to find the flights with the longest departure delays. Find the flights that left earliest in the morning.

flights |>
  arrange(desc(dep_delay))

flights |>
  arrange(dep_time)

#3. Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)

flights |>
  arrange(desc(distance / air_time * 60))

#4. Was there a flight on every day of 2013?

flights |>
  distinct(month, day) |>
  count()
#Efectivamente hubo un vuelo todos los dias

#5. Which flights traveled the farthest distance? Which traveled the least distance?

#Mas distancia
flights |>
  arrange(desc(distance))

#Menos distancia
flights |>
  arrange(distance)

#6.Does it matter what order you used filter() and arrange() if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.

#RTA: En cuanto a resultado es igual, pero en performance es mejor primero filtrar y minimizar el numero de filas para despues organizar un numero de filas menor con arrange

#7. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?

#RTA dep_delay=dep_time - sched_dep_time

#8.Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.

flights |>
  select(dep_time, dep_delay, arr_time, arr_delay)

flights |>
  select(starts_with("dep"), starts_with("arr"))

flights |>
  select(!year:day & !starts_with("sched") & !carrier:time_hour)

#9.What happens if you specify the name of the same variable multiple times in a select() call?

flights |> 
  select(year, month, year)

#RTA: Lo selecciona una sola vez

#10. What does the any_of() function do? Why might it be helpful in conjunction with this vector?

variables <- c("year", "month", "day", "dep_delay", "arr_delay")
flights |>
  select(any_of(variables))

#Rta: any of hace que se utilizen las columnas definidas dentro de un vector, en este caso con el vector es util para utilizar todas las columnas que contiene.

#11.Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?

flights |> select(contains("TIME"))

#RTA: No me sorprende. Select toma mayusculas y minusculas como indiferentes. Se puede cambiar seteando ignore.case = FALSE

#12.Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.

flights |>
  rename(air_time_min = air_time) |>
  relocate (air_time_min, .before = 1)

#13.Why doesn’t the following work, and what does the error mean?

flights |> 
  select(tailnum) |> 
  arrange(arr_delay)
#> Error in `arrange()`:
#> ℹ In argument: `..1 = arr_delay`.
#> Caused by error:
#> ! object 'arr_delay' not found

#El codigo no funciona porque seleccionas solo tailnum y despues queres que ordene una columna que al no estar seleccionada, no esta presente. El error dice que no puede encontrar arr_delay, y es justamente porque la dejaste afuera de la seleccion

#14. Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))

flights |>
  group_by(carrier) |>
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE)
  ) |>
  arrange(desc(avg_delay))

#RTA: El peor es F9

#Desafio
flights |>
  group_by(carrier, dest) |>
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  ) |>
  arrange(desc(avg_delay))
#Es dificil desentrelazarlo por el numero distinto de vuelos por aerolinea hacia cada areopuerto. Es dificil decir que es representativo, quizas seria mejor restarle el avg de cada areopuerto al avg de cada aerolinea para cada aeropuerto

#15.Find the flights that are most delayed upon departure to each destination

flights |>
  group_by(dest) |>
  slice_max(dep_delay,n = 1, with_ties = FALSE)

#16. How do delays vary over the course of the day? Illustrate your answer with a plot.

flights |>
  group_by(hour) |>
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) |>
  ggplot(aes(x = hour, y = avg_delay))+
  geom_line()

#RTA: Los delays son mas altos cuanto mas se acercan aproximadamente a las 19hs

#17.What happens if you supply a negative n to slice_min() and friends?

#Elimina esas filas en vez de dejar solo esas.

#18.Explain what count() does in terms of the dplyr verbs you just learned. What does the sort argument to count() do?

#RTA: Count es como hacer un shortcut a group by y summarize(n = n()), sort hace que ademas los arregle en orden descendiente

#19. We forgot to draw the relationship between weather and airports in Figure 19.1. What is the relationship and how should it appear in the diagram?

#RTA: La relacion entre weather y airports es atraves de la tabla flights por la variable origin

#20. weather only contains information for the three origin airports in NYC. If it contained weather records for all airports in the USA, what additional connection would it make to flights?

#RTA: Habria una nueva conexion atraves de dest

#21.The year, month, day, hour, and origin variables almost form a compound key for weather, but there’s one hour that has duplicate observations. Can you figure out what’s special about that hour?

#RTA: Daylight savings.

#22.We know that some days of the year are special and fewer people than usual fly on them (e.g., Christmas eve and Christmas day). How might you represent that data as a data frame? What would be the primary key? How would it connect to the existing data frames?


dias_festivos <- tibble(
  year = c(2013, 2013),
  month = c(12, 12),
  day = c(24, 25),
  name = c("Nochebuena", "Navidad"),
  type = c("dia festivo", "dia festivo")
)

#La primary key seria (year, month, day) y se conecta por estas mismas variables a flights

#23. Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the weather data. Can you see any patterns?

peores <- flights |>
  group_by(year, month, day, hour, origin)|>
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))|>
  ungroup()|>
  slice_max(avg_delay, n = 48, with_ties = FALSE)
peores |>
  left_join(weather)|>
  summarise(
    visib = mean(visib, na.rm = TRUE),
    wind = mean(wind_speed, na.rm = TRUE),
    precip = mean(precip, na.rm = TRUE)
  )
todas <- flights |>
  group_by(year, month, day, hour, origin) |>
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) |>
  ungroup() |>
  left_join(weather)

todas |>
  summarise(
    visib = mean(visib, na.rm = TRUE),
    wind = mean(wind_speed, na.rm = TRUE),
    precip = mean(precip, na.rm = TRUE)
  )

#RTA: En las tablas de promedios se puede ver que las variables con efecto son visibilidad y precipitacion.

#24. Imagine you’ve found the top 10 most popular destinations using this code:

top_dest <- flights2 |>
  count(dest, sort = TRUE) |>
  head(10)

#How can you find all flights to those destinations?

flights2 |>
  semi_join(top_dest)

#25.Does every departing flight have corresponding weather data for that hour?

flights |>
  anti_join(weather, by = c("year", "month", "day", "hour", "origin"))

#RTA: No.

#26.What do the tail numbers that don’t have a matching record in planes have in common? (Hint: one variable explains ~90% of the problems.)

planes

faltante <- flights |>
  anti_join(planes, by = "tailnum")

faltante |>
  count(origin, sort = TRUE)
faltante |>
  count(dest, sort = TRUE)
faltante |>
  count(carrier, sort = TRUE)

#RTA: Parece ser que los carriers MQ y AA son responsables de la gran mayoria del problema

#27 Add a column to planes that lists every carrier that has flown that plane. You might expect that there’s an implicit relationship between plane and airline, because each plane is flown by a single airline. Confirm or reject this hypothesis using the tools you’ve learned in previous chapters.

tailnumcarriers <- flights |>
  group_by(tailnum) |>
  summarise(carriers  = list(unique(carrier)))

planes2 <- planes |>
  left_join(tailnumcarriers)

planes2 |>
  mutate(n_carriers = lengths(carriers))|>
  count(n_carriers, sort = TRUE)

#RTA: Es falso

#28. Add the latitude and the longitude of the origin and destination airport to flights. Is it easier to rename the columns before or after the join?

flights2 <- flights |>
  left_join(
    airports |> select(faa, lat, lon),
    by = c("origin" = "faa")
  ) |>
  rename(origin_lat = lat,
         origin_lon = lon)

flights2 <- flights2 |>
  left_join(
    airports |> select(faa, lat, lon),
    by = c("dest" = "faa")
  ) |>
  rename(dest_lat = lat,
         dest_lon = lon)

#RTA: Es mejor despues, mas facil

#29.Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Here’s an easy way to draw a map of the United States:

airports |>
  semi_join(flights, join_by(faa == dest)) |>
  ggplot(aes(x = lon, y = lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

#You might want to use the size or color of the points to display the average delay for each airport.

avgdelays <- flights |>
  group_by(dest) |>
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))

airports2 <- airports |>
  left_join(avgdelays, by = c("faa" = "dest"))

airports2 |>
  semi_join(flights, join_by(faa == dest)) |>
  ggplot(aes(x = lon, y = lat)) +
  borders("state") +
  geom_point(aes(color = avg_delay)) +
  coord_quickmap()

#29. What happened on June 13 2013? Draw a map of the delays, and then use Google to cross-reference with the weather.

delays_junio13 <- flights |>
  filter(year == 2013, month == 6, day == 13) |>
  group_by(dest) |>
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE))

airportsjunio13 <- airports |>
  semi_join(
    flights |> filter(year == 2013, month == 6, day == 13),
    join_by(faa == dest)
  ) |>
  left_join(delays_junio13, by = c("faa" = "dest"))

airportsjunio13 |>
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point(aes(color = avg_delay)) +
  coord_quickmap()
