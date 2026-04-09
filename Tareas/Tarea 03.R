#1. How many rows are in penguins? How many columns?

library(palmerpenguins)
library(tidyverse)
library(ggplot2)
penguins

#RTA: 344 filas, 8 columnas

#2. What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out.

?penguins

#RTA: Es una medicion en milimetros de la profundidad del pico (o altura)

#3. Make a scatterplot of bill_depth_mm vs. bill_length_mm. That is, make a scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis. Describe the relationship between these two variables.

ggplot(
  data = penguins,
  mapping = aes(y = bill_depth_mm, x = bill_length_mm)
)+
  geom_point()
#RTA: Parecerian no tener correlacion

#4. What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?

ggplot(
  data = penguins,
  mapping = aes(x = bill_depth_mm, y = species)
)+
  geom_point()

#RTA: Generamos un grafico con lineas poco claras, un mejor geom seria alguno que permita ver mejor la distribucion (como geom_violin)

#Why does the following give an error and how would you fix it?

#ggplot(data = penguins) + 
# geom_point()

ggplot(data = penguins) + 
  geom_point()

#Definimos mapeo de X e Y

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = bill_depth_mm)) + 
  geom_point()

#RTA: El problema del codigo es que no mapea X e Y, generando error

#6. What does the na.rm argument do in geom_point()? What is the default value of the argument? Create a scatterplot where you successfully use this argument set to TRUE

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = bill_depth_mm)) + 
  geom_point(na.rm = )
#El codigo sin asignar na.rm

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = bill_depth_mm)) + 
  geom_point(na.rm = FALSE )
#El codigo dandole FALSE a na.rm

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = bill_depth_mm)) + 
  geom_point(na.rm = TRUE )
#El codigo dandole TRUE a na.rm

#na.rm controla si aparece el aviso de valores faltantes, por lo general esta puesto en false para que aparezca, ponerlo en true podria ser util si uno ya sabe que esos valores faltan y es intencional

#7. Add the following caption to the plot you made in the previous exercise: “Data come from the palmerpenguins package.” Hint: Take a look at the documentation for labs().

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = bill_depth_mm)) + 
  geom_point(na.rm = TRUE )+
  labs (title = "Data comes from the palmerpenguins package.")

#8. Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? And should it be mapped at the global level or at the geom level?

ggplot(
  #Asigno data y mapeo variables
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  #Establesco el geom, le doy color por bill depth a los puntos y genero la linea de tendencia
  geom_point(aes(color = bill_depth_mm)) +
  geom_smooth()

#RTA: Bill depth deberia tener la aesthetic color, para que los puntos aparezcan con una espectro de color dependiendo la profundidad del pico, esto deberia hacerse en el nivel de geom para no afectar por bill depth a cualquier otra cosa que no sean los puntos

#9.Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)
#RTA: Es lo que me esperaba, el mapeo de color=island en global hace que genera 3 lineas distintas, se=false no sabia que hacia pero al ver el grafico me doy cuenta que elimina la sombra de incertidumbre que suelen tener los graficos

#10.Will these two graphs look different? Why/why not?

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )

#Los graficos se ven iguales ya que lo agregado a geom smooth y geom point en el geom level es algo ya presente en el nivel global en el otro grafico, lo cual es heredado por todos los geoms consiguientes.

#11. Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?

ggplot(penguins, aes(y = species)) +
  geom_bar()

#Pruebo con x para ver la diferencia
ggplot(penguins, aes(x = species)) +
  geom_bar()

#RTA: Cambia la direccion de las barras

#12. How are the following two plots different? Which aesthetic, color or fill, is more useful for changing the color of bars?
  
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")  

#RTA: La primera solo le cambia el contorno, mientras que la segunda cambia el color de la barra entera, haciendola mucho mas util

#13. What does the bins argument in geom_histogram() do?

#Probamos sin

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram()

#Probamos con

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(bins = 50)

#RTA: Controla el numero de subdivisiones o barras

#14.Make a histogram of the carat variable in the diamonds dataset that is available when you load the tidyverse package. Experiment with different binwidths. What binwidth reveals the most interesting patterns?

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

#RTA: 0.1 parece permitir ver la diferencias entre los diamantes

#15.The mpg data frame that is bundled with the ggplot2 package contains 234 observations collected by the US Environmental Protection Agency on 38 car models. Which variables in mpg are categorical? Which variables are numerical? (Hint: Type ?mpg to read the documentation for the dataset.) How can you see this information when you run mpg?

?mpg

#RTA: manufacturer, model, trans, drv, fl, class son categoricas. displ, year, cyl, cty, hwy son numericas

#16. Make a scatterplot of hwy vs. displ using the mpg data frame. Next, map a third, numerical variable to color, then size, then both color and size, then shape. How do these aesthetics behave differently for categorical vs. numerical variables?

#Generamos el scatterplot
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

#Probamos con variable nominal

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = year ))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(size = year ))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = year, size = year ))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(shape = year ))

#RTA: Se diferencia el comportamiento con las categoricas en que se comportan como un espectro, un intervalo, mientras que para las categoricas simplemente se le asignan un color a cada categoria y listo (Por otra parte para nominales shape directamente no anda)

#17.In the scatterplot of hwy vs. displ, what happens if you map a third variable to linewidth?

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(linewidth = year ))

#RTA: salta un aviso diciendo que ingora la aesthetic desconocida

#18.What happens if you map the same variable to multiple aesthetics?

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = year, size = year ))

#RTA: Se aplican ambas al mismo tiempo

#19.Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points by species. What does adding coloring by species reveal about the relationship between these two variables? What about faceting by species?

#Coloreamos por especie
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(aes(color = species ))

#Faceteamos por especie

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(aes(color = species ))+
  facet_wrap(~species)

#RTA: Ambos metodos revelan la relacion entre la especie y las otras dos variables elegidas, quizas el facet lo hace mas evidente aun.

#20. Why does the following yield two separate legends? How would you fix it to combine the two legends?

#Codigo original

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species")

#Codigo arreglado

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "species")

#RTA: Las dos leyendas se generan porque en aes pusimos species en minuscula y en labs lo pusimos con S mayuscula, el programa es muy literal asi que asume que son cosas distintas. El arreglo es sacarle la mayuscula a una o ponersela a la otra

#21. Create the two following stacked bar plots. Which question can you answer with the first one? Which question can you answer with the second one?
  
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")

#RTA: El primero responde a que porcentaje de pinguinos de cada isla es de cada especie, mientras que el segundo responde que porcentaje de pinguino de cada especie esta en cada isla

#22. Run the following lines of code. Which of the two plots is saved as mpg-plot.png? Why?

ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.png")

#RTA: Siempre se guarda la ultima que fue ejecutada, si se ejecuta en orden cronologico, entonces la segunda

#23. What do you need to change in the code above to save the plot as a PDF instead of a PNG? How could you find out what types of image files would work in ggsave()?

#Cambio png por pdf
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.pdf")

#RTA: Cambiando png por pdf. Sabrias probando o leyendo la bibliografia de ggplot, quizas si elegis un formato no soportado por ggplot te lleva hacia una guia o te informa sobre los formatos que si lo estan
