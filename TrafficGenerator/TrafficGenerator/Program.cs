// See https://aka.ms/new-console-template for more information

using System;
using System.Linq;

Random rnd = new Random();
while(true)
    Console.WriteLine($"GET http://192.168.178.35:5010/HelloWorld/?name={RandomString(10)}");


string RandomString(int length)
{
    const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return new string(Enumerable.Repeat(chars, length)
        .Select(s => s[rnd.Next(s.Length)]).ToArray());
}
