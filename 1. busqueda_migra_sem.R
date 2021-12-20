#CON LAS BASES YA GENERADAS EN SINTAXIS 0 (primer semana del mes), SE CORRE ESTO PARA BUSCAR LOS ULTIMOS CRUCES DE LOS VIAJEROS.

library(data.table)
library (dplyr)
library(haven)
library(foreign)


######### Abro base del mes.

#*cambiar nombre de mes de sav que levanto

Mes_20 <-as.data.table (read_sav("/srv/DataDNMYE/turismo_internacional/termometro/2021/12_diciembre/diciembre 2021_ 1 al 7.zip", 
                                 col_select = c(FECHA_CR,FECHA_NA, NRO_DOC, sexo, tipo_cru, arg, pax_4)))
#cambio class de sexo

class(Mes_20$sexo)
Mes_20$sexo <- as.integer(Mes_20$sexo)
head(Mes_20)


####2. Búsqueda mensual.#######################################################


ultima <- fread ("/srv/DataDNMYE/turismo_internacional/termometro/2021/busqueda_migraciones/2021_agr_11_ant.csv", sep = ",") 

#######Selecciono Entradas y matcheo, luego lo mismo con salidas.

Entradas <- ultima[tipo_cru == 1]
Salidas  <- ultima[tipo_cru == 2]

rm(ultima)

###########Empiezo con ultima base. Matcheo

#seteo keys para matcheo

setkey(Mes_20, FECHA_NA, NRO_DOC,sexo)
setkey(Entradas,FECHA_NA, NRO_DOC,sexo)
setkey(Salidas,FECHA_NA, NRO_DOC, sexo)

#entradas traigo fecha de ultimo cruce y prop_c

Mes_20<-merge(Mes_20, Entradas [ ,c(1,2,3,5,6)], all.x=TRUE, Sort=F)


#cambiar nombre de columna.

Mes_20 <- rename(Mes_20, E_2021_2 = "Fecha")
Mes_20 <- rename(Mes_20, prop_2021_2= "prop_c")

names (Mes_20)

#salidas, solo traigo fecha.

Mes_20<-merge(Mes_20, Salidas [ ,c(1,2,3,5)], all.x=TRUE, Sort=F)

#cambiar nombre 

Mes_20 <- rename(Mes_20, S_2021_2 = "Fecha")
names (Mes_20)


# base 2021

dt_2021 <- fread("/srv/DataDNMYE/turismo_internacional/termometro/2021/busqueda_migraciones/2021_agr.csv", sep= ",")

head(dt_2021)
#chequear que incluya el ultimo mes definitivo.
unique(month(dt_2021$Fecha))


#######Selecciono Entradas y matcheo, luego lo mismo con salidas.

Entradas <- dt_2021[tipo_cru == 1]
Salidas  <- dt_2021[tipo_cru == 2]

rm(dt_2021)


########### Matcheo

setkey(Mes_20, FECHA_NA, NRO_DOC,sexo)
setkey(Entradas,FECHA_NA, NRO_DOC,sexo)
setkey(Salidas,FECHA_NA, NRO_DOC, sexo)

#entradas traigo fecha de ultimo cruce y prop_c

Mes_20<-merge(Mes_20, Entradas [ ,c(1,2,3,5,6)], all.x=TRUE, Sort=F)


#cambiar nombre de columna.

Mes_20 <- rename(Mes_20, E_2021 = "Fecha")
Mes_20 <- rename(Mes_20, prop_2021= "prop_c")

names (Mes_20)

#salidas, solo traigo fecha.

Mes_20<-merge(Mes_20, Salidas [ ,c(1,2,3,5)], all.x=TRUE, Sort=F)

#cambiar nombre 

Mes_20 <- rename(Mes_20, S_2021 = "Fecha")
names (Mes_20)


rm(Entradas, Salidas)


####### 2020 ----


dt_2020<- fread("/srv/DataDNMYE/turismo_internacional/termometro/2021/busqueda_migraciones/2020_agr.csv", sep = ",") 

head(dt_2020)


#######Selecciono Entradas y matcheo, luego lo mismo con salidas.

