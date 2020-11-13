using Bogus;
using Microsoft.Azure.Cosmos;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using System.Threading.Tasks;

namespace BulkImportJsonToCosmon
{
    class Program
    {
        private const string EndpointUrl = "https://venkirg123.documents.azure.com:443/";
        private const string AuthorizationKey = "lZhdoffINLoeVTbwSEVV3vqhbjut8eAjwGIP0NF5DUi1qJqZslKGEF5NfLlAy9GWNdf4kTXNMOCHK4AHOh9s8g==";
        private const string DatabaseName = "Earth";
        private const string ContainerName = "Person";
        private const int ItemsToInsert = 30;

        static async Task Main(string[] args)
        {
            CosmosClient cosmosClient = new CosmosClient(EndpointUrl, AuthorizationKey, new CosmosClientOptions() { AllowBulkExecution = true });

            Microsoft.Azure.Cosmos.Database database = await cosmosClient.CreateDatabaseIfNotExistsAsync(Program.DatabaseName);

            await database.DefineContainer(Program.ContainerName, "/eyeColor")
                    .WithIndexingPolicy()
                        .WithIndexingMode(IndexingMode.Consistent)
                        .WithIncludedPaths()
                            .Attach()
                        .WithExcludedPaths()
                            .Path("/*")
                            .Attach()
                    .Attach()
                .CreateAsync(50000);

            List<KeyValuePair<PartitionKey, Stream>> itemsToInsert = new List<KeyValuePair<PartitionKey, Stream>>(ItemsToInsert);
            foreach (Model.Person item in Program.GetItemsToInsert())
            {
                MemoryStream stream = new MemoryStream();
                await JsonSerializer.SerializeAsync(stream, item);
                itemsToInsert.Add(new KeyValuePair<PartitionKey, Stream>( new PartitionKey(item.eyeColor), stream));
            }

            Container container = database.GetContainer(ContainerName);
            List<Task> tasks = new List<Task>(ItemsToInsert);
            foreach (KeyValuePair<PartitionKey, Stream> item in itemsToInsert)
            {
                tasks.Add(container.CreateItemStreamAsync(item.Value, item.Key)
                    .ContinueWith((Task<ResponseMessage> task) =>
                    {
                        using (ResponseMessage response = task.Result)
                        {
                            if (!response.IsSuccessStatusCode)
                            {
                                Console.WriteLine($"Received {response.StatusCode} ({response.ErrorMessage}).");
                            }
                        }
                    }));
            }

            // Wait until all are done
            await Task.WhenAll(tasks);
        }

        private static IReadOnlyCollection<Model.Person> GetItemsToInsert()
        {
            return new Bogus.Faker<Model.Person>()
            .StrictMode(true)
            //Generate item
            .RuleFor(o => o._id, f => Guid.NewGuid().ToString()) //id
            .RuleFor(o => o.index, f=> f.IndexGlobal.ToString())
            .RuleFor(o => o.guid, f=> Guid.NewGuid().ToString()) //partitionkey
            .RuleFor(o=> o.greeting,"hello")
            .RuleFor(o=> o.about,"About")
            .RuleFor(o => o.age, f => f.Random.Int(20,40))
            .RuleFor(o=> o.registered, DateTime.Now)
            .RuleFor(o=> o.eyeColor, f=> f.PickRandom<string>(new string[] {"blue","green","brown" }))
            .RuleFor(o=> o.favoriteFruit,new string[] {"orange","apple","pineapple" })
            .Generate(ItemsToInsert);
        }
    }
}
