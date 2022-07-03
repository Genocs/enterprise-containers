using Genocs.KubernetesCourse.WebApi.Messaging;
using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Prometheus;
using Serilog;
using Serilog.Events;


Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Debug()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .CreateLogger();


var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((ctx, lc) => lc
    .WriteTo.Console());

// Azure Application Insight configuration 
builder.Services.AddApplicationInsightsTelemetry();
builder.Services.ConfigureTelemetryModule<DependencyTrackingTelemetryModule>((module, o) =>
{

});
// Azure Application Insight configuration - END

builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.Configure<HealthCheckPublisherOptions>(options =>
{
    options.Delay = TimeSpan.FromSeconds(2);
    options.Predicate = check => check.Tags.Contains("ready");
});

builder.Services.AddTransient<ITechTalksEventPublisher, TechTalksEventPublisher>();


builder.WebHost.UseSentry(options =>
{
    options.Dsn = "https://05b9449ee8ff4c23a8a0b38d351b3633@o1049645.ingest.sentry.io/6030891";
    options.TracesSampleRate = 1.0;
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseRouting();

app.UseAuthorization();

app.UseSentryTracing();

app.UseHttpMetrics();

// Expose default Prometheus Metrics
// app.UseMetricServer();


app.MapControllers();
app.MapMetrics();

app.Run();

Log.CloseAndFlush();
