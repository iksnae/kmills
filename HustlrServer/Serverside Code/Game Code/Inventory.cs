using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
/***
 * Inventory objects are used to store specific types of items(Products,Weapons,Upgrades) and are connected to each Avatar(it's Holder).
 * */
namespace MyGame
{
    /***********************************************************************
     *     _  __  _ __  __ ____  __  _  _____  ____ _____ __  __
     *    | ||  \| |\ \/ /| ===||  \| ||_   _|/ () \| () )\ \/ /
     *    |_||_|\__| \__/ |____||_|\__|  |_|  \____/|_|\_\ |__| 
     *    
     ***********************************************************************
     * The base class provides some basic fields that are shared across all.
     * ---------------------------------------------------------------------
     * PROPERTIES
     * InventoryType: the type of Inventory (ProductInventory,WeaponInventory,WeaponUpgradeInventory)
     * ID: the identifying property used by their InventoryItems.
     * Owner: the Player that has access to the the Inventory. This value never changes.
     * Holder: the Avatar the Inventory is attatched to. This value never changes.
     * ---------------------------------------------------------------------
     * METHODS
     * There are no methods or constructors, because this class is for holding 
     * information common across all classes that extends it.
     * *********************************************************************/
    class Inventory
    {
        // the inventory types
        public const int PRODUCT=0;
        public const int WEAPON=1;
        public const int WEAPON_UPGRADE=2;
        public const int WORKER_UPGRADE = 3;
        // common inventory properties
        public int InventoryType=-1;
        public string ID ="";
        public string Owner="nobody";
        public string Holder="nobody";

        public string baseMessage()
        {
            string xml = "<ID>" + ID + "</ID>";
            xml += "<InventoryType>" + InventoryType + "</InventoryType>";
            xml += "<Holder>" + Holder + "</Holder>";
            xml += "<Owner>" + Owner + "</Owner>";
            return xml; 
        }
    }


    /**************************************************************************************
     *    _____ _____  ____  ____  __ __  ____  _____  ____ 
     *    | ()_)| () )/ () \| _) \|  |  |/ (__`|_   _|(_ (_`
     *    |_|   |_|\_\\____/|____/ \___/ \____)  |_| .__)__)
     *     _  __  _ __  __ ____  __  _  _____  ____ _____ __  __
     *    | ||  \| |\ \/ /| ===||  \| ||_   _|/ () \| () )\ \/ /
     *    |_||_|\__| \__/ |____||_|\__|  |_|  \____/|_|\_\ |__| 
     *    
     ***************************************************************************************
     * The ProductInventory is used for storing and handling Product objects. It contains 
     * fields and functions specific to products.
     * -------------------------------------------------------------------------------------
     * Products: list of products currently carried by Holder
     * MessageString: generates string for sending properties in a message
     * GetProductByType: returns list of products of specified type
     ***************************************************************************************/
    class ProductInventory:Inventory
    {
        public ProductInventory()
        {
            InventoryType = Inventory.PRODUCT;
        }
        public ProductInventory(string holder)
        {
            Holder = holder;
            InventoryType = Inventory.PRODUCT;
        }
        // products
        public List<Product> Products = new List<Product>();

        //
        public string MessageString()
        {
            string msg = "<ProductInventory>";
            msg += baseMessage();
            msg += "<Products>";
            for (int i = 0; i < Products.Count; i++)
            {
                Product item = Products[i];
                msg += item.MessageString();
            }
            msg += "</Products></ProductInventory>";
            return msg;
        }
        public List<Product> GetProductByType(int type)
        {
            List<Product> prods = new List<Product>();
            foreach (Product p in Products)
            {
                if (p.ProductType == type) prods.Add(p);
            }
            return prods;
        }
    }




