using System;
using System.Collections.Generic;
using Microsoft.Azure.Documents;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace BasicFunctionApp
{
    public static class BasicCosmosDb
    {
        /// <summary>
        /// 1. A cosmos db account is required.
        /// 2. Create a cosmos db, then a table, then a collection.
        /// 3. Specifiy the account connection string ,db name and collection name in the function.
        /// 4. The function is execute when a record is added or modified in the collection.
        /// </summary>
        /// <param name="input"></param>
        /// <param name="log"></param>
        [FunctionName("BasicCosmosDb")]
        public static void Run([CosmosDBTrigger(
            databaseName: "Test",
            collectionName: "Users",
            ConnectionStringSetting = "CosmosConnection",
            LeaseCollectionName = "leases",
            CreateLeaseCollectionIfNotExists = true)]IReadOnlyList<Document> input, ILogger log)
        {
            if (input != null && input.Count > 0)
            {
                log.LogInformation("Documents modified " + input.Count);
                log.LogInformation("First document Id " + input[0].Id);
            }
        }
    }
}
