from ExperimentManager import ExperimentManager
import HspiceRunner

var = {
    'LoadCap': ["1f", "4f", "8f", "16f"],
    'vdd': [0.6, 0.7, 0.8, 0.9],
    'number_fin': [2,3],
}

config = {
    "passo": "0.01n",
    "t_pulse": "10n",
    "dl": "0.1p",
    'pmosL': "4e-08",
    'nmosL': "4e-08",
    "temp": [-25.0, 0.0, 25.0, 50.0, 75.0, 100.0],
    "inp_file": "Scripts/inverter_spc.sp", 
    "copy": ["Scripts/holddoor.txt"]
}

ex = ExperimentManager("FET_INVERTER", var, HspiceRunner.run, config)
ex.run(max_workers=6)
