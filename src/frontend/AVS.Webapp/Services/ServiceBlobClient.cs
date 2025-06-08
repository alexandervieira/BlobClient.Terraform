
namespace AVS.Webapp.Services
{
    public class ServiceBlobClient : IServiceBlobClient
    {
        private readonly HttpClient _httpClient;

        public ServiceBlobClient(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<string> GetBlobSasUrlAsync(string clienteId)
        {
            var response = await _httpClient.GetAsync($"generate-sas?clientId={clienteId}");
            response.EnsureSuccessStatusCode();
            return await response.Content.ReadAsStringAsync();
        }
    }
}
