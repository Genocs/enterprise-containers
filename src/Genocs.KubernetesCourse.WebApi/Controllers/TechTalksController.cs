using Bogus;
using Genocs.KubernetesCourse.Contracts;
using Genocs.KubernetesCourse.WebApi.Services;
using Genocs.KubernetesCourse.WebApi.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Genocs.KubernetesCourse.WebApi.Controllers;

[Route("api/[controller]")]
public class TechTalksController : Controller
{
    private readonly ITechTalksEventPublisher _messageQueue;
    private readonly InternalApiClient _internalApiClient;

    public TechTalksController(ITechTalksEventPublisher messageQueue, InternalApiClient internalApiClient)
    {
        _messageQueue = messageQueue ?? throw new ArgumentNullException(nameof(messageQueue));
        _internalApiClient = internalApiClient ?? throw new ArgumentNullException(nameof(internalApiClient));
    }

    // GET: api/TechTalks
    [HttpGet]
    public IEnumerable<TechTalk> GetAll()
    {
        List<TechTalk> techTalks = new List<TechTalk>();

        throw new UnauthorizedAccessException("Throwing sample message for Sentry");

        return techTalks;
    }

    // POST api/TechTalks/Generate?numberOfMessages=100
    [HttpGet("Generate")]
    public IActionResult GenerateTechTalks(int numberOfMessages)
    {
        var fakeDataCreator = new Faker();

        var categoryNames = new List<string>()
        {
            "Meetup",
            "Free Conference",
            "Paid Conference",
            "Hackathon",
            "EventTribe"
        };

        var categoryDescriptions = new List<string>()
        {
            "Community event organized via meetup",
            "Free Tech Conference",
            "Paid Tech Conference",
            "Hackathon",
            "Community event organized via Eventribe"
        };

        var levelNames = new List<string>()
        {
            "100 - Beginner",
            "200 - Intermediate",
            "300 - Advanced",
            "400 - Expert"
        };

        var techTalks = new Faker<TechTalk>()
        .StrictMode(true)
        .RuleFor(t => t.Id, f => f.Random.Number(1, 1000))
        .RuleFor(t => t.TechTalkName, f => f.Lorem.Word())
        .RuleFor(t => t.CategoryId, f => f.Random.Number(1, 5))
        .RuleFor(t => t.Category, new Category
        {
            Id = fakeDataCreator.Random.Number(1, 5),
            CategoryName = fakeDataCreator.PickRandom(categoryNames),
            Description = fakeDataCreator.PickRandom(categoryDescriptions)
        })
        .RuleFor(t => t.LevelId, f => f.Random.Number(1, 4))
        .RuleFor(t => t.Level, new Level
        {
            Id = fakeDataCreator.Random.Number(1, 4),
            LevelName = fakeDataCreator.PickRandom(levelNames)
        });

        // generate required number of dummy TechTalks
        var dummyTechTalks = techTalks.Generate(numberOfMessages);
        _messageQueue.SendMessages(dummyTechTalks);
        return Ok();
    }

    [HttpGet("GetFromInternalApi")]
    public async Task<IActionResult> GetFromInternalApi()
        => Ok(await _internalApiClient.GetInternalAsync());

    [HttpGet("PostFromInternalApi")]
    public async Task<IActionResult> PostFromInternalApi()
        => Ok(await _internalApiClient.PostInternalAsync());
}
