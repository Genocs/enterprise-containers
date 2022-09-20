namespace Genocs.KubernetesCourse.Internal.WebApi.Models;

public class OrderCreated
{
    public string? OrderId { get; set; }
    public decimal Amount { get; set; }
    public DateTime EmissionDate { get; set; }
}
