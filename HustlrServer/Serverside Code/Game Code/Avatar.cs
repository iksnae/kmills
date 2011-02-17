using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MyGame
{
    /***********************************************************************
     *       ____ __  __ ____  _____  ____  _____ 
     *      / () \\ \/ // () \|_   _|/ () \ | () )
     *     /__/\__\\__//__/\__\ |_| /__/\__\|_|\_\
     *     
     ***********************************************************************   
     * This is the base data object of all Bots, Spots and the like. It 
     * contains the basic information that is shared and visualised
     * in the game world.
     * ---------------------------------------------------------------------
     * PROPERTIES
     * 
     * ---------------------------------------------------------------------
     * METHODS
     * 
     ***********************************************************************/
    class Avatar
    {
        // avatar types
        public const int PLAYER = 0;
        public const int BOT = 1;
        public const int SPOT = 2;

        // avatar base data
        public string ID = "";
        public string Handle = "";
        public string Owner = "nobody";
        public int Type;
        public string Status="";
        public Location Location=new Location(0.0,0.0);
        
        public string baseMessage()
        {
            string str="";
            str += "<ID>"+ID+"</ID>";
            str += "<Handle>" + Handle + "</Handle>";
            str += "<Owner>" + Owner + "</Owner>";
            str += "<Type>" + Type + "</Type>";
            
            return str;
        }
        
    }



    /**
     *  
     **/
    class Spot : Avatar
    {
        public int Income;    // the spot's income
        public int Cash;      // the spot's cash on-hand (vunerable to attack)
        public int Upkeep;    // the spot's cost of operation
        public int Defense;   // the spot's defense level

        public ProductInventory Products;   // the spot's product inventory (vulnerable to attack)
        public List<Worker> Workers = new List<Worker>();

       
    }






    class Worker:Avatar
    {

        public const int PITCHER = 0;
        public const int ENFORCER = 1;
        public const int RUNNER = 2;
        public const int LOOKOUT = 3;
        public const int UNKNOWN = 86;

        public int WorkerType = UNKNOWN;
        public DateTime Hired;  // the date the worker was hired
        public int Income = 0;    // the worker's income
        public int Defense = 0;   // the worker's defense level
        public int Offense=0;   // the worker's defense level
        public Array Vehicles;  // the worker's transportation options
        public double Loyalty=1.0;   // the worker's loyalty level ( used as probability factor, when performing assignments)
        public double Luck=0.5;      // the worker's luck level ( used as probability factor. increased thru skills)
        public string Activity="ready for work"; // the worker's current activity   
        public int Experience=0; // the points the work accumulates with each activity
        public int Level=0; // the workers level, earned through Experience points. unlocks upgrades and inproves all skills.

        public bool Alive=true;
        public int DeathCount=0;
        public int KillCount=0;
        public double DamageDelivered=0;
        public double DamageReceived=0;

        public ProductInventory Products; // worker products
        public WeaponInventory Weapons;   // the worker's weapons
        public WorkerUpgradeInventory Upgrades; // the worker's upgrades

        public double Health = 20;
        public double MaxHealth = 20;

        public Worker() { }
        public Worker(int worker_type)
        {
            Type = 2;
            WorkerType = worker_type;
            switch (WorkerType)
            {
                case PITCHER:
                    initPitcher();
                    break;
                case ENFORCER:
                    initEnforcer();
                    break;
                case RUNNER:
                    break;
                case LOOKOUT:
                    break;
                case UNKNOWN:
                    break;

            }
        }

        private void initPitcher()
        {
            this.Activity = "waiting for work";
            this.Defense = 0;
            this.Handle = "Unamed Pitcher";
            this.Health = 10;
            this.Hired = DateTime.Now.ToUniversalTime();
            this.ID = "pitcher";
            this.MaxHealth = 10;
            this.Offense = 0;
            this.Status = "waiting for work";
            this.WorkerType = PITCHER;
            this.Location = new Location();
            this.Weapons = new WeaponInventory(this.ID);
            this.Upgrades = new WorkerUpgradeInventory(this.ID);
            Weapons.PrimaryWeapon = Weapons.AddWeapon(new WeaponFactory().BasicFists());
            Weapons.PrimaryWeapon = Weapons.AddWeapon(new WeaponFactory().BasicFists());
            this.Products = new ProductInventory(this.ID);
        }
        private void initEnforcer()
        {
            this.Activity = "waiting for orders";
            this.Defense = 10;
            this.Handle = "Unamed Enforcer";
            this.Health = 35;
            this.Hired = DateTime.Now.ToUniversalTime();
            this.ID = "enforcer";
            this.MaxHealth = 35;
            this.Offense = 10;
            this.Status = "waiting for orders";
            this.Location = new Location();
            this.WorkerType = ENFORCER;
            Weapon bat = new WeaponFactory().WoodenLouisvillSluggah();
            Weapons.Holder = ID;
            Weapons.PrimaryWeapon = Weapons.AddWeapon(bat);
            Weapons.SecondaryWeapon = Weapons.AddWeapon(new WeaponFactory().GoldenGloves());

            Weapons.AddWeapon(new WeaponFactory().BasicFists());


        }

        public double GetDamage()
        {
            return Weapons.PrimaryWeapon.Fire();
        }

        
        public void Attacked(Worker attacker, double damage)
        {
            DamageReceived += damage;
            Health -= damage;
            CheckVitals();
        }

        private void CheckVitals()
        {
            if (Health > (MaxHealth * .7))
            {
                CallForHelp();
            }
        }
        private void CallForHelp()
        {

        }
        private void Flea()
        {

        }
        private void Attack(Worker target)
        {
            target.Attacked(this, GetDamage());
        }
        private void Attack(Spot spot)
        {

        }
        private void Attack(List<Worker> workers)
        {

        }
        
        
        public string MessageString()
        {

            string msg = "<Worker>";
            msg += baseMessage();
            msg += "<WorkerType>" + WorkerType + "</WorkerType>";
            msg += "<Hired>" + Hired + "</Hired>";
            msg += "<Income>" + Income + "</Income>";
            msg += "<Defense>" + Defense + "</Defense>";
            msg += "<Offense>" + Offense + "</Offense>";
            msg += "<Loyalty>" + Loyalty + "</Loyalty>";
            msg += "<Luck>" + Luck + "</Luck>";
            msg += "<Activity>" + Activity + "</Activity>";
            msg += "<Experience>" + Experience + "</Experience>";
            msg += "<Level>" + Level + "</Level>";
            msg += "<Alive>" + Alive + "</Alive>";
            msg += "<DeathCount>" + DeathCount + "</DeathCount>";
            msg += "<KillCount>" + KillCount + "</KillCount>";
            msg += "<DamageDelivered>" + DamageDelivered + "</DamageDelivered>";
            msg += "<DamageReceived>" + DamageReceived + "</DamageReceived>";
            msg += "<Status>" + Status + "</Status>";
            msg += "<Health>" + Health + "</Health>";
            msg += "<MaxHealth>" + MaxHealth + "</MaxHealth>";
            msg += Location.MessageString();
            msg += Upgrades.MessageString();
            msg += Products.MessageString();
            msg += Weapons.MessageString();
            msg += "</Worker>";

            return msg;
        }
    }
    
}
