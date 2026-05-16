#!/bib/bash
# Instalar dependencias del frontend
cd frontend
npm install

# Volver a la raíz
cd ..

# Levantar todo con Docker
docker-compose up --build
