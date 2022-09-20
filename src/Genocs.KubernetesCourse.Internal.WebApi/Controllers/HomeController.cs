using Genocs.KubernetesCourse.Internal.WebApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace Genocs.KubernetesCourse.Internal.WebApi.Controllers;

[Route("")]
public class HomeController : Controller
{

    public HomeController()
    {

    }

    [HttpGet("")]
    public IActionResult GetHome()
        => Ok("Welcome to Kubernates course!");

    [HttpGet("GetInternal")]
    public IActionResult GetInternal()
        => Ok("Internal call it's OK!");

    [HttpPost("PostInternal")]
    [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(OrderCreated))]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public IActionResult PostInternal()
        =>  Ok(new OrderCreated {
                                OrderId = Guid.NewGuid().ToString(),
                                EmissionDate = DateTime.UtcNow,
                                Amount = 10.0M
                            });

}
