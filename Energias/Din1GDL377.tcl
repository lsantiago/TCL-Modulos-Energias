######################################################################################
#Din1GDL377.tcl                                                                  #
#Analisis dinamico de  una estructura en solo grado de libertad 1GDL                 #
#Unidades: kN, m, s                                                                  #
######################################################################################
wipe ;# Este comando borra todos los objetos existentes en el interpretador Tcl
#DEFINICION DE CONSTANTES
set pi [expr acos(-1.0)]
#RECEPCION DE DATOS ##################################################################
set T 0.2 ;#Periodo
set m 100 ;#Masa
set Damp 5 ;#Amortiguamiento
set damp [expr $Damp*pow(100,-1)]
set duracionA 20 ;#Duración del analisis

#########################################################################################
# Nuevas variables.																		#
set omega [expr 2*$pi*pow($T,-1)]														
set k [expr $m*pow($omega,2)]							
set c [expr 2*$m*$damp*$omega]

puts $omega
puts $k
puts $c
#######################################################################################


#EMPIEZO A CREAR EL MODELO ###########################################################
model basic -ndm 2 -ndf 2      ;# 2 dimenciones; 2 Grados de Libertad (GDL) por nudo
# Se define la geometría -------------------------------------------------------------
# Coordenadas de los nudos
#    n x y
node 1 0 0
node 2 1 0
# Se empotra el nudo 1 
#   n 1 2 
fix 1 1 1
fix 2 0 1 
# Se asigna una masa en Tonne (kN/g) al nudo 2 en la dirección X
#    n  1   2
mass 2 $m 1e-6
# Definicion de Elementos   ------------------------------------------------------
# Se crea un elemento truss entre los nudos 1 y 2
# Al elemento elástico se le asigna un area de 1 m2
#Calculo el modulo de elasticidad
set E [expr (4*$m *pow($pi,2))/(pow($T,2))]
 
set TagMaterial 0 ;#Etiqueta
# MATERIAL: Elastico
uniaxialMaterial Elastic  $TagMaterial $E
#Defino el elemento
#             nele ni nj  Area TagMaterial
element truss 1 1  2 1  $TagMaterial
#MODELO CREADO
 
#VIBRACIÓN FORZADA ############################
 set pasoA [expr $T*pow(30,-1)]
# EXCITACION: Función Lineal
set Impulso 10 ;#Impulso
set DuracionImp 11 ;#Duración del impulso
set Fmax [expr $Impulso*$DuracionImp]
#Aplico la funcion de carga
#Se aplicará la carga a intervalos iguales de tiempo
# t0 F0 t1 F1
#0  0  DI Fmax
set time1 $DuracionImp
set dt $time1

set fileName "C:/vlee/Dinamica/377/TCLOpenSees/FactoresDE/FacDforceCL.txt"
set serie1  "Series -dt $dt -filePath $fileName"
pattern Plain 1 $serie1 {
#     node Fx Fy
load 2 $Fmax 0
}
#LA CARGA FUE DEFINIDA###########################################################
 
 #REALIZO EL ANALISIS DINAMICO
constraints Plain
numberer Plain
system BandGeneral
test NormDispIncr 1.0e-5 6
algorithm Newton
set alphaM [expr 4*$pi*$damp*pow($T,-1)]
set betaK [expr $damp*$T*pow($pi,-1)]
integrator Newmark 0.5 0.25 
rayleigh $alphaM $betaK 0 0
analysis Transient



#Guardo los resultados
recorder Node -file C:/vlee/Dinamica/377/TCLOpenSees/Resultados/Desplazamiento.out  -time  -closeOnWrite -node 2 -dof 1 disp
recorder Node -file C:/vlee/Dinamica/377/TCLOpenSees/Resultados/Velocidad.out  -time  -closeOnWrite -node 2 -dof 1 vel
recorder Node -file C:/vlee/Dinamica/377/TCLOpenSees/Resultados/Aceleracion.out  -time -node 2 -dof 1 accel
recorder Node -file C:/vlee/Dinamica/377/TCLOpenSees/Resultados/Reaccion.out  -time -node 1 -dof 1 reaction
recorder Element -file C:/vlee/Dinamica/377/TCLOpenSees/Resultados/Fuerza.out  -time -ele 1  localForce


#Pido los resultados segun la duración del analisis
set npuntos [format "%.0f" [ expr $duracionA*pow($pasoA,-1)]] 
analyze $npuntos $pasoA

set nameDespIn "C:/vlee/Dinamica/377/TCLOpenSees/Resultados/Desplazamiento.out"
set nameVelIn "C:/vlee/Dinamica/377/TCLOpenSees/Resultados/Velocidad.out"
set DirFileOut "C:/vlee/Dinamica/377/TCLOpenSees/Resultados"

source C:/vlee/Dinamica/377/TCLOpenSees/WriteEnerg.tcl
writeEPoteYCine 0 $nameDespIn $DirFileOut $k
writeEPoteYCine 1 $nameVelIn $DirFileOut $m
writeEDisi $nameVelIn $DirFileOut $c


exit

