*****************************************
* Developed by Gabriel L. Jacinto       *
* Cell: NAND2                           *
* Extracted: yes                        *
* Number of fins: 3                     *  
*****************************************

simulator lang=hspice
.include "config.cir"

* Imports
.include "asap5_tt.pm"

* Simulation configuration
.option post = 2
.option measform = 3


* Parameters 
.param nfet_phig = 4.860
.param pfet_phig = 4.375
.param sigma=3 variation=0.03

* Componentes
    * Transistores  
    MP1 vdd inpA out vdd PMOS w= pmosW l= pmosL
    MP2 vdd inpB out vdd PMOS w= pmosW l= pmosL

    MN1 node inpA out  gnd NMOS w= nmosW l= nmosL
    MN2 gnd  inpB node gnd NMOS w= nmosW l= nmosL

    * Carga
    Cload out gnd load

    * Fontes
    * A 1 0 1 1 1
    * B 1 1 1 0 1
    * S 0 1 0 1 0
    Vvdd vdd gnd DC Vin
    VcontroleA inpA gnd PWL (0n Vin   't_pulse' Vin   't_pulse+dl' 0 '2*t_pulse' 0 '2*t_pulse+dl' Vin)
    VcontroleB inpB gnd PWL (0n Vin '3*t_pulse' Vin '3*t_pulse+dl' 0 '4*t_pulse' 0 '4*t_pulse+dl' Vin)

    .ic v(out)= 0

* Analise    
    .tran passo 5*t_pulse

    .measure tran tplhA trig v(inpA) val='0.5*Vin' fall=1 targ v(out) val='0.5*Vin' rise=1
    .measure tran tphlA trig v(inpA) val='0.5*Vin' rise=1 targ v(out) val='0.5*Vin' fall=1
    .measure tran tplhB trig v(inpB) val='0.5*Vin' fall=1 targ v(out) val='0.5*Vin' rise=2
    .measure tran tphlB trig v(inpB) val='0.5*Vin' rise=1 targ v(out) val='0.5*Vin' fall=2
    
    .measure tran Iint INTEG i(Vvdd) from=0n to='5*t_pulse'
    .measure tran Iint2 INTEG i(vvdd) from=0n to=50n
    


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