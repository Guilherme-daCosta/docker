FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY app.py /app/app.py

EXPOSE 5001

CMD [ "python", "app.py" ]