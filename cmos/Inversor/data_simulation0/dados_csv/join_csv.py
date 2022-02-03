import glob
import pandas as pd
import os

def join_slice(diretorio, extensao, skip_lines):
	os.chdir(diretorio)
	extension = 'csv'
	all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
	combined_files = pd.concat([pd.read_csv(f,skiprows=skip_lines,na_values='failed') for f in all_filenames])
	combined_files.to_csv("joined_data.csv", index=False, encoding='utf-8-sig')

join_slice(input(),input(),int(input()))
