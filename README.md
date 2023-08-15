# Permeation Analysis Script

This script is designed to analyze molecular permeation events in simulation trajectories, focusing on oxygen atoms passing through a water membrane. It is intended for use with the VMD (Visual Molecular Dynamics) software.

## Purpose

The script calculates and identifies permeation events of oxygen atoms through a water membrane in simulation trajectories. It tracks the positions of water atoms and detects when these atoms cross specified upper and lower Z-axis limits.

## Calculation of Permeability Coefficients

### Diffusion Permeation Coefficient (Pd)

The diffusion permeation coefficient (Pd) characterizes the rate at which molecules diffuse through a pore. It is determined by quantifying the equilibrium flux through the pore in MD simulations. The formula for calculating Pd is:

```
Pd = 0.5 * (Positive Water Translocation + Negative Water Translocation) / (Molar Water Volume)
```

- Positive and negative water translocation counts are obtained from the `permeation.csv` file.
- Molar water volume (nw) represents the volume occupied by one mole of water.

### Osmotic Permeation Coefficient (Pf)

The osmotic permeation coefficient (Pf) describes the net water flux through a pore induced by a difference in solute concentration between two compartments connected by a pore. The formula for calculating Pf is:

```
Pf = (Molar Water Volume) * (Collective Diffusion Coefficient)
```

- The collective diffusion coefficient (Dn) characterizes the movement of water molecules in the pore. It is calculated based on cumulative displacements of water molecules normalized to the pore length.
- Molar water volume (nw) represents the volume occupied by one mole of water.

## Installation

1. Install VMD (Visual Molecular Dynamics) on your system if you haven't already. VMD is available for download at [https://www.ks.uiuc.edu/Development/Download/download.cgi](https://www.ks.uiuc.edu/Development/Download/download.cgi).

2. Download the `permeation.tcl` script and place it in a directory of your choice.

## Usage

1. Open a terminal window.

2. Navigate to the directory containing both the `TOPOLOGY.gro` and `TRAYECTORIA.xtc` files. These files are your simulation topology and trajectory files, respectively.

3. Execute the script using the following command:

   ```bash
   vmd TOPOLOGY.gro TRAYECTORIA.xtc -dispdev text -eofexit < permeation.tcl > output.log
   ```

   - Replace `TOPOLOGY.gro` and `TRAYECTORIA.xtc` with your actual topology and trajectory file names.

4. The script will analyze the simulation trajectory, detect permeation events, and calculate the Pd and Pf coefficients. The results will be written to `permeation.csv` and `summary.txt` files in the same directory.

## Contact

For any questions or inquiries, feel free to contact JJ Casal at jcasal@fmed.uba.ar.
