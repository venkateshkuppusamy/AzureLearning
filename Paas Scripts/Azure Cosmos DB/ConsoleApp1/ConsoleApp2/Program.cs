using System;
using System.Collections.Generic;

namespace ConsoleApp2
{
    class Program
    {
        static void Main(string[] args)
        {
            //string result  = interpolate(25, new List<int>() { 10,25,50,100,500}, new List<float>() {2.46f,2.58f,2.0f,2.25f,3.0f } );

            //string result = interpolate(1999, new List<int>() { 10, 25, 50, 100, 500 }, new List<float>() { 27.32f, 23.13f, 21.25f, 18.00f, 15.50f });

            //string result = interpolate(2, new List<int>() { 10, 25, 50, 100, 500 }, new List<float>() { 0.0f, 0.0f, 0.0f, 0.0f, 54.25f });

            //string result = interpolate(1730, new List<int>() { 10, 40, 47, 60, 67, 83, 645, 664, 760, 790, 870, 933, 1000 }, new List<float>() { 19.36f, 1.36f, 4.38f, 4.66f, 6.54f, 5.82f, 1f, 5.49f, 6.56f, 8.83f, 1.28f, 1.71f, 1f });

            string result = interpolate(40, new List<int>() { 10, 25, 50, 100, 500 }, new List<float>() { 17f, 18f, 20f, 22f, 29.15f });
            //20.8
            //19.20
            Console.WriteLine(result);
            Console.Read();


        }

        public static string interpolate(int n, List<int> instances, List<float> price)
        {
            Console.WriteLine(String.Join(",", instances));
            Console.WriteLine(String.Join(",", price));
            int index = instances.IndexOf(n);
            if (index > -1)
            {
                return Convert.ToString(price[index]);
            }
            else
            {
                int i = 0;
                int j = 0;
                while (n > instances[i] && i< instances.Count-1)
                {
                    i++;
                }
                if (i == 0)
                {
                    return "0.00";
                }
                i = 1;
                float pricediff = Math.Abs(price[i] - price[i - 1]);
                int unitdiff = instances[i] - instances[i - 1];
                float den = (float)(n - instances[i]) / unitdiff;
                float fprice = Math.Abs(price[i] - (pricediff * den));
                return fprice.ToString("0.00");
            }
        }

        
    }
}
