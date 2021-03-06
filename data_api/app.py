from flask import Flask, render_template, jsonify
import json
import os.path
from roamPy.roamClass import Roam
import redivis
from neo4jClass import Neo
from requests import exceptions

app = Flask(__name__)

app.config['roamToken']         = os.environ.get('Roam_API_Key')
app.config['REDIVIS_API_TOKEN'] = os.environ.get('REDIVIS_API_TOKEN')
app.config['dbPwd']             = os.environ.get('Neo4j_password')

roam = Roam('https://api.roam.plus/external/', os.environ.get('Roam_API_Key'))

uri = "bolt://localhost:11004"
user = "neo4j"
password = os.environ.get('Neo4j_password')
connNeo = Neo(uri = uri, user = user, password=password)


#Home
@app.route('/')
def home():
    return render_template('home.html')

#Return Storage Information (Neo4j & Redivis)
@app.route('/storage/<dataset>')
def getStorage(dataset):

    try:
        dataset_Neo = connNeo.getStorage(dataset = dataset)
    except:
        dataset_Neo = []

    try: 
        dataset_Red = redivis.organization("StanfordGSBLibrary").dataset(dataset)
        dataset_Red.get()
        dsR = dataset_Red.properties
    except:
        dsR = []


    if len(dataset_Neo) == 0 and len(dsR) != 0:

        return(jsonify(dsR))
    
    elif len(dataset_Neo) != 0 and len(dsR) == 0:

        return(jsonify(dataset_Neo))

    elif len(dataset_Neo) != 0 and len(dsR) != 0:

        return(jsonify({"Database": dataset_Neo,  "Redivis": dsR}))

    else:
        return(jsonify("No match"))
        
    

    
#Return License Information(Neo4j & Roam)
@app.route('/license/<dataset>')
def getLicense(dataset):

    try:
         dataset_Neo = connNeo.getLicense(dataset = dataset)
    except:
         dataset_Neo = []
   
    try: 
        with open('../roamLicenseLookup.json') as json_file:
            roamLookup = json.load(json_file)

        id = roamLookup[dataset.lower()] 

        license = roam.getOneSubwithRelations(id = str(id), relations=['licensePeriods.license.publisher','licensePeriods.licensePeriodStatus'])

        dataset_Roam = license['included']
    except: 
        dataset_Roam = []

    #return(jsonify(len(dataset_Neo)))

    if len(dataset_Neo) == 0 and len(dataset_Roam) != 0:

            return(jsonify({"Roam": dataset_Roam}))
        
    elif len(dataset_Neo) != 0 and len(dataset_Roam) == 0:

        return(jsonify({"Database": dataset_Neo}))

    elif len(dataset_Neo) != 0 and len(dataset_Roam) != 0:

        return(jsonify({"Database": dataset_Neo,  "Roam": dataset_Roam}))

    else:
        return(jsonify("No Data")) 



#Return subscription period (Roam)
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


#Return Users of a dataset (Neo4j)
@app.route('/users/<dataset>')
def getUsers(dataset):

    users_Neo = connNeo.getUsers(dataset = dataset)

    return(jsonify({'Users': users_Neo}))

    
#Return dataset desc (Neo4j)
@app.route('/description/<dataset>')
def getDatasetDescription(dataset):

    datasetDesc = connNeo.getDescription(dataset=dataset)

    return(jsonify({'Dataset Description': datasetDesc}))



#Return datasets of User (Neo4j)
@app.route('/userInfo/<sunet>')
def getUserDatasets(sunet):

    userDatasets = connNeo.getUserDatasets(sunet= sunet)

    return(jsonify({sunet: userDatasets}))


#Return Publisher of dataset (Neo4j & Roam)
@app.route('/publisher/<dataset>')
def getPublisher(dataset):
    
    publisher_Neo = connNeo.getPublisher(dataset)
 
    with open('../roamLicenseLookup.json') as json_file:
        roamLookup = json.load(json_file)

    if dataset.lower() in roamLookup:
        
        id = roamLookup[dataset.lower()]

        pub = roam.getOneSubwithRelations(id = str(id), relations=['licensePeriods.license.publisher'])

        pub = pub['included']
        
        return(jsonify({'Neo4j': publisher_Neo, 'Roam': pub}))
    
    else:

        return(jsonify({'Neo4j': publisher_Neo})) 



#Return all dataset titles for Dropdown (Neo4j)
@app.route('/allDatasets')
def getAllDatasets():

    allDatasets = connNeo.getAllDatasets()

    return(jsonify(allDatasets))

#Return all dataset titles for Dropdown (Red)
@app.route('/allRedDatasets')
def getRedDatasets():
    dataNames = redivis.organization("stanfordgsblibrary").list_datasets()        
    names = list()
    for i in range(0,len(dataNames)):
        names.append(dataNames[i]['name'])
    names2 = ', '.join(names)
    return(names2)

#Return all dataset titles for Dropdown (Roam)
@app.route('/allRoamDatasets')
def getRoamDatasets():
    dataNames = roam.getAllSubscriptions()

    return(jsonify(dataNames))


#Return all SUNetIDs for dropdown (Neo4j)
@app.route('/allUsers')
def getAllusers():
    allUsers = connNeo.getAllUsers()

    return(jsonify(allUsers))

#Return user-data network
@app.route('/network')
def getNetwork():
    network = connNeo.getUDNodes()
    return(jsonify(network))