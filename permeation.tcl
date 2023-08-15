# Permeation Analysis Script

# Define upper and lower Z-axis limits for permeation detection
set upperEnd 60
set lowerEnd 45

# If the simulation stabilizes later, set the number of frames to skip
set skipFrame 0

puts "Calculating permeation events"

# Create output files for results
set filename1 "permeation.csv"
set filename2 "summary.txt"

# Select water atoms within a specific range of indices
set wat [atomselect top "name OH2 and within 5 of index 10506 to 14007"]

# Initialize lists to track water atom states and labels
set segList [$wat get segname]
set ridList [$wat get resid]
set labelList {}

foreach segment $segList {
    lappend labelList 0
}

# Initialize counters for positive and negative permeation events
set positiveZCount 0
set negativeZCount 0
set numFrame [molinfo top get numframes]

# Open output file for writing permeation events
set outfile [open $filename1 w+]

for {set fr 0} {$fr < $numFrame} {incr fr} {
    molinfo top set frame $fr

    set oldList $labelList
    set labelList {}
    
    foreach z [$wat get z] oldLab $oldList segname $segment resid $ridList {
        if {$z > $upperEnd} {
            set newLab 2
            if {$oldLab == -1} {
                puts "$segname:$resid +z frame $fr"
                puts $outfile "$fr  $segname  $resid  z"
                if {$fr >= $skipFrame} {
                    incr positiveZCount
                }
            }
        } elseif {$z < $lowerEnd} {
            set newLab -2
            if {$oldLab == 1} {
                puts "$segname:$resid -z frame $fr"
                puts $outfile "$fr $segname $resid -z"
                if {$fr >= $skipFrame} {
                    incr negativeZCount
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

puts "Creating summary"
puts "+z direction events: $positiveZCount"
puts "-z direction events: $negativeZCount"

# Calculate collective diffusion coefficient (Dn)
set cumulativeDisplacements [list]
foreach z [$wat get z] {
    lappend cumulativeDisplacements $z
}
set poreLength [expr $upperEnd - $lowerEnd]
foreach idx [array indices cumulativeDisplacements] z $cumulativeDisplacements {
    set cumulativeDisplacements($idx) [expr $z / $poreLength]
}
set sumSquaredDisplacements 0
foreach z $cumulativeDisplacements {
    set sumSquaredDisplacements [expr $sumSquaredDisplacements + ($z * $z)]
}
set msd [expr $sumSquaredDisplacements / [llength cumulativeDisplacements]]
set timeInterval 1 ;# Replace with your actual time interval between measurements
set Dn [expr $msd / (6 * $timeInterval)]

# Calculate osmotic permeation coefficient (Pf)
set nw  ;# Replace with your molar water volume
set Pf [expr $nw * $Dn]

# Open summary file and write the count of events in both directions
set summaryFile [open $filename2 w+]
puts $summaryFile "+z -z"
puts $summaryFile "$positiveZCount $negativeZCount"
puts $summaryFile "Collective Diffusion Coefficient (Dn): $Dn"
puts $summaryFile "Osmotic Permeation Coefficient (Pf): $Pf"
close $summaryFile
