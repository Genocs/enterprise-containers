using Genocs.KubernetesCourse.WebApi.Models;

namespace Genocs.KubernetesCourse.WebApi.Services;

public class InternalApiClient
{
    private readonly HttpClient _httpClient;

    public InternalApiClient(HttpClient httpClient, IConfiguration config)
    {
        var url = config.GetSection("ApiClients").GetSection("InternalApi").Value;
        _httpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));
        _httpClient.BaseAddress = new Uri(url);
    }

    public async Task<string?> GetInternalAsync()
        => await _httpClient.GetStringAsync("GetInternal");

    public async Task<OrderCreated?> PostInternalAsync()
    {
        var response = await _httpClient.PostAsJsonAsync<OrderCreated>("PostInternal", new OrderCreated { });
        if(response != null && response.StatusCode == System.Net.HttpStatusCode.OK)
        {
            var orderCreated = await response.Content.ReadFromJsonAsync<OrderCreated>();
            return orderCreated;
        }
        return null;
    }     
}