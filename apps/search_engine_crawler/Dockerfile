FROM python:3.6-alpine

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . $APP_HOME
RUN pip install -r /$APP_HOME/requirements.txt
WORKDIR $APP_HOME/crawler

ENV EXCLUDE_URLS ".*github.com"
ENV MONGO_PORT 27017
ENV RMQ_PORT 31706
ENV CHECK_INTERVAL 600

EXPOSE 8000
CMD ["python", "-u", "crawler.py", "https://vitkhab.github.io/search_engine_test_site/"]
