from flask import Flask
import os


app = Flask(__name__)

@app.route('/mctl-planner')
def planner():

  def xstr(s):
    if s is None:
        return ''
    return str(s)
    
  dbURL = "DB_URL = "+xstr(os.environ.get('DB_URL'))+"\n"
  dbPort = "DB_PORT = "+xstr(os.environ.get('DB_PORT'))+"\n"
  dbUsername = "DB_USERNAME = "+xstr(os.environ.get('DB_USERNAME'))+"\n"
  dbPassword = "DB_PASSWORD = "+xstr(os.environ.get('DB_PASSWORD'))+"\n"
  secret = dbURL+dbPort+dbUsername+dbPassword

  return "Hello I'm planner! \n"+secret

@app.route('/')
def health():
    return "planner is healthy"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
