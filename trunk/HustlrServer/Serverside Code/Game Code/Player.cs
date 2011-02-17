using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PlayerIO.GameLibrary;
/**
* Player Value Object class
* - This is the VO used for storing each player's data as well as reference the connected user for callbacks
**/
    
namespace MyGame
{
    public class Player : BasePlayer
    {


        public string UserName;   // unique player indentity 
        public string Name;       // public name (customizable)
        public string Status;     // public status message(customizable)
        public int Rank;       // global rank of player (automatic)
        public bool Online;     // online status (automatic)
        public List<string> Blocked;    // the player's blocked user list (custom csv)
        public List<string> Friends;    // the player's friend list (custom csv)
        public List<string> Enemies;    // the player's friend list (custom csv)
        public List<string> Allies;    // the player's friend list (custom csv)
        public List<string> Connects;    // the player's friend list (custom csv)

        public DateTime MemberSince;
        public DateTime LastLogin;
        public string BankAccountID;
        public string Avatar;

    }
}
