FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /app

# pdf2image requires poppler binaries to convert PDF pages to images.
RUN apt-get update \
    && apt-get install -y --no-install-recommends poppler-utils \
    && command -v pdfinfo \
    && command -v pdftoppm \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
