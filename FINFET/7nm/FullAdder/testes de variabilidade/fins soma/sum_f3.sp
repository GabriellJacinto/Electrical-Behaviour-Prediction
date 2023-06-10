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
parameters ground_valor=0
parameters num_fins=3

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
	Va a gnd pwl(0n 0 24n 0 24.01n supply 48n supply 48.01n 0 52n 0 52.01n supply 56n supply 56.01n 0 64n 0 64.01n supply 68n supply 68.01n 0 76n 0 76.01n supply 80n supply 80.01n 0 88n 0 88.01n supply 92n supply 92.01n 0 108n 0 108.01n supply 120n supply 120.01n 0 132n 0 132.01n supply 144n supply)
	Vb b gnd pwl(0n 0 12n 0 12.01n supply 22n supply 22.01n 0 36n 0 36.01n supply 46n supply 46.01n 0 60n 0 60.01n supply 72n supply 72.01n 0 84n 0 84.01n supply 94n supply 94.01n 0 100n 0 100.01n supply 104n supply 104.01n 0 112n 0 112.01n supply 116n supply 116.01n 0 124n 0 124.01n supply 128n supply 128.01n 0 136n 0 136.01n supply 140n supply 140.01n 0 144n 0)
	Vcin cin gnd pwl(0n 0 4n 0 4.01n supply 8n supply 8.01n 0 16n 0 16.01n supply 20n supply 20.01n 0 28n 0 28.01n supply 32n supply 32.01n 0 40n 0 40.01n supply 44n supply 44.01n 0 70n 0 70.01n supply 96n supply 96.01n 0 118n 0 118.01n supply 144n supply)
******

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
             Mp2inva4 vcc na a1 vdd          		pmos_rvt w=27.0n l=20n nfin=1
             Mn2inva4 a1 na vss ground   			nmos_rvt w=27.0n l=20n nfin=1 
             Mp2invb4 vcc nb b1 vdd          		pmos_rvt w=27.0n l=20n nfin=1
             Mn2invb4 b1 nb vss ground   			nmos_rvt w=27.0n l=20n nfin=1 
             Mp2invcin4 vccin ncin cin1 vdd         pmos_rvt w=27.0n l=20n nfin=1
             Mn2invcin4 cin1 ncin vssin ground   	nmos_rvt w=27.0n l=20n nfin=1 
******

*****PRIMEIRO FOUT 4 SUM
          	Mp1fout4S vccout sum nsum vdd          	pmos_rvt w=27.0n l=20n nfin=4
         	Mn1fout4S nsum sum vssout ground   		nmos_rvt w=27.0n l=20n nfin=4 
******

*****PRIMEIRO FOUT 4 COUT
          	Mp1fout4C vccout cout ncout vdd         pmos_rvt w=27.0n l=20n nfin=4
          	Mn1fout4C ncout cout vssout ground   	nmos_rvt w=27.0n l=20n nfin=4 
******


* instanciar subckt
		X1 cin1 a1 b1 cout sum vccbloco vssbloco vcc ground mirror
*


*****MEDIDAS DE ATRASOS DE PROPAGACAO
				*CIN
