using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MyGame
{
    class WeaponFactory
    {
        public const string BASIC_FISTS = "basicfists";
        public const string GOLDEN_GLOVES = "goldengloves";
        public const string WOODEN_LOUISVILLE_SLUGGAH = "woodenlouisvillesluggah";

        public Weapon WoodenLouisvillSluggah()
        {
            Weapon bat = new Weapon();
            bat.WeaponType = Weapon.MELEE;
            bat.ID = WOODEN_LOUISVILLE_SLUGGAH;
            bat.Label = "Wooden Louiville Sluggah";
            bat.Description = "perfect for hard heads.";
            bat.Damage = 8;
            bat.Rate = 1;
            bat.Capacity = 0;
            bat.Accuracy = .75;
            bat.Overheat = 0;
            bat.Ammo = new Ammo();
            bat.Upgrades = new List<WeaponUpgrade>();
            return bat;
        }



        public Weapon BasicFists()
        {
            Weapon fist = new Weapon();
            fist.WeaponType = Weapon.MELEE;
            fist.ID = BASIC_FISTS;
            fist.Label = "Fists";
            fist.Description = "When all else fails, it's back to basics";
            fist.Damage = 1;
            fist.Accuracy = 0.75;
            fist.Rate = 2;
            fist.Capacity = 0;
            fist.Type = 2;
            fist.Overheat = 0;
            fist.Attention = 1;
            fist.Condition = 1.0;
            fist.Ammo = new Ammo();
            fist.Upgrades = new List<WeaponUpgrade>();
            return fist;
        }
        
        
        
        public Weapon GoldenGloves()
        {
            Weapon fist = new Weapon();
            fist.WeaponType = Weapon.MELEE;
            fist.ID = GOLDEN_GLOVES;
            fist.Label = "Golden Gloves";
            fist.Description = "the ol' 1.. 2..";
            fist.Damage = 4;
            fist.Accuracy = 0.9;
            fist.Rate = 4;
            fist.Capacity = 0;
            fist.Type = 2;
            fist.Overheat = 0;
            fist.Attention = 1;
            fist.Condition = 1.0;
            fist.Ammo = new Ammo();
            fist.Upgrades = new List<WeaponUpgrade>();
            return fist;
        }



    }
}
