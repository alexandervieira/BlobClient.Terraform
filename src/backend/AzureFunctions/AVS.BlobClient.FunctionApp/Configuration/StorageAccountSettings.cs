namespace AVS.BlobClient.FunctionApp.Configuration
{
    public class StorageAccountSettings
    {
        public string KeyVaultUri { get; set; } = string.Empty;
        public string StorageAccountName { get; set; } = string.Empty;
        public string KeyVaultSecret { get; set; } = string.Empty;
        public string BlobName { get; set; } = string.Empty;
        public string BlobContainerName { get; set; } = string.Empty;
    }
}