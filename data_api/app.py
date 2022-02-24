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

roam = Roam('https://api.roam.plus/external/', os.environ.get('Roam_API_Key'))

uri = "bolt://localhost:7687"
user = "neo4j"
password = os.environ.get('Neo4j_password')
connNeo = Neo(uri = uri, user = user, password=password)



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
    connNeo.close()

    if dataset_Neo[0][0] == 'Redivis':

            dataset_Red = redivis.organization("StanfordGSBLibrary").dataset(dataset)
            
            dataset_Red.get()

            return(jsonify({'Redivis': dataset_Red.properties, 'Neo4j': dataset_Neo}))
    else:
        return(jsonify(dataset_Neo))

    

@app.route('/license/<dataset>')
def getLicense(dataset):

    dataset_Neo = connNeo.getLicense(dataset = dataset)
   

    with open('../roamLicenseLookup.json') as json_file:
        roamLookup = json.load(json_file)

    if dataset.lower() in roamLookup:
        
        id = roamLookup[dataset.lower()]

        license = roam.getOneSubwithRelations(id = str(id), relations=['licensePeriods.license.publisher','licensePeriods.licensePeriodStatus'])

        license = license['included']
        
        return(jsonify({'Neo4j': dataset_Neo, 'Roam': license}))
    
    else:

        return(jsonify(dataset_Neo)) 




@app.route('/subscriptionPeriod/<dataset>')
def getSubscriptionPeriod(dataset): 

        with open('../roamLicenseLookup.json') as json_file:
            roamLookup = json.load(json_file)

        if dataset.lower() in roamLookup:
        
            id = roamLookup[dataset.lower()]

            subP = roam.getOneSubwithRelations(id, ['subscriptionPeriods'])

            subP = subP['included']

            return(jsonify({'Roam': subP}))

        else: 
            return render_template('error.html')



@app.route('/users/<dataset>')
def getUsers(dataset):

    users_Neo = connNeo.getUsers(dataset = dataset)

    return(jsonify({'Users': users_Neo}))

    

@app.route('/description/<dataset>')
def getDatasetDescription(dataset):

    dataset = connNeo.getDataset(dataset=dataset)


#@app.route('/userInfo/<sunet>')

#@app.route('/publisher/<pubName>)