    /***********************************************************************
     *    __    __ ____   ____  _____  ____  __  _  
     *    \ \/\/ /| ===| / () \ | ()_)/ () \|  \| |
     *     \_/\_/ |____|/__/\__\|_|   \____/|_|\__|
     *     _  __  _ __  __ ____  __  _  _____  ____ _____ __  __
     *    | ||  \| |\ \/ /| ===||  \| ||_   _|/ () \| () )\ \/ /
     *    |_||_|\__| \__/ |____||_|\__|  |_|  \____/|_|\_\ |__| 
     *    
     ***********************************************************************
     * The WeaponsInventory is used for storing and handling Weapon objects. 
     * It contains fields and methods specific to weapons.
     * --------------------------------------------------------------------
     * PROPERTIES:
     * PrimaryWeapon: the first weapon used by Holder
     * SecondaryWeapon: the second weapon used by Holder
     * Weapons: all weapons available to Holder
     * Upgrades: all weapong upgrades available to Holder
     * --------------------------------------------------------------------
     * METHODS:
     * MessageString: generates string for sending properties in a message
     * GetWeaponByID: returns Weapon object by it ID property
     ***********************************************************************/
    class WeaponInventory : Inventory
    {
        public Weapon PrimaryWeapon = new Weapon();
        public Weapon SecondaryWeapon = new Weapon();
        
        
        // all weapons
        public List<Weapon> Weapons = new List<Weapon>();

        // all upgrades
        public List<WeaponUpgrade> WeaponUpgrades= new List<WeaponUpgrade>();

        // all ammo
        public List<Ammo> Ammo = new List<Ammo>();

        // all ammo upgrades
        public List<AmmoUpgrade> AmmoUpgrades = new List<AmmoUpgrade>();


        // construction: basic empty
        public WeaponInventory()
        {
            InventoryType = Inventory.WEAPON;
            Ammo.Add(new Ammo());
        }

        // construction: holder
        public WeaponInventory(string holder)
        {
            Holder = holder;
            InventoryType = Inventory.WEAPON;
            Ammo.Add(new Ammo());
        }

        public WeaponInventory(string holder,string owner)
        {
            Holder = holder;
            Owner = owner;
            InventoryType = Inventory.WEAPON;
            Ammo.Add(new Ammo());
        }

        public Weapon AddWeapon(Weapon w)
        {
            Weapons.Add(w);
            return w;
        }
        public Weapon GetWeaponById(string id)
        {
            foreach (Weapon w in Weapons)
            {
                if (w.ID == id) return w;
            }
            return null;
        }
        // message string
        public string MessageString()
        {
            string str = "<WeaponInventory>";
            str += baseMessage();
            str += "<PrimaryWeapon>" + PrimaryWeapon.MessageString() + "</PrimaryWeapon>";
            str += "<SecondaryWeapon>" + SecondaryWeapon.MessageString() + "</SecondaryWeapon>";

            str += "<Weapons>";
            for (int i = 0; i < Weapons.Count; i++)
            {
                Weapon item = Weapons[i];
                str += item.MessageString();
            }
            str += "</Weapons>";

            str += "</WeaponInventory>";
            Console.WriteLine("weapon inventory items string: " + str);
            return str;
        }

        public Weapon GetWeaponByID(string id)
        {
            foreach(Weapon w in Weapons)
            {
                if (w.ID == id) return w;  
            }
            return null;
        }
        public List<Weapon> GetWeaponsByType(int type)
        {
            List<Weapon> weps = new List<Weapon>();
            foreach (Weapon w in Weapons)
            {
                if (w.WeaponType == type) weps.Add(w);
            }
            return weps;
        }
        
    }
    /**
     * 
     * Worker Upgrade inventory
     * ***/

    class WorkerUpgradeInventory : Inventory
    {
       public List<WorkerUpgrade> Upgrades = new List<WorkerUpgrade>();
       
        public WorkerUpgradeInventory()
       {
           InventoryType = Inventory.WORKER_UPGRADE;
       }
       public WorkerUpgradeInventory(string holder)
       {
           Holder = holder;
           InventoryType = Inventory.WORKER_UPGRADE;
       }
       public string MessageString()
       {
           string msg = "<WorkerUpgradeInventory>";
           msg += baseMessage();
           msg += "<Upgrades>";
           for (int i = 0; i < Upgrades.Count; i++)
           {
               WorkerUpgrade item = Upgrades[i];
               msg += item.MessageString();
           }
           msg += "</Upgrades></WorkerUpgradeInventory>";
           return msg;
       }
    }
    /**
     * 
     * 
     * **/
    class BankAccount : Inventory
    {
        public string AccountID;
        public int Balance;
        public List<Transaction> RecentTransactions=new List<Transaction>();
    }
}