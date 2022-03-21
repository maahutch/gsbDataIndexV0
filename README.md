# gsbDataIndexV0
MVP of data api and web frontend for GSB Data Index. The systems pulls metadata from multiple sources and presents the data in a web frontend. USers can search for different meta data elements by dataset, search for datasets accessible to which a given user has been granted access and visualize/anaylse the user-data subgraph to help understand data usage at the GSB.  The current version of the application pulls data from three separate sources: a customer Neo4j database, Redivis and Roam. Potential future data sources to be included are Adobe-Sign, WRDS and Folio. 

### Design
This 'Version 0' consists of tow major parts: A flask Rest API and an R Shiny frontend. The platform also pulls data froma Neo4j database but the design and data ingestion code is not included in this repository. The api accepts either a dataset or user name from the frontend and then returns the relevant metadata from the queried endpoint. The current design has one endpoint for each category of metdata and retieves the metadata for that category from the system or systems in which it is stored. For example, the `/storage` endpoint returns data from both Neo4j and Redivis whereas `/license` returns data from Neo4j and Roam. 

### Setup   
The current system assumes the Neo4j database is running on the localhost. The api looks for keys and the database password as system variables, as described in `app.py`. Amongst the dependencies for the api is the library `roamPy`, a custom library of python wrapper functions developed by the GSB Library. At the time of writing `roamPy` is still in development and should be used with caution. The current version of the shiny application also assumes the api is running on the localhost. The `www` directory contains a css stylesheet for the shiny frontend. 

### API
A Flask Rest API that provides a number of endpoints to retrieve dataset metadata from multiple sources. 

#### Endpoints
`/`  Homepage. Will return an html document with 'GSB Data Index V0'. Can be used to rest if API is running. 

`/getStorage/<dataset>` Accepts the name of a dataset and returns information about the system on which it is stored. If the dataset is stored on Redivis, it will also return metadata from the Redivis system decribing the version and storge information (, tables, url, Gb's etc.)

`/getLicense/<dataset>` Accepts the name of a dataset and return information about the dataset's license from the database and the Roam platform. 

`/getSubscriptionPeriod/<dataset>` Accepts the name of a dataset and returns information regarding the current Subscription period from the Redivis system. 

`/getUsers/<dataset>` Accepts the name of a dataset and returns information on each individual granted access to the dataset from the Graph Database. 

`/description/<dataset>` Accepts the name of a dataset and returns the descriptive metadata from the Graph Database

`/userInfo/<sunet>` Accepts a SUNetID and returns data on every dataset to which that individual has been granted access. 

`/publisher/<dataset>` Accepts the name of a dataset and returns metadata about the publisher from the Grpah Database and Roam.

`/userInfo/<sunet>` Accepts a SUNetID and returns the description of all the datasets to which that user has been granted access. 

##### The next endpoints accept no arguments and return a list of all name datasets in that system. Used to populate dropdowns in shiny app.

`/allDatasets` Returns the names of all datasets in the Graph Database

`/allRedDatasets` Returns the names of all datasets in Redivis

`/allRoamDatasets` Returns the names of all dataasets in Roam

`/allusers` Returns the SUNetID of all the users in the Neo4j database

`/network` Returns the user-dataset network for visualization/analysis platform. 

### Shiny Frontend
A Shiny web app to send arrguments to the data api and prcess the json results into a tabular for for display. Includes a tab page for each end pint category described above. 

`app.R` The main app file describing the layout and interactivity of the app.

`getAllDatasets.R`, `getRedDatasets.R`, `getAllUserNames.R` and `getRoamDatasets.R` are functions that retrieve the data from the endpoints with the same name. These functions are called when the app loads to populate the dropdown menus with dataset and user names. 

`getDataByUser.R` Returns data from the `/userInfo/<sunet>`. Displays a table with metadata features for the users datasets

`getDescription.R` Returns data from the `/description/<dataset>` endpoint and displays it as a table. 

`getLicense.R` Returns data from the `/getLicense/<dataset>` endpoint. Combines data from Roam and Neo4j. 

`getNetwork.R` Returns data from the `/network` endpoint and prepares the node and edge tables necessary for the visnetwork visualisation. 

`getPublisher.R` Returns data from the `/publisher/<dataset>` and prepares the response. Combines data from Neo4j and Roam. 

`getStaticNetwork.R` Returns data from the `/network` endpoint and prepares the node and edge tables necessary for the igraph visualisation. 

`getStorage.R` Returns data from the `/getStorage/<dataset>` endpoint. Can accept result when dataset in Roam or DB  or both but both dropdowns must be set to the same dataset or it will return data for different datasets if both datasets are in both systems. Otherwise, it will only return data for the dataset it can find in either system. Still buggy, needs further testing. 

`getSubscriptionPeriod.R` Returns data from the `/getSubscriptionPeriod/<dataset>` endpoint. Retrieves all subscription period data from Roam for the name dataset. 

`getUsers.R` Returns data from the `/users/<dataset>` endpoint. Retireves data on users listed as having access to the named dataset in the Neo4j database. 

