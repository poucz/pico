#!/bin/bash

echo "STARTING POU..."


while [ 1 ]; do

	inotifywait -r   -e  modify -e create -e close_write assets/
	chmod -R 777 assets


done &



apache2-foreground
