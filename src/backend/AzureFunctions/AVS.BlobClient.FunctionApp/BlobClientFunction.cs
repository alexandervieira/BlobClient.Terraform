using AVS.BlobClient.FunctionApp.Configuration;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Azure.Storage;
using Azure.Storage.Blobs;
using Azure.Storage.Sas;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Net;

public class BlobClientFunction
{
    private readonly ILogger _logger;
    private readonly StorageAccountSettings _storageSettings;    

    public BlobClientFunction(ILoggerFactory loggerFactory, IConfiguration configuration)
    {
        _logger = loggerFactory.CreateLogger<BlobClientFunction>();
        _storageSettings = configuration.GetSection("StorageAccountValues").Get<StorageAccountSettings>()
            ?? throw new InvalidOperationException("StorageAccountValues configuration is missing");
    }

    [Function("BlobClientFunction")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Function, "get", Route = "generate-sas")] HttpRequestData req)
    {
        _logger.LogInformation("C# HTTP trigger function processed a request to generate a Blob SAS URL.");

        // Obtendo o parâmetro 'clienteId' da query string
        var clienteId = req.Query["clientId"]?.ToString();

        // Se o 'clienteId' não for fornecido, retorna uma resposta de BadRequest
        if (string.IsNullOrEmpty(clienteId))
        {
            var badResponse = req.CreateResponse(HttpStatusCode.BadRequest);
            badResponse.WriteString("Missing clienteId parameter");
            return badResponse;
        }        

        try
        {
            // Usar o Key Vault para obter a chave de acesso ao Blob Storage
            var client = new SecretClient(new Uri(_storageSettings.KeyVaultUri), new DefaultAzureCredential());
            var secretResponse = await client.GetSecretAsync(_storageSettings.KeyVaultSecret);

            // Verificar se o valor do segredo é nulo
            if (string.IsNullOrEmpty(secretResponse.Value?.Value))
            {
                var badResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
                badResponse.WriteString("BlobStorageAccessKey is not configured properly.");
                return badResponse;
            }

            string storageAccountKey = secretResponse.Value.Value;

            // Usar o storageAccountKey para acessar o Blob Storage
            var blobServiceClient = new BlobServiceClient(new StorageSharedKeyCredential(_storageSettings.StorageAccountName, storageAccountKey).ToString());
            var blobContainerClient = blobServiceClient.GetBlobContainerClient(_storageSettings.BlobContainerName);
            var blobClient = blobContainerClient.GetBlobClient(_storageSettings.BlobName);

            // Gerar o SAS Token para o Blob
            var sasBuilder = new BlobSasBuilder
            {
                BlobContainerName = _storageSettings.BlobContainerName,
                BlobName = _storageSettings.BlobName,
                ExpiresOn = DateTimeOffset.UtcNow.AddMinutes(15)
            };

            sasBuilder.SetPermissions(BlobSasPermissions.Read);

            var sasQueryParameters = sasBuilder.ToSasQueryParameters(new StorageSharedKeyCredential(_storageSettings.StorageAccountName, storageAccountKey));
            var blobUrlWithSas = $"{blobClient.Uri}?{sasQueryParameters}";

            // Criar uma resposta HTTP com status OK e a URL com SAS
            var response = req.CreateResponse(HttpStatusCode.OK);
            await response.WriteStringAsync(blobUrlWithSas);            
            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error generating SAS URL");
            var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            await errorResponse.WriteStringAsync("Error generating SAS URL");
            return errorResponse;
        }
        
    }
   
}
