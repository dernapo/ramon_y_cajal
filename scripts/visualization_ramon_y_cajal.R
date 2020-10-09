#####################################################
## Vamos a preparar varias gráficas con los datos
#####################################################

## Cargar librerias #####
pacman::p_load(data.table, here, ggplot2, hrbrthemes,
               patchwork, ggtext)

## Set theme ####
theme_set(theme_ipsum_rc())
theme_set(theme_ipsum())
theme_set(theme_ft_rc())

## Cargar datos ####

rc_dt <- fread(max(list.files(path = here("data"), pattern = ".*csv$", full.names = TRUE)))

## Visualización ####
area_graph <- rc_dt[, .(count = .N), area][order(-count)] %>% 
  ggplot(aes(y = reorder(area, count), x = count)) +
  geom_col() +
  labs(title = "Por Área",
       x = NULL,
       y = NULL)

organismo_graph <- rc_dt[, .(count = .N), organismo][order(-count)][1:19] %>% 
  ggplot(aes(y = reorder(organismo, count), x = count)) +
  geom_col() +
  labs(title = "Por Organismo",
       subtitle = "top 19",
       x = NULL,
       y = NULL)

## Poner los gráficos juntos
(organismo_graph / area_graph) +  plot_annotation(
  title = "Contratos Ramón y Cajal",
  subtitle = "Ayudas para contratos convocatoria 2019",
  caption = paste0("Fuente: https://www.ciencia.gob.es/\nAutor: @dernapo\nDate: ", format(Sys.Date(), "%d %b %y")),
  theme = theme(plot.title = element_markdown(lineheight = 1.1),
                plot.subtitle = element_markdown(lineheight = 1.1))
)


## Guardar visualización ####
ggsave(here("output", paste0(format(Sys.time(), "%Y%m%d_%H%M"), "_ramonycajal.png")), 
       height = 12, 
       width = 12)
