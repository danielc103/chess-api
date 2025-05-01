FROM python:3.13-slim

ENV FLASK_APP=chess.py
ENV FLASK_RUN_HOST=0.0.0.0

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache -r requirements.txt

COPY chess.py .

EXPOSE 5000

CMD ["flask", "run"]

