#/bin/bash
#Developed by 4null0


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exiting...\n${endColour}"
	tput cnorm;
	exit 0
}

tput civis

#Control de los parametros pasados
if [ $# = 0 ] || [ $# -gt 2 ]; then
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Este script sólo admite un parámetro, que corresponde con los tres primeros octetos de una red de tipo C\n ${endColour}"
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Ejemplo: ./PreguntaleALDNS 192.168.0 \n ${endColour}"
	tput cnorm
	exit 1
else
	fecha=$(date +%d-%m-%Y)
	hora=$(date +%X)
	red=$1

	directorio=$red--$fecha--$hora

	mkdir $directorio

	if [ -d $directorio ]; then
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Empezamos con la red: $red.0 ...\n ${endColour}"
		for d in {1..254}; do 
			nombre=$(nslookup $red.$d | cut -d "=" -f 2 | head -n 1 | grep -v "server can't" | grep -v "trying next server")
			if [ ! -z $nombre ]; then 
				echo -e "${greenColour}  [*]${endColour}${grayColour} $red.$d = $nombre\n ${endColour}"
				echo "$red.$d = $nombre" >> $directorio/Detecciones.txt
			fi
		done
	else
		echo -e "\n${redColour}[*]${endColour}${grayColour} Error al crear el directorio: $directorio/Descargas ...\n ${endColour}"
	fi
fi
