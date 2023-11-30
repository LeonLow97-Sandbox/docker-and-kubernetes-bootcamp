import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def main():
    return "Welcome!"

@app.route("/hello")
def hello():
    return "Hello Leon, this is your Flask server running on port 5000!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
