from flask import Flask, render_template, jsonify
import json
import os.path
from roamPy.roamClass import Roam
import redivis
from neo4jClass import Neo

app = Flask(__name__)

app.config['roamToken']         = os.environ.get('Roam_API_Key')
app.config['REDIVIS_API_TOKEN'] = os.environ.get('REDIVIS_API_TOKEN')
app.config['dbPwd']             = os.environ.get('Neo4j_password')

@app.route('/')
def home():
    return render_template('home.html')


@app.route('/storage/<dataset>')
def getStorage(dataset):

    uri = "bolt://localhost:7687"
    user = "neo4j"
    password = os.environ.get('Neo4j_password')
    connNeo = Neo(uri = uri, user = user, password=password)

    dataset_Neo = connNeo.getStorage(dataset = dataset)

    if dataset_Neo[0][0] == 'Redivis':

            dataset_Red = redivis.organization("StanfordGSBLibrary").dataset(dataset)
            
            dataset_Red.get()

            return(jsonify({'Redivis': dataset_Red.properties, 'Neo4j': dataset_Neo}))
    else:
        return(jsonify(dataset_Neo))

    #


#@app.route('/license/<dataset>')

#@app.route('/subscriptionPeriod/<dataset>')

#@app.route('/users/<dataset>')

#@app.route('/description/<dataset>')

#@app.route('/userInfo/<sunet>')
