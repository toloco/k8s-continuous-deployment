import os

from connections import get_db
from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello():
    return f'HELLO {os.getenv("APP_NAME")}'


@app.route("/ping")
def ping():
    return "PING"


@app.route("/ready")
def ready():
    return "UP!", (200 if all([get_db()]) else 503)


if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0")
