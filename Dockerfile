# Usa una imagen base de Python 3.12.7
FROM python:3.12.7-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de tu proyecto Django al contenedor
COPY . /app/

# Actualiza pip
RUN pip install --upgrade pip

# Instala las dependencias del proyecto desde el archivo requirements.txt
RUN pip install -r requirements.txt

# Instala dependencias adicionales necesarias para PostgreSQL (psycopg2) y otros paquetes de sistema
RUN apt-get update && apt-get install -y \
    libpq-dev \
    tzdata

# Establece las variables de entorno
ENV PYTHONUNBUFFERED 1

# Configura las variables de entorno con django-environ (si las tienes en un archivo .env)
# Asegúrate de que el contenedor lea las variables de entorno necesarias
# Se asume que ya tienes un archivo .env con las variables configuradas

# Realiza las migraciones de la base de datos y recopila los archivos estáticos
RUN python manage.py migrate
RUN python manage.py collectstatic --noinput

# Usamos gunicorn para ejecutar la aplicación en producción
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
