############################################################
# Procedimiento para calcular la energia pontecial o       #
# cinética. Se requiere como datos de entrada un vector    #
# de desplazamientos o velocidad y el valor de rigidez     #
# o masa segun se calcule la energia pontecial o cinetica  #
# respectivamente.                                         #
#                                                          #
#             CalEPoteYCin [Desplazamiento k]              #
# Desplazamiento: Vector de desplazamiento o velocidad     #
# k: Rigidez o masa del sistema                            #
#                                                          #
# Escrito por: Edwin Duque	                               #
#			   Santiago Quiñonez                           #
# Fecha: 14/02/2017                                        #
# Ultima revisión: 14/02/2017                              #
############################################################


proc CalEPoteYCin {Desplazamiento k} \
{
	foreach u $Desplazamiento {
       lappend vr [expr {$u*$u*$k*500}]
	}
	set vr	
	return $vr
}

################################################################
# Procedimiento para calcular la energia disipativa. Se        #
# requiere como datos de entrada un vector de desplazamientos, #
# velocidad y el valor de coeficiente de amortiguamiento       #
#                                                              #
#             CalEDisi [tiempo velocidad c]                    #
# Parametros:                                                  #
# tiempo: Vector de tiempo.                                    #
# velocidad: Vector de velocidad                               #
# c: Coeficiente de amortiguamiento                            #
# Ejem de uso:                                                 #
#      set EDisipa [CalEDisi $vel $c]                          #
#                                                              #
# Escrito por: Edwin Duque	                                   #
#			   Santiago Quiñonez                               #
# Fecha: 14/02/2017                                            #
# Ultima revisión: 14/02/2017                                  #
################################################################
proc CalEDisi {tiempo velocidad c} \
{
	
	set suma 0
	set limite [llength $tiempo]
	set v1 [lindex $velocidad 0]
	set v1 [expr $v1 * $v1 * $c * 1000]
	set vr 0
	

	for {set i 0} {$i < [expr $limite-1]} {incr i} {
		set t1 [lindex $tiempo $i]
    	set t2 [lindex $tiempo [expr $i+1]]
    	set v2 [lindex $velocidad [expr $i+1]]
    	set v2 [expr $v2 * $v2 * $c*1000] 
    	set vm [expr ($v1 + $v2)/2]
    	set suma [expr $suma + $vm * ($t2 - $t1)]
    	lappend vr $suma
    	
    	
    	set v1 $v2
	}

	#set vr
	return $vr
}


# DESPLAZAMIENTO

# Proceso getAllDesplazamientos
# 	Obtiene todos los desplazamientos
# Parámetros 
# 	nameFile: Nombre del archivo de desplazamientos 
# Ej. de uso:
# 	set datos [getAllDesplazamientos "Desplazamiento2.out"]
# 	set desp [lindex $datos 2]
# 	puts $desp
proc getAllDesplazamientos {nameFile} \
{
	set nroColumnas [getNroColumnasDes $nameFile]

	for {set i 0} {$i <= $nroColumnas} {incr i} {
		set desplazamiento [getDesplazamiento $nameFile $i]
		lappend allDes $desplazamiento
	}

	set allDes
	return $allDes 
}

# Obtiene un desplazamiento
proc getDesplazamiento {nameFile nroCol} \
{
	set pfi [open $nameFile "r"]
	while {1 == 1} {
	    set cnt [gets $pfi row]
	    if {$cnt < 0} {break}
	    set word [lindex [split $row " "] $nroCol]
	    lappend vr $word
	}
	close $pfi

	set vr	
	return $vr
}

proc getNroColumnasDes {nameFile} \
{
	set pfi [open $nameFile "r"]
	set cnt [gets $pfi row]
	set fila [split $row " "]
	set nroCol [llength $fila]
	close $pfi

	return [expr $nroCol-1]
}

# END DESPLAZAMIENTO


proc getRelDesplazamientos {nameFile} \
{
	set nroColumnas [getNroColumnasDes $nameFile]
	
	
		for {set i 0} {$i <= $nroColumnas} {incr i} {
			


			  if {$i <= 1} {			
				set desplazamiento [getDesplazamiento $nameFile $i]
				set limite [llength $desplazamiento]
	            lappend allRelDes $desplazamiento
				} else {

				set Vdesp1 [getDesplazamiento $nameFile [expr $i-1]]
				set Vdesp2 [getDesplazamiento $nameFile $i]
				

					#

					for {set j 0} {$j <= [expr $limite-1]} {incr j} {
						set desp1 [lindex $Vdesp1 $j]
						set desp2 [lindex $Vdesp2 $j]
						set Vecdis [expr ($desp2-$desp1)] 
					
						lappend desplazamientoRel $Vecdis

					}
					set desplazamientoRel 
					lappend allRelDes $desplazamientoRel
				}
	            
				
			
			
		}

		set allRelDes
		return $allRelDes 
}


proc imprLista {nameFileOut A B} \
{
	set allList [linsert $A end $B]
	set NumColum [llength $allList]
	#set fileWr [open $nameFileOut w]
	
		for {set i 0} {$i < $NumColum} {incr i 1} { 
		 
		 set DatList [lindex $allList $i]
		 set Nlines [llength $DatList]

		 	
		 	foreach x $DatList {	;# Now loop and print...
    		puts "$x\t"
			
			}
		}

			#set Data
			
		#}
		#puts $fileWr "$c" 
		
		#close $fileWr


