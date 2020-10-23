using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

/*
 Pre requisites to develop and run functions
 1. Azure function tools, either available in Visual studion installation or install it seperately.
 2. Azure storage account or storage emulator.
 3. For local testing an valid storage account or storage emulator is required.
 4. After deployment to azure, the http url should incldue access key.
*/ 

namespace BasicFunctionApp
{
    public static class BasicHttp
    {
        [FunctionName("BasicHttp")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name = name ?? data?.name;

            string responseMessage = string.IsNullOrEmpty(name)
                ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
                : $"Hello, {name}. Welcome to the landing page, this HTTP triggered function executed successfully.";

            return new OkObjectResult(responseMessage);
        }
    }
}
