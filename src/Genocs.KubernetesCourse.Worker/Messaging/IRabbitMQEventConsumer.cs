namespace Genocs.KubernetesCourse.Worker.Messaging;

public interface IRabbitMQEventConsumer
{
    void Initialize();
    public void Close();
}