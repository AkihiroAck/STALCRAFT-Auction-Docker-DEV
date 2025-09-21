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
EXPOSE 8000
#ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
