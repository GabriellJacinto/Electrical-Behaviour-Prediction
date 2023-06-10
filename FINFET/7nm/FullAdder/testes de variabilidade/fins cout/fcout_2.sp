*****************************************
* Complex cell: ADDER_MIRROR            *
*****************************************

simulator lang=spectre
name options save=all

* parâmetros
include "7nm_FF.pm"
include "LIBRARY_FinFET_traditional.cir"

parameters vcc=0.7
parameters supply = 0.7
parameters num_fins=2
parameters ground_valor=0

*****FONTES
simulator lang = spice
           ***USADAS NOS BULKS
              Vvdd vdd gnd supply
              Vground ground gnd ground_valor
           ***USADAS NO 1º INVERSOR
              Vvccin vccin gnd supply
              Vvssin vssin gnd ground_valor
           ***USADAS NO 2º INVERSOR
              Vvcc vcc gnd supply
              Vvss vss gnd ground_valor
           ***USADAS NO BLOCO
              Vvccbloco vccbloco gnd supply
              Vvssbloco vssbloco gnd ground_valor
           ***USADAS NO FO4
              Vvccout vccout gnd supply
              Vvssout vssout gnd ground_valor 
******

*****ONDAS
simulator lang = spice
	Va a gnd pwl(0n 0 12n 0 12.01n supply 24n supply 24.01n 0 28n 0 28.01n supply 32n supply 32.01n 0 40n 0 40.01n supply 44n supply 44.01n 0 50n 0 50.01n supply 58n supply 58.01n 0 72n 0)
	Vb b gnd pwl(0n supply 12n supply 12.01n 0 24n 0 24.01n supply 34n supply 34.01n 0 52n 0 52.01n supply 56n supply 56.01n 0 64n 0 64.01n supply 68n supply 68.01n 0 72n 0)
	Vcin cin gnd pwl(0n 0 4n 0 4.01n supply 8n supply 8.01n 0 16n 0 16.01n supply 20n supply 20.01n 0 36n 0 36.01n supply 46n supply 46.01n 0 62n 0 62.01n supply 72n supply)
*****

*****PRIMEIRO INVERSOR
simulator lang = spice
              Mp1inva4 vccin a na vdd          		pmos_rvt w=27.0n l=20n nfin=1
              Mn1inva4 na a vssin ground   			nmos_rvt w=27.0n l=20n nfin=1 
              Mp1invb4 vccin b nb vdd          		pmos_rvt w=27.0n l=20n nfin=1
              Mn1invb4 nb b vssin ground   			nmos_rvt w=27.0n l=20n nfin=1 
              Mp1invcin4 vccin cin ncin vdd         pmos_rvt w=27.0n l=20n nfin=1
              Mn1invcin4 ncin cin vssin ground   	nmos_rvt w=27.0n l=20n nfin=1 
*****

*****SEGUNDO INVERSOR
simulator lang = spice
             Mp2inva4 vcc na a1 vdd          		pmos_rvt w=27.0n l=20n nfin=1
             Mn2inva4 a1 na vss ground   			nmos_rvt w=27.0n l=20n nfin=1 
             Mp2invb4 vcc nb b1 vdd          		pmos_rvt w=27.0n l=20n nfin=1
             Mn2invb4 b1 nb vss ground   			nmos_rvt w=27.0n l=20n nfin=1 
             Mp2invcin4 vccin ncin cin1 vdd         pmos_rvt w=27.0n l=20n nfin=1
             Mn2invcin4 cin1 ncin vssin ground   	nmos_rvt w=27.0n l=20n nfin=1 
******

*****PRIMEIRO FOUT 4 SUM
simulator lang = spice
          	Mp1fout4S vccout sum nsum vdd          	pmos_rvt w=27.0n l=20n nfin=4
         	Mn1fout4S nsum sum vssout ground   		nmos_rvt w=27.0n l=20n nfin=4 
******

