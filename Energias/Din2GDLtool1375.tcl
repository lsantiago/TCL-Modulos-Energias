######################################################################################
#Din2GDLtool1375.tcl                                                                  #
#Analisis dinamico de  una estructura de dos grados de libertad 2GDL                 #
#Unidades: kN, m, s                                                                  #
######################################################################################
wipe ;# Este comando borra todos los objetos existentes en el interpretador Tcl
#DEFINICION DE CONSTANTES
set pi [expr acos(-1.0)]
#RECEPCION DE DATOS ##################################################################
set m1 10 ;#Masa 1
set m2 9 ;#Masa 2
set k1 200 ;#Rigidez 1
set k2 200 ;#Rigidez 2
set c1 10 ;#Constante de amortiguamiento 1
set c2 10 ;#Constante de amortiguamiento  2
set duracionA 30 ;#Duración del analisis
#EMPIEZO A CREAR EL MODELO ###########################################################
model basic -ndm 2 -ndf 2      ;# 2 dimenciones; 2 Grados de Libertad (GDL) por nudo
# Se define la geometría -------------------------------------------------------------
# Coordenadas de los nudos
#    n x y
node 1 0 0
node 2 1 0
node 3 2 0
node 4 3 0
# Se empotra el nudo 1, del resto solo se restringe el segundo grado de libertad
#   n 1 2 
fix 1 1 1
fix 2 0 1 
fix 3 0 1 
fix 4 0 1 
# Se asigna una masa en Tonne (kN/g) al nudo 2 y 3 en la dirección X
#    n  1   2
mass 2 $m1 1e-6
mass 3 $m2 1e-6
mass 4 1e-6 1e-6
# Definicion de Elementos   ------------------------------------------------------
# Se crea un elemento truss entre los nudos 1 y 2
# Al elemento elástico se le asigna un area de 1 m2
#Los modulos de elasticidad E son igual a K ya que A=1 y L=1
set E1 $k1
set E2 $k2
 
set TagMaterial11 11 ;#Etiqueta
set TagMaterial12 12 ;#Etiqueta
# MATERIAL: Elastico
uniaxialMaterial Elastic  $TagMaterial11 $E1
uniaxialMaterial Elastic  $TagMaterial12 $E2
 #DEFINO EL MATERIAL VISCOSO
set TagMaterial21 111 ;#Etiqueta
set TagMaterial22 222 ;#Etiqueta
set alpha1 1
set alpha2 1
uniaxialMaterial Viscous $TagMaterial21 $c1 $alpha1
uniaxialMaterial Viscous $TagMaterial22 $c2 $alpha2
#Defino los elementos
#             nele ni nj  Area TagMaterial
element truss 1 1  2 1  $TagMaterial11
element truss 2 2  3 1  $TagMaterial12
element truss 3 3  4 1  $TagMaterial12
element truss 4 1  2 1  $TagMaterial21
element truss 5 2  3 1  $TagMaterial22
element truss 6 3  4 1  $TagMaterial22
#MODELO CREADO
 
#VIBRACIÓN FORZADA ############################
# EXCITACION: Función Lineal
set Impulso 11 ;#Impulso
set DuracionImp 10 ;#Duración del impulso
set Fmax [expr $Impulso*$DuracionImp]
#Aplico la funcion de carga
#Se aplicará la carga a intervalos iguales de tiempo
# t0 F0 t1 F1
#0  0  DI Fmax
set dt $DuracionImp
set fileName "C:/vlee/Dinamica/375/TCLOpenSees/FactoresDE/FacDforceCL.txt"
set serie1  "Series -dt $dt -filePath $fileName"
pattern Plain 1 $serie1 {
#     node Fx Fy
load 2 $Fmax 0
}
#Se aplicará la carga a intervalos iguales de tiempo
# t0 F0 t1 F1
#0  0  DI Fmax
set dt1 $DuracionImp
set fileName "C:/vlee/Dinamica/375/TCLOpenSees/FactoresDE/FacDforceCL.txt"
set serie2  "Series -dt $dt1 -filePath $fileName"
pattern Plain 2 $serie2 {
#     node Fx Fy
load 3 $Fmax 0
}
#LA CARGA FUE DEFINIDA###########################################################
 
 #REALIZO EL ANALISIS DINAMICO
constraints Plain
numberer Plain
system BandGeneral
test NormDispIncr 1.0e-6 6
algorithm Newton
integrator Newmark 0.5 0.25
analysis Transient
#Guardo los resultados: GDL 1
recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Desplazamiento1.out  -time -node 2 -dof 1 disp
recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Velocidad1.out  -time -node 2 -dof 1 vel
recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Aceleracion1.out  -time -node 2 -dof 1 accel
recorder Element -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Fuerza1.out  -time -ele 1  localForce
recorder Element -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Fuerza2.out  -time -ele 2  localForce
#Guardo los resultados: GDL 2
recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Desplazamiento2.out  -time -node 3 -dof 1 disp
recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Velocidad2.out  -time -node 3 -dof 1 vel
recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Aceleracion2.out  -time -node 3 -dof 1  accel
recorder Element -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Fuerza3.out  -time -ele 4  localForce
recorder Element -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/Fuerza4.out  -time -ele 5  localForce

recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/DesplazamientoT.out  -time -closeOnWrite -node 2 3 -dof 1 disp
recorder Node -file D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/VelocidadT.out  -time -closeOnWrite -node 2 3 -dof 1 vel
#EIGENVALUES
set eigenvalues [eigen 2]
set omega1 [expr sqrt([lindex $eigenvalues 0])] ;# Las frecuencias de vibracion son la raiz cuadrada de los valores propios
set T1 [expr 2.0*$pi*pow($omega1,-1)] ;# Periodo del primer modo de vibración2
set omega2 [expr sqrt([lindex $eigenvalues 1])] ;# Las frecuencias de vibracion son la raiz cuadrada de los valores propios
set T2 [expr 2.0*$pi*pow($omega2,-1)] ;# Periodo del primer modo de vibración2


#########################################################################################
# Nuevas variables.																		#
													
set k "$k1 $k2"
set c "$c1 $c2"
set m "$m1 $m2"
#######################################################################################

set pasoA [expr $T2*pow(30,-1)]
set npuntos [format "%.0f" [ expr $duracionA*pow($pasoA,-1)]]
#Pido los resultados segun la duración del analisis
analyze $npuntos $pasoA


set nameDespIn "D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/DesplazamientoT.out"
set nameVelIn "D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/VelocidadT.out"
set DirFileOut "D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias"


source D:/Dropbox/VLEE (LABORATORIO VIRTUAL DE INGENIERÍA SÍSMICA)/TCL-Modulos/Energias/WriteEnerg.tcl
writeEPoteYCine 0 $nameDespIn $DirFileOut $k
writeEPoteYCine 1 $nameVelIn $DirFileOut $m
writeEDisi $nameVelIn $DirFileOut $c


set time [getTime] 
puts $time
exit
