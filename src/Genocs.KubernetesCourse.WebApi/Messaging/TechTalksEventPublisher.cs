using Genocs.KubernetesCourse.Contracts;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;

namespace Genocs.KubernetesCourse.WebApi.Messaging;

public class TechTalksEventPublisher : ITechTalksEventPublisher
{
    private const string queueName = "hello";
    private const string routingKey = "hello";

    private readonly string rabbitMQHostName;
    private readonly string rabbitMQUserName;
    private readonly string rabbitMQPassword;

    public TechTalksEventPublisher(IConfiguration config)
    {
        rabbitMQHostName = config.GetValue<string>("RABBITMQ_HOST_NAME");
        rabbitMQUserName = config.GetValue<string>("RABBITMQ_USER_NAME");
        rabbitMQPassword = config.GetValue<string>("RABBITMQ_PASSWORD");
    }

    public void SendMessages(List<TechTalk> talks)
    {
        var factory = new ConnectionFactory()
        {
            HostName = rabbitMQHostName,
            UserName = rabbitMQUserName,
            Password = rabbitMQPassword,
            //VirtualHost = rabbitMQUserName
        };

        using (var connection = factory.CreateConnection())
        {
            using (var channel = connection.CreateModel())
            {
                channel.QueueDeclare(
                    queue: queueName,
                    durable: true,
                    exclusive: false,
                    autoDelete: false,
                    arguments: null
                );

                var properties = channel.CreateBasicProperties();
                properties.Persistent = true;

                List<byte[]> serializedTalks = new List<byte[]>();

                talks.ForEach(talk =>
                {
                    serializedTalks.Add(
                        Encoding.UTF8.GetBytes(
                            JsonConvert.SerializeObject(talk)
                            ));
                });

                serializedTalks.ForEach(body =>
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