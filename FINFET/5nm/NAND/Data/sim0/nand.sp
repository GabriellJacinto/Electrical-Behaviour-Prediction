*****************************************
* Developed by Gabriel L. Jacinto       *
* Cell: Inverter                        *
* Extracted: no                         *
* Number of fins: 3                     *  
*****************************************

* Imports
.include "asap5_tt.pm"
.include "config.cir"

*define parameters 
.param nfet_phig = gauss(4.860,0.03,3)
.param pfet_phig = gauss(4.324,0.03,3)

.global nfet_phig pfet_phig

VSS Gnd 0 'vss'

* Transistors  
*M<instance> source gate drain bulk(gnd or vdd)  tecnology  fins

Mp1 vdd inpA out vdd pmos_rvt nfin=number_fin
Mp2 vdd inpB out vdd pmos_rvt nfin=number_fin

Mn1 node inpA out  0 nmos_rvt nfin=number_fin
Mn2 0  inpB node 0 nmos_rvt nfin=number_fin

* Capacitance
Cz Z Gnd "load"

* Voltage source
* A 1 0 1 1 1
* B 1 1 1 0 1
* S 0 1 0 1 0
Vvdd (vdd 0) vsource dc=Vin type=dc
VcontroleA (inpA 0) vsource type=pwl wave=[0n Vin   t_pulse Vin   (t_pulse+dl) 0 (2*t_pulse) 0 (2*t_pulse+dl) Vin]
VcontroleB (inpB 0) vsource type=pwl wave=[0n Vin (3*t_pulse) Vin (3*t_pulse+dl) 0 (4*t_pulse) 0 (4*t_pulse+dl) Vin]

*.ic v(out)= 0

*do transient analysis
	*syntax: .TRAN tiner tstop START=stval 
	*tiner - time step
	*tstop - final time
	*stval - initial time (default 0)
    * Carga
    Cload out gnd load

    * Fontes
    * A 1 0 1 1 1
    * B 1 1 1 0 1
    * S 0 1 0 1 0
    Vvdd vdd gnd DC Vin
    VcontroleA inpA gnd PWL (0n Vin   't_pulse' Vin   't_pulse+dl' 0 '2*t_pulse' 0 '2*t_pulse+dl' Vin)
    VcontroleB inpB gnd PWL (0n Vin '3*t_pulse' Vin '3*t_pulse+dl' 0 '4*t_pulse' 0 '4*t_pulse+dl' Vin)


* Analise    
    .tran 0.01n 10n sweep Monte=50

    .measure tran tplhA trig v(inpA) val='0.5*Vin' fall=1 targ v(out) val='0.5*Vin' rise=1
    .measure tran tphlA trig v(inpA) val='0.5*Vin' rise=1 targ v(out) val='0.5*Vin' fall=1
    .measure tran tplhB trig v(inpB) val='0.5*Vin' fall=1 targ v(out) val='0.5*Vin' rise=2
    .measure tran tphlB trig v(inpB) val='0.5*Vin' rise=1 targ v(out) val='0.5*Vin' fall=2
    
    .measure tran Iint INTEG i(Vvdd) from=0n to='5*t_pulse'
    .measure tran Iint2 INTEG i(vvdd) from=0n to=50n
*Power
.measure tran total_power avg P(Vvdd) from=0n to=50n
*Energy
.measure tran Iint INTEG i(Vvdd) from=0n to=50n

*simulation options (you can modify this. Post is needed for .tran analysis)
*.OPTION Post Brief NoMod probe measout
*.option post = 1
.option post = 2
.option measform = 3

.end