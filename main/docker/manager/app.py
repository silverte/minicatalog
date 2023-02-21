from flask import Flask

app = Flask(__name__)

@app.route('/mctl-manager')
def planner():
    return "Hello I'm manager!"

@app.route('/')
def health():
    return "manager is healthy"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
