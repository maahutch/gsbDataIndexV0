# gsbDataIndexV0
MVP of data api and web frontend for GSB Data Index

### API
A Flask Rest API that provides a number of endpoints to retrieve dataset metadata from multiple sources. 

#### Endpoints
`/`  Homepage. Will return an html document with 'GSB Data Index V0'. Can be used to rest if API is running. 

`/getStorage/<dataset>` Accepts the name of a dataset and returns information about the system on which it is stored. If the dataset is stored on Redivis, it will also return metadata from the Redivis system decribing the version and storge information (, tables, url, Gb's etc.)

`/getLicense/<dataset>` Accepts the name of a dataset and return information about the dataset's license from the database and the Roam platform. 

`/getSubscriptionPeriod/<dataset>` Accepts the name of a dataset and returns information regarding the current Subscription period from the Redivis system. 

`/getUsers/<dataset>` Accepts the name of a dataset and returns information on each individal granted access to the dataset from the Graph Database. 

`/description/<dataset>` Accepts the name of a dataset and returns the descriptive metadata from the Graph Database

`/userInfo/<sunet>` Accepts a SUNetID and returns data on every dataset to which that individual has been granted access. 

`/publisher/<dataset>` Accepts the name of a dataset and returns metadata about the publisher from the Grpah Database and Roam.

##### The next three endpoints accept no arguments and return a list of all name datasets in that system. Used to populate dropdowns in shiny app.

`/allDatasets` Returns the names of all datasets in the Graph Database

`/allRedDatasets` Returns the names of all datasets in Redivis

`/allRoamDatasets` Returns the names of all dataasets in Roam


### Shiny Frontend