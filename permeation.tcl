# Ejecutar con
# vmd TOPOLOGIA.gro TRAYECTORIA.xtc -dispdev text -eofexit < permeation.tcl > output.log

# cuidado, porque depende del sistema de coordenadas de la trayectoria y NO de las unidades de VMD.
# por ejemplo, Gromacs usa A para las distancias.

set upperEnd 60
set lowerEnd 45

# Si vemos que la simulación se estabiliza después, debemos seleccionar el número de frames que consideramos como
# simulación estable
set skipFrame 0

puts "Calculando los eventos de permeación"

# Creamos los archivos de salida
set filename1 "permeation.csv"
set filename2 "resumen.txt"

#cuenta cuando pasan los oxígenos del agua. Acá depende de la topología usada
set wat [atomselect top "name OH2 and within 5 of index 10506 to 14007"] 

# empieza a recuperar los residuos que corresponden con la condición de selección anterior
set segList [$wat get segname]
set ridList [$wat get resid]
set labelList {}

foreach foo $segList {
  lappend labelList 0
}

# las variables que van a recolectar los valores, hacia el z positivo y hacia el z negativo
set positivo 0
set negativo 0
set numFrame [molinfo top get numframes]


set outfile [open $filename1 w+]

for {set fr 0} {$fr < $numFrame} {incr fr} {
  molinfo top set frame $fr
  
  set oldList $labelList
  set labelList {}
  foreach z [$wat get z] oldLab $oldList segname $segList resid $ridList {
    if {$z > $upperEnd} {
      set newLab 2
      if {$oldLab == -1} {
        puts "$segname:$resid +z frame $fr"
        puts $outfile "$fr  $segname  $resid  z"
        if {$fr >= $skipFrame} {
          incr positivo
        }
      }
    } elseif {$z < $lowerEnd} {
      set newLab -2
      if {$oldLab == 1} {
        puts "$segname:$resid -z frame $fr"
        puts $outfile "$fr $segname $resid -z"
        if {$fr >= $skipFrame} {
          incr negativo
        }
      }
    } elseif {abs($oldLab) > 1} {
      set newLab [expr $oldLab / 2]
    } else {
      set newLab $oldLab
    }
    lappend labelList $newLab
  }

}
close $outfile

puts "Creando el resumen"
puts "+z direction is: $positivo"
puts "-z direction is: $negativo"

set resumen [open $filename2 w+]
puts $resumen "+z -z"
puts $resumen "$positivo $negativo"
close $resumen

