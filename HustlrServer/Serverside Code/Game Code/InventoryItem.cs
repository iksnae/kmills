using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace MyGame
{
    /*********************************************************************************
      _____                      _                    _____ _                  
     |_   _|                    | |                  |_   _| |                 
       | |  _ ____   _____ _ __ | |_  ___  _ __ _   _  | | | |_  ___ _ __ ___  
       | | | '_ \ \ / / _ \ '_ \| __|/ _ \| '__| | | | | | | __|/ _ \ '_ ` _ \ 
      _| |_| | | \ V /  __/ | | | |_| (_) | |  | |_| |_| |_| |_|  __/ | | | | |
     |_____|_| |_|\_/ \___|_| |_|\__|\___/|_|   \__, |_____|\__|\___|_| |_| |_|
                                                 __/ |                         
                                                |___/                          
     * 
     * This is the Value Object used by Inventory lists to describe inventory products.
     * 
     * 
     * */
    // base inventory item
    class InventoryItem
    {
        public string ID="";
        public int Type=-1;
        public string Label="";
        public string Description="";
        public string Image="";

        // basic constructor
        public InventoryItem(){}

        // constructor with type argument
        public InventoryItem(int type)
        {
            Type = type;
            Image = Label = Description = "";
            
        }

        // constructor with type and label arguments
        public InventoryItem(int type, string label)
        {
            Type = type;
            Label = label;
            Image = Description = "";
        }


        // constructor with type, label and description arguments
        public InventoryItem( int type, string label, string description )
        {
            Type = type;
            Label = label;
            Description = description;
            Image = "";
        }


        // constructor with type, label, description and image arguments
        public InventoryItem(int type, string label, string description,string image)
        {
            Type = type;
            Label = label;
            Description = description;
            Image = "";
        }


        // 
        public string baseMessage()
        {
            string xml = "<ID>"+ID+"</ID>";
            xml += "<Label>" + Label + "</Label>";
            xml += "<Description>" + Description + "</Description>";
            xml += "<Image>" + Image + "</Image>";
            return xml; 
        }
        
    }





    // product
    class Product:InventoryItem
    {
        // types
        public const int Cocaine = 0;
        public const int Crack = 1;
        public const int Weed = 2;
        public const int Heroin = 3;
        public const int Speed = 4;
        public const int Ectasy = 5;
        public const int Shrooms = 6;
        public const int Acid = 7;
        public const int Meth = 8;
        public const int Dust = 9;

        // grades
        public const int GradeA = 0;
        public const int GradeB = 1;
        public const int GradeC = 2;
        public const int GradeD = 3;
        public const int GradeE = 4;
        public const int GradeF = 5;

        // product properties
        public int ProductType;
        public int Grade;
        public int Quantity;

        public string MessageString()
        {
            string msg = "<Product type='"+ProductType+"''>";
            msg += baseMessage();
            msg += "<ProductType>" + ProductType + "</ProductType>";
            msg += "<Grade>" + Grade + "</Grade>";
            msg += "<Quantity>" + Quantity + "</Quantity>";
            msg += "</Product>";
            return msg;
        }
        
    }



    // weapon
    class Weapon : InventoryItem
    {
        public Ammo Ammo;
        // weapon types
        public const int MELEE = 0;
        public const int PISTOL = 1;
        public const int RIFLE = 2;
        public const int SMG = 3;
        public const int ASSAULT_RIFLE = 4;
        public const int SHOTGUN = 5;
        public const int EXPLOSIVE = 6;
        public const int THROWN = 7;


        // weapon properties
        public int WeaponType;
        public int Capacity;
        public int Damage;
        public int Rate;

        // modifiers
        public double Condition;
        public double Accuracy;
        public int Attention;
        public double Overheat;
        
        // upgrades
        public List<WeaponUpgrade> Upgrades = new List<WeaponUpgrade>();
        public List<AmmoUpgrade> AmmoUpgrades = new List<AmmoUpgrade>();
        public Weapon()
        {
            
        }
        
        
        public string MessageString()
        {
            string msg = "<Weapon>";
            msg += baseMessage();
            msg += "<Condition>" + Condition + "</Condition>";
            msg += "<Accuracy>" + Accuracy + "</Accuracy>";
            msg += "<Attention>" + Attention + "</Attention>";
            msg += "<Upgrades>";
            for(int i=0; i<Upgrades.Count;i++)
            {
                msg += Upgrades[i].MessageString();
            }
            msg += "</Upgrades>";
            msg += "</Weapon>";
            return msg;
        }

        public double Fire()
        {
            if (Ammo.Quantity <= 0)
            {
                return 0.0;
            }
            else
            {
                Ammo.Quantity -= Rate;
                // really basic calculation of fire action
                double d = Damage * Rate * Accuracy * Condition;
                return d;
            }
        }

        public void RemoveUpgrade(WeaponUpgrade upgrade)
        {
            WeaponUpgrade u = GetUpgradeByID(upgrade.ID);
            if (upgrade.IsAttatched && upgrade.AttachedTo==ID && u!=null)
            {
                Upgrades.Remove(u);
                upgrade.IsAttatched = false;
                upgrade.AttachedTo = null;
            }
        }
        
        
        public void AttachUpgrade(WeaponUpgrade upgrade)
        {
            if (!upgrade.IsAttatched)
            {
                // add attachment
                upgrade.IsAttatched = true;
                upgrade.AttachedTo = ID;
                // 
                Upgrades.Add(upgrade);
            }
            else
            {
                // attachment in use
            }
        }



        public WeaponUpgrade GetUpgradeByID(string id)
        {
            foreach (WeaponUpgrade w in Upgrades)
            {
                if (w.ID == id) return w;
            }
            return null;
        }
        
    }

    class WeaponUpgrade : InventoryItem
    {
        public bool IsAttatched;
        public string AttachedTo;
        public string EffectedTarget;
        public string EffectValue;

        public WeaponUpgrade()
        {
            IsAttatched = false;
            AttachedTo = "";
            EffectedTarget = "";
            EffectedTarget = "";
        }

        public string MessageString()
        {
            string msg = "<InventoryItem>";
            msg += "<IsAttatched>" + IsAttatched + "</IsAttatched>";
            msg += "<AttachedTo>" + AttachedTo + "</AttachedTo>";
            msg += "<EffectedTarget>" + EffectedTarget + "</EffectedTarget>";
            msg += "<EffectValue>" + EffectValue + "</EffectValue>";
            msg += "</InventoryItem>";
            return msg;
        }
    }
    class Ammo : InventoryItem
    {
        public const int NONE = 999;
       
        public int AmmoType;
        public int Quantity;
        public List<AmmoUpgrade> Upgrades = new List<AmmoUpgrade>();

        public Ammo()
        {
            AmmoType = NONE;
            Quantity = 0;
        }

        public string MessageString()
        {
            string msg = "<InventoryItem>";
            msg += baseMessage();
            msg += "<AmmoType>" + AmmoType + "<AmmoType/>";
            msg += "<Quantity>" + AmmoType + "<Quantity/>";
            for (int i = 0; i < Upgrades.Count; i++)
            {
                msg += Upgrades[i].MessageString();
            }
            msg += "</InventoryItem>";
            return msg;
        }

    }
    class AmmoUpgrade:InventoryItem
    {
        public bool IsAttatched;
        public string AttachedTo;
        public string EffectedTarget;
        public string EffectValue;
        public double Quantity;
        public double Condition;

        public AmmoUpgrade()
        {
            IsAttatched = false;
            AttachedTo = "";
            EffectedTarget = "";
            EffectValue = "";
            Quantity = 0.0;
            Condition = 0.0;
        }

        public string MessageString()
        {
            string msg = "<AmmoUpgrade>";
            msg += baseMessage();
            msg += "<IsAttatched>" + IsAttatched + "</IsAttatched>";
            msg += "<AttachedTo>" + AttachedTo + "</AttachedTo>";
            msg += "<EffectedTarget>" + EffectedTarget + "</EffectedTarget>";
            msg += "<EffectValue>" + EffectValue + "</EffectValue>";
            msg += "<Quantity>" + Quantity + "</Quantity>";
            msg += "</AmmoUpgrade>";
            return msg;
        }
    }
    class WorkerUpgrade : InventoryItem
    {
        public bool IsAttatched;
        public bool IsTemporary;
        public string AttachedTo;
        public string EffectedTarget;
        public string EffectValue;
        public double Quality;
        public double Condition;
        public double Duration;

        public string MessageString()
        {
            string msg = "<WorkerUpgrade>";
            msg += baseMessage();
            msg += "<IsAttatched>" + IsAttatched + "</IsAttatched>";
            msg += "<AttachedTo>" + AttachedTo + "</AttachedTo>";
            msg += "<EffectedTarget>" + EffectedTarget + "</EffectedTarget>";
            msg += "<EffectValue>" + EffectValue + "</EffectValue>";
            msg += "<Quality>" + Quality + "</Quality>";
            msg += "<Condition>" + Condition + "</Condition>";
            msg += "<Duration>" + Duration + "</Duration>";

            msg += "</WorkerUpgrade>";
            return msg;
        }
    }

    class Transaction
    {
        public int Amount;
        public DateTime Time;
        public string Sender;
        public string Receiver;
        public string Memo;
    }
}
