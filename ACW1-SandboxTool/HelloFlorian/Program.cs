using System;

namespace HelloFlorian
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Hello ");

            string input = Console.ReadLine();

            if (string.IsNullOrEmpty(input))
            {
                Console.WriteLine("World");
            }
            else
            {
                Console.WriteLine(input);
            }
        }
    }
}