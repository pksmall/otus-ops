FROM python:3.7

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . $APP_HOME
RUN pip install -r /$APP_HOME/requirements.txt
WORKDIR $APP_HOME/ui
ENV MONGO mongo_db
ENV MONGO_PORT 27017
ENV FLASK_APP ui.py
EXPOSE 8000
CMD ["gunicorn", "ui:app", "-b", "0.0.0.0"]
