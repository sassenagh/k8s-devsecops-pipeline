FROM python:3.11-slim

ENV PIP_PROGRESS_BAR=off

RUN useradd -m appuser

WORKDIR /app
COPY app/ .

RUN pip install --no-cache-dir -r requirements.txt

USER appuser

CMD ["python", "-u", "main.py"]