using System.Diagnostics;
using AVS.Webapp.Models;
using AVS.Webapp.Services;
using Microsoft.AspNetCore.Mvc;

namespace AVS.Webapp.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IServiceBlobClient _serviceBlobClient;

        public HomeController(ILogger<HomeController> logger, IServiceBlobClient serviceBlobClient)
        {
            _logger = logger;
            _serviceBlobClient = serviceBlobClient;
        }

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GenerateSas(string clientId)
        {
            if (string.IsNullOrEmpty(clientId))
            {
                _logger.LogError("ClientId is null or empty.");
                return BadRequest("ClientId is required.");
            }

            try
            {
                var blobSasUrl = await _serviceBlobClient.GetBlobSasUrlAsync(clientId);
                ViewBag.BlobSasUrl = blobSasUrl;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving Blob SAS URL for ClientId: {ClientId}", clientId);
                return StatusCode(500, "Internal server error while retrieving Blob SAS URL.");
            }

            return View(nameof(Index));
        }

        [HttpGet]
        public IActionResult Privacy()
        {
            return View();
        }

        [HttpGet]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
