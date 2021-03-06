using Prometheus;
using System;
using System.IO;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Genocs.KubernetesCourse.Worker.Messaging;

namespace Genocs.KubernetesCourse.Worker;

class Program
{
    static IConfiguration Configuration;

    private static readonly Counter TickTock = Metrics.CreateCounter("sampleapp_ticks_total", "Just keeps on ticking");

    static void Main(string[] args)
    {
        var metricServer = new MetricServer(hostname : "localhost", port: 5000);
        metricServer.Start();

        ConfigureEnvironment();
        var serviceProvider = ConfigureServices();

        var techTalksEventConsumer = serviceProvider.GetService<ITechTalksEventConsumer>();

        Console.WriteLine("Starting to read from the queue");

        techTalksEventConsumer.ConsumeMessage();

    }

    static void ConfigureEnvironment()
    {
        string environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Development";

        var builder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile($"appsettings.{environment}.json", optional: true)
            .AddEnvironmentVariables();

        Configuration = builder.Build();

    }

    static ServiceProvider ConfigureServices()
    {
        var services = new ServiceCollection();
        services.AddOptions();

        services.AddSingleton(provider => Configuration);

        services.AddSingleton<ITechTalksEventConsumer, TechTalksEventConsumer>();

        return services.BuildServiceProvider();
    }
}
