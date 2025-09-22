# Usa una imagen ligera de Python
FROM python:3.12.7-slim

# Establece la carpeta de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos necesarios
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Instala dependencias del sistema (como libpq para PostgreSQL y tzdata para zona horaria)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia el resto del código del proyecto
COPY . .

# Copia y da permisos al entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exponer puerto (ajusta si usas otro)
EXPOSE 8000

# Ejecuta el script de entrada que correrá las migraciones y luego lanzará Gunicorn
ENTRYPOINT ["/entrypoint.sh"]

# Comando por defecto
CMD ["gunicorn", "postgresTest.wsgi:application", "--bind", "0.0.0.0:8000"]
