using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MyGame
{
    class Location
    {
        public string Description="";
        public double Latitude=0.0;
        public double Longitude=0.0;

        public Location()
        {

        }
        public Location(double lat, double lng)
        {
            lat = Latitude;
            lng = Longitude;
        }
        public Location(string lat, string lng)
        {
            Latitude = double.Parse(lat);
            Longitude = double.Parse(lng);
        }
        public string MessageString()
        {
            string msg = "<Location>";
            msg += "<Description>" + Description + "</Description>";
            msg += "<Latitude>" + Latitude + "</Latitude>";
            msg += "<Longitude>" + Longitude + "</Longitude>";
            msg += "</Location>";
            return msg;
        }
    }
}
