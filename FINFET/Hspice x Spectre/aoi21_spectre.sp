*****************************************
* Developed by Alexandra Zimpeck        *
* Complex cell: AOI21                   *
* Extracted: no                         *
* Number of fins: 3                     *  
*****************************************

* Importações
include "7nm_TT.pm"

* Configurações iniciais
simulator lang=spectre
name options save=all
global 0

* Declaração de variáveis
parameters vcc=0.7 
parameters num_fins=3

* Declaração das fontes
V0 (vdd  0) vsource dc=vcc type=dc

* Declaração das entradas
V1 (a    0) vsource type=pwl wave=[0 0 1n 0 1.01n vcc 2n vcc 2.01n 0 8n 0 8.01n vcc 9n vcc 9.01n 0 10n 0 10.01n vcc 11n vcc 11.01n 0 12n 0 12.01n vcc 13n vcc 13.01n 0 14n 0]
V2 (b    0) vsource type=pwl wave=[0 0 3n 0 3.01n  vcc 4n vcc 4.01n 0 5n 0 5.01n vcc 11n vcc 11.01n 0 14n 0]
V3 (c    0) vsource type=pwl wave=[0 vcc 5n vcc 5.01n 0 6n 0 6.01n vcc 7n vcc 7.01n 0 14n 0]

* Subcircuito
subckt AOI21_close gnd vdd b c a out 
MM3 out b x   gnd nmos_rvt l=20n nfin=num_fins 
MM4 x   c gnd gnd nmos_rvt l=20n nfin=num_fins 
MM5 out a gnd gnd nmos_rvt l=20n nfin=num_fins 
MM1 y   b vdd vdd pmos_rvt l=20n nfin=num_fins
MM2 y   c vdd vdd pmos_rvt l=20n nfin=num_fins 
MM0 out a y   vdd pmos_rvt l=20n nfin=num_fins 
ends AOI21_close

* Chamada ao subcircuito
I1  (0   vdd  b c a out) AOI21_close

* Tempo de simulação
tran1 tran start=0 stop=14n method=trap

* Medições de atrasos
simulator lang=spice
.measure tran td_lh_a_b0c1 trig v(a) VAL='vcc*0.5' FALL=1 TARG v(out) VAL='vcc*0.5' RISE=1
.measure tran td_hl_a_b0c1 trig v(a) VAL='vcc*0.5' RISE=1 TARG v(out) VAL='vcc*0.5' FALL=1
.measure tran td_lh_a_b1c0 trig v(a) VAL='vcc*0.5' FALL=2 TARG v(out) VAL='vcc*0.5' RISE=4
.measure tran td_hl_a_b1c0 trig v(a) VAL='vcc*0.5' RISE=2 TARG v(out) VAL='vcc*0.5' FALL=4
.measure tran td_lh_a_b0c0 trig v(a) VAL='vcc*0.5' FALL=4 TARG v(out) VAL='vcc*0.5' RISE=6
.measure tran td_hl_a_b0c0 trig v(a) VAL='vcc*0.5' RISE=4 TARG v(out) VAL='vcc*0.5' FALL=6
.measure tran td_lh_b_a0c1 trig v(b) VAL='vcc*0.5' FALL=1 TARG v(out) VAL='vcc*0.5' RISE=2
.measure tran td_hl_b_a0c1 trig v(b) VAL='vcc*0.5' RISE=1 TARG v(out) VAL='vcc*0.5' FALL=2
.measure tran td_lh_c_a0b1 trig v(c) VAL='vcc*0.5' FALL=2 TARG v(out) VAL='vcc*0.5' RISE=3
.measure tran td_hl_c_a0b1 trig v(c) VAL='vcc*0.5' RISE=1 TARG v(out) VAL='vcc*0.5' FALL=3

* Medição de consumo
.measure tran total_power avg P(V0) from=0n to=14n




