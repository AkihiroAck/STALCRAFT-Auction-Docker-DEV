FROM python:3.12.10
WORKDIR /usr/src/app
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN sed -i 's/\r$//g' /usr/src/app/entrypoint_web.sh
RUN sed -i 's/\r$//g' /usr/src/app/entrypoint_celery.sh
RUN chmod +x /usr/src/app/entrypoint_web.sh
RUN chmod +x /usr/src/app/entrypoint_celery.sh
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*
EXPOSE 8000
