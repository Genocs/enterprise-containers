using Genocs.KubernetesCourse.Contracts;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

namespace Genocs.KubernetesCourse.Worker.Messaging;

public class RabbitMQEventConsumer : IRabbitMQEventConsumer
{
    // private const string exchangeName = "ApplicationMessagesExchange";
    private const string _queueName = "hello";
    private const string _routingKey = "hello";

    private readonly ILogger<RabbitMQEventConsumer> _logger;


    private readonly ushort rabbitMQBatchSize;

    private readonly ConnectionFactory _factory;
    private IConnection? _connection;
    private IModel? _channel;
    private EventingBasicConsumer? _eventingBasicConsumer;


    private static ManualResetEvent _resetEvent = new ManualResetEvent(false);

    public RabbitMQEventConsumer(IConfiguration config, ILogger<RabbitMQEventConsumer> logger)
    {
        string rabbitMQHostName = config.GetValue<string>("RABBITMQ_HOST_NAME") ?? "localhost";
        string rabbitMQUserName = config.GetValue<string>("RABBITMQ_USER_NAME") ?? "guest";
        string rabbitMQPassword = config.GetValue<string>("RABBITMQ_PASSWORD") ?? "guest";
        string rabbitMQVirtualHost = config.GetValue<string>("RABBITMQ_VIRTUAL_HOST") ?? "/";
        bool useSSL = config.GetValue<bool>("RABBITMQ_USE_SSL");

        rabbitMQBatchSize = config.GetValue<ushort>("RABBITMQ_BATCH_SIZE");
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));

        _logger.LogInformation("RabbitMQEventConsumer started!!");

        _factory = new ConnectionFactory()
        {
            HostName = rabbitMQHostName,
            UserName = rabbitMQUserName,
            Password = rabbitMQPassword,
            VirtualHost = rabbitMQVirtualHost
        };

        if (useSSL)
        {
            _factory.Ssl = new SslOption(rabbitMQHostName) { Enabled = useSSL };
        }
    }

    public void Initialize()
    {
        if ((_connection != null) || (_channel != null) || (_eventingBasicConsumer != null))
        {
            throw new InvalidOperationException("Release all resources before call Initialize");
        }

        _connection = _factory.CreateConnection();

        if (_connection != null)
        {
            _channel = _connection.CreateModel();
        }

        if (_channel is null)
        {
            return;
        }

        _channel.QueueDeclare(
                queue: _queueName,
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null
            );

        // Fetch messages as per the BatchSize configuration at a time to process
        _channel.BasicQos(prefetchSize: 0, prefetchCount: rabbitMQBatchSize, global: false);

        _eventingBasicConsumer = new EventingBasicConsumer(_channel);

        _eventingBasicConsumer.Received += (TechTalksModel, ea) =>
        {
            var body = ea.Body.Span;
            var props = ea.BasicProperties;
            var replyProps = _channel.CreateBasicProperties();
            replyProps.CorrelationId = props.CorrelationId;

            var message = Encoding.UTF8.GetString(body);
            var techTalk = JsonConvert.DeserializeObject<ApplicationMessage>(message);

            if (techTalk != null)
            {
                _logger.LogInformation($"Processed message with id: '{techTalk.Id}'");
            }

            _channel.BasicAck(deliveryTag: ea.DeliveryTag, multiple: false);
        };

        _channel.BasicConsume(queue: _queueName,
                                autoAck: false,
                                consumer: _eventingBasicConsumer);
        _resetEvent.WaitOne();
    }

    public void Close()
    {
        if (_connection != null)
        {
            _connection.Close();
            _connection.Dispose();
            _connection = null;
        }

        if (_channel != null)
        {
            _channel.Close();
            _channel.Dispose();
            _channel = null;
        }

        _eventingBasicConsumer = null;
    }

    private void LogMessageDetails(ApplicationMessage message)
    {
        _logger.LogInformation($"Message Id: {message.Id}, Name: {message.MessageName}, Category: {message.CategoryId}, Level: {message.LevelId}");
        _logger.LogInformation($"Message persisted successfully at {DateTime.Now.ToLongTimeString()}");
    }
}