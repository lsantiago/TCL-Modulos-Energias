#############################################################
# Procedimiento para  imprimir la energia potencial y o     #
# cinetica. Se requiere como datos de entrada el nombre del #
# archivo que contiene el desplazamiento o velocidad y la   #
# rigidez o masa segun se vaya a imprimir la energia        # 
# potencial o cinectica respectivamente.                    #
# El archivo que serà leido tendra en su primera columna    #
# el tiempo y las columnas siguientes corresponderan a los  #
# resultados obtenidos de la simulación.                    #
#                                                           #  
#         writeEPoteYCine [nameFile k]                      #
# nameFile: Nombre del Archivo con los resultados de la sim #          
# k: Rigidez o masa segun corresponda                       #
#                                                           #
# Escrito por: Edwin Duque                                  #
#              Santiago Quiñonez                            #
# Fecha: 14/02/2017                                         #
# Ultima revisión: 14/02/2017                               #
#############################################################


# Llama al archivo utilerias
source C:/Users/Administrador/Documents/GitHub/TCL-Modulos-Energias/Energias/utilerias.tcl

proc writeEPoteYCine {nameFile k} {

# Obtiene el número de columnas del archivo
set NumColum [getNroColumnasDes $nameFile]
# Lee los datos del archivo nameFile
set datos [getAllDesplazamientos $nameFile]
# La primera columna es el tiempo
set t [lindex $datos 0]
# Obtiene el número de lineas
set Nlines [llength $t]
puts $NumColum 
	puts "Generando archivo energia potencial.out"
	
	# Genera el archivo en el que imprimen las energias 
	set fileEPotencial [open C:/Users/Administrador/Documents/GitHub/TCL-Modulos-Energias/Energias/EPotencial.out w]

	for {set i 1} {$i <= $NumColum} {incr i 1} {
		
		 puts [format "Desplazamiento leido%01d" $i] 
		
		 set desp [lindex $datos $i]
		 # Llama a la función que calcula la energia potencial
		 set EPotencial [CalEPoteYCin $desp $k]
		 
		 	#Imprime las energias en columnas
			for {set j 0} {$j < $Nlines} {incr j 1} {
				#set tiempo [lindex $t $j]
				set energia [lindex $EPotencial $j]
				puts $fileEPotencial "$tiempo $energia" 
			}
			
		 close $fileEPotencial 
	 }


}


proc writeEDisi {nameFile c} {

# Obtiene el número de columnas del archivo
set NumColum [getNroColumnasDes $nameFile]
# Lee los datos del archivo nameFile
set datos [getAllDesplazamientos $nameFile]
# La primera columna es el tiempo
set t [lindex $datos 0]
# Obtiene el número de lineas
set Nlines [llength $t]

	puts "Generando archivo energia potencial.out"
	
	for {set i 1} {$i <= $NumColum} {incr i 1} {
		
		 puts [format "velocidad leida%01d" $i] 
		 # Genera el archivo en el que imprimen las energias 
		 set fileEDisi [open C:/Users/Administrador/Documents/GitHub/TCL-Modulos-Energias/Energias/EDisi$i w]
		 set vel [lindex $datos $i]

		 # Llama a la función que calcula la energia potencial
		 set EDisi [CalEDisi $t $vel $c]
		 
		 	#Imprime las energias en columnas
			for {set j 0} {$j < $Nlines} {incr j 1} {
			
			set tiempo [lindex $t $j]
			set energia [lindex $EDisi $j]
			puts $fileEDisi "$tiempo $energia" 
			puts "$j $tiempo $energia"
			}
			
		 close $fileEDisi 
	 }
}