using AVS.BlobClient.FunctionApp.Configuration;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

builder.Services
    .AddApplicationInsightsTelemetryWorkerService()
    .ConfigureFunctionsApplicationInsights();

builder.Configuration
       .SetBasePath(builder.Environment.ContentRootPath)
       .AddJsonFile("local.settings.json", true, true)
       .AddJsonFile($"local.settings.{builder.Environment.EnvironmentName}.json", true, true)
       .AddEnvironmentVariables();

//var localsettingsSection = builder.Configuration.GetSection("StorageAccountValues");
//if (localsettingsSection == null)
//{
//    throw new InvalidOperationException("StorageAccountValues configuration section is missing");
//}
//builder.Services.Configure<StorageAccountSettings>(localsettingsSection);

//var storageAccountSettings = localsettingsSection.Get<StorageAccountSettings>();

//if (storageAccountSettings == null)
//{
//    throw new InvalidOperationException("StorageAccountSettings could not be bound from configuration");
//}

//var keyVaultUri = storageAccountSettings.KeyVaultUri;

builder.Build().Run();
