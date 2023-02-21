from flask import Flask

app = Flask(__name__)

@app.route('/mctl-planner')
def planner():
    return "Hello I'm planner!"

@app.route('/')
def health():
    return "planner is healthy"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
