# FINFET Technology Circuits
This folder contains the circuits used in our work. For each circuit there is a "Data" folder and a "Models" folder.
As of now, we have used 7nm.

## Data Folder
Contains the hspice simulation files, the circuit description, a csv for the simulation result, and other extra files used for the development.

## Models Folder
Contains the jupyter notebooks used for data processing and training of the Machine Learning algorithms. There can also be found compiled results from the trained models.

### HSPICE vs SPECTRE COMMANDS

|     DESCRIPTION      |     HSPICE      |     SPECTRE     | 
| --------------- | --------------- | --------------- | 
| Case Sensitive? | YES | no | 
| Varibles Declaration | .param    | parameters    | 
| Imports | .include    | include    | 
| Process Variability | gauss()    |  statistics{process{vary <name> dist=gauss std=<sdt>}}   | 
| Voltage Source | Vvdd    | V0    | 
| Ground Source | Vgnd    | global 0    | 
| Voltage Source | Va a gnd pwl(0 0 1n 0 1.01n vcc 2n) | V1 (a    0) vsource type=pwl wave=[0 0 1n 0 1.01n vcc 2n] |
| Subcircuit Declaration | .subckt   .ENDS | subckt   ends | 
| Subcircuit Instantiation | X1  gnd vdd  b c a out PhD_AOI21_3FIN_1  | I1  (0   vdd  b c a out) AOI21_close    | 
| Transiant Sim (w/ Monte Carlo)| .tran 1p 14n sweep MONTE=2000    | mc1 montecarlo variations=process seed=<int> numruns=<int> donominal=yes{	tran1 tran start=0 stop=14n method=trap}    | 



