using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace Sample_Api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HelloWorldController : ControllerBase
    {
        private Random rnd = null;

        public HelloWorldController()
        {
            rnd = new Random();
        }
        
        [HttpGet]
        public async Task<string> Get(string name)
        {
            await Task.Delay(rnd.Next(0, 300));
            return $"hey {name}";
        }
        
        [HttpPost]
        public async Task<string> Post([FromForm] string name)
        {
            await Task.Delay(rnd.Next(0, 300));
            return $"hey {name}";
        }
    }
}