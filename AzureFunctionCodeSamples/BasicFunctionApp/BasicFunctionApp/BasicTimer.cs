using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace BasicFunctionApp
{
    /*
        1. Publish using zip deploy
        2. Function app settings needs to be added during publish. local.setting.json is for development.
        3. Live Logs are seen in log stream in azure portal.
        4. Logs history are captures in file system. Use kudu to see file structure and see the logs.

     */ 
    public static class BasicTimer
    {
        
        /// <summary>
        /// A basic timer function which runs every 5 sec. Configured as cron expression. 
        /// </summary>
        /// <param name="myTimer"></param>
        /// <param name="log"></param>
        [FunctionName("BasicTimer")]
        public static void Run([TimerTrigger("*5 * * * * *")]TimerInfo myTimer, ILogger log)
        {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
        }
    }
}
