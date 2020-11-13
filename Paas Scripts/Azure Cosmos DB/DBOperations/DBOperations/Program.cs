using Microsoft.Azure.Cosmos;
using System;

namespace DBOperations
{
    class Program
    {
        private static string cosmosendpoint = "https://venkirg123.documents.azure.com:443/";
        private static string key = "lZhdoffINLoeVTbwSEVV3vqhbjut8eAjwGIP0NF5DUi1qJqZslKGEF5NfLlAy9GWNdf4kTXNMOCHK4AHOh9s8g==";
        static void Main(string[] args)
        {
            CollectionService cs = new CollectionService();
            cs.CreateCollection("Animal", @"/animaltype").Wait();
            var collection = cs.GetCollection("Animal");
            Console.WriteLine($"{collection.Id} {collection.Database.Id}");

            var collections = cs.GetAllCollection().GetAwaiter().GetResult();
            foreach (var item in collections)
            {
                Console.WriteLine($"Collection name {item}");
            }

            cs.DeleteCollection("Animal").Wait();
            Console.Read();
        }

        private static void DatbaseService()
        {
            DatabaseService databaseService = new DatabaseService();
            databaseService.CreateDB("Standard").Wait();
            var db = databaseService.GetDB("Standard");
            Console.WriteLine($"Read database {db.Id}");

            databaseService.DeleteDB("Standard").Wait();
        }

               
    }
}
