# ENERGÍA
proc energia {vector k} \
{
	foreach u $vector {
        lappend vr [expr {$u*$u*$k*0.5}]
	}
	set vr	
	return $vr
}

# END ENERGÍA


# INTEGRACIÓN

proc integracion {tiempo velocidad c} \
{

	set suma 0
	set limite [llength $tiempo]

	set v1 [lindex $velocidad 0]
	set v1 [expr $c]
	
	for {set i 0} {$i < [expr $limite-1]} {incr i} {
		set t1 [lindex $tiempo $i]
    	set t2 [lindex $tiempo [expr $i+1]]
    	
    	set v2 [lindex $velocidad [expr $i+1]]
    	set v2 [expr $v2 * $v2 * $c] 
    	
    	set vm [expr ($v1 + $v2)/2]
    	set suma [expr $suma + $vm * ($t2 - $t1)]
    	lappend vr $suma
    	
    	
    	set v1 $v2
	}

	set vr
	return $vr
}
# END INTEGRACIÓN


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

	for {set i 0} {$i < $nroColumnas} {incr i} {
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

# Obtiene el número de colummas del archivo de desplazamientos
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


