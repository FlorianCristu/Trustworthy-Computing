using System;

namespace HelloFlorian
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Console.Write("Hello ");
            string input = Console.ReadLine();

            if (string.IsNullOrWhiteSpace(input))
            {
                input = "World";
            }

            Console.WriteLine("Hello " + input);
        }
    }
}