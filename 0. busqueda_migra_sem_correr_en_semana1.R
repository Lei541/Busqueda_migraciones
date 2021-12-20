### SE GENERAN BASES AGREGADAS, ACUMULADA DEL AÑO (DEFINITIVA) Y PROVISORIA (ANTICIPO ULTIMO MES) (ULTIMA ENTRADA Y SALIDA DE CADA VIAJERO PARA LUEGO HACER BUSQUEDA)
library(data.table)
library (dplyr)
library(lubridate)
library(haven)

##DEFINIR NOMBRES DE BASES MENSUALES
#*DEFINITIVA (Esta base se genera en spss y se guarda como csv en esta carpeta)

archivo_csv <- "entradas/10_2021.csv"

#ANTICIPO:
#Abro base ANTICIPO del mes anterior. 

ultima <-as.data.table (read_sav("entradas/noviembre 2021 (4_a).zip", 
                                 col_select = c("FECHA_CR", "FECHA_NA", "NRO_DOC", "PROP_CRU", "sexo", "tipo_cru")))

# cambio de tipo en var fecha_cr (de character a date) 

ultima [, FECHA_CR := as.Date(FECHA_CR,format="%m/%d/%Y")]

# Ordenar. 

setorder(ultima, FECHA_NA, NRO_DOC, sexo, FECHA_CR)

#####Agrupar/ trae ultima prop_cr y fecha

ultima <- ultima[,.( (Fecha =(FECHA_CR[.N])) , (prop_c =(PROP_CRU[.N])) ) ,
                 by= .(FECHA_NA, NRO_DOC, sexo, tipo_cru)]


ultima <- rename(ultima, Fecha = "V1")
ultima <- rename(ultima, prop_c= "V2")

head(ultima)

# guardar hasta para usar hasta tener base def.
#*cambiar nombre 

fwrite(ultima, "2021_agr_11_ant.csv")




##1. SUMO BASE DEFINITIVA A BASE COMPLETA ANUAL.############################


#Abro base definitiva csv del mes anterior. 

vars <- c("FECHA_CR", "FECHA_NA", "NRO_DOC", "PROP_CRU", "sexo", "tipo_cru")

ultima_def <- fread(archivo_csv, sep = ";", select = vars) 

# cambio de tipo en var fecha_cr (de character a date) 

ultima_def [, FECHA_CR := as.Date(FECHA_CR,format="%m/%d/%Y")]

# Abro base acumulada  al mes anterior .

dt_2021<- fread(file= "2021.csv", sep = ",") 

# (sumar nuevo mes con rbind (chequear heads) 

dt_2021 [, FECHA_CR := as.Date(FECHA_CR,format="%m/%d/%Y")]
class (ultima_def$FECHA_CR)
class (dt_2021$FECHA_CR)

#sumo mes actual.

dt_2021<- bind_rows(dt_2021, ultima_def)

# Ordenar. 

setorder(dt_2021, FECHA_NA, NRO_DOC, sexo, FECHA_CR)

#guardar para seguir sumando meses el proximo mes 

fwrite(dt_2021, "2021.csv")

####2. Búsqueda mensual.#######################################################

#####Agrupar/ trae ultima_def prop_cr y fecha

dt_2021 <- dt_2021[,.( (Fecha =(FECHA_CR[.N])) , (prop_c =(PROP_CRU[.N])) ) ,
                   by= .(FECHA_NA, NRO_DOC, sexo, tipo_cru)]


dt_2021 <- rename(dt_2021, Fecha = "V1")
dt_2021 <- rename(dt_2021, prop_c= "V2")


head(dt_2021)

# guardar para que quede lista para correr definitiva del mes. 

fwrite(dt_2021, "2021_agr.csv")




