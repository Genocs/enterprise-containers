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
    public IActionResult PostInternal()
        => Ok("Internal call it's OK!");
}
