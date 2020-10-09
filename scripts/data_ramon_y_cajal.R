#####################################################
## Vamos a extraer los datos del pdf
#####################################################

## Cargar las librerias #####
pacman::p_load(data.table, here, tabulizer, dplyr, pdftools, 
               stringr)


## Configuración #####

# localización del pdf
file_ramonycajal <- "https://www.ciencia.gob.es/stfls/MICINN/Ayudas/PE_2017_2020/PE_Promocion_Talento_Empleabilidad/Subprograma_Estatal_Incorporacion/FICHEROS/Ramon_Cajal_2019/PROPUESTA_RESOLUCION_DEFINITIVA_RYC_2019_I.pdf"


## Extraer los datos ####
out <- extract_tables(file_ramonycajal)

## Limpiar los datos ####
dt_list <- lapply(out, data.table)


##### Primera tabla del pdf
setnames(dt_list[[1]], old = "V1", new = "organismo")

dt_list[[1]][, area := paste0(V2, V3)]
dt_list[[1]][, nombre := paste(V4, V5, V6, V7)]

##### Segunda tabla del pdf
setnames(dt_list[[2]], 
         old = c("V1", "V2"),
         new = c("organismo", "area"),
         skip_absent=TRUE)

dt_list[[2]][, nombre := paste(V3, V4, V5)]

##### Tercera tabla del pdf
setnames(dt_list[[3]], 
         old = c("V1", "V2"),
         new = c("organismo", "area"),
         skip_absent=TRUE)
dt_list[[3]][, nombre := paste(V3, V4, V5, V6, V7)]

##### Cuarta tabla del pdf
setnames(dt_list[[4]], 
         old = c("V1", "V3"),
         new = c("organismo", "area"),
         skip_absent=TRUE)

dt_list[[4]][, nombre := paste(V5, V6, V8)]


##### Quinta tabla del .pdf
setnames(dt_list[[5]], 
         old = c("V1", "V3"),
         new = c("organismo", "area"),
         skip_absent=TRUE)

dt_list[[5]][, nombre := paste(V4, V6, V7)]



## Juntar las 5 tablas y limpiarlas ####

# Selecionar las columnas que me interesan
dt_list2 <- lapply(dt_list, function(x) {x[, c("organismo", "area", "nombre")]}) 

# Juntarlas
rc_dt <- rbindlist(dt_list2)

# Limpiar
rc_dt <- rc_dt[!area %in% c("Area Temática", "")]

# Limpiar espacios al principio y al final
rc_dt[, nombre := str_trim(nombre)] 

# Limpiar espacios dobles
rc_dt[, nombre := str_squish(nombre)]

# Recortar nombres largos
rc_dt[organismo == "AGENCIA ESTATAL CONSEJO SUPERIOR DE INVESTIGACIONES CIENTIFICAS (CSIC)",
      organismo := "CSIC"]


## Guardar datos ####
fwrite(rc_dt, here("data", paste0(format(Sys.time(), "%Y%m%d_%H%M"), "_ramonycajal.csv")))



