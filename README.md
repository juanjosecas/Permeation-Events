# Permeation Analysis Script

This script is designed to analyze molecular permeation events in simulation trajectories, specifically focusing on oxygen atoms passing through a water membrane. It is intended for use with the VMD (Visual Molecular Dynamics) software and is particularly useful for researchers in the field of pharmacy, drug development, and microscopy analysis.

## Purpose

The script calculates and identifies permeation events of oxygen atoms through a water membrane in simulation trajectories. It tracks the positions of water atoms and detects when these atoms cross specified upper and lower Z-axis limits.

## Installation

1. Install VMD (Visual Molecular Dynamics) on your system if you haven't already. VMD is available for download at [https://www.ks.uiuc.edu/Development/Download/download.cgi](https://www.ks.uiuc.edu/Development/Download/download.cgi).

2. Download the `permeation.tcl` script and place it in a directory of your choice.

## Usage

1. Open a terminal window.

2. Navigate to the directory containing both the `TOPOLOGY.gro` and `TRAYECTORIA.xtc` files. These files are your simulation topology and trajectory files, respectively.

3. Execute the script using the following command:
   
   ```
   vmd TOPOLOGY.gro TRAYECTORIA.xtc -dispdev text -eofexit < permeation.tcl > output.log
   ```

   - Make sure to replace `TOPOLOGY.gro` and `TRAYECTORIA.xtc` with the actual names of your topology and trajectory files.

4. The script will analyze the simulation trajectory and detect permeation events. The output will be written to `permeation.csv` and `resumen.txt` files in the same directory.

## Important Notes

- The script relies on the Z-axis coordinates of water atoms. Ensure that the coordinates match the units used in your simulation software.

- Adjust the `upperEnd` and `lowerEnd` values in the script to match your system's geometry and desired permeation boundaries.

- The script assumes that the simulation is stable after a certain number of frames specified by `skipFrame`.

## Contact

For any questions or inquiries, feel free to contact JJ at jcasal@fmed.uba.ar

