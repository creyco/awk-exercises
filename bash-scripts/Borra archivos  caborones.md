# Borra archivos del usuario ollama que pesen menos de 1MB exactamente
# Tip extra: Si alguna vez quieres hacer lo mismo pero con archivos mayores a un tamaño, cambia el signo - por un +.

sudo find ./ -type f -user ollama -size -1048576c -exec rm -vf {} \;

