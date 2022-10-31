using Genocs.KubernetesCourse.Contracts;

namespace Genocs.KubernetesCourse.WebApi.Services.Interfaces;

public interface IRabbitMQPublisher
{
    void SendMessages(List<ApplicationMessage> messages);
}