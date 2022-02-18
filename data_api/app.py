from flask import Flask
import json
import os.path
from roamPy import Roam

app = Flask(__name__)

roamToken    = os.environ.get('Roam_API_Key')
redivisToken = os.environ.get('Redivis_API_Key')
dbPwd        = os.environ.get('Neo4j_password')


@app.route('/storage/<dataset>')

@app.route('/license/<dataset>')

@app.route('/subscriptionPeriod/<dataset>')

@app.route('/users/<dataset>')

@app.route('/description/<dataset>')

@app.route('/userInfo/<sunet>')

