*****************************************
* Developed by Gabriel L. Jacinto       *
* Cell: NAND2                           *
* Extracted: no                         *
* Number of fins: 3                     *  
*****************************************


* Simulation configuration
simulator lang=spectre
name options save=all
global 0

* Imports
include "../lib/FET_TT.pm"
include "var.sp"

* Parameters 
parameters nfet_phig = 4.372
parameters pfet_phig = 4.8108
parameters sigma=3 variation=0.03

* Process variability
statistics 
{
	process
	{
	    vary nfet_phig dist=gauss std="(nfet_phig*variation)/sigma" percent=no
	    vary pfet_phig dist=gauss std="(pfet_phig*variation)/sigma" percent=no
	}
}

* Transistors  
*M<instance> source gate drain bulk(gnd or vdd)  tecnology  fins

Mp1 vdd inpA out vdd pmos_rvt nfin=number_fin
Mp2 vdd inpB out vdd pmos_rvt nfin=number_fin

Mn1 node inpA out  0 nmos_rvt nfin=number_fin
Mn2 0  inpB node 0 nmos_rvt nfin=number_fin

* Capacitance
capz (out 0) capacitor c=load

* Voltage source
* A 1 0 1 1 1
* B 1 1 1 0 1
* S 0 1 0 1 0
Vvdd (vdd 0) vsource dc=Vin type=dc
VcontroleA (inpA 0) vsource type=pwl wave=[0n Vin   t_pulse Vin   (t_pulse+dl) 0 (2*t_pulse) 0 (2*t_pulse+dl) Vin]
VcontroleB (inpB 0) vsource type=pwl wave=[0n Vin (3*t_pulse) Vin (3*t_pulse+dl) 0 (4*t_pulse) 0 (4*t_pulse+dl) Vin]

*.ic v(out)= 0

mc1 montecarlo variations=process seed=1234 numruns=10 donominal=yes saveprocessparams=yes
{
* COMO ESPECIFICAR COMO EM HSPICE ".tran 0.01n 10n sweep Monte=50"? ACHEI ISSO(?):
*.step param=nfet_phig start=0 stop=10n step=0.01n
*.step param=pfet_phig start=0 stop=10n step=0.01n

	tran1 tran start=0 stop=50n method=trap
}

simulator lang=spice
* Propagation Time
.measure tran tplhA trig v(inpA) val='0.5*Vin' fall=1 targ v(out) val='0.5*Vin' rise=1
.measure tran tphlA trig v(inpA) val='0.5*Vin' rise=1 targ v(out) val='0.5*Vin' fall=1
.measure tran tplhB trig v(inpB) val='0.5*Vin' fall=1 targ v(out) val='0.5*Vin' rise=2
.measure tran tphlB trig v(inpB) val='0.5*Vin' rise=1 targ v(out) val='0.5*Vin' fall=2
*Power
.measure tran total_power avg P(Vvdd) from=0n to=50n
*Energy
.measure tran Iint INTEG i(Vvdd) from=0n to=50n

.end