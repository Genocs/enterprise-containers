using Genocs.KubernetesCourse.Worker.Messaging;

namespace Genocs.KubernetesCourse.Worker;

public class ConsoleHostedService :
    IHostedService
{
    private readonly IRabbitMQEventConsumer _techTalksEventConsumer;

    public ConsoleHostedService(IRabbitMQEventConsumer techTalksEventConsumer)
    {
        _techTalksEventConsumer = techTalksEventConsumer ?? throw new ArgumentNullException(nameof(techTalksEventConsumer));
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        _techTalksEventConsumer.Initialize();
        await Task.CompletedTask;
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        _techTalksEventConsumer.Close();
        await Task.CompletedTask;
    }
}