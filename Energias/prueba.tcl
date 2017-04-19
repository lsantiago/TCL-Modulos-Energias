source utilerias.tcl
#!/usr/bin/tclsh
array set A {2 3 4 5} 
array set B {6 9 8 7}
#imprLista New $A $B


foreach index [array names A] {
   puts "$A($index)\t$B($index)"
}