FROM nextcloud:latest 

# Установка Tesseract OCR и зависимостей
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-rus \  
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*
