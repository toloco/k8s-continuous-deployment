import os

from flask import Flask, jsonify
from flask_swagger import swagger

app = Flask(__name__)


@app.route("/")
def hello():
    return f'HELLO {os.getenv("APP_NAME")}'


@app.route("/ping")
def ping():
    return "PING"


@app.route("/ready")
def ready():
    return "UP!", 200


@app.route("/spec")
def spec():
    swag = swagger(app)
    swag['info']['version'] = "1.0"
    swag['info']['title'] = "My API"
    return jsonify(swag)


if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0")
