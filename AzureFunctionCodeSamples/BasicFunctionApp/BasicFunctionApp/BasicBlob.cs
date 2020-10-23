using System;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace BasicFunctionApp
{
    public static class BasicBlob
    {
        /// <summary>
        /// 1. Basic blob trigger, which execute when a file/folder is uploaded to a particualr blob
        /// 2. Storage connection string and blob container name should be specified.
        /// </summary>
        /// <param name="myBlob"></param>
        /// <param name="name"></param>
        /// <param name="log"></param>
        [FunctionName("BasicBlob")]
        public static void Run([BlobTrigger("samples-workitems/{name}", Connection = "BlobConnection")]Stream myBlob, string name, ILogger log)
        {
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
        }
    }
}
