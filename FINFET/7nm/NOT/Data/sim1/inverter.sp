*****************************************
* Developed by Gabriel L. Jacinto       *
* Cell: Inverter                        *
* Extracted: no                         *
* Number of fins: 3                     *  
*****************************************

* Simulation configuration
simulator lang=spectre
name options save=all
global 0

* Imports
include "FET_TT.pm"
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
Mp1             X    Y     Z     X               pmos_rvt nfin=number_fin
Mn1             Z    Y     0     0               nmos_rvt nfin=number_fin

* Capacitance
capz (Z 0) capacitor c=LoadCap

* Voltage source
VX (X 0) vsource dc=vdd type=dc 

* Input voltage source
VY (Y 0) vsource type=pwl wave=[0n 0 10n 0 10.01n 0.7 20n 0.7 20.01n 0]

mc1 montecarlo variations=process seed=1234 numruns=50 donominal=yes saveprocessparams=yes
{
* COMO ESPECIFICAR COMO EM HSPICE ".tran 0.01n 10n sweep Monte=50"? ACHEI ISSO(?):
*.step param=nfet_phig start=0 stop=10n step=0.01n
*.step param=pfet_phig start=0 stop=10n step=0.01n

	tran1 tran start=0 stop=40n method=trap
}

simulator lang=spice
* Propagation Time
.measure tran tphl trig v(Y) val='0.5*vdd' rise=1 targ v(Z) val='0.5*vdd' fall=1
.measure tran tplh trig v(Y) val='0.5*vdd' fall=1 targ v(Z) val='0.5*vdd' rise=1
*Power
.measure tran total_power avg P(VX) from=0n to=40n
*Energy
.measure tran Iint INTEG i(VX) from=0n to=40n

.end
