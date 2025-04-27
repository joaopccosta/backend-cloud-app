from flask import Flask, request, jsonify
import re
from datetime import date

import os
import boto3
from botocore.exceptions import ClientError
from prometheus_client import Counter, generate_latest

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "http_requests_total", "Total HTTP requests", ["method", "endpoint"]
)
ERROR_COUNT = Counter(
    "http_errors_total", "Total HTTP error responses", ["method", "endpoint", "status"]
)

DYNAMODB_REGION = os.getenv("AWS_REGION", "eu-west-1")
DYNAMODB_ENDPOINT = os.getenv("DYNAMODB_ENDPOINT", "https://dynamodb.eu-west-1.amazonaws.com")
DYNAMODB_TABLE = os.getenv("DYNAMODB_TABLE", "users")

dynamodb = boto3.resource(
    "dynamodb", region_name=DYNAMODB_REGION, endpoint_url=DYNAMODB_ENDPOINT
)
table = dynamodb.Table(DYNAMODB_TABLE)


@app.before_request
def before_request():
    REQUEST_COUNT.labels(method=request.method, endpoint=request.path).inc()


@app.errorhandler(Exception)
def handle_error(e):
    status = getattr(e, "code", 500)
    ERROR_COUNT.labels(
        method=request.method, endpoint=request.path, status=status
    ).inc()
    return jsonify(error=str(e)), status


@app.route("/hello/<username>", methods=["PUT"])
def put_hello(username):
    print(f"PUT /hello/{username}")
    if not re.fullmatch(r"[a-zA-Z]+", username):
        print(f"Invalid username - {username}")
        return jsonify(error="Invalid username"), 400

    data = request.get_json()
    try:
        dob = date.fromisoformat(data["dateOfBirth"])
        if dob >= date.today():
            print("Date must be in the past")
            return jsonify(error="Date must be in the past"), 400
    except Exception:
        print("Invalid date format")
        return jsonify(error="Invalid date format"), 400

    try:
        table.put_item(
            Item={"username": username.lower(), "dateOfBirth": data["dateOfBirth"]}
        )
    except ClientError as e:
        return jsonify(error="DynamoDB error: " + str(e)), 500

    return "", 204


@app.route("/hello/<username>", methods=["GET"])
def get_hello(username):
    if not re.fullmatch(r"[a-zA-Z]+", username):
        print(f"Invalid username - {username}")
        return jsonify(error="Invalid username"), 400

    try:
        result = table.get_item(Key={"username": username.lower()})
        item = result.get("Item")
        if not item:
            print(f"User not found - {username}")
            return jsonify(error="User not found"), 404

        dob = date.fromisoformat(item["dateOfBirth"])
        today = date.today()
        next_birthday = dob.replace(year=today.year)
        if next_birthday < today:
            next_birthday = next_birthday.replace(year=today.year + 1)

        days_until = (next_birthday - today).days
        msg = (
            f"Hello, {username}! Happy birthday!"
            if days_until == 0
            else f"Hello, {username}! Your birthday is in {days_until} day(s)"
        )
        return jsonify(message=msg)

    except ClientError as e:
        return jsonify(error="DynamoDB error: " + str(e)), 500


@app.route("/health")
def health():
    return "OK", 200


@app.route("/metrics")
def metrics():
    return (
        generate_latest(),
        200,
        {"Content-Type": "text/plain; version=0.0.4; charset=utf-8"},
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 8888)))
