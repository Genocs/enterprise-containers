using Genocs.KubernetesCourse.Worker;
using Genocs.KubernetesCourse.Worker.Messaging;
using Serilog;
using Serilog.Events;

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Debug()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .CreateLogger();

Microsoft.Extensions.Hosting.IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.AddSingleton<IRabbitMQEventConsumer, RabbitMQEventConsumer>();

        services.AddHostedService<ConsoleHostedService>();

        // Add services to the container.
        //services.AddHttpClient<CustomerClient>();

    })
    .ConfigureLogging((hostingContext, logging) =>
    {
        logging.AddSerilog(dispose: true);
        logging.AddConfiguration(hostingContext.Configuration.GetSection("Logging"));
    })
    .Build();

await host.RunAsync();

await TelemetryAndLogging.FlushAndCloseAsync();

Log.CloseAndFlush();

//class Program
//{
//    static IConfiguration Configuration;

//    static void Main(string[] args)
//    {
//        var metricServer = new MetricServer(hostname : "localhost", port: 5000);
//        metricServer.Start();

//        ConfigureEnvironment();
//        var serviceProvider = ConfigureServices();

//        var techTalksEventConsumer = serviceProvider.GetService<ITechTalksEventConsumer>();

//        Console.WriteLine("Starting to read from the queue");

//        techTalksEventConsumer.ConsumeMessage();

//    }

//    static void ConfigureEnvironment()
//    {
//        string environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Development";

//        var builder = new ConfigurationBuilder();
//        //    .SetBasePath(Directory.GetCurrentDirectory())
//        //    .AddJsonFile($"appsettings.{environment}.json", optional: true)
//        //    .AddEnvironmentVariables();

//        Configuration = builder.Build();

//    }

//    static ServiceProvider ConfigureServices()
//    {
//        var services = new ServiceCollection();
//        services.AddOptions();

//        services.AddSingleton(provider => Configuration);

//        services.AddSingleton<ITechTalksEventConsumer, TechTalksEventConsumer>();

//        return services.BuildServiceProvider();
//    }
//}
