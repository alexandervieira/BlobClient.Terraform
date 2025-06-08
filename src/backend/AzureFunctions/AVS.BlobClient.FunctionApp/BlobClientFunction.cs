using System.Net;
using Azure.Storage.Blobs;
using Azure.Storage.Sas;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Azure.Storage;

public class BlobClientFunction
{
    private readonly ILogger _logger;
    public HttpResponseData? Response { get; set; }

    public BlobClientFunction(ILoggerFactory loggerFactory)
    {
        _logger = loggerFactory.CreateLogger<BlobClientFunction>();
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

        // Verificar se o keyVaultUri é nulo ou vazio antes de criar o objeto Uri
        if (!EnvironmentVariableValid("KeyVaultUri", "KeyVaultUri is not configured properly.", req))
            return Response!;

        // Recuperar o URI do Key Vault a partir das configurações da Function App
        var keyVaultUri = Environment.GetEnvironmentVariable("KeyVaultUri");

        // Usar o Key Vault para obter a chave de acesso ao Blob Storage
        var client = new SecretClient(new Uri(keyVaultUri!), new DefaultAzureCredential());
        var secretResponse = await client.GetSecretAsync("BlobStorageAccessKey");

        // Verificar se o valor do segredo é nulo
        if (string.IsNullOrEmpty(secretResponse.Value?.Value))
        {
            var badResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            badResponse.WriteString("BlobStorageAccessKey is not configured properly.");
            return badResponse;
        }

        string storageAccountKey = secretResponse.Value.Value;

        if(!EnvironmentVariableValid("StorageAccountName", "StorageAccountName is not configured properly.", req))
            return Response!;

        var storageAccountName = Environment.GetEnvironmentVariable("StorageAccountName");        

        if (!EnvironmentVariableValid("BlobName", "BlobName is not configured properly.", req))
            return Response!;

        var blobName = Environment.GetEnvironmentVariable("BlobName");       

        if (!EnvironmentVariableValid("BlobContainerName", "BlobContainerName is not configured properly.", req))
            return Response!;

        var blobContainerName = Environment.GetEnvironmentVariable("BlobContainerName");
        
        // Usar o storageAccountKey para acessar o Blob Storage
        var blobServiceClient = new BlobServiceClient(new StorageSharedKeyCredential(storageAccountName, storageAccountKey).ToString());
        var blobContainerClient = blobServiceClient.GetBlobContainerClient(blobContainerName);
        var blobClient = blobContainerClient.GetBlobClient(blobName);

        // Gerar o SAS Token para o Blob
        var sasBuilder = new BlobSasBuilder
        {
            BlobContainerName = blobContainerName,
            BlobName = blobName,
            ExpiresOn = DateTimeOffset.UtcNow.AddMinutes(15)
        };

        sasBuilder.SetPermissions(BlobSasPermissions.Read);

        var sasQueryParameters = sasBuilder.ToSasQueryParameters(new StorageSharedKeyCredential(storageAccountName, storageAccountKey));
        var blobUrlWithSas = $"{blobClient.Uri}?{sasQueryParameters}";

        // Criar uma resposta HTTP com status OK e a URL com SAS
        var response = req.CreateResponse(HttpStatusCode.OK);
        response.WriteString(blobUrlWithSas);
        Response = response;
        return Response;
    }

    private bool EnvironmentVariableValid(string variableName, string message, HttpRequestData req)
    {
        if (string.IsNullOrEmpty(Environment.GetEnvironmentVariable(variableName)))
        {
            var badResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            badResponse.WriteString(message);
            Response = badResponse;
            return false;
        }
        return true;

    }
}
