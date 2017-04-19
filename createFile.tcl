source C:/vlee/Dinamica/377/TCLOpenSees/Resultados

set c 12.327

# Captura los datos de velocidad
set fileVelocidad [open "Velocidad.out" "r"]
set velocidad [read $fileVelocidad]
close $fileVelocidad

# Captura los datos de tiempo
set fileTiempo [open "Tiempo.out" "r"]
set tiempo [read $fileTiempo]
puts $tiempo
close $fileTiempo

puts "Generando archivo energia disipativa.out"
set fileAreas [open "Areas.out" "w"]
#set listResultados [energia $tiempo 4]

#Aquí llama al método de integración
set energia [integracion $tiempo $velocidad $c]

#Anexando resultados al archivo Fuerza.out
foreach x $energia {
	puts $fileAreas $x
}

# Create a vector time and velocity. 
#set tiempo { 0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 } 
#set velocidad { 0.02 0.04 0.06 0.08 0.10}  

#set energia [integracion $tiempo $velocidad]
#puts $energia









