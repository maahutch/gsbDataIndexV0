from neo4j import GraphDatabase
import json


class Neo: 

    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password), encrypted=False)

    def close(self):
        self.driver.close()

    #Storage endpoint
    @staticmethod
    def __getStorage(tx, name):
        query = "MATCH (a:Dataset)-[r:STORED_ON]->(b:StorageSystem) \
                 WHERE a.title = '%s' \
                 RETURN b.name, b.securityStandard, b.connectionAddress" % (name)
        
        result = tx.run(query, name = name)
        return [record for record in result]

    def getStorage(self, dataset):
        with self.driver.session() as session:
            result = session.read_transaction(self.__getStorage, dataset)
            storage = list(result)
            return(storage)

    #License endpoint
    @staticmethod
    def __getLicense(tx, name):
        query = "MATCH (a:Dataset)<-[r:LICENSE_TYPE]-(b:TermsAndConditions) \
                 WHERE a.title = '%s' \
                 RETURN b.description, b.usageRestriction" % (name)
        
        result = tx.run(query, name = name)
        return [record for record in result]

    def getLicense(self, dataset):
        with self.driver.session() as session:
            result = session.read_transaction(self.__getLicense, dataset)
            license = list(result)
            return(license)


    #Users endpoint
    @staticmethod
    def __getUsers(tx, name):
        query = "MATCH (a:Dataset)<-[r:GRANTED_ACCESS]-(b:User) \
                WHERE a.title = '%s' \
                RETURN b.name, b.sunet, b.email, b.dept, b.pos, b.phone, b.orcid" % (name)
        result = tx.run(query, name=name)
        return [record for record in result]

    def getUsers(self, dataset):
        with self.driver.session() as session: 
            result = session.read_transaction(self.__getUsers, dataset)
            users = list(result)
            return(users)



# if __name__ =="__main__":
#    uri = "bolt://127.0.0.1:7687"
#    user = "neo4j"
#    password = 

#    neo = Neo(uri, user, password)

#    print(neo.getStorage('Berkely Options'))

#    neo.close()