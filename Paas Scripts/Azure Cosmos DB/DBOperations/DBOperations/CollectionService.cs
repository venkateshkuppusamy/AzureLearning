using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Documents.Client;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace DBOperations
{
    class CollectionService
    {
        private string cosmosendpoint = "https://venkirg123.documents.azure.com:443/";
        private string key = "lZhdoffINLoeVTbwSEVV3vqhbjut8eAjwGIP0NF5DUi1qJqZslKGEF5NfLlAy9GWNdf4kTXNMOCHK4AHOh9s8g==";
        private string dbName = "Earth";
        
        private CosmosClient client;
        private DocumentClient documentClient;

        public CollectionService()
        {
            client = new CosmosClient(cosmosendpoint, key);
            documentClient = new DocumentClient(new Uri(cosmosendpoint), key);
        }

        public async Task CreateCollection(string collectionName, string partitionKey)
        {
            var result = await client.GetDatabase(dbName).CreateContainerIfNotExistsAsync(collectionName, partitionKey);
            
            Console.WriteLine($"Collection created {result.Container.Id} operation status{result.StatusCode}");
        }

        public Container GetCollection(string collectionName)
        {
            return client.GetContainer(dbName, collectionName);
        }

        public async Task<List<string>> GetAllCollection()
        {
            List<string> lst = new List<string>();
            var collection = await documentClient.ReadDocumentCollectionFeedAsync(UriFactory.CreateDatabaseUri(dbName));
            foreach (var item in collection)
            {
                lst.Add(item.Id);
            }
            return lst;
        }

        public async Task DeleteCollection(string collectionName)
        {
           await documentClient.DeleteDocumentCollectionAsync(UriFactory.CreateDocumentCollectionUri(dbName, collectionName));
            Console.WriteLine($"Collection deleted {collectionName}");
        }
    }
}
