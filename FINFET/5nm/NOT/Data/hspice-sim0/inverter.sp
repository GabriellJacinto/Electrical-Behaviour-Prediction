*****************************************
* Developed by Gabriel L. Jacinto       *
* Cell: Inverter                        *
* Extracted: no                         *
* Number of fins: 3                     *  
*****************************************

* Imports
.include './asap5_tt.pm'
.include var.sp

* Configurações iniciais
* simulator lang=hspice

*define parameters 
.param nfet_phig = gauss(4.860,0.03,3)
.param pfet_phig = gauss(4.324,0.03,3)

.global nfet_phig pfet_phig

VSS Gnd 0 'vss'

*add transistors  
mp1 Z Y X Y pmos_rvt NFIN=number_fin
mn1 Z Y 0 Y nmos_rvt NFIN=number_fin

*add cap
Cz Z Gnd 'LoadCap'

*add voltage source
VX X 0 'vdd'

VY Y 0 PULSE(0 0.7 0.5n 10p 10p 0.5n 1n)

*do transient analysis
	*syntax: .TRAN tiner tstop START=stval 
	*tiner - time step
	*tstop - final time
	*stval - initial time (default 0)
.tran 0.01n 10n sweep Monte=10

*print the V(Z) to waveform file *.tr0
.print V(Z)
.print V(X)
.print V(Y)
.print i(Cz)
.print power(Cz)

*simulation options (you can modify this. Post is needed for .tran analysis)
*.OPTION Post Brief NoMod probe measout
*.option post = 1
.option post = 2
.option measform = 3


*measurement
.measure tran t_fall_delay TRIG V(Y) VAL = 0.35 TD = 1n
+ RISE = 2 TARG V(Z) VAL = 0.35 FALL = 2

.measure tran t_rise_delay TRIG V(Y) VAL = 0.35 TD = 1n
+ FALL = 2 TARG V(Z) VAL = 0.35 RISE = 2

.measure tran t_fall_time TRIG V(Z) VAL = 0.56 TD = 1n
+ FALL = 2 TARG V(Z) VAL = 0.14 FALL = 2

.measure tran t_rise_time TRIG V(Z) VAL = 0.14 TD = 1n
+ RISE = 2 TARG V(Z) VAL = 0.56 RISE = 2

.end
