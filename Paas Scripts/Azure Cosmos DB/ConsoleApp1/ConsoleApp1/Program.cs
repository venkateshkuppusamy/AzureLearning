using System;
using System.Collections.Generic;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
			int count = minswap(new List<int> { 3, 3, 1, 2 });
			Console.WriteLine(count);
			Console.ReadLine();
        }

		static void swap(List<int> arr, int i, int t)
		{
			int z = 0;

			z = arr[i];
			arr[i] = arr[t];
			arr[t] = z;
		}

		public static int minswap(List<int> arr)
        {
			int s = 0;
			int n = arr.Count;
			Dictionary<int, int> mp = new Dictionary<int, int>(n);

			int[] k = new int[n];
			int x = 0;
			for (int i = 0; i < n; i++)
			{
				x = arr[i];
				k[i] = x;
				mp.Add(x, i);
			}
			Array.Sort(k);
			int t = 0;
			for (int i = 0; i < n; i++)
			{
				if (k[i] != arr[i])
				{
					t = mp[k[i]];
					mp[arr[i]] = t;
					mp[k[i]] = i;
					swap(arr, i, t);
					s++;
				}
			}
			return s;

		}
    }
}
