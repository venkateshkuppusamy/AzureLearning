using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Documents.Client;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace DBOperations
{
    class DatabaseService
    {
        private string cosmosendpoint = "https://venkirg123.documents.azure.com:443/";
        private string key = "lZhdoffINLoeVTbwSEVV3vqhbjut8eAjwGIP0NF5DUi1qJqZslKGEF5NfLlAy9GWNdf4kTXNMOCHK4AHOh9s8g==";

        private CosmosClient client;
        private DocumentClient documentClient;



        public DatabaseService()
        {
            client = new CosmosClient(cosmosendpoint, key);
            documentClient = new DocumentClient(new Uri(cosmosendpoint), key);
        }

        public async Task CreateDB(string dbName)
        {
            var result = await client.CreateDatabaseIfNotExistsAsync(dbName);
            Console.WriteLine($"Created {result.Database.Id} opertion status {result.StatusCode}");
        }

        public Database GetDB(string dbName)
        {
            return client.GetDatabase(dbName);
        }

        public async Task DeleteDB(string dbName)
        {
            var db = await documentClient.DeleteDatabaseAsync(UriFactory.CreateDatabaseUri(dbName));
            Console.WriteLine($"Deleted db {dbName}");
        }


    }
}
