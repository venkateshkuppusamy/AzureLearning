using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Microsoft.WindowsAzure.Storage.Blob;

namespace BasicDurableFunctionApp
{
    public static class FanInOut
    {
        [FunctionName("FanInOut_Orchestrator")]
        public static async Task<long> FanInOut_Orchestrator(
            [OrchestrationTrigger] IDurableOrchestrationContext backupContext)
        {
            string rootDirectory = backupContext.GetInput<string>()?.Trim();
            if (string.IsNullOrEmpty(rootDirectory))
            {
                rootDirectory = Directory.GetParent(typeof(FanInOut).Assembly.Location).FullName;
            }
            rootDirectory = rootDirectory.Remove(rootDirectory.Length -4);
            rootDirectory = Path.Combine(rootDirectory, "Logs");
            string[] files = await backupContext.CallActivityAsync<string[]>("FanInOut_GetFileList",  rootDirectory);

            var tasks = new Task<long>[files.Length];
            for (int i = 0; i < files.Length; i++)
            {
                tasks[i] = backupContext.CallActivityAsync<long>("FanInOut_CopyFileToBlob", files[i]);
            }

            await Task.WhenAll(tasks);

            long totalBytes = tasks.Sum(t => t.Result);
            return totalBytes;
        }

        [FunctionName("FanInOut_GetFileList")]
        public static string[] FanInOut_GetFileList([ActivityTrigger] string rootDirectory,ILogger log)
        {
            log.LogInformation($"Searching for files under '{rootDirectory}'...");
            string[] files = Directory.GetFiles(rootDirectory, "*", SearchOption.AllDirectories);
            log.LogInformation($"Found {files.Length} file(s) under {rootDirectory}.");

            return files;
        }

        [FunctionName("FanInOut_CopyFileToBlob")]
        public static async Task<long> CopyFileToBlob([ActivityTrigger] string filePath, Binder binder,ILogger log)
        {
            long byteCount = new FileInfo(filePath).Length;

            // strip the drive letter prefix and convert to forward slashes
            string blobPath = filePath.Substring(Path.GetPathRoot(filePath).Length).Replace('\\', '/');
            string outputLocation = $@"backups/Logs";
            BlobAttribute attribute = new BlobAttribute(outputLocation, FileAccess.Write);
            attribute.Connection = System.Environment.GetEnvironmentVariable("blobConnectionString");
            log.LogInformation($"Copying '{filePath}' to '{outputLocation}'. Total bytes = {byteCount}.");

            // copy the file contents into a blob
            using (Stream source = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.Read))
            using (Stream destination = await binder.BindAsync<CloudBlobStream>(attribute))
                //new BlobAttribute(outputLocation, FileAccess.Write)))
            {
                await source.CopyToAsync(destination);
            }

            return byteCount;
        }


        [FunctionName("FanInOut_HttpStart")]
        public static async Task<HttpResponseMessage> FanInOut_HttpStart(
        [HttpTrigger(AuthorizationLevel.Function, methods: "post", Route = "FanInOut/orchestrators/{functionName}")] HttpRequestMessage req,
        [DurableClient] IDurableClient starter,
        string functionName,
        ILogger log)
        {
            // Function input comes from the request content.
            object eventData = await req.Content.ReadAsAsync<object>();
            string instanceId = await starter.StartNewAsync(functionName, eventData);

            log.LogInformation($"Started orchestration with ID = '{instanceId}'.");

            return starter.CreateCheckStatusResponse(req, instanceId);
        }
    }
}