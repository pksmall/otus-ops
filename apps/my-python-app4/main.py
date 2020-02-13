"""The is a simple python Flask app"""
import prometheus_client
from flask import Flask, Response
APP = Flask(__name__)


CONTENT_TYPE_LATEST = str('text/plain; version=0.0.4; charset=utf-8')
COUNTER_PAGES_SERVED = prometheus_client.Counter('my_python_app_web_pages_served', 'Number of pages served by frontend')


@APP.route('/metrics')
def metrics():
    return Response(prometheus_client.generate_latest(), mimetype=CONTENT_TYPE_LATEST)


@APP.route("/")
def hello():
    """This is the main page of the web application"""
    COUNTER_PAGES_SERVED.inc()
    return "Hello from Pavel! ALL HAIL PAVEL!"


if __name__ == "__main__":
    APP.run(host='0.0.0.0', port=5000)
