using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace BasicDurableFunctionApp
{
    public static class FunctionChain
    {
        [FunctionName("E1_HelloSequence")]
        public static async Task<List<string>> RunOrchestrator(
     [OrchestrationTrigger] IDurableOrchestrationContext context)
        {
            var outputs = new List<string>();

            outputs.Add(await context.CallActivityAsync<string>("E1_SayHello", "Tokyo"));
            outputs.Add(await context.CallActivityAsync<string>("E1_SayHello", "Seattle"));
            outputs.Add(await context.CallActivityAsync<string>("E1_SayHello_DirectInput", "London"));

            // returns ["Hello Tokyo!", "Hello Seattle!", "Hello London!"]
            return outputs;
        }

        [FunctionName("E1_SayHello")]
        public static string SayHello([ActivityTrigger] IDurableActivityContext context)
        {
            string name = context.GetInput<string>();
            return $"Hello {name}!";
        }

        [FunctionName("E1_SayHello_DirectInput")]
        public static string SayHelloDirectInput([ActivityTrigger] string name)
        {
            return $"Hello {name}!";
        }

        [FunctionName("FunctionChain_HttpStart")]
        public static async Task<HttpResponseMessage> Run(
        [HttpTrigger(AuthorizationLevel.Function, methods: "post", Route = "orchestrators/{functionName}")] HttpRequestMessage req,
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