*****PRIMEIRO FOUT 4 COUT
simulator lang = spice
          	Mp1fout4C vccout cout ncout vdd         pmos_rvt w=27.0n l=20n nfin=4
          	Mn1fout4C ncout cout vssout ground   	nmos_rvt w=27.0n l=20n nfin=4 
******

* instanciar subckt
		X1 cin1 a1 b1 cout sum vccbloco vssbloco vcc ground mirror
*

*****MEDIDAS DE ATRASOS DE PROPAGACAO
simulator lang = spice
	.measure tran TP_LH_Cin_0_1 trig v(cin1) val='0.5*supply' rise=1 targ v(cout) val='0.5*supply' rise=1
	.measure tran TP_HL_Cin_0_1 trig v(cin1) val='0.5*supply' fall=1 targ v(cout) val='0.5*supply' fall=1
	.measure tran TP_LH_Cin_1_0 trig v(cin1) val='0.5*supply' rise=2 targ v(cout) val='0.5*supply' rise=2
	.measure tran TP_HL_Cin_1_0 trig v(cin1) val='0.5*supply' fall=2 targ v(cout) val='0.5*supply' fall=2

	.measure tran TP_LH_0_A_1 trig v(a1) val='0.5*supply' rise=2 targ v(cout) val='0.5*supply' rise=3
	.measure tran TP_HL_0_A_1 trig v(a1) val='0.5*supply' fall=2 targ v(cout) val='0.5*supply' fall=3
	.measure tran TP_LH_1_A_0 trig v(a1) val='0.5*supply' rise=3 targ v(cout) val='0.5*supply' rise=4
	.measure tran TP_HL_1_A_0 trig v(a1) val='0.5*supply' fall=3 targ v(cout) val='0.5*supply' fall=4

	.measure tran TP_LH_0_1_B trig v(b1) val='0.5*supply' rise=2 targ v(cout) val='0.5*supply' rise=5
	.measure tran TP_HL_0_1_B trig v(b1) val='0.5*supply' fall=3 targ v(cout) val='0.5*supply' fall=5
	.measure tran TP_LH_1_0_B trig v(b1) val='0.5*supply' rise=3 targ v(cout) val='0.5*supply' rise=6
	.measure tran TP_HL_1_0_B trig v(b1) val='0.5*supply' fall=4 targ v(cout) val='0.5*supply' fall=6
*****

*****Medidas de energia---
simulator lang = spice
	.measure tran Iint_Vvccin INTEG i(Vvccin) 			from=0n to=72n
	.measure tran Iint_Vvcc INTEG i(Vvcc)				from=0n to=72n
	.measure tran Iint_Vvccbloco INTEG i(Vvccbloco) 	from=0n to=72n
	.measure tran Iint_Vvccout INTEG i(Vvccout) 		from=0n to=72n
*****

*****MEDIDAS DE POTENCIA
simulator lang = spice
	.measure tran potencia_media_vccin avg p(Vvccin) 		from = 0n to=72n
	.measure tran potencia_media_vcc avg p(Vvcc) 			from = 0n to=72n
	.measure tran potencia_media_vccbloco avg p(Vvccbloco) 	from = 0n to=72n
	.measure tran potencia_media_vccout avg p(Vvccout) 		from = 0n to=72n

	.measure tran potencia_max_vccin max p(Vvccin) 			from = 0n to=72n
	.measure tran potencia_max_vcc max p(Vvcc) 				from = 0n to=72n
	.measure tran potencia_max_vccbloco max p(Vvccbloco) 	from = 0n to=72n
	.measure tran potencia_max_vccout max p(Vvccout) 		from = 0n to=72n

	.measure tran potencia_min_vccin min p(Vvccin) 			from = 0n to=72n
	.measure tran potencia_min_vcc min p(Vvcc) 				from = 0n to=72n
	.measure tran potencia_min_vccbloco min p(Vvccbloco) 	from = 0n to=72n
	.measure tran potencia_min_vccout min p(Vvccout) 		from = 0n to=72n
******

* tipo de simulação
simulator lang=spectre
		tran1 tran start=0 stop=150n
*
