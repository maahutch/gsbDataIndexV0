from flask import Flask, render_template
import json
import os.path
from roamPy import Roam
import redivis
from neo4jClass import Neo

app = Flask(__name__)

roamToken    = os.environ.get('Roam_API_Key')
#redivisToken = os.environ.get('Redivis_API_Key')
dbPwd        = os.environ.get('Neo4j_password')

@app.route('/')
def home():
    return render_template('home.html')


@app.route('/storage/<dataset>')
def getStorage(dataset):




    dataset = redivis.organization("StanfordGSBLibrary").dataset(dataset)

#@app.route('/license/<dataset>')

#@app.route('/subscriptionPeriod/<dataset>')

#@app.route('/users/<dataset>')

#@app.route('/description/<dataset>')

#@app.route('/userInfo/<sunet>')
