using Genocs.KubernetesCourse.Contracts;
using Genocs.KubernetesCourse.WebApi.Services.Interfaces;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;

namespace Genocs.KubernetesCourse.WebApi.Services;

public class RabbitMQPublisher : IRabbitMQPublisher
{
    private const string queueName = "hello";
    private const string routingKey = "hello";

    private readonly string _rabbitMQHostName;
    private readonly string _rabbitMQUserName;
    private readonly string _rabbitMQPassword;
    private readonly string _rabbitMQVirtualHost;
    private readonly bool _useSSL;



    public RabbitMQPublisher(IConfiguration config)
    {
        _rabbitMQHostName = config.GetValue<string>("RABBITMQ_HOST_NAME") ?? "localhost";
        _rabbitMQUserName = config.GetValue<string>("RABBITMQ_USER_NAME") ?? "guest";
        _rabbitMQPassword = config.GetValue<string>("RABBITMQ_PASSWORD") ?? "guest";
        _rabbitMQVirtualHost = config.GetValue<string>("RABBITMQ_VIRTUAL_HOST") ?? "/";
        _useSSL = config.GetValue<bool>("RABBITMQ_USE_SSL");
    }

    public void SendMessages(List<ApplicationMessage> messages)
    {
        var factory = new ConnectionFactory()
        {
            HostName = _rabbitMQHostName,
            UserName = _rabbitMQUserName,
            Password = _rabbitMQPassword,
            VirtualHost = _rabbitMQVirtualHost
        };

        if (_useSSL)
        {
            factory.Ssl = new SslOption(_rabbitMQHostName) { Enabled = _useSSL };
        }

        using (var connection = factory.CreateConnection())
        {
            using (var channel = connection.CreateModel())
            {
                channel.QueueDeclare(
                    queue: queueName,
                    durable: false,
                    exclusive: false,
                    autoDelete: false,
                    arguments: null
                );

                var properties = channel.CreateBasicProperties();
                properties.Persistent = true;

                List<byte[]> serializedMessages = new List<byte[]>();

                messages.ForEach(talk =>
                {
                    serializedMessages.Add(
                        Encoding.UTF8.GetBytes(
                            JsonConvert.SerializeObject(talk)
                            ));
                });

                serializedMessages.ForEach(body =>
                {
                    channel.BasicPublish(exchange: "",
                            routingKey: routingKey,
                            basicProperties: properties,
                            body: body);
                });

            }
        }
    }
}