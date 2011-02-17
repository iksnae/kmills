using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MyGame
{
    class RobotFactory
    {


        public const int PitcherInitialHealthMax = 20;
        public const int PitcherInitialIncome = 50;
        public const string PitcherInitialActivity = "idle.";
        public const string PitcherInitialHandle = "New Pitcher";

        public const int EnforcerInitialHealthMax = 40;
        public const int EnforcerInitialIncome = 100;
        public const string EnforcerInitialActivity = "idle.";
        public const string EnforcerInitialHandle = "New Enforcer";



        public Worker NewWorker(int worker_type)
        {
            switch (worker_type)
            {
                case Worker.PITCHER:
                    return CreateNewPitcher();
                    break;
                case Worker.ENFORCER:
                    return CreateNewEnforcer();
                    break;
                default:
                    return new Worker();
                    break;
            }
        }



        public Worker CreateNewPitcher()
        {
            Worker worker = new Worker();
            worker.Type = Avatar.BOT;
            worker.WorkerType = Worker.PITCHER;
            worker.Health = worker.MaxHealth = PitcherInitialHealthMax;
            worker.ID = GenerateID("pitcher");
            worker.Handle = PitcherInitialHandle;
            worker.Income = PitcherInitialIncome;
            worker.Status = worker.Activity = PitcherInitialActivity;
            worker.Alive = true;
            worker.DamageDelivered = 0;
            worker.DamageReceived = 0;
            worker.DeathCount = 0;
            worker.Defense = 0;
            worker.Experience = 0;
            worker.Location = new Location();
            worker.Loyalty = 1.0;
            worker.Luck = 0.5;
            worker.Offense = 0;
            worker.Products = new ProductInventory(worker.ID);
            worker.Weapons = new WeaponInventory(worker.ID);
            worker.Upgrades = new WorkerUpgradeInventory(worker.ID);
            worker.Weapons.PrimaryWeapon = worker.Weapons.AddWeapon(new WeaponFactory().BasicFists());
            worker.Weapons.SecondaryWeapon = worker.Weapons.GetWeaponByID(WeaponFactory.BASIC_FISTS);


            return worker;
        }

        public Worker BlankPitcher()
        {
            Worker worker = new Worker();
            worker.Type = Avatar.BOT;
            worker.WorkerType = Worker.PITCHER;
            return worker;
        }

        public Worker CreateNewEnforcer()
        {
            Worker worker = new Worker();
            worker.Type = Avatar.BOT;
            worker.WorkerType = Worker.ENFORCER;
            worker.Health = worker.MaxHealth = PitcherInitialHealthMax;
            worker.ID = GenerateID("enforcer");
            worker.Handle = PitcherInitialHandle;
            worker.Income = PitcherInitialIncome;
            worker.Status = worker.Activity = PitcherInitialActivity;
            worker.Alive = true;
            worker.DamageDelivered = 0;
            worker.DamageReceived = 0;
            worker.DeathCount = 0;
            worker.Defense = 1;
            worker.Experience = 0;
            worker.Location = new Location();
            worker.Loyalty = 1.0;
            worker.Luck = 0.5;
            worker.Offense = 1;
            worker.Products = new ProductInventory(worker.ID);
            worker.Weapons = new WeaponInventory(worker.ID);
            worker.Upgrades = new WorkerUpgradeInventory(worker.ID);
            worker.Weapons.PrimaryWeapon = worker.Weapons.AddWeapon(new WeaponFactory().WoodenLouisvillSluggah());
            worker.Weapons.SecondaryWeapon = worker.Weapons.AddWeapon(new WeaponFactory().GoldenGloves());
            return worker;
        }
        public Worker BlankEnforcer()
        {
            Worker worker = new Worker();
            worker.Type = Avatar.BOT;
            worker.WorkerType = Worker.ENFORCER;
            return worker;
        }
        public string GenerateID(string baseStr)
        {
            return baseStr + "_random_string";
        }
    }
}
