
set m1 10 ;#Masa 1
set m2 9 ;#Masa 2
set k1 200 ;#Rigidez 1
set k2 200 ;#Rigidez 2
set c1 10 ;#Constante de amortiguamiento 1
set c2 10 ;#Constante de amortiguamiento  2

#########################################################################################
# Nuevas variables.																		#
													
set k "$k1 $k2"
set c "$c1 $c2"
set m "$m1 $m2"
#######################################################################################

set nameDespIn "C:/vlee/Dinamica/375/TCLOpenSees/Resultados2Gtool1/DesplazamientoT.out"
set nameVelIn "C:/vlee/Dinamica/375/TCLOpenSees/Resultados2Gtool1/VelocidadT.out"
set DirFileOut "C:/vlee/Dinamica/375/TCLOpenSees/Resultados2Gtool1"


source C:/vlee/Dinamica/377/TCLOpenSees/WriteEnerg.tcl
writeEPoteYCine 0 $nameDespIn $DirFileOut $k
writeEPoteYCine 1 $nameVelIn $DirFileOut $m
writeEDisi $nameVelIn $DirFileOut $c