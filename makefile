all:

init:
	sudo apt update
	sudo apt install openjdk-11-jdk
	sudo apt install python3 python3-venv
	python3 -m venv spark-env
	@echo "Run :"
	@echo "   source spark-env/bin/activate"
	@echo "   pip install --upgrade pip"
	@echo "   pip install pyspark"

activate:
	@echo "Run :"
	@echo "   source spark-env/bin/activate"

################
# Part 1
################

part1: part1-download part1-unzip

part1-download:
	@for file in $(shell cat files.txt | head -10); do \
		echo $${file} ;\
		if [ -f dataset/zip//$${file} ]; then \
			echo "Nothing to do" ;\
		else \
			wget http://data.gdeltproject.org/events/$${file} -P dataset/zip/;\
		fi;\
	done

part1-unzip:
	@for file in $(shell ls dataset/zip/); do \
		echo $${file} ;\
		unzip -n dataset/zip//$${file} -d dataset/raw ;\
	done

deactivate:
	@echo "Run :"
	@echo "   deactivate"

clean: deactivate
	rm -rf dataset/parquet
	rm -rf dataset/raw
	rm -rf dataset/zip
	rm -rf output/

mr-proper: clean bonus-clean
	rm -rf spark-env/

bonus: bonus-download

bonus-download:
	mkdir -p dataset/bonus
	wget "https://data.nantesmetropole.fr/api/explore/v2.1/shared/datasets/224400028_suivi-qualite-eaux-superficielles-loire-atlantique-stations-departemen@loireatlantique/exports/csv?lang=fr&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B" -O dataset/bonus/data.csv

bonus-clean:
	rm -rf dataset/bonus