Entradas <- dt_2020[tipo_cru == 1]
Salidas  <- dt_2020[tipo_cru == 2]

rm(dt_2020)

########### Matcheo

setkey(Mes_20, FECHA_NA, NRO_DOC,sexo)
setkey(Entradas,FECHA_NA, NRO_DOC,sexo)
setkey(Salidas,FECHA_NA, NRO_DOC, sexo)

#entradas traigo fecha de ultimo cruce y prop_c

Mes_20<-merge(Mes_20, Entradas [ ,c(1,2,3,5,6)], all.x=TRUE, Sort=F)

#cambiar nombre de columna.


Mes_20 <- rename(Mes_20, E_2020 = "Fecha")
Mes_20 <- rename(Mes_20, prop_2020= "prop_c")

names (Mes_20)

#salidas, solo traigo fecha.

Mes_20<-merge(Mes_20, Salidas [ ,c(1,2,3,5)], all.x=TRUE, Sort=F)

#cambiar nombre 

Mes_20 <- rename(Mes_20, S_2020 = "Fecha")
names (Mes_20)


#Abro csv 2019 (3) de DT generado desde agosto a dic 2019. 

dt_2019 <- fread("/srv/DataDNMYE/turismo_internacional/termometro/2021/busqueda_migraciones/2019_8_12 agr.csv", sep= ",")


#######Selecciono Entradas y matcheo, luego lo mismo con salidas.

Entradas <- dt_2019[tipo_cru == 1]
Salidas  <- dt_2019[tipo_cru == 2]

########### Matcheo

setkey(Mes_20, FECHA_NA, NRO_DOC,sexo)
setkey(Entradas,FECHA_NA, NRO_DOC,sexo)
setkey(Salidas,FECHA_NA, NRO_DOC, sexo)

#entradas traigo fecha de ultimo cruce y prop_c

Mes_20<-merge(Mes_20, Entradas [ ,c(1,2,3,5,6)], all.x=TRUE, Sort=F)

#cambiar nombre de columna.

Mes_20 <- rename(Mes_20, E_2019_3 = "Fecha")
Mes_20 <- rename(Mes_20, prop_2019_3= "prop_c")

names(Mes_20)

#salidas, solo traigo fecha.

Mes_20<-merge(Mes_20, Salidas [ ,c(1,2,3,5)], all.x=TRUE, Sort=F)

#cambiar nombre 

Mes_20 <- rename(Mes_20, S_2019_3 = "Fecha")
names(Mes_20)


#me tira error al guardar en sav: write_sav(Mes_20, "Mes_21_sem.sav")

#cambio formato fecha para que levante bien en SPSS. Pasa a chr.

class(Mes_20$FECHA_CR)
Mes_20$FECHA_CR <-format(Mes_20$FECHA_CR,"%d/%b/%Y %H:%M:%S")
class(Mes_20$FECHA_CR)

#Cambio fecha para que la levante en spss bien. (solo el mes que estoy corriendo, pero no pasa nada si corro otros meses)

#Mes_20$FECHA_CR <-gsub("abr.", "Apr", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("may.", "May", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("jun.", "Jun", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("jul.", "Jul", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("ago.", "Aug", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("sep.", "Sep", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("oct.", "Oct", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("/nov./", "-Nov-", Mes_20$FECHA_CR)
Mes_20$FECHA_CR <-gsub("/dic./", "-Dec-", Mes_20$FECHA_CR)
Mes_20$FECHA_CR <-gsub("/ene./", "-Jan-", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("/feb./", "-Feb-", Mes_20$FECHA_CR)
#Mes_20$FECHA_CR <-gsub("/mar./", "-Mar-", Mes_20$FECHA_CR)

head(Mes_20)

#guardo en server.

fwrite(Mes_20, "/srv/DataDNMYE/turismo_internacional/termometro/2021/12_diciembre/Mes_21_sem.csv")


# chequeos (no necesarios)

unique(year(Mes_20$S_2021))
unique(month(Mes_20$S_2021))
unique(month(Mes_20$E_2021))
library (lubridate)
unique(day(Mes_20$S_2021))
