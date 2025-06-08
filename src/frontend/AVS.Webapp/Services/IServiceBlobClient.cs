namespace AVS.Webapp.Services
{
    public interface IServiceBlobClient
    {
        Task<string> GetBlobSasUrlAsync(string clienteId);
    }
}
