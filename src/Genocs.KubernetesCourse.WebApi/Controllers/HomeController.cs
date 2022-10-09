using Bogus;
using Genocs.KubernetesCourse.Contracts;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Genocs.KubernetesCourse.WebApi.Controllers;

[Route("")]
public class HomeController : Controller
{

    public HomeController()
    {

    }

    [HttpGet("")]
    public IActionResult GetHome()
    {
        return Ok("Welcome to Kubernates course!");
    }
}