simulator lang = spice
				.measure tran TP_LH_Cin_0_0 trig v(cin1) val='0.5*supply' rise=1 targ v(sum) val='0.5*supply' rise=1
				.measure tran TP_HL_Cin_0_0 trig v(cin1) val='0.5*supply' fall=1 targ v(sum) val='0.5*supply' fall=1
			
				.measure tran TP_HL_Cin_0_1 trig v(cin1) val='0.5*supply' rise=2 targ v(sum) val='0.5*supply' fall=2
				.measure tran TP_LH_Cin_0_1 trig v(cin1) val='0.5*supply' fall=2 targ v(sum) val='0.5*supply' rise=3
				
				.measure tran TP_HL_Cin_1_0 trig v(cin1) val='0.5*supply' rise=3 targ v(sum) val='0.5*supply' fall=4
				.measure tran TP_LH_Cin_1_0 trig v(cin1) val='0.5*supply' fall=3 targ v(sum) val='0.5*supply' rise=5
			
				.measure tran TP_LH_Cin_1_1 trig v(cin1) val='0.5*supply' rise=4 targ v(sum) val='0.5*supply' rise=6
				.measure tran TP_HL_Cin_1_1 trig v(cin1) val='0.5*supply' fall=4 targ v(sum) val='0.5*supply' fall=6
				
				
				*A
				.measure tran TP_LH_0_A_0 trig v(a1) val='0.5*supply' rise=2 targ v(sum) val='0.5*supply' rise=8
				.measure tran TP_HL_0_A_0 trig v(a1) val='0.5*supply' fall=2 targ v(sum) val='0.5*supply' fall=8
	
				.measure tran TP_HL_0_A_1 trig v(a1) val='0.5*supply' rise=3 targ v(sum) val='0.5*supply' fall=9				
				.measure tran TP_LH_0_A_1 trig v(a1) val='0.5*supply' fall=3 targ v(sum) val='0.5*supply' rise=10
				
				.measure tran TP_HL_1_A_0 trig v(a1) val='0.5*supply' rise=4 targ v(sum) val='0.5*supply' fall=11
				.measure tran TP_LH_1_A_0 trig v(a1) val='0.5*supply' fall=4 targ v(sum) val='0.5*supply' rise=12

				.measure tran TP_LH_1_A_1 trig v(a1) val='0.5*supply' rise=5 targ v(sum) val='0.5*supply' rise=13
				.measure tran TP_HL_1_A_1 trig v(a1) val='0.5*supply' fall=5 targ v(sum) val='0.5*supply' fall=13				
				
				
				*B	
				.measure tran TP_LH_0_0_B trig v(b1) val='0.5*supply' rise=1 targ v(sum) val='0.5*supply' rise=2 
				.measure tran TP_HL_0_0_B trig v(b1) val='0.5*supply' fall=1 targ v(sum) val='0.5*supply' fall=3
			
				.measure tran TP_HL_0_1_B trig v(b1) val='0.5*supply' rise=2 targ v(sum) val='0.5*supply' fall=5
				.measure tran TP_LH_0_1_B trig v(b1) val='0.5*supply' fall=4 targ v(sum) val='0.5*supply' rise=14
					                                    
				.measure tran TP_HL_1_0_B trig v(b1) val='0.5*supply' rise=4 targ v(sum) val='0.5*supply' fall=12                                                                                       
				.measure tran TP_LH_1_0_B trig v(b1) val='0.5*supply' fall=7 targ v(sum) val='0.5*supply' rise=19
			                                                         
				.measure tran TP_LH_1_1_B trig v(b1) val='0.5*supply' rise=8 targ v(sum) val='0.5*supply' rise=20
				.measure tran TP_HL_1_1_B trig v(b1) val='0.5*supply' fall=8 targ v(sum) val='0.5*supply' fall=20
			
				*.measure tran maxBA1 param = 'max(tphl_b_a1,tplh_b_a1)'
				*.measure tran maxaux1 param = 'max(maxAB0,maxAB1)'
				*.measure tran maxaux2 param = 'max(maxBA0,maxBA1)'
				*.measure tran maxtp param = 'max(maxaux1,maxaux2)'
				*.measure tran avg_tp param = '(tphl_a_b0 + tplh_a_b0 + tphl_a_b1 + tplh_a_b1 + tphl_b_a0 + tplh_b_a0 + tphl_b_a1 + tplh_b_a1)/8'
*****

*****Medidas de energia---
simulator lang = spice
	.measure tran Iint_Vvccin INTEG i(Vvccin) 			from=0n to=144n
	.measure tran Iint_Vvcc INTEG i(Vvcc)				from=0n to=144n
	.measure tran Iint_Vvccbloco INTEG i(Vvccbloco) 	from=0n to=144n
	.measure tran Iint_Vvccout INTEG i(Vvccout) 		from=0n to=144n
*****

*****MEDIDAS DE POTENCIA
simulator lang = spice
	.measure tran potencia_media_vccin avg p(Vvccin) 		from = 0n to=144n
	.measure tran potencia_media_vcc avg p(Vvcc) 			from = 0n to=144n
	.measure tran potencia_media_vccbloco avg p(Vvccbloco) 	from = 0n to=144n
	.measure tran potencia_media_vccout avg p(Vvccout) 		from = 0n to=144n
		
	.measure tran potencia_max_vccin max p(Vvccin) 			from = 0n to=144n
	.measure tran potencia_max_vcc max p(Vvcc) 				from = 0n to=144n
	.measure tran potencia_max_vccbloco max p(Vvccbloco) 	from = 0n to=144n
	.measure tran potencia_max_vccout max p(Vvccout) 		from = 0n to=144n
		
	.measure tran potencia_min_vccin min p(Vvccin) 			from = 0n to=144n
	.measure tran potencia_min_vcc min p(Vvcc) 				from = 0n to=144n
	.measure tran potencia_min_vccbloco min p(Vvccbloco) 	from = 0n to=144n
	.measure tran potencia_min_vccout min p(Vvccout) 		from = 0n to=144n
****

* tipo de simulação
simulator lang=spectre
		tran1 tran start=0 stop=150n
*

