#!/bin/bash

if [ -z $1 ]                                           #Comprobar 1 argumento
then
	echo “Falta la ruta ORIGEN”
	exit 2
elif [ -z $2 ]                                         #Comprobar 2 argumento
then
	echo “Falta la ruta DESTINO”
	exit 2
elif [ -z $3 ]                                         #Comprobar 3 argumento
then
	echo “Falta una extension”
	exit 2
fi

echo "Usuario activo: $(whoami)"			#Nombre de usuario
echo "Hora: $(date)"					#Hora y fecha
echo
echo "Version de BASH: "
bash --version						#Version de bash
echo

directoriosiniciales=$(tree $2 | tail -n 1 | cut -d "," -f1 | cut -d " " -f1)
archivosiniciales=$(tree $2 | tail -n 1 | cut -d "," -f2 | cut -d " " -f2)

contador=1

if [ -d $1 ]									#Comprobar si existe el directorio
then	
	for i in $@
	do
		if [ $contador -gt 2 ]						#Empezar a partir del 2 argumento
		then
			punto=$(echo $i | cut --characters=1)			#Comprobar si hay un punto
			punt='.'						#	
			if [ $punto == $punt ]					#
			then
				var1=$(find $1 -name "*$i" | wc -l)		#Comprobar si existe la extension sin el punto
				if [ $var1 == 0 ]				#
				then
					echo "Los archivos con extension $i no existen"
				else
					rsync -r -m --include="*$i" --include="*/" --exclude="*" $1 $2			
					if [ $? != 0 ]								#Comprobar errores
					then
						exit 2
					fi
				fi
			else
				var2=$(find $1 -name "*.$i" | wc -l)				#Comprobar si existe la extension con el punto
				if [ $var2 == 0 ]						#
				then
					echo "Los archivos con extension $i no existen"
				else
					rsync -r -m --include="*.$i" --include="*/" --exclude="*" $1 $2
					if [ $? != 0 ]								#Comprobar errores
					then
						exit 2
					fi
				fi

			fi
		fi

	contador=$((contador+1)) 

	done
	
	
	
	
	directoriosfinales=$(tree $2 | tail -n 1 | cut -d "," -f1 | cut -d " " -f1)
	archivosfinales=$(tree $2 | tail -n 1 | cut -d "," -f2 | cut -d " " -f2)
	res1=$(($directoriosfinales-$directoriosiniciales))
	res2=$(($archivosfinales-$archivosiniciales))
	
	if [ $res2 == 0 ]									#Comprobar archivos copiados
	then
		echo "No se ha copiado ningun directorio ni archivo"
		echo "La ejecución del programa ha sido correcta"
		echo "Puede que no exista ningun archivo con las extensiones indicadas o que el directorio DESTINO contenga ya los archivos que se querian copiar"
		exit 1
	else
		echo "Directorios y archivos ya existentes en la carpeta DESTINO antes de la copia: $(tree $2 | tail -n 1)" 
		echo "Operacion completada correctamente"
		echo "Directorios copiados a la carpeta DESTINO: $res1"
		echo "Archivos copiados a la carpeta DESTINO: $res2"
	fi
else
	echo "El directorio de ORIGEN no existe"
	exit 2
fi

exit 0
