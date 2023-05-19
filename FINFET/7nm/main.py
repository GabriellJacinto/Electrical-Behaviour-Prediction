from ExperimentManager import ExperimentManager
import HspiceRunner

var = {
    'LoadCap': ["1f", "4f", "8f", "16f"],
    'vdd': [0.6, 0.7, 0.8, 0.9],
    'number_fin': [3,4,5], # 3 a 5 devido ao congestionamento
}

config = {
    "temp": [-25.0, 0.0, 25.0, 50.0, 75.0, 100.0],
    "inp_file": "Scripts/inverter_spc.sp", 
    "copy": ["Scripts/FET_TT.pm"]
}

ex = ExperimentManager("FET_INVERTER", var, HspiceRunner.run, config)
ex.run(max_workers=6)
