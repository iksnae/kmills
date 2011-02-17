using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace MyGame {
	
	[RoomType("MyGame")]
	public class GameCode : Game<Player> {


        private List<Worker> AllWorkers = new List<Worker>();
        private List<Player> AllPlayers = new List<Player>();
        private List<Spot> AllSpots = new List<Spot>();
        private RobotFactory robotFactory = new RobotFactory();
        private WeaponFactory weaponFactory = new WeaponFactory();
		// This method is called when an instance of your the game is created
		public override void GameStarted() {
			Console.WriteLine("Game is started: " + RoomId);
     //       CreateNewWorker(Worker.ENFORCER);
     //       CreateNewWorker(Worker.PITCHER);
            AddTimer(delegate
            {
                Console.WriteLine("tick!");
            }, 1000);

		}

		// This method is called when the last player leaves the room, and it's closed down.
		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);
		}

		// This method is called whenever a player joins the game
		public override void UserJoined(Player player) {
			// this is how you send a player a message
			player.Send("hello");

			// this is how you broadcast a message to all players connected to the game
			Broadcast("UserJoined", player.Id);
		}

		// This method is called when a player leaves the game
		public override void UserLeft(Player player) {
			Broadcast("UserLeft", player.Id);
		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message) {
            Console.WriteLine("GotMessage:" + message.Type);
			switch(message.Type) {
				// This is how you would set a players name when they send in their name in a 
				// "MyNameIs" message
				case "MyNameIs":
					player.Name = message.GetString(0);
					break;
                case "create_worker":
                   // CreateNewWorker();
                    break;
                case "get_worker":
                    GetWorker(message.GetString(0), player);
                    break;
                case "hire_worker":
                    HireWorker(player,message.GetInt(0));
                    break;
                case "get_my_workers":
                    GetPlayerWorkers(player);
                    break;
			}
		}


        private void GetPlayerWorkers(Player player)
        {
            PlayerIO.BigDB.LoadRange("workers", "ByOwner", null, player.ConnectUserId, player.ConnectUserId, 10000, delegate(DatabaseObject[] results)
            {
                if (results != null)
                {
                    string msg = "<Workers>";
                    for (int i = 0; i < results.Length; i++)
                    {
                        DatabaseObject o = results[i];
                        Worker w = DatabaseObjectToWorker(o);
                        msg += w.MessageString();
                    }
                    msg += "</Workers>";
                    player.Send("my_workers", msg);
                }
            });
        }

        private void HireWorker(Player player, int type)
        {
            Console.WriteLine("hire worker:" + type);
            
            Worker worker = robotFactory.NewWorker(type);
            worker.Owner = player.ConnectUserId;
            worker.Weapons.Owner = player.ConnectUserId;
            worker.Products.Owner = player.ConnectUserId;
            worker.Upgrades.Owner = player.ConnectUserId;
            
            DatabaseObject obj = WorkerToDatabaseObject(worker);

            PlayerIO.BigDB.CreateObject("workers", null, obj, delegate(DatabaseObject result)
            {
                if (result!=null)
                {
                    Console.WriteLine("worker hired:" + worker.ID);
                    worker.ID = result.Key;
                    player.Send("worker_hired", worker.MessageString());
                    result.Set("ID",result.Key);
                    result.Save();
                }
            });
        }

        ////

        private void CreateNewWorker(int type)
        {
            Console.WriteLine("new worker:" + type);
            Worker worker = robotFactory.NewWorker(type);
            DatabaseObject obj = WorkerToDatabaseObject(worker);
            PlayerIO.BigDB.CreateObject("workers",null,obj,delegate(DatabaseObject result)
            {
                Console.WriteLine("worker created:"+worker.ID);
            });

        }





        public void GetWorker(string key, Player p)
        {
            Console.WriteLine("getting worker:"+key);
            PlayerIO.BigDB.Load("workers", key, delegate(DatabaseObject result)
            {
                if (result != null)
                {
                    Console.WriteLine("worker found.");
                    Worker worker = DatabaseObjectToWorker(result);
                    p.Send("worker_data", worker.MessageString());
                }
                else
                {
                    Console.WriteLine("worker not found.");
                }
            });
        }

        ////////////////////////////////////////////////
        //  DATA OBJECT CONVERSION METHODS
        ////////////////////////////////////////////////
        //  PlayerToDatabaseObject()
        //  DatabaseObjectToPlayer()
        //  WorkerToDatabaseObject()
        //  DatabaseObjectToWorker()
        //  DatabaseObjectToWorkerUpgradeInventory()
        //  WorkerUpgradeInventoryToDatabaseObject()
        //  DatabaseObjectToWorkerUpgrade()
        //  WorkerUpgradeToDatabaseObject()
        //  LocationToDatabaseObject()
        //  DatabaseObjectToLocation()
        //  DatabaseObjectToProduct()
        //  ProductToDatabaseObject()
        //  ProductInventoryToDatabaseObject()
        //  DatabaseObjectToProductInventory()
        //  WeaponInventoryToDatabaseObject()
        //  DatabaseObjectToWeaponInventory()
        //  DatabaseObjectToWeapon()
        //  WeaponToDatabaseObject()
        //  DatabaseObjectToWeaponUpgrade()
        //  WeaponUpgradeToDatabaseObject()
        //  DatabaseObjectToAmmo()
        //  AmmoToDatabaseObject()
        //  DatabaseObjectToAmmoUpgrade()
        //  AmmoUpgradeToDatabaseObject()
        //  DatabaseObjectToBankAccount()
        //  DatabaseObjectToTransaction()
        //
        ////////////////////////////////////////////////
        
        private DatabaseObject PlayerToDatabaseObject(Player player)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("Avatar", player.Avatar);
            obj.Set("BankAcountID", player.BankAccountID);
            obj.Set("LastLogin", player.LastLogin);
            obj.Set("MemberSince", player.MemberSince);
            obj.Set("Name", player.Name);
            obj.Set("Online", player.Online);
            obj.Set("Rank", player.Rank);
            obj.Set("Status", player.Status);
            obj.Set("UserName", player.UserName);

            DatabaseArray friends = new DatabaseArray();
            DatabaseArray enemies = new DatabaseArray();
            DatabaseArray allies = new DatabaseArray();
            DatabaseArray blocked = new DatabaseArray();
            DatabaseArray connects = new DatabaseArray();

            for(int i=0;i<player.Allies.Count;i++)
            {
                allies.Add(player.Allies[i]);
            }
            for(int i=0;i<player.Blocked.Count;i++)
            {
                blocked.Add(player.Allies[i]);
            }
            for(int i=0;i<player.Enemies.Count;i++)
            {
                enemies.Add(player.Friends[i]);
            }
            for(int i=0;i<player.Connects.Count;i++)
            {
                player.Connects.Add(player.Allies[i]);
            }
            
            obj.Set("Allies", allies);
            obj.Set("Blocked", blocked);
            obj.Set("Friends", friends);
            obj.Set("Enemies", enemies);
            obj.Set("Connects", connects);



            return obj;
        }

        private Player DatabaseObjectToPlayer(DatabaseObject obj)
        {
            Player player = new Player();
            player.BankAccountID = obj.GetString("BankAccount");
            player.LastLogin = obj.GetDateTime("Lastlogin");
            player.MemberSince = obj.GetDateTime("Lastlogin");
            player.Name = obj.GetString("Lastlogin");
            player.Online = obj.GetBool("Lastlogin");
            player.Rank = obj.GetInt("Lastlogin");
            player.Status = obj.GetString("Lastlogin");
            player.UserName = obj.GetString("Lastlogin");
            player.Avatar = obj.GetString("Avatar");

            player.Allies = new List<string>();
            player.Blocked = new List<string>();
            player.Friends = new List<string>();
            player.Connects = new List<string>();

            DatabaseArray allies = obj.GetArray("Allies");
            DatabaseArray enemies = obj.GetArray("Enemies");
            DatabaseArray friends = obj.GetArray("Friends");
            DatabaseArray connects = obj.GetArray("Connects");

            for (int i = 0; i < allies.Count;i++ )
            {
                player.Allies.Add(allies.GetString(i));
            }
            for (int i = 0; i < connects.Count; i++)
            {
                player.Connects.Add(connects.GetString(i));
            }
            for (int i = 0; i < enemies.Count; i++)
            {
                player.Enemies.Add(connects.GetString(i));
            }
            for (int i = 0; i < friends.Count; i++)
            {
                player.Friends.Add(connects.GetString(i));
            }


            

            return player;
        }

        private DatabaseObject WorkerToDatabaseObject(Worker worker)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("ID", worker.ID);
            obj.Set("WorkerType", worker.WorkerType);
            obj.Set("Owner", worker.Owner);
            obj.Set("Status", worker.Status);
            obj.Set("Activity", worker.Activity);
            obj.Set("Alive", worker.Alive);
            obj.Set("DamageDelivered", worker.DamageDelivered);
            obj.Set("DamageReceived", worker.DamageReceived);
            obj.Set("DeathCount", worker.DeathCount);
            obj.Set("Defense", worker.Defense);
            obj.Set("Experience", worker.Experience);
            obj.Set("Handle", worker.Handle);
            obj.Set("Health", worker.Health);
            obj.Set("Hired", worker.Hired);
            obj.Set("Income", worker.Income);
            obj.Set("KillCount", worker.KillCount);
            obj.Set("Level", worker.Level);
            obj.Set("Loyalty", worker.Loyalty);
            obj.Set("Luck", worker.Luck);
            obj.Set("Offense", worker.Offense);
            obj.Set("Type", worker.Type);
            obj.Set("Weapons", WeaponInventoryToDatabaseObject(worker.Weapons));
            obj.Set("Products", ProductInventoryToDatabaseObject(worker.Products));
            obj.Set("Location",LocationToDatabaseObject(worker.Location));
            obj.Set("Upgrades", WorkerUpgradeInventoryToDatabaseObject(worker.Upgrades));
            return obj;
        }

        private Worker DatabaseObjectToWorker(DatabaseObject obj)
        {
            Worker worker = new Worker(Worker.UNKNOWN);
            worker.Activity = obj.GetString("Activity");
            worker.Alive = obj.GetBool("Alive");
            worker.DamageDelivered = obj.GetDouble("DamageDelivered");
            worker.DamageReceived = obj.GetDouble("DamageReceived");
            worker.DeathCount = obj.GetInt("DeathCount");
            worker.Defense = obj.GetInt("Defense");
            worker.Experience = obj.GetInt("Experience");
            worker.Handle = obj.GetString("Handle");
            worker.Health = obj.GetDouble("Health");
            worker.Hired = obj.GetDateTime("Hired");
            worker.ID = obj.GetString("ID");
            worker.Income = obj.GetInt("Income");
            worker.KillCount = obj.GetInt("KillCount");
            worker.Level = obj.GetInt("Level");
            worker.Location = DatabaseObjectToLocation(obj.GetObject("Location"));
            worker.Loyalty = obj.GetDouble("Loyalty");
            worker.Luck = obj.GetDouble("Luck");
            worker.Offense = obj.GetInt("Offense");
            worker.Owner = obj.GetString("Owner");
            worker.Products = DatabaseObjectToProductInventory(obj.GetObject("Products"));
            worker.Status = obj.GetString("Status");
            worker.Type = obj.GetInt("Type");
            worker.Upgrades = DatabaseObjectToWorkerUpgradeInventory(obj.GetObject("Upgrades"));
//            worker.Vehicles = obj.GetString("");
            worker.Weapons = DatabaseObjectToWeaponInventory(obj.GetObject("Weapons"));
            worker.WorkerType = obj.GetInt("WorkerType");


            return worker;
        }
        private WorkerUpgradeInventory DatabaseObjectToWorkerUpgradeInventory(DatabaseObject obj)
        {
            WorkerUpgradeInventory inventory = new WorkerUpgradeInventory();
            inventory.Holder = obj.GetString("Holder");
            inventory.ID = obj.GetString("ID");
            inventory.InventoryType = obj.GetInt("InventoryType");
            inventory.Owner = obj.GetString("Owner");
            List<WorkerUpgrade> upgrades = new List<WorkerUpgrade>();

            foreach(DatabaseObject wuObj in obj.GetArray("Upgrades"))
            {
                upgrades.Add( DatabaseObjectToWorkerUpgrade(wuObj));
            }
            inventory.Upgrades = upgrades;
            return inventory;
        }
        private DatabaseObject WorkerUpgradeInventoryToDatabaseObject(WorkerUpgradeInventory inventory)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("Holder", inventory.Holder);
            obj.Set("ID", inventory.ID);
            obj.Set("InventoryType", inventory.InventoryType);
            obj.Set("Owner", inventory.Owner);
            DatabaseArray arr = new DatabaseArray();
            foreach (WorkerUpgrade u in inventory.Upgrades)
            {
                arr.Add(WorkerUpgradeToDatabaseObject(u));
            }

            obj.Set("Upgrades", arr);

            return obj;
        }
        private WorkerUpgrade DatabaseObjectToWorkerUpgrade(DatabaseObject obj)
        {
            WorkerUpgrade upgrade = new WorkerUpgrade();
            upgrade.AttachedTo = obj.GetString("AttachedTo");
            upgrade.Description = obj.GetString("Description");
            upgrade.EffectedTarget = obj.GetString("EffectedTarget");
            upgrade.EffectValue = obj.GetString("EffectValue");
            upgrade.ID = obj.GetString("ID");
            upgrade.Image = obj.GetString("Image");
            upgrade.IsAttatched = obj.GetBool("IsAttatched");
            upgrade.Label = obj.GetString("Label");
            upgrade.Type = obj.GetInt("Type");
            upgrade.Condition = obj.GetDouble("Condition");
            upgrade.Quality = obj.GetDouble("Quality");
            upgrade.IsTemporary = obj.GetBool("IsTemporary");
            return upgrade;
        }
        private DatabaseObject WorkerUpgradeToDatabaseObject(WorkerUpgrade upgrade)
        {
            DatabaseObject obj=new DatabaseObject();
            obj.Set("AttachedTo", upgrade.AttachedTo);
            obj.Set("Condition", upgrade.Condition);
            obj.Set("Description", upgrade.Description);
            obj.Set("Duration", upgrade.Duration);
            obj.Set("EffectedTarget", upgrade.EffectedTarget);
            obj.Set("EffectValue", upgrade.EffectValue);
            obj.Set("ID", upgrade.ID);
            obj.Set("Image", upgrade.Image);
            obj.Set("IsAttatched", upgrade.IsAttatched);
            obj.Set("IsTemporary", upgrade.IsTemporary);
            obj.Set("Label", upgrade.Label);
            obj.Set("Quality", upgrade.Quality);
            obj.Set("Type", upgrade.Type);
            
            
            return obj;
        }
        private DatabaseObject LocationToDatabaseObject(Location loc)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("Description", loc.Description);
            obj.Set("Latitude", loc.Latitude);
            obj.Set("Longitude", loc.Longitude);
            
            return obj;
        }
        private Location DatabaseObjectToLocation(DatabaseObject obj)
        {
            Location loc = new Location();
            loc.Description = obj.GetString("Description");
            loc.Latitude = obj.GetDouble("Latitude");
            loc.Longitude = obj.GetDouble("Longitude");
            return loc;
        }
        private Product DatabaseObjectToProduct(DatabaseObject obj)
        {
            Product product = new Product();
            product.Description = obj.GetString("Description");
            product.Grade = obj.GetInt("Grade");
            product.ID = obj.GetString("ID");
            product.Image = obj.GetString("Image");
            product.Label = obj.GetString("Label");
            product.ProductType = obj.GetInt("Producttype");
            product.Quantity = obj.GetInt("Quality");
            product.Type = obj.GetInt("Type");
            
            return product;
        }
        private DatabaseObject ProductToDatabaseObject(Product product)
        {
            DatabaseObject obj=new DatabaseObject();
            obj.Set("Description", product.Description);
            obj.Set("Grade", product.Grade);
            obj.Set("ID", product.ID);
            obj.Set("Image", product.Image);
            obj.Set("Label", product.Label);
            obj.Set("ProductType", product.ProductType);
            obj.Set("Quality", product.Quantity);
            obj.Set("Type", product.Type);

            return obj;
        }
        private DatabaseObject ProductInventoryToDatabaseObject(ProductInventory inventory)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("Holder", inventory.Holder);
            obj.Set("ID", inventory.ID);
            obj.Set("InventoryType", inventory.InventoryType);
            obj.Set("Owner", inventory.Owner);
            DatabaseArray arr = new DatabaseArray();
            List<Product> products = new List<Product>();
            foreach (Product p in inventory.Products)
            {
                arr.Add(ProductToDatabaseObject(p));
            }
            obj.Set("Products", arr);

            return obj;
        }
        private ProductInventory DatabaseObjectToProductInventory(DatabaseObject obj)
        {
            ProductInventory inventory=new ProductInventory();
            inventory.Holder = obj.GetString("Holder");
            inventory.ID = obj.GetString("ID");
            inventory.InventoryType = obj.GetInt("InventoryType");
            inventory.Owner = obj.GetString("Owner");
            List<Product> products=new List<Product>();
            foreach (DatabaseObject prObj in obj.GetArray("Products"))
            {
                products.Add(DatabaseObjectToProduct(prObj));
            }
            inventory.Products = products;
            
            return inventory;
        }
        private DatabaseObject WeaponInventoryToDatabaseObject(WeaponInventory inventory)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("ID", inventory.ID);
            obj.Set("Holder", inventory.Holder);
            obj.Set("InventoryType", inventory.InventoryType);
            obj.Set("Owner", inventory.Owner);
            obj.Set("PrimaryWeapon",WeaponToDatabaseObject(inventory.PrimaryWeapon));
            obj.Set("SecondaryWeapon",WeaponToDatabaseObject(inventory.SecondaryWeapon));
            
            
            DatabaseArray weapons = new DatabaseArray();
            DatabaseArray upgrades = new DatabaseArray();
            DatabaseArray ammo = new DatabaseArray();



            foreach (Weapon w in inventory.Weapons)
            {
                weapons.Add(WeaponToDatabaseObject(w));
            }
            foreach(WeaponUpgrade u in inventory.WeaponUpgrades)
            {
                upgrades.Add(WeaponUpgradeToDatabaseObject(u));
            }

            foreach (Ammo a in inventory.Ammo)
            {
                ammo.Add(AmmoToDatabaseObject(a));
            }
            
            obj.Set("Weapons", weapons);
            obj.Set("Upgrades", upgrades);
            obj.Set("Ammo",ammo);
            return obj;
        }
        private WeaponInventory DatabaseObjectToWeaponInventory(DatabaseObject obj)
        {
            WeaponInventory inventory = new WeaponInventory();
            inventory.Holder = obj.GetString("Holder");
            inventory.ID = obj.GetString("ID");
            inventory.InventoryType = obj.GetInt("InventoryType");
            inventory.Owner = obj.GetString("Owner");
            inventory.PrimaryWeapon = DatabaseObjectToWeapon(obj.GetObject("PrimaryWeapon"));
            inventory.SecondaryWeapon = DatabaseObjectToWeapon(obj.GetObject("SecondaryWeapon"));
            
            List<Weapon> weapons = new List<Weapon>();
            DatabaseArray weaponsObjs = obj.GetArray("Weapons");

            List<WeaponUpgrade> weaponUpgrades = new List<WeaponUpgrade>();
            DatabaseArray weaponUpgradObjs = obj.GetArray("WeaponUpgrades");
            
            List<Ammo> ammo = new List<Ammo>();
            DatabaseArray ammoObjs = obj.GetArray("Ammo");
            
            List<AmmoUpgrade> ammoUpgrades = new List<AmmoUpgrade>();
            DatabaseArray ammoUpgradeObjs = obj.GetArray("AmmoUpgrades");

            if (weaponsObjs != null)
            {
                foreach (DatabaseObject wObj in weaponsObjs)
                {
                    weapons.Add(DatabaseObjectToWeapon(wObj));
                }
            }
            if (weaponUpgradObjs != null)
            {
                foreach (DatabaseObject wuObj in weaponUpgradObjs)
                {
                    weaponUpgrades.Add(DatabaseObjectToWeaponUpgrade(wuObj));
                }
            }
            if (ammoObjs != null)
            {
                foreach (DatabaseObject aObj in ammoObjs)
                {
                    ammo.Add(DatabaseObjectToAmmo(aObj));
                }
            }
            if (ammoUpgradeObjs != null)
            {
                foreach (DatabaseObject auObj in ammoUpgradeObjs)
                {
                    ammoUpgrades.Add(DatabaseObjectToAmmoUpgrade(auObj));
                }
            }
            inventory.Weapons = weapons;
            inventory.WeaponUpgrades = weaponUpgrades;
            inventory.Ammo = ammo;
            inventory.AmmoUpgrades = ammoUpgrades;
            return inventory;
        }
        private Weapon DatabaseObjectToWeapon(DatabaseObject obj)
        {
            Weapon weapon = new Weapon();
            weapon.Accuracy = obj.GetDouble("Accuracy");
            weapon.Attention = obj.GetInt("Attention");
            weapon.Capacity = obj.GetInt("Capacity");
            weapon.Condition = obj.GetDouble("Condition");
            weapon.Damage = obj.GetInt("Damage");
            weapon.Description = obj.GetString("Description");
            weapon.ID = obj.GetString("ID");
            weapon.Image = obj.GetString("Image");
            weapon.Label = obj.GetString("Label");
            weapon.Overheat = obj.GetDouble("Overheat");
            weapon.Rate = obj.GetInt("Rate");
            weapon.Type = obj.GetInt("Type");
            weapon.WeaponType = obj.GetInt("WeaponType");
            weapon.Ammo = DatabaseObjectToAmmo(obj.GetObject("Ammo"));
            
            
            
            List<WeaponUpgrade> upgrades = new List<WeaponUpgrade>();
            DatabaseArray upgradeObjs = obj.GetArray("Upgrades");
            if (upgradeObjs != null)
            {
                for (int i = 0; i < upgradeObjs.Count; i++)
                {
                    DatabaseObject wu = upgradeObjs.GetObject(i);
                    upgrades.Add(DatabaseObjectToWeaponUpgrade(wu));
                }
            }
            weapon.Upgrades =  upgrades;
            return weapon;
        }
        private DatabaseObject WeaponToDatabaseObject(Weapon weapon)
        {
            if (weapon == null) return null;
            DatabaseObject obj = new DatabaseObject();
            obj.Set("ID", weapon.ID);
            obj.Set("Accuracy", weapon.Accuracy);
            obj.Set("Attention", weapon.Attention);
            obj.Set("Capacity", weapon.Capacity);
            obj.Set("Condition", weapon.Condition);
            obj.Set("Damage", weapon.Damage);
            obj.Set("Description", weapon.Description);
            obj.Set("Image", weapon.Image);
            obj.Set("Label", weapon.Label);
            obj.Set("Overheat", weapon.Overheat);
            obj.Set("Rate", weapon.Rate);
            obj.Set("Type", weapon.Type);
            obj.Set("WeaponType", weapon.WeaponType);
            obj.Set("Ammo", AmmoToDatabaseObject(weapon.Ammo));
            return obj;
        }
        
        private WeaponUpgrade DatabaseObjectToWeaponUpgrade(DatabaseObject obj)
        {
            WeaponUpgrade upgrade = new WeaponUpgrade();
            upgrade.AttachedTo = obj.GetString("AttachedTo");
            upgrade.Description = obj.GetString("Description");
            upgrade.EffectedTarget = obj.GetString("EffectedTarget");
            upgrade.EffectValue = obj.GetString("EffectValue");
            upgrade.ID = obj.GetString("ID");
            upgrade.Image = obj.GetString("Image");
            upgrade.IsAttatched = obj.GetBool("IsAttatched");
            upgrade.Label = obj.GetString("Label");
            upgrade.Type = obj.GetInt("Type");
            return upgrade;
        }

        private DatabaseObject WeaponUpgradeToDatabaseObject(WeaponUpgrade upgrade)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("ID", upgrade.ID);
            obj.Set("AttachedTo", upgrade.AttachedTo);
            obj.Set("Description", upgrade.Description);
            obj.Set("EffectedTarget", upgrade.EffectedTarget);
            obj.Set("EffectValue", upgrade.EffectValue);
            obj.Set("Image", upgrade.Image);
            obj.Set("IsAttatched", upgrade.IsAttatched);
            obj.Set("Label", upgrade.Label);
            obj.Set("Type", upgrade.Type);
            
            return obj;
        }
        private Ammo DatabaseObjectToAmmo(DatabaseObject obj)
        {
            Ammo ammo = new Ammo();
            ammo.AmmoType = obj.GetInt("AmmoType");
            ammo.Description = obj.GetString("Description");
            ammo.ID = obj.GetString("ID");
            ammo.Image = obj.GetString("Image");
            ammo.Label = obj.GetString("Label");
            ammo.Quantity = obj.GetInt("Quantity");
            ammo.Type = obj.GetInt("Type");
            
            List<AmmoUpgrade> upgrades = new List<AmmoUpgrade>();
            DatabaseArray upgradeObjs = obj.GetArray("Upgrades");
            
            foreach (DatabaseObject upOb in upgradeObjs)
            {
                upgrades.Add(DatabaseObjectToAmmoUpgrade(upOb));
            }
            
            ammo.Upgrades = upgrades;
            

            return ammo;
        }
        private DatabaseObject AmmoToDatabaseObject(Ammo ammo)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("ID", ammo.ID);
            obj.Set("AmmoType", ammo.AmmoType);
            obj.Set("Description", ammo.Description);
            obj.Set("Image", ammo.Image);
            obj.Set("Label", ammo.Label);
            obj.Set("Quantity", ammo.Quantity);
            obj.Set("Type", ammo.Type);
            DatabaseArray upgrades = new DatabaseArray();
            foreach (AmmoUpgrade u in ammo.Upgrades)
            {
                upgrades.Add(AmmoUpgradeToDatabaseObject(u));
            }
            obj.Set("Upgrades", upgrades);
            return obj;
        }
        private AmmoUpgrade DatabaseObjectToAmmoUpgrade(DatabaseObject obj)
        {
            AmmoUpgrade upgrade = new AmmoUpgrade();
            upgrade.AttachedTo = obj.GetString("AttachedTo");
            upgrade.Description = obj.GetString("Description");
            upgrade.EffectedTarget = obj.GetString("EffectedTarget");
            upgrade.EffectValue = obj.GetString("EffectValue");
            upgrade.ID = obj.GetString("ID");
            upgrade.Image = obj.GetString("Image");
            upgrade.IsAttatched = obj.GetBool("IsAttatched");
            upgrade.Label = obj.GetString("Label");
            upgrade.Type = obj.GetInt("Type");
            return upgrade;
        }
        private DatabaseObject AmmoUpgradeToDatabaseObject(AmmoUpgrade upgrade)
        {
            DatabaseObject obj = new DatabaseObject();
            obj.Set("ID", upgrade.ID);
            obj.Set("AttachedTo", upgrade.AttachedTo);
            obj.Set("Condition", upgrade.Condition);
            obj.Set("Description", upgrade.Description);
            obj.Set("EffectedTarget", upgrade.EffectedTarget);
            obj.Set("EffectedValue", upgrade.EffectValue);
            obj.Set("Image", upgrade.Image);
            obj.Set("IsAttached", upgrade.IsAttatched);
            obj.Set("Label", upgrade.Label);
            obj.Set("Quantity", upgrade.Quantity);
            obj.Set("Type", upgrade.Type);
            return obj;
        }
	
        private BankAccount DatabaseObjectToBankAccount(DatabaseObject obj)
        {
            BankAccount bank = new BankAccount();
            bank.ID = obj.GetString("ID");

            bank.AccountID = obj.GetString("ID");
            bank.Balance = obj.GetInt("ID");
            bank.Holder = obj.GetString("ID");
            bank.InventoryType = obj.GetInt("ID");
            bank.Owner = obj.GetString("ID");
            DatabaseArray arr = obj.GetArray("");
            bank.RecentTransactions = new List<Transaction>();
            for (int i = 0; i < arr.Count; i++)
            {
                
                DatabaseObject td = arr.GetObject(i);
                Transaction tr = DatabaseObjectToTransaction(td); 
                bank.RecentTransactions.Add(tr);
            }
            return bank;
            
        }
        private Transaction DatabaseObjectToTransaction(DatabaseObject obj)
        {
            Transaction t = new Transaction();
            t.Amount = obj.GetInt("Amount");
            t.Time = obj.GetDateTime("Time");
            t.Memo = obj.GetString("Memo");
            t.Receiver = obj.GetString("Receiver");
            t.Sender = obj.GetString("Sender");
            return t;
        }
	}
}
