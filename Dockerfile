FROM python:3.11-slim

# Establece el directorio de trabajo
WORKDIR /app

# Instala dependencias del sistema necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
 && rm -rf /var/lib/apt/lists/*

# Copia e instala dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ⚡ Descarga el modelo Word2Vec en tiempo de build
RUN python -c "import gensim.downloader as api; api.load('word2vec-google-news-300')"

# Copia el resto del código
COPY . .

# Expone el puerto (solo informativo, no fuerza el puerto)
EXPOSE 8000

# 👇 Usa el puerto que Azure indique, o 8000 por defecto
ENV PORT=8000

# Comando de inicio dinámico
CMD ["/bin/bash", "-c", "uvicorn main:app --host 0.0.0.0 --port 8000"]