using System;
using System.Collections.Generic;
using System.Text;

namespace BulkImportJsonToCosmon.Model
{
    class Person
    {
        public string _id { get; set; }
        public string  index { get; set; }
        public string guid { get; set; }
        public int age { get; set; }
        public string eyeColor { get; set; }
        public string email { get; set; }
        public string phone { get; set; }
        public string address { get; set; }
        public string about { get; set; }
        public DateTime registered { get; set; }
        public Friend[] friends { get; set; }
        public string greeting { get; set; }
        public string[] favoriteFruit { get; set; }
    }

}
