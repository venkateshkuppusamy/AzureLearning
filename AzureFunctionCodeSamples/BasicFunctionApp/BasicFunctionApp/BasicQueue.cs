using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace BasicFunctionApp
{
    public static class BasicQueue
    {
        /// <summary>
        /// 1. Basic queue trigger, define the storage connection where the queue is 
        /// 2. Define the queue name from where the items are picker.
        /// 3. Once items are picked for processing the item is deleted in the queue.
        /// </summary>
        /// <param name="myQueueItem"></param>
        /// <param name="log"></param>
        [FunctionName("BasicQueue")]
        public static void Run([QueueTrigger("myqueue-items", Connection = "QueueConnection")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
        }
    }
}
