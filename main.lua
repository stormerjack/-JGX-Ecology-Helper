-- ============================================================
-- PYX ECOLOGY HELPER
-- ============================================================

if not ESP then ESP = {} end

ESP.SettingsPath = "Settings\\EcologyHelper.json"

ESP.State = {
    SavePending = false,
    LastSaveRequestTick = 0,
    LastSaveTick = 0,
    HpCache = {},
    LastHpRefresh = 0,
    ActorNameCache = {},
    LastActorNameRefresh = 0,
    EcologyGradeCache = {},
    NameGradeCache = {},
    EcologyDebugCache = {},
    LastEcologyRefresh = 0,
    KnowledgeNameGradeIndex = {},
    LastKnowledgeIndexRefresh = 0,
    StaticCardNameGradeIndex = {},
    StaticCharacterGradeIndex = {},
    LastStaticCardIndexRefresh = 0,
    FocusMonsterName = "",
    FocusMonsterNames = {},
    DebugPathTarget = nil,
    DebugWaypointTarget = nil,
    DebugPathStatus = "",
    OpenSubHeaders = {},
    OpenRegionHeaders = {},
}

-- ============================================================
-- 1. CONFIGURATION
-- ============================================================

ESP.Global = {
    Enabled = true,
    ShowBox = true,
    ShowSnaplines = true,
    ShowText = true,
    TextSizePx = 21,
    ShowEcologyInfo = false,
    HideWhenDead = false,
    ShowRadar = false,
    MaxDistance = 8000, -- Ajusté à 8000 (80 mètres), distance standard d'affichage BDO
    SelectedActorAddr = 0
}

-- Configuration des acteurs
ESP.Actors = {
    [1] = { name = "Monster",      enabled = true,  color = ImVec4(1.0, 0.0, 0.0, 1.0), boxH = 60,  offY = 0 },
    [2] = { name = "Npc",          enabled = true,  color = ImVec4(0.0, 1.0, 0.0, 1.0), boxH = 150, offY = 0 },
}

ESP.DefaultConfig = { name = "Unknown", enabled = false, color = ImVec4(1,1,1,1), boxH = 100, offY = 0 }

ESP.EcologySections = {
    {
        title = "Ecology of Eastern Balenos",
        groups = {
            {
                title = "Beasts",
                entries = {
                    "Baby Boar", "Stoneback Crab", "Balenos Bear", "Boar", "Wolf", "Fox", "Weasel", "Grass Beetle",
                    "Parasitic Bee", "Gray Boar", "Gray Wolf", "Gray Fox", "Plain Stoneback Crab", "Mature Tree Spirit",
                    "Immature Tree Spirit", "Small Tree Spirit"
                }
            },
            {
                title = "Imps",
                entries = {
                    "Imp Altar", "Imp Amulet", "Imp Defense Tower", "Steel Imp Wizard", "Steel Imp Warrior", "Steel Imp",
                    "Imp Wizard", "Imp Raider", "Imp Soldier"
                }
            },
            {
                title = "Goblins",
                entries = {
                    "Giath's Secret", "Giant Goblin Totem", "Giant Goblin Tower", "Goblin Cauldron", "Goblin Watchtower",
                    "Goblin Elite Soldier", "Goblin Shaman", "Goblin Thrower", "Goblin Fighter", "Goblin"
                }
            },
            {
                title = "Exiles of Mediah",
                entries = {
                    "Cron Castle Barricade", "Cron Castle Supply", "Senior Soldier", "Operation Chief", "Scout",
                    "Rookie Soldier", "Cron Castle Barracks", "Cron Castle Flag", "Cron Castle Watchtower"
                }
            },
            {
                title = "Cox Pirates",
                entries = {
                    "Red Foot Assassin", "Deck Elite Combatant", "Deck Combatant", "Elite Sentinel", "Drunk Treasure Hunter",
                    "Iron Combatant", "Cox Prison", "Crazy Jack", "Cox Elite Gladiator", "Captain Khuru", "One-Eyed Outlaw",
                    "Megimegi", "Cox Elite Warrior", "Cox Female Warrior", "Cox Raider", "Cox Warrior", "Pirate Watchtower",
                    "Pirate Treasure Chest", "Pirate Flag"
                }
            },
            {
                title = "Bumblin' Buccaneers",
                entries = {
                    "Bumblin' Outlaw", "Bumblin' Buccaneers Barracks", "Bumblin' Megimegi", "Bumblin' Combatant",
                    "Bumblin' Buccaneer's Flag", "Bumblin' Captain", "Bumblin' Watchtower", "Bumblin' Cannoneer",
                    "Bumblin' Elite Warrior", "Bumblin' Female Warrior", "Bumblin' Raider", "Bumblin' Warrior",
                    "Bumblin' Assassin", "Bumblin' Madcap", "Bumblin' Watchman", "Bumblin' Sniper", "Bumblin' Gladiator"
                }
            },
            {
                title = "Protties",
                entries = {
                    "Kaz Protty", "Zera Protty", "Protty", "Protty Ootheca", "Black Crystal Seaweed", "Ocean Crystal Seaweed",
                    "Sid Protty"
                }
            },
            {
                title = "Sycraia Underwater Ruins",
                entries = {
                    "Sycrak", "Sycrid", "Eyes of the Deep Sea", "Tower of Restoration", "Force Field Defender", "Damaged Lykin",
                    "Damaged Pirash", "Elmermol", "Kureba", "Lykin", "Pirash", "Damaged Kureba"
                }
            }
        }
    },
    {
        title = "Ecology of Serendia",
        groups = {
            {
                title = "Beasts",
                entries = {
                    "Serendia Elk", "Serendia Wolf", "Serendia Bear", "Big Horn Triangle Head Salamander", "Fan Flamingo Nest",
                    "Swamp Hermit Crab", "Grassback Crab", "Kuku Bird Nest", "Sheep", "Rainbow Lizard", "Lamb",
                    "Mountain Sheep", "Scary Salamander", "Serendia Mountain Sheep", "Small Salamander", "Fan Flamingo",
                    "Triangle Head Lizard", "Kuku Bird", "Moss Stoneback Crab"
                }
            },
            {
                title = "Plants",
                entries = {
                    "Thorn Tentacle Nest", "Mudster", "Mudster Swamp", "Black Thorn Tentacle", "Red Thorn Tentacle",
                    "Thorn Tentacle", "Poisonous Swamp Plant", "Wheat Field Lookout", "Scarecrow Ghost", "Pumpkin Ghost",
                    "Toxic Thorn Tentacle"
                }
            },
            {
                title = "Insects",
                entries = {
                    "Cobweb", "Beehive", "Conch-Parasitic Bee", "Big Bush Spider", "Bush Spider", "Acid Spider",
                    "Acid Spider Den", "Pouch-Parasitic Bee", "Barrel-Parasitic Bee", "Tiny Bee", "Beetle", "Spider"
                }
            },
            {
                title = "Bandits",
                entries = {
                    "Demibeast Bandit Warrior", "Bandit Defense Captain", "Bandit Raid Captain", "Giant Bandit", "Bandit Archer",
                    "Bandit Warrior", "Trap", "Briar Lightning Trap", "Log Lightning Trap", "Trained Wolf", "Bandit Round Hut",
                    "Bandit Hut", "Bandit Amulet", "Bandit Watchtower", "Bandit Large Watchtower", "Prison",
                    "Bandit Treasure Chest", "Bandit Treasure Wagon"
                }
            },
            {
                title = "Imps",
                entries = {
                    "Imp Pigpen", "Mine Imp", "Mine Imp Wagon", "Mine Imp Tower", "Imp Flag", "Altar Imp Food Wagon",
                    "Altar Imp Barracks", "Altar Imp Prison", "Strong Altar Imp Trainer", "Altar Imp Fighter",
                    "Altar Imp Trainer", "Altar Imp Scout", "Altar Imp Warrior", "Altar Imp"
                }
            },
            {
                title = "Fogans",
                entries = {
                    "Swamp Fogan Giant Tower", "Small Swamp Fogan", "Big Swamp Fogan", "Fogan Hatchling", "Fogan Food Depot",
                    "Fogan Defense Tower", "Fogan Amulet", "Fogan Archer Dugout", "Swamp Fogan Warrior", "Swamp Fogan Egg",
                    "Swamp Fogan Fortuneteller", "Swamp Fogan Lookout", "Swamp Fogan Guard", "Swamp Fogan"
                }
            },
            {
                title = "Nagas",
                entries = {
                    "Ambushed Naga", "Naga Hut", "Naga Guard Tower", "Swamp Naga Commander", "Swamp Naga Axeman",
                    "Swamp Naga Apprentice Axeman", "Swamp Naga Apprentice Spearman", "Swamp Naga"
                }
            },
            {
                title = "Red Orcs",
                entries = {
                    "Red Orc Shamanic Cauldron", "Red Orc Prison", "Firewood Orc", "Red Orc Giant Altar", "Firebreathing Orc Cannon",
                    "Red Orc Hut", "Long Red Orc", "Red Orc Berserker", "Red Orc Fighter", "Orc Mushroom Brazier",
                    "Orc Large Cauldron", "Small Red Orc Warrior", "Small Red Orc", "Red Orc Elite Soldier",
                    "Red Orc Wizard", "Red Orc Warrior", "Red Orc"
                }
            },
            {
                title = "Al Rhundi Rebels",
                entries = {
                    "Rebel Barricade", "Rebel Supply", "Rebel Barracks", "Elite Guard", "Elite Infantry", "Rebel Flag",
                    "Rebel Watchtower", "Wizard", "Patrol", "Vanguard", "Infantry"
                }
            },
            {
                title = "Cultists",
                entries = {
                    "Wicked Cultist", "Cultist Flag", "Cultist Giant Warrior", "Cultist Stone Statue",
                    "Cultist Assassin", "Cultist Shaman", "Cultist Warrior", "Cultist"
                }
            },
            {
                title = "Kzarka",
                entries = {
                    "Altar of Blood", "Serendia Shrine Victim", "Serendia Shrine Warrior", "Serendia Shrine Priestess",
                    "Kzarka, the Lord of Corruption", "Serendia Shrine Priest", "Serendia Shrine Wizard"
                }
            },
            {
                title = "Shadow Knights",
                entries = {
                    "Shadow Priestess", "Dwarf Miner", "Shadow Wizard", "Shadow Knight"
                }
            }
        }
    },
    {
        title = "Ecology of Calpheon",
        groups = {
            {
                title = "Beasts",
                entries = {
                    "Ambushing Stone Spider", "Mutant Gargoyle", "Brown Bear", "Sharp Rock Spider", "Mature Stone Rat",
                    "Young Stone Rat",
                    "Spotted Deer", "Female Elk", "Young Elk", "Elk", "Baby Waragon", "Waragon", "Waragon Egg",
                    "Explosive Waragon", "Calpheon Worm", "Farm Boar", "Brown Raccoon",
                    "Locust Swarm", "Plantation Big Mole", "Plantation Small Mole", "Bat", "Mountain Lamb",
                    "Blue Lizard", "Calpheon Beetle", "Young Red Boar", "Rhino Lizard",
                    "Stone Rat", "Red Boar", "Red Boar's Den", "Iguana", "Stone Crab", "Big House-Parasitic Bee",
                    "Rainbow Fox", "Stonescale Devourer", "Spotted Hyena", "Red Bear", "Ferocious Weasel",
                    "Long-haired Water Buffalo", "Kuku Hatchling"
                }
            },
            {
                title = "Plants",
                entries = {
                    "Toxic Cave Plant", "Treant Crystal Tree", "Lazy Tree Spirit", "Tough Tree Spirit",
                    "Owl Treant", "Small Treant", "Scream Treant", "Treant Stub",
                    "Treant Spirit", "Rooted Old Wood Treant", "Twin-Headed Treant", "Root Treant", "Old Tree Treant"
                }
            },
            {
                title = "Khurutos",
                entries = {
                    "Khuruto Shaman", "Khuruto Fighter", "Small Khuruto", "Khuruto Soldier", "Khuruto Elite Soldier",
                    "Khuruto Pot", "Khuruto Tent", "Khuruto Ration Depot", "Khuruto Wooden Totem", "Khuruto Amulet",
                    "Khuruto Resting Area", "Khuruto Sacrifice", "Khuruto Prison"
                }
            },
            {
                title = "Quint Hill",
                entries = {
                    "Troll Wagon", "Troll Porter", "Troll Shaman", "Troll Thrower", "Troll Warrior", "Troll",
                    "Surrendered Khuruto Soldier", "Surrendered Khuruto Elite Soldier", "Young Troll Ox", "Troll Siege Soldier",
                    "Troll Buff Tower", "Troll Catapult", "Troll Ration Depot", "Troll Protection Tower", "Troll Hut",
                    "Dragon Protection Tower", "Troll Barricade", "Ancient Troll Elite Warrior", "Troll Cow",
                    "Troll Elite Warrior", "Ancient Troll Shaman", "Ancient Troll Thrower", "Ancient Troll Warrior",
                    "Ancient Troll"
                }
            },
            {
                title = "Marni's House",
                entries = {
                    "Horn Chimera", "Orc Test Subject", "Mad Screaming Orc Wizard", "Chimera", "Mad Screaming Saunil",
                    "Unidentified Cauldron", "Mad Screaming Harpy", "Mad Screaming Orc Warrior", "Mad Scientist Bomb",
                    "Mad Scientist Cannon"
                }
            },
            {
                title = "Saunils",
                entries = {
                    "Saunil Commander", "Saunil Vanguard", "Saunil Elite Soldier", "Saunil Archer", "Saunil Warrior",
                    "Saunil Guard", "Saunil Siege Tower", "Saunil Mobile Catapult", "Saunil Immobile Catapult",
                    "Saunil Brawler", "Saunil Elder", "Saunil Armored Warrior", "Saunil Fighter"
                }
            },
            {
                title = "Mansha Forest",
                entries = {
                    "Mansha Trap", "Mansha Lightning Trap", "Mansha Javelin Thrower", "Mansha Warrior", "Ogre"
                }
            },
            {
                title = "Rhutum",
                entries = {
                    "Rhutum Archer", "Rhutum Wizard", "Rhutum Elite Warrior", "Rhutum Fighter", "Rhutum Soldier",
                    "Rhutum Elite Archer", "Rhutum Elite Brawler", "Rhutum Sculpture", "Rhutum Ration", "Rhutum Flag",
                    "Rhutum Tower", "Rhutum Cannon", "Captive Prison", "Rhutum Hut"
                }
            },
            {
                title = "Lake Kaia",
                entries = {
                    "Fat Catfishman", "Otter Fisher", "Catfishman Fisher", "Catfishman", "Catfishman Elite Fisher",
                    "Catfishman Light-armored Warrior", "Catfishman Meat", "Catfishman Rotten Fish", "Catfishman Witmirth",
                    "Water Strider", "Jellyfish"
                }
            },
            {
                title = "Hexe Sanctuary",
                entries = {
                    "Hexe Sanctuary Shamanic Tree", "Skeleton Wolf", "Skeleton Warrior", "Skeleton Archer", "Skeleton",
                    "Witch Tower", "Skeleton Witmirth", "Skeleton Lizard", "Green Orc Skeleton Warrior"
                }
            },
            {
                title = "Ruins",
                entries = {
                    "Circle Ruins Tree", "Ruins Spider", "Witch Possessed by a Black Spirit", "Giant Possessed by a Black Spirit",
                    "Adventurer Possessed by a Black Spirit", "Roaming Black Spirit", "Triangle Ruins Tree", "Tiny Ruins Spider",
                    "Arch Ruins Tree", "Large Cylinder Ruins Tree", "Small Cylinder Ruins Tree", "Face Ruins Tree",
                    "Ancient Ruins Stone Gate", "Ruins Golem", "Spotted Deer Possessed by a Black Spirit",
                    "Ancient Ruins Defender", "Ancient Ruins Guard"
                }
            },
            {
                title = "Secret Societies",
                entries = {
                    "Hand of Kzarka", "Calpheon Shrine Pillar", "Aura of Failed Kzarka", "Calpheon Elite Shadow Priestess",
                    "Cave Stalactite", "Remnants of Kzarka", "Calpheon Shrine Warrior", "Calpheon Elite Shadow Knight",
                    "Calpheon Shrine Elite Wizard", "Calpheon Shrine Elite Warrior", "Calpheon Shrine Priestess",
                    "Calpheon Shadow Guard", "Calpheon Shadow Wizard", "Calpheon Shadow Knight", "Calpheon Angry Protester",
                    "Calpheon Protester Berserker", "Calpheon Protester Priestess", "Calpheon Protester Warrior",
                    "Calpheon Protester"
                }
            },
            {
                title = "Harpies",
                entries = {
                    "Harpy Nest", "Small Harpy", "Harpy", "Black Harpy Elite", "Harpy Abductor", "Harpy Mage",
                    "Harpy Warrior"
                }
            },
            {
                title = "Giants",
                entries = {
                    "Cyclops Food Drying Stand", "Treasure Chamber of One-Eyed Giant", "Giant Sculpture", "Giant Sculpture",
                    "Cyclops", "Giant Warrior", "Giant", "Giant Combatant", "Giant Brawler", "Giant Fighter",
                    "Disguised Giant"
                }
            },
            {
                title = "Creatures of Calpheon",
                entries = {
                    "Root Nymph Rest Area", "Ruins Monster", "Crow", "Cave Flytrap Worm", "Big Glutoni",
                    "Small Glutoni", "Mutant Glutoni", "Medium-sized Glutoni", "Stoneback Crab Egg",
                    "Faust Forest Tiny Stoneback Crab", "Faust Forest Tough Stoneback Crab", "Earth Root Nymph",
                    "Fire Root Nymph", "Grass Root Nymph", "Rough Stoneback Crab",
                    "Faust Forest Herb Stoneback Crab", "Faust Forest Scrub Stoneback Crab", "Baby Gargoyle"
                }
            },
            {
                title = "Quarry",
                entries = {
                    "Petrified Laborer Sculpture", "Half-petrified Miner", "Petrified Miner", "Rock Spider",
                    "Petrifying Worker", "Golem Spider", "Petrifying Berserk Miner", "Petrifying Foreman", "Junk Pile",
                    "Petrifying Dwarf", "Petrifying Bomber", "Keplan Catapult", "Keplan Saw", "Junk Golem",
                    "Petrifying Miner"
                }
            },
            {
                title = "Refugee Camp",
                entries = {
                    "Contaminated Dwarf", "Contaminated Woman", "Contaminated Man", "Contaminated Butcher",
                    "Contaminated Dog", "Contaminated Giant", "Pile of Mountain Sheep Skulls", "Refugee Camp Round Barracks",
                    "Refugee Camp Barracks", "Refugee Camp Jar", "Refugee Camp Amulet", "Contaminated Black Dog",
                    "Contaminated Witch", "Contaminated Wizard"
                }
            },
            {
                title = "Creatures of Northern Calpheon",
                entries = {
                    "Calpheon Giant Bee", "Mask Owl Archer", "Mask Owl Warrior", "Mask Owl", "Hummingbird",
                    "Plantation Stone-shelled Crab", "Thief Imp", "Farm Stoneback Crab", "Masked Pumpkin Ghost"
                }
            },
            {
                title = "Mutants",
                entries = {
                    "Mutant Tree Spirit", "Mutant Troll", "Mutant Ogre"
                }
            },
            {
                title = "Star's End Sacrifice",
                entries = {
                    "Apostle of Malevolence", "Unstable Star Debris", "Traces of a Corrupt Star", "Pillar of Despair",
                    "Amulet of Decay", "Remnants of Corruption", "Apostle of Defilement", "Harbinger of Immorality",
                    "Harbinger of Corruption", "Apostle of Immorality", "Harbinger of Defilement", "Apostle of Corruption"
                }
            }
        }
    },
    {
        title = "Ecology of Mediah",
        groups = {
            {
                title = "Creatures of Mediah",
                entries = {
                    "Mediah Stoneback Crab Egg", "Stone Hole Spider Den", "Stone Hole Spider House", "Mediah Mountain Lamb",
                    "Stonetail Bison", "Baby Stone Rhino", "Beetle Stoneback Crab", "High Head Stoneback Crab",
                    "Mediah Mountain Sheep", "Elite", "Armadillo", "Wasteland Iguana", "Desert Crab", "Blue Desert Crab",
                    "Rock Desert Crab", "Vera Desert Crab", "Small Stone Head Bison", "Wasteland Cheetah Dragon",
                    "Grass Hedgehog", "Rock Spider", "Stone Rhino", "Rock Head Bison", "Mature Rock Spirit",
                    "Stone Hole Worm", "Stone Crab", "Tiny Stone Hole Spider", "Stone Hole Spider"
                }
            },
            {
                title = "Abandoned Iron Mine",
                entries = {
                    "Tacky Wood Doll", "Crude Watchtower", "Lightning Trumpeter", "Thunder Drummer", "Equipment Holder",
                    "Imp Work Supervisor", "Khuruto Chaser", "Khuruto Guard", "Khuruto Sheriff", "Khuruto Executor",
                    "Saunil Sheriff", "Tacky Stone Wagon", "Tacky Surveillance Dugout", "Tacky Fire Cannon",
                    "Troll Work Supervisor", "Rhutum Chief Shaman", "Saunil Guard", "Red Orc Sentinel", "Red Orc Guard",
                    "Rhutum Sheriff", "Rhutum Guard"
                }
            },
            {
                title = "Ruins Helms",
                entries = {
                    "Helm Raid Captain", "Helm Crusher", "Helm Destroyer", "Helm Devourer", "Helm Tribe Mineral Wagon",
                    "Golem Summoning Stone", "Helm Golem", "Helm Iron Shield", "Stone Golem", "Gravestone Golem",
                    "Wilderness Golem", "Helm Tribe Forge", "Helm Tribe Mine", "Defense Trench", "Helm Angry Hammer",
                    "Helm Small Mace", "Helm Big Mace", "Helm Hunter", "Helm Hammer", "Helm Miner",
                    "Helm Two-Axe Warrior", "Helm Big Axe"
                }
            },
            {
                title = "Sausan Garrison",
                entries = {
                    "Sausan Supply Chest", "Sausan Cannoneer", "Sausan Golden Wagon", "Sausan Guardian", "Sausan Tent",
                    "Sausan Supply Camp", "Sausan Watchtower", "Sausan Soldier", "Sausan Assassin", "Sausan Sniper",
                    "Sausan Scout", "Tough Sausan Soldier", "Sausan Watch", "Shultz Guard Armored Soldier",
                    "Shultz Guard Sniper", "Shultz Guard Gladiator"
                }
            },
            {
                title = "Wandering Rogues & the Manes",
                entries = {
                    "Mane Tunnel", "Blinding Stone Grave", "Mane Grave", "Wandering Rogue Giant Soldier",
                    "Wandering Rogue Obsidian Altar", "Wandering Rogue Prison", "Elementalist's Stone Tower",
                    "Wandering Rogue", "Wandering Rogue Fighter", "Wandering Rogue Elementalist", "Blind Pugnose",
                    "Giant Mane", "Agile Mane", "Big Mane", "Small Mane"
                }
            },
            {
                title = "Canyon of Corruption",
                entries = {
                    "Rotten Sand Tower", "Rotten Swamp", "Decayed Swamp Monster", "Elric High Priest", "Elric Layperson",
                    "Elric Priest", "Elric Cultist", "Ritual Tool of Corruption", "Elric Shamanic Tree", "Elric Follower"
                }
            },
            {
                title = "Soldier's Cemetery",
                entries = {
                    "Grudged Sword", "Frenzied Skeleton Decurion", "Grudged Skeleton", "Frenzied Skeleton Centurion",
                    "Frenzied Skeleton Rifleman", "Frenzied Skeleton", "Frenzied Black Sorcerer",
                    "Frenzied Skeleton Watchdog", "Frenzied Skeleton Axeman"
                }
            },
            {
                title = "Mutated Ecology",
                entries = {
                    "Ferrid Tali", "Mutated Saunil", "Incomplete Orc Test Subject", "Mutant Chimera",
                    "Mutated Obsidian Monster", "Lava Swamp", "Ferrid Tio", "Ferrid Tuny"
                }
            },
            {
                title = "Tungrad",
                entries = {
                    "Kimel", "Puruko", "Elqueesh", "Belloten", "Bamole", "Kamel", "Ruins Stoneback Crab",
                    "Kukuri", "Buruko", "Kamol", "Balten", "Ancient Ruins Guard Tower"
                }
            }
        }
    },
    {
        title = "Ecology of Valencia",
        groups = {
            {
                title = "Creatures of Valencia",
                entries = {
                    "Gorgo Cobra", "Desert Scorpion", "Sand Spirit", "Laytenn", "Margos", "Miker Newt", "Coco Bird",
                    "Kelop", "Toxic Desert Scorpion", "Baby Valencian Lion", "Valencian Lioness", "Rocky Bat",
                    "Hobo Bat", "Kisleev Harpy Mage", "Kisleev Harpy", "Tombback Crab", "Desert Kuku Bird",
                    "Desert Iguana", "Dryroot Camel", "Desert Fox", "Valencia Mountain Sheep", "Sandceratops",
                    "Valencia Female Elephant", "Giant Desert Scorpion", "Valencian Lion", "Stone Mountain Turtle Dragon"
                }
            },
            {
                title = "Centaurus Herd",
                entries = {
                    "Centaurus Axeman", "Centaurus Hunter", "Centaurus", "Centaurus Seeker", "Centaurus Treasure Chest",
                    "Guard Tower of Earth"
                }
            },
            {
                title = "Cadry Followers",
                entries = {
                    "Cadry Armored Fighter", "Cadry Black Mage", "Cadry Fighter", "Cadry Commander", "Cadry Chief Gatekeeper",
                    "Cadry Summoning Stone", "Cadry Small Cannon", "Cadry Ruins Prison", "Cadry Large Cannon"
                }
            },
            {
                title = "Basilisk Herd",
                entries = {
                    "Petrified Adventurer", "Petrified Soldier", "Basilisk Petrifier", "Basilisk Watcher",
                    "Basilisk Ambusher", "Basilisk Statue"
                }
            },
            {
                title = "Bashim",
                entries = {
                    "Khala Reinforced Thrower", "Khala Commanding Officer", "Khala Elite Combatant", "Terruda Bandsman",
                    "Terruda Reinforced Infantryman", "Terruda Thrower", "Terruda Infantryman", "Ohonsey Elementalist",
                    "Ohonsey Archer", "Ohonsey", "Bashim Target Totem", "Bashim Extermination Totem", "Bashim Guard Totem",
                    "Bashim Energy Totem"
                }
            },
            {
                title = "Valencia Waragon",
                entries = {
                    "Colossal Stone Waragon", "Stone Prickle Lizard", "Stone Mutant Waragon", "Stone Waragon",
                    "Stone Worm", "Stone Waragon Egg"
                }
            },
            {
                title = "Gahaz Bandits",
                entries = {
                    "Sandstorm Elite", "Sandstorm Assassin", "Sandstorm Plunderer", "Shadow of Gahaz", "Sandstorm Rifleman",
                    "Bandit's Treasure Chest", "Sandstorm Barracks", "Sandstorm Large Watchtower", "Desert Trap",
                    "Sandstorm Bear Trap", "Sandstorm Watchtower"
                }
            },
            {
                title = "Desert Nagas",
                entries = {
                    "Desert Naga Commanding Officer", "Desert Naga Combat Monk", "Desert Naga Combatant",
                    "Desert Naga Chief Gatekeeper", "Desert Naga Statue", "Desert Naga Gigantic Guardian Tower"
                }
            },
            {
                title = "Desert Fogans",
                entries = {
                    "Desert Fogan Seer", "Desert Fogan Sentry", "Desert Fogan Fighter", "Desert Fogan Hoppity",
                    "Desert Fogan Chief Gatekeeper", "Desert Fogan Food Depot", "Desert Fogan Statue", "Desert Fogan Egg"
                }
            },
            {
                title = "Argos Saunils",
                entries = {
                    "Crescent Guardian", "Crescent Follower", "Crescent Watcher", "Crescent Chief Gatekeeper",
                    "Argos Sand Tower", "Argos Artifact Repository", "Argos Obsidian Energy", "Argos Obsidian Altar"
                }
            },
            {
                title = "Aakman & the Ancients (Weapon) I",
                entries = {
                    "Ancient Civilization Originator", "Ancient Civilization Guardian", "Ancient Civilization Follower",
                    "Demol", "Burmol", "Alten", "Kalten", "Casius", "Kreator", "Ancient Ator"
                }
            },
            {
                title = "Aakman & the Ancients (Weapon) II",
                entries = {
                    "Hystria Watch Tower", "Hystria Guard Tower", "Tukar Demol", "Tukar Burmol", "Elten", "Tukar Balten",
                    "Tanco", "Vodkhan", "Kalqueesh", "Aakman Illusion Trap", "Aakman Illusion Statue", "Tutuka",
                    "Aakman Guardian", "Aakman Watcher", "Aakman Punisher", "Aakman Airbender", "Aakman Flamen",
                    "Aakman Elite Watcher", "Aakman Elite Guardian"
                }
            },
            {
                title = "Lava Tribe of Valencia",
                entries = {
                    "Lava Searcher", "Lava Tukar", "Lava Fafalun", "Lava Devourer", "Lava Sulfur Bundle",
                    "Lava Hydraulic Nozzle", "Lava Phlogiston Condenser", "Lava Taolun", "Lava Faolun"
                }
            },
            {
                title = "The Imprisoned",
                entries = {
                    "Pile of Jail Junk", "Jail Alarm Device", "Caphras' Torture Device", "Dark Eyes Warder",
                    "Caphras' Follower", "Iron Fist Warder", "Executioner", "Frenzied Executioner", "Sordid Deportee"
                }
            },
            {
                title = "Creatures of the Great Ocean",
                entries = {
                    "Saltwater Crocodile", "Lekrashan", "Margoria Pirate Fleet", "Goldmont Medium Battleship",
                    "Goldmont Small Battleship", "Goldmont Large Battleship", "Ocean Stalker", "Nineshark",
                    "Black Rust", "Hekaru", "Candidum"
                }
            }
        }
    },
    {
        title = "Ecology of Kamasylvia",
        groups = {
            {
                title = "Steppe",
                entries = {
                    "Immature Black Leopard", "Immature Griffon", "Immature King Griffon", "Phnyl", "King Griffon",
                    "Baby Belladonna Elephant", "Ferrina", "Ferrica", "Griffon", "Feather Wolf", "Belladonna Elephant",
                    "Griffon Egg"
                }
            },
            {
                title = "Forest (Kamasylvia) I",
                entries = {
                    "Crystal Alligator", "Belomimus", "Greenstone Bull", "Arched Hummingbird", "Loah Snake",
                    "Rock Gargoyle", "Baby Rock Gargoyle", "Black Leopard", "Gazelle", "Poacher", "Kamasylvia Brown Bear"
                }
            },
            {
                title = "Forest (Kamasylvia) II",
                entries = {
                    "Lapis Lazuli Crab", "Lapis Lazuli Bison", "Contaminated Ivy Guard", "Contaminated Bush Keeper",
                    "Vera Grassland Crab", "Grassland Hedgehog", "Rock Rhino", "Kamasylvia Herb Stoneback Crab",
                    "Kamasylvia Scrub Stoneback Crab", "Kamasylvia Small Stoneback Crab", "Kamasylvia Rough Stoneback Crab",
                    "Bush Thicket Beetle", "Forest Bat", "Feather Weasel", "Kamasylvia Mountain Sheep", "Silver Fox",
                    "Kamasylvia Female Horn Deer", "Kamasylvia Young Horn Deer", "Kamasylvia Horn Deer",
                    "Black Sand Small Mole", "Kamasylvia Mountain Lamb", "Kamasylvia Weasel", "Lapis Lazuli Tree Spirit",
                    "Lapis Lazuli Spider", "Lapis Lazuli Shard Spider", "Big Horn Salamander", "Red Beak Devourer",
                    "Lavender Kuku Bird", "Lapis Lazuli Scale Iguana", "Water Buffalo", "Poisonous Thorn Tentacle",
                    "Bush Hermit Crab", "Kamasylvia Small Lizard", "Big Horned Wild Boar", "Tiny Bee Swarm",
                    "Silk Shade Flamingo", "Black Sand Mole", "Bush Spider", "Maroon Raccoon"
                }
            },
            {
                title = "Manshaum",
                entries = {
                    "Manshaum Hut", "Manshaum Totem", "Manshaum Narc's Spear", "Manshaum Charm", "Manshaum Fighter",
                    "Manshaum Hunter", "Manshaum Great Warrior", "Manshaum Warrior", "Manshaum Shaman"
                }
            },
            {
                title = "Mirumok Ruins",
                entries = {
                    "Treant Old Tree", "Treant Ghost Tree", "Mirumok Watcher", "Mirumok Lookout",
                    "Degraded Old Tree Treant", "Degraded Ruins Tree Treant", "Voraro", "Old Mirumok", "Mirumok"
                }
            },
            {
                title = "Fadus",
                entries = {
                    "Fadus Warrior Chief", "Fadus Blue Pride", "Fadus Blue Box", "Fadus Weapon Ornament",
                    "Fadus Blue Barrier", "Fadus Warrior", "Fadus Supply Barrack", "Fadus Double Barrack",
                    "Fadus Challenger", "Fadus Dual Wielder", "Fadus Archer", "Fadus Shaman"
                }
            },
            {
                title = "Forest Ronaros Lookout",
                entries = {
                    "Ron's Mirror", "White Tree Thorn Vine", "Forest Ronaros Marksman", "Forest Ronaros Catcher",
                    "Forest Ronaros Guardian", "Forest Ronaros Scout"
                }
            },
            {
                title = "Polly's Mushrooms",
                entries = {
                    "Thief Imp Philums", "Twinkle-in-the-Dark Mushroom", "Trumpet Bell Poison Mushroom",
                    "Cotton Bubble Mushroom", "Snowflake Poison Mushroom", "Musk Pocket Mushroom",
                    "Shadow Poison Mushroom", "Cloudy Rain Mushroom", "Red Skirt Poison Mushroom"
                }
            },
            {
                title = "Gyfin Rhasia",
                entries = {
                    "Gyfin Rhasia Statue of Earth", "Gyfin Rhasia Tower of Transfusion", "Gyfin Rhasia Tower of Carnage",
                    "Gyfin Rhasia Crusher", "Gyfin Rhasia Flamen", "Gyfin Rhasia Decimator", "Gyfin Rhasia Guard"
                }
            },
            {
                title = "Ash Forest",
                entries = {
                    "Ghost of Ash Forest", "Volkras", "Barnas", "Gairas"
                }
            }
        }
    },
    {
        title = "Ecology of Drieghan",
        groups = {
            {
                title = "Beasts",
                entries = {
                    "Horned Rock Lizard", "Spiked Rock Lizard", "Stone Cobra", "Rock Scorpion", "Marmot",
                    "Rockroot Armadillo", "Rockskin Boar", "Yak", "Explosive Stone", "Llama",
                    "Highland Stoneback Crab", "Gray Highland Wolf", "Guanaco", "Drieghan Female Goat",
                    "Drieghan Male Goat", "Sharp Stoneback Crab"
                }
            },
            {
                title = "Kagtum Tribe",
                entries = {
                    "Kagtum Raider", "Kagtum Lookout", "Enraged Garmoth Statue", "Traitor's Jail",
                    "Enchanting Garmoth Statue", "Frenzied Kagtum", "Blood Wolf", "Kagtum Laborer",
                    "Kagtum Warden", "Kagtum Chaser", "Kagtum Executioner"
                }
            },
            {
                title = "Sherekhan Necropolis",
                entries = {
                    "Federik", "Nybrica", "Belcadas", "Lateh", "Garud"
                }
            },
            {
                title = "Tshira Ruins",
                entries = {
                    "Tree Ghost Spider", "Swamp Imp Bronk", "Vine Keeper", "Grove Keeper", "Leaf Spider",
                    "Murky Swamp Caller", "Leaf Keeper", "Kvariak", "Bronk Huts", "Bronk Food Storage",
                    "Venomous Swamp Nest", "Tree Hermit"
                }
            },
            {
                title = "Khalk Canyon",
                entries = {
                    "Khalk of Darkness", "Bloodthirsty Khalk"
                }
            }
        }
    },
    {
        title = "Ecology of O'dyllita",
        groups = {
            {
                title = "Beasts",
                entries = {
                    "Gorilla", "Grass Rhino", "Black Moss Stoneback Crab", "Black Armadillo", "Young Grass Rhino",
                    "Shadow Lion", "Verdure Doe", "Verdure Buck", "Shadow Wolf"
                }
            },
            {
                title = "Tunkuta",
                entries = {
                    "Turo Berserker", "Turo Pike Warrior", "Turo Scout", "Turo Totem", "Turo Charm", "Turo Resting Spot"
                }
            },
            {
                title = "Thornwood Forest",
                entries = {
                    "Ahib Salun Wolf Spearmaiden", "Ahib Salun Bear Spearmaiden", "Ahib Dark Mage", "Eye of Wrath",
                    "Eye of Despair", "Eye of Agony", "Ahib Dark Champion", "Ahib Condemner", "Ahib Dark Chaser",
                    "Ahib Beast Trainer"
                }
            },
            {
                title = "Olun's Valley",
                entries = {
                    "Indomitable Golem", "Olun's Golem", "Rock Golem", "Boulder Golem", "Olun's Power Tower",
                    "Olun's Statue", "Olun's Heart"
                }
            }
        }
    },
    {
        title = "Ecology of the Mountain of Eternal Winter",
        groups = {
            {
                title = "Okjinsinis",
                entries = {
                    "Traditional Okjinsini Brazier", "Okjinsini Stone Tomb", "Okjinsini Totem", "Jade Lamp",
                    "Okjinsini Brazier Keeper", "Okjinsini Lamp Keeper", "Okjinsini Winter Keeper"
                }
            },
            {
                title = "Beasts",
                entries = {
                    "Snowfield Black Yak", "Frost-tail Weasel", "Snowfield Yak", "Snowflake Stoneback Crab",
                    "Snowfield Markhor", "Snow Leopard", "Winter Bear", "Snowfield Ili Pika", "Frost Wolf"
                }
            },
            {
                title = "Murrowak's Labyrinth",
                entries = {
                    "Murrowak Burrow", "Murraska", "Ironclad Murraska"
                }
            },
            {
                title = "Winter Tree Fossil",
                entries = {
                    "Takium", "Panyalla", "Komau", "Breukia", "Winter Nest Treant", "Titika", "Winter Root Treant"
                }
            },
            {
                title = "Erekhan",
                entries = {
                    "Erekhantus", "Erekhantus", "Erekhantus", "Erekhantus"
                }
            }
        }
    },
    {
        title = "Ecology of Ulukita",
        groups = {
            {
                title = "City of the Dead",
                entries = {
                    "Tehmelun Messengers", "Tehmelun Military Dogs", "Tehmelun Creed Knight",
                    "Tehmelun Elite Soldier", "Tehmelun Seeker"
                }
            },
            {
                title = "Tungrad Ruins",
                entries = {
                    "Tungrad Putarek", "Tungrad Executioner", "Tungrad Visionary", "Tungrad Ascetic"
                }
            },
            {
                title = "Darkseekers' Retreat",
                entries = {
                    "Vengeful Darkseeker", "Punitive Darkseeker", "Mournful Darkseeker", "Eternal Darkseeker"
                }
            },
            {
                title = "Yzrahid Highlands",
                entries = {
                    "Seculion's Leg", "Navis", "Kilar", "Lehar", "Seculion"
                }
            }
        }
    },
    {
        title = "Ecology of Morning Light",
        groups = {
            {
                title = "Honglim Base",
                entries = {
                    "Fox Bandit Boss", "Boar Bandit", "Raccoon Bandit", "Fox Bandit", "Lynx Bandit"
                }
            },
            {
                title = "Dokkebi Forest",
                entries = {
                    "Combatkebi", "Philosophkebi", "Strongkebi", "Prankkebi"
                }
            },
            {
                title = "Golden Pig Cave",
                entries = {
                    "Raider Golden Pig", "Elite Golden Pig"
                }
            }
        }
    },
    {
        title = "Ecology of Edania",
        groups = {
            {
                title = "Ecology of Aetherion",
                entries = {
                    "Darktouched Spirit Knight", "Possessed Muraka", "Mutated Muraka", "Black Wings",
                    "Black Spirit-consumed Blader", "Black Spirit-consumed Mercenary", "Darktouched Young Spirit",
                    "Darktouched Root Spirit", "Darktouched Spirit Shaman"
                }
            },
            {
                title = "Ecology of Orbita",
                entries = {
                    "Black Spirit-consumed Knight", "Black Spirit-consumed Valkyrie", "Gravewarden of Dusk",
                    "Gravewarden of Dawn", "Gravekeeper Golem", "Titan", "Fallen Valkyrie"
                }
            },
            {
                title = "Ecology of Nymphamaré",
                entries = {
                    "Black Spirit-consumed Mermaid", "Coral Naga Trickster", "Coral Naga Frontliner",
                    "Coral Naga Chief Shaman", "Coral Naga Lookout", "Winged Mermaid", "Coral Dreamfish"
                }
            },
            {
                title = "Ecology of Tenebraum",
                entries = {
                    "Black Spirit-consumed Successor", "Black Spirit-consumed Sorceress", "Remnant of the Seer",
                    "Remnant of the Watcher", "Remnant of the Architect", "Manticore"
                }
            },
            {
                title = "Ecology of Zephyros",
                entries = {
                    "Black Spirit-consumed Archer", "Thebe", "Metis", "Beelzebub",
                    "Zephyros Shadow Knight", "Zephyros Shadow Priest"
                }
            },
            {
                title = "Ecology of Outer Edania",
                entries = {
                    "Coral Stoneback Crab", "Golden Leaf Snake", "Cliffside Mountain Sheep", "Rock Elephant"
                }
            }
        }
    }
}

local function DrawEcologySections()
    local actors = Pyx.Game.Actors.GetList() or {}
    ESP.RefreshActorNames(actors)
    ESP.RefreshEcologyGrades(actors)

    local gradeByName = {}
    for _, actor in ipairs(actors) do
        local actorName = ESP.GetActorDisplayName(actor, ESP.GetConfig(actor.Type))
        local actorNk = ESP.NormalizeName(actorName)
        if actorNk ~= "" then
            local g = ESP.GetDisplayGrade(ESP.GetEcologyGrade(actor))
            if g ~= "N/A" then
                gradeByName[actorNk] = g
            elseif gradeByName[actorNk] == nil then
                gradeByName[actorNk] = "N/A"
            end
        end
    end

    if type(ESP.RefreshKnowledgeNameGradeIndex) == "function" then
        ESP.RefreshKnowledgeNameGradeIndex()
    end

    for nk, g in pairs(ESP.State.KnowledgeNameGradeIndex or {}) do
        if g ~= "N/A" then
            gradeByName[nk] = ESP.KeepBestGrade(gradeByName[nk], g)
        end
    end

    for i, section in ipairs(ESP.EcologySections or {}) do
        ImGui.PushID(50000 + i)
        local sectionTitle = tostring(section.title)
        local regionKey = ESP.NormalizeName(sectionTitle)
        local regionMap = ESP.State.OpenRegionHeaders or {}
        ESP.State.OpenRegionHeaders = regionMap
        local regionOpen = regionMap[regionKey] == true
        local regionArrow = regionOpen and "▼" or "▶"
        if ImGui.Selectable(string.format("%s %s", regionArrow, sectionTitle), false) then
            regionMap[regionKey] = not regionOpen
            regionOpen = not regionOpen
            ESP.RequestSave()
        end
        if regionOpen then
            ImGui.PushStyleColor(ImGuiCol_Button, ImVec4(1.00, 0.95, 0.10, 1.0))
            ImGui.PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(1.00, 0.98, 0.30, 1.0))
            ImGui.PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0.92, 0.82, 0.00, 1.0))
            ImGui.PushStyleColor(ImGuiCol_Text, ImVec4(0.00, 0.00, 0.00, 1.0))
            if ImGui.Button("Enable ESP for all") then
                ESP.ClearFocusSelection()
            end
            ImGui.PopStyleColor(4)

            for j, subgroup in ipairs(section.groups or {}) do
                ImGui.PushID(j)
                local subgroupIsTable = (type(subgroup) == "table")
                if subgroupIsTable or type(subgroup) == "string" then
                    local subTitle = subgroupIsTable and tostring(subgroup.title or "Unnamed") or tostring(subgroup)
                    local subgroupEntries = subgroupIsTable and (subgroup.entries or {}) or {}
                    local sCount = 0
                    local totalCount = 0
                    for _, entry in ipairs(subgroupEntries) do
                        local entryNk = ESP.NormalizeName(tostring(entry))
                        if entryNk ~= "" then
                            totalCount = totalCount + 1
                            local g = ESP.GetDisplayGrade(gradeByName[entryNk] or "N/A")
                            if g == "S" then
                                sCount = sCount + 1
                            end
                        end
                    end
                    local headerTitle = subgroupIsTable and string.format("%s %d/%d", subTitle, sCount, totalCount) or subTitle
                    local subKey = ESP.NormalizeName(tostring(section.title) .. "|" .. subTitle)
                    local openMap = ESP.State.OpenSubHeaders or {}
                    ESP.State.OpenSubHeaders = openMap
                    local isOpen = openMap[subKey] == true
                    local arrow = isOpen and "▼" or "▶"
                    if ImGui.Selectable(string.format("%s %s", arrow, headerTitle), false) then
                        openMap[subKey] = not isOpen
                        isOpen = not isOpen
                        ESP.RequestSave()
                    end
                    if isOpen then

                        ImGui.PushStyleColor(ImGuiCol_Button, ImVec4(1.00, 0.95, 0.10, 1.0))
                        ImGui.PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(1.00, 0.98, 0.30, 1.0))
                        ImGui.PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0.92, 0.82, 0.00, 1.0))
                        ImGui.PushStyleColor(ImGuiCol_Text, ImVec4(0.00, 0.00, 0.00, 1.0))
                        if ImGui.Button("Enable ESP for all") then
                            ESP.ClearFocusSelection()
                        end
                        ImGui.PopStyleColor(4)

                        local navigateTargets = {
                            [ESP.NormalizeName("Baby Boar")] = { x = 11738.64, y = -2948.78, z = 45980.24 },
                            [ESP.NormalizeName("Stoneback Crab")] = { x = 40572.60, y = -3996.76, z = 53148.59 },
                            [ESP.NormalizeName("Balenos Bear")] = { x = 11560.02, y = -2189.51, z = 42207.95 },
                            [ESP.NormalizeName("Boar")] = { x = 14956.43, y = -3465.37, z = 48598.25 },
                            [ESP.NormalizeName("Grass Beetle")] = { x = 9494.65, y = -5434.21, z = 68320.73 },
                            [ESP.NormalizeName("Fox")] = { x = -51030.46, y = -4079.80, z = 48864.89 },
                            [ESP.NormalizeName("Gray Fox")] = { x = -73958.52, y = -3546.20, z = 77744.59 },
                            [ESP.NormalizeName("Weasel")] = { x = -54553.86, y = -2953.74, z = 66683.91 },
                            [ESP.NormalizeName("Parasitic Bee")] = { x = 10798.90, y = -4312.64, z = 62409.11 },
                            [ESP.NormalizeName("Gray Boar")] = { x = -38802.37, y = -2752.55, z = 33240.81 },
                            [ESP.NormalizeName("Gray Wolf")] = { x = -34593.20, y = -861.16, z = 16395.49 },
                            [ESP.NormalizeName("Wolf")] = { x = -34181.14, y = -2950.12, z = 52599.30 },
                            [ESP.NormalizeName("Serendia Elk")] = { x = 49431.34, y = 686.67, z = -140733.45 },
                            [ESP.NormalizeName("Serendia Wolf")] = { x = 79073.57, y = 3122.33, z = -112608.55 },
                            [ESP.NormalizeName("Serendia Bear")] = { x = 80170.65, y = 6134.43, z = -120474.80 },
                            [ESP.NormalizeName("Big Horn Triangle Head Salamander")] = { x = -48091.75, y = -1715.23, z = -105351.20 },
                            [ESP.NormalizeName("Fan Flamingo Nest")] = { x = 48843.79, y = -3092.35, z = -74428.27 },
                            [ESP.NormalizeName("Swamp Hermit Crab")] = { x = 49758.70, y = -3077.39, z = -70581.16 },
                            [ESP.NormalizeName("Grassback Crab")] = { x = -44351.57, y = -1638.79, z = -74604.73 },
                            [ESP.NormalizeName("Kuku Bird Nest")] = { x = -10958.95, y = 586.77, z = -9112.35 },
                            [ESP.NormalizeName("Sheep")] = { x = -41094.86, y = 7572.66, z = -5600.38 },
                            [ESP.NormalizeName("Rainbow Lizard")] = { x = -11666.94, y = -1625.56, z = -58541.54 },
                            [ESP.NormalizeName("Lamb")] = { x = -24037.70, y = 5889.44, z = 733.74 },
                            [ESP.NormalizeName("Mountain Sheep")] = { x = -30294.10, y = 6620.24, z = -10820.59 },
                            [ESP.NormalizeName("Scary Salamander")] = { x = -89789.16, y = -1859.06, z = -119047.63 },
                            [ESP.NormalizeName("Serendia Mountain Sheep")] = { x = 34470.21, y = 1582.70, z = 31597.52 },
                            [ESP.NormalizeName("Small Salamander")] = { x = 48373.35, y = -655.36, z = -91651.55 },
                            [ESP.NormalizeName("Fan Flamingo")] = { x = 54828.86, y = -3121.27, z = -77337.12 },
                            [ESP.NormalizeName("Triangle Head Lizard")] = { x = -41602.69, y = -2147.56, z = -74217.23 },
                            [ESP.NormalizeName("Kuku Bird")] = { x = -215763.55, y = -1898.23, z = -111216.02 },
                            [ESP.NormalizeName("Moss Stoneback Crab")] = { x = -52742.91, y = -807.21, z = -77298.25 },
                            [ESP.NormalizeName("Thorn Tentacle Nest")] = { x = 45129.84, y = -3135.03, z = -75317.40 },
                            [ESP.NormalizeName("Mudster")] = { x = 33657.73, y = 402.56, z = -110789.12 },
                            [ESP.NormalizeName("Mudster Swamp")] = { x = 33657.73, y = 402.56, z = -110789.12 },
                            [ESP.NormalizeName("Black Thorn Tentacle")] = { x = -21656.39, y = -2655.46, z = -86117.19 },
                            [ESP.NormalizeName("Red Thorn Tentacle")] = { x = -21656.39, y = -2655.46, z = -86117.19 },
                            [ESP.NormalizeName("Thorn Tentacle")] = { x = -21656.39, y = -2655.46, z = -86117.19 },
                            [ESP.NormalizeName("Poisonous Swamp Plant")] = { x = -2399.98, y = -214.45, z = -107289.66 },
                            [ESP.NormalizeName("Wheat Field Lookout")] = { x = 66885.83, y = -1657.02, z = -64693.52 },
                            [ESP.NormalizeName("Scarecrow Ghost")] = { x = 66885.83, y = -1657.02, z = -64693.52 },
                            [ESP.NormalizeName("Pumpkin Ghost")] = { x = 213.24, y = 294.83, z = -8473.53 },
                            [ESP.NormalizeName("Toxic Thorn Tentacle")] = { x = 46272.49, y = -3142.20, z = -75991.34 },
                            [ESP.NormalizeName("Cobweb")] = { x = -18443.07, y = 570.57, z = -123984.45 },
                            [ESP.NormalizeName("Beehive")] = { x = -12921.23, y = -445.91, z = -14459.82 },
                            [ESP.NormalizeName("Conch-Parasitic Bee")] = { x = -92354.19, y = -2167.88, z = -107276.27 },
                            [ESP.NormalizeName("Big Bush Spider")] = { x = -48920.33, y = -571.51, z = -143248.22 },
                            [ESP.NormalizeName("Bush Spider")] = { x = -48920.33, y = -571.51, z = -143248.22 },
                            [ESP.NormalizeName("Acid Spider")] = { x = -42493.89, y = -1967.33, z = -73566.70 },
                            [ESP.NormalizeName("Acid Spider Den")] = { x = 14235.90, y = 55.94, z = -77270.68 },
                            [ESP.NormalizeName("Pouch-Parasitic Bee")] = { x = 9728.50, y = -2195.15, z = -56869.15 },
                            [ESP.NormalizeName("Barrel-Parasitic Bee")] = { x = 13052.36, y = -1577.64, z = -59964.64 },
                            [ESP.NormalizeName("Tiny Bee")] = { x = -7579.06, y = -1373.24, z = -22664.98 },
                            [ESP.NormalizeName("Beetle")] = { x = -5929.69, y = 1261.47, z = -3340.20 },
                            [ESP.NormalizeName("Spider")] = { x = -12337.41, y = 222.55, z = -119456.19 },
                            [ESP.NormalizeName("Demibeast Bandit Warrior")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Raid Captain")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Giant Bandit")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Archer")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Warrior")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Trap")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Log Lightning Trap")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Round Hut")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Hut")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Amulet")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Watchtower")] = { x = -93419.02, y = -2750.61, z = -43756.14 },
                            [ESP.NormalizeName("Bandit Treasure Chest")] = { x = -83145.97, y = -656.99, z = -25534.13 },
                            [ESP.NormalizeName("Briar Lightning Trap")] = { x = -86397.03, y = -188.65, z = -32294.98 },
                            [ESP.NormalizeName("Trained Wolf")] = { x = -82748.62, y = -1623.45, z = -36546.09 },
                            [ESP.NormalizeName("Bandit Defense Captain")] = { x = -91119.51, y = 774.40, z = -29645.39 },
                            [ESP.NormalizeName("Bandit Treasure Wagon")] = { x = -102015.30, y = 1280.45, z = -15497.14 },
                            [ESP.NormalizeName("Bandit Large Watchtower")] = { x = -102015.30, y = 1280.45, z = -15497.14 },
                            [ESP.NormalizeName("Prison")] = { x = -100767.84, y = 1104.24, z = -15130.07 },
                            [ESP.NormalizeName("Imp Pigpen")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Imp Flag")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Altar Imp Food Wagon")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Altar Imp Barracks")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Altar Imp Fighter")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Altar Imp Trainer")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Altar Imp Scout")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Altar Imp Warrior")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Altar Imp")] = { x = -41513.19, y = -2070.86, z = -43544.38 },
                            [ESP.NormalizeName("Mine Imp Wagon")] = { x = 58429.37, y = 826.38, z = -16226.36 },
                            [ESP.NormalizeName("Mine Imp Tower")] = { x = 81090.86, y = -1604.96, z = -34442.77 },
                            [ESP.NormalizeName("Strong Altar Imp Trainer")] = { x = -54263.71, y = -2893.56, z = -49791.59 },
                            [ESP.NormalizeName("Altar Imp Prison")] = { x = -42105.55, y = 3947.18, z = -23534.41 },
                            [ESP.NormalizeName("Swamp Fogan Giant Tower")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Small Swamp Fogan")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Big Swamp Fogan")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Fogan Food Depot")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Fogan Defense Tower")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Fogan Amulet")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Fogan Archer Dugout")] = { x = -10230.09, y = -2202.23, z = -135750.64 },
                            [ESP.NormalizeName("Fogan Hatchling")] = { x = 26489.24, y = -2189.34, z = -130583.12 },
                            [ESP.NormalizeName("Swamp Fogan Warrior")] = { x = 8912.17, y = -2173.28, z = -119752.47 },
                            [ESP.NormalizeName("Swamp Fogan Egg")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Swamp Fogan Fortuneteller")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Swamp Fogan Lookout")] = { x = 11832.42, y = -2137.12, z = -118773.83 },
                            [ESP.NormalizeName("Swamp Fogan Guard")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Swamp Fogan")] = { x = 17110.68, y = -2204.50, z = -125565.26 },
                            [ESP.NormalizeName("Swamp Naga Axeman")] = { x = -32049.63, y = -2432.71, z = -114208.36 },
                            [ESP.NormalizeName("Swamp Naga Apprentice Axeman")] = { x = -32049.63, y = -2432.71, z = -114208.36 },
                            [ESP.NormalizeName("Swamp Naga Apprentice Spearman")] = { x = -32049.63, y = -2432.71, z = -114208.36 },
                            [ESP.NormalizeName("Swamp Naga")] = { x = -32049.63, y = -2432.71, z = -114208.36 },
                            [ESP.NormalizeName("Swamp Naga Commander")] = { x = -30916.51, y = -2299.54, z = -110627.23 },
                            [ESP.NormalizeName("Naga Guard Tower")] = { x = -2595.35, y = -191.42, z = -101123.11 },
                            [ESP.NormalizeName("Naga Hut")] = { x = -93.28, y = -292.60, z = -99831.64 },
                            [ESP.NormalizeName("Ambushed Naga")] = { x = 36663.01, y = -3551.67, z = -50239.04 },
                            [ESP.NormalizeName("Red Orc Shamanic Cauldron")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Red Orc Prison")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Red Orc Giant Altar")] = { x = -69440.98, y = -400.57, z = -102566.06 },
                            [ESP.NormalizeName("Firebreathing Orc Cannon")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Red Orc Hut")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Long Red Orc")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Orc Mushroom Brazier")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Orc Large Cauldron")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Small Red Orc Warrior")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Small Red Orc")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Red Orc Fighter")] = { x = -78271.80, y = -505.75, z = -110437.70 },
                            [ESP.NormalizeName("Red Orc Berserker")] = { x = -74670.19, y = -356.41, z = -108269.57 },
                            [ESP.NormalizeName("Firewood Orc")] = { x = -71254.07, y = -362.14, z = -109742.06 },
                            [ESP.NormalizeName("Red Orc Elite Soldier")] = { x = -71254.07, y = -362.14, z = -109742.06 },
                            [ESP.NormalizeName("Red Orc Wizard")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Red Orc Warrior")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Red Orc")] = { x = -76775.43, y = -276.44, z = -115872.98 },
                            [ESP.NormalizeName("Rebel Barricade")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Rebel Supply")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Rebel Barracks")] = { x = 89980.54, y = -1614.86, z = -86752.91 },
                            [ESP.NormalizeName("Elite Guard")] = { x = 101052.06, y = -476.01, z = -109968.12 },
                            [ESP.NormalizeName("Elite Infantry")] = { x = 101052.06, y = -476.01, z = -109968.12 },
                            [ESP.NormalizeName("Rebel Flag")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Rebel Watchtower")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Wizard")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Patrol")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Vanguard")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Infantry")] = { x = 81852.50, y = -1484.84, z = -89927.97 },
                            [ESP.NormalizeName("Wicked Cultist")] = { x = 312.27, y = -1488.72, z = -128923.13 },
                            [ESP.NormalizeName("Cultist Flag")] = { x = -21458.18, y = 1923.49, z = -166612.53 },
                            [ESP.NormalizeName("Cultist Giant Warrior")] = { x = -21458.18, y = 1923.49, z = -166612.53 },
                            [ESP.NormalizeName("Cultist Stone Statue")] = { x = -26611.43, y = 3225.24, z = -166774.84 },
                            [ESP.NormalizeName("Cultist Shaman")] = { x = -21458.18, y = 1923.49, z = -166612.53 },
                            [ESP.NormalizeName("Cultist Warrior")] = { x = -21458.18, y = 1923.49, z = -166612.53 },
                            [ESP.NormalizeName("Cultist")] = { x = -21458.18, y = 1923.49, z = -166612.53 },
                            [ESP.NormalizeName("Cultist Assassin")] = { x = -11509.52, y = 3862.98, z = -172597.42 },
                            [ESP.NormalizeName("Altar of Blood")] = { x = 39877.80, y = 1472.44, z = -164143.75 },
                            [ESP.NormalizeName("Serendia Shrine Warrior")] = { x = 45179.19, y = 718.34, z = -174650.70 },
                            [ESP.NormalizeName("Serendia Shrine Priest")] = { x = 45179.19, y = 718.34, z = -174650.70 },
                            [ESP.NormalizeName("Serendia Shrine Priestess")] = { x = 45179.19, y = 718.34, z = -174650.70 },
                            [ESP.NormalizeName("Serendia Shrine Wizard")] = { x = 53624.01, y = 652.28, z = -190963.28 },
                            [ESP.NormalizeName("Serendia Shrine Victim")] = { x = 53624.01, y = 652.28, z = -190963.28 },
                            [ESP.NormalizeName("Kzarka, the Lord of Corruption")] = { x = 53624.01, y = 652.28, z = -190963.28 },
                            [ESP.NormalizeName("Dwarf Miner")] = { x = -67004.28, y = -3336.47, z = -103821.94 },
                            [ESP.NormalizeName("Shadow Knight")] = { x = -73506.21, y = -4645.68, z = -94206.43 },
                            [ESP.NormalizeName("Shadow Priestess")] = { x = -73506.21, y = -4645.68, z = -94206.43 },
                            [ESP.NormalizeName("Shadow Wizard")] = { x = -77208.27, y = -4646.10, z = -99341.34 },
                            [ESP.NormalizeName("Ambushing Stone Spider")] = { x = -119656.64, y = 3291.71, z = -153855.61 },
                            [ESP.NormalizeName("Mutant Gargoyle")] = { x = -292386.75, y = 8982.65, z = -270816.53 },
                            [ESP.NormalizeName("Brown Bear")] = { x = -347091.56, y = 13243.95, z = -273109.88 },
                            [ESP.NormalizeName("Sharp Rock Spider")] = { x = -160247.52, y = 468.12, z = -106853.60 },
                            [ESP.NormalizeName("Mature Stone Rat")] = { x = -166458.34, y = -1772.95, z = -180145.23 },
                            [ESP.NormalizeName("Young Stone Rat")] = { x = -166458.34, y = -1772.95, z = -180145.23 },
                            [ESP.NormalizeName("Spotted Deer")] = { x = -191456.80, y = 4680.36, z = 39577.99 },
                            [ESP.NormalizeName("Female Elk")] = { x = -293172.50, y = 8201.98, z = -253357.67 },
                            [ESP.NormalizeName("Young Elk")] = { x = -293172.50, y = 8201.98, z = -253357.67 },
                            [ESP.NormalizeName("Elk")] = { x = -293172.50, y = 8201.98, z = -253357.67 },
                            [ESP.NormalizeName("Baby Waragon")] = { x = -192754.95, y = -1139.91, z = 13271.62 },
                            [ESP.NormalizeName("Waragon")] = { x = -192754.95, y = -1139.91, z = 13271.62 },
                            [ESP.NormalizeName("Waragon Egg")] = { x = -192754.95, y = -1139.91, z = 13271.62 },
                            [ESP.NormalizeName("Explosive Waragon")] = { x = -192754.95, y = -1139.91, z = 13271.62 },
                            [ESP.NormalizeName("Calpheon Worm")] = { x = -192754.95, y = -1139.91, z = 13271.62 },
                            [ESP.NormalizeName("Farm Boar")] = { x = -194623.80, y = -1385.68, z = 275.28 },
                            [ESP.NormalizeName("Brown Raccoon")] = { x = -194623.80, y = -1385.68, z = 275.28 },
                            [ESP.NormalizeName("Locust Swarm")] = { x = -203163.61, y = -1388.61, z = -781.98 },
                            [ESP.NormalizeName("Plantation Big Mole")] = { x = -204762.77, y = -1455.80, z = -8885.80 },
                            [ESP.NormalizeName("Plantation Small Mole")] = { x = -204762.77, y = -1455.80, z = -8885.80 },
                            [ESP.NormalizeName("Bat")] = { x = -182983.36, y = -2045.47, z = -133173.02 },
                            [ESP.NormalizeName("Mountain Lamb")] = { x = -179198.19, y = 7541.64, z = -193685.80 },
                            [ESP.NormalizeName("Blue Lizard")] = { x = -255302.05, y = -1821.66, z = -135457.86 },
                            [ESP.NormalizeName("Calpheon Beetle")] = { x = -135763.72, y = 1809.43, z = -124797.51 },
                            [ESP.NormalizeName("Rhino Lizard")] = { x = -198391.03, y = 4150.87, z = -217293.56 },
                            [ESP.NormalizeName("Stone Rat")] = { x = -157940.02, y = -1107.78, z = -186229.31 },
                            [ESP.NormalizeName("Red Boar")] = { x = -344983.44, y = 12978.93, z = -271149.75 },
                            [ESP.NormalizeName("Young Red Boar")] = { x = -349065.94, y = 13528.90, z = -274067.38 },
                            [ESP.NormalizeName("Red Boar's Den")] = { x = -344983.44, y = 12978.93, z = -271149.75 },
                            [ESP.NormalizeName("Iguana")] = { x = -185626.59, y = 1877.94, z = -201678.16 },
                            [ESP.NormalizeName("Stone Crab")] = { x = -133637.47, y = 2740.60, z = -117103.59 },
                            [ESP.NormalizeName("Big House-Parasitic Bee")] = { x = -142459.39, y = -1513.65, z = -138890.03 },
                            [ESP.NormalizeName("Rainbow Fox")] = { x = -209877.61, y = 2027.13, z = -94418.16 },
                            [ESP.NormalizeName("Stonescale Devourer")] = { x = -234332.11, y = 224.94, z = -188207.25 },
                            [ESP.NormalizeName("Spotted Hyena")] = { x = -154568.84, y = 2919.25, z = -242640.38 },
                            [ESP.NormalizeName("Red Bear")] = { x = -350467.00, y = 389.81, z = -89072.96 },
                            [ESP.NormalizeName("Ferocious Weasel")] = { x = -397009.88, y = 6096.36, z = -186381.97 },
                            [ESP.NormalizeName("Long-haired Water Buffalo")] = { x = -167487.20, y = 751.74, z = 13258.60 },
                            [ESP.NormalizeName("Kuku Hatchling")] = { x = -226761.19, y = 1743.53, z = -101001.48 },
                            [ESP.NormalizeName("Toxic Cave Plant")] = { x = -182983.36, y = -2045.47, z = -133173.02 },
                            [ESP.NormalizeName("Treant Crystal Tree")] = { x = -402679.56, y = 7609.27, z = -191108.44 },
                            [ESP.NormalizeName("Lazy Tree Spirit")] = { x = -161140.38, y = 748.66, z = -71438.91 },
                            [ESP.NormalizeName("Tough Tree Spirit")] = { x = -159688.42, y = 1976.42, z = -60962.18 },
                            [ESP.NormalizeName("Owl Treant")] = { x = -382369.03, y = 5330.42, z = -180696.45 },
                            [ESP.NormalizeName("Small Treant")] = { x = -382369.03, y = 5330.42, z = -180696.45 },
                            [ESP.NormalizeName("Scream Treant")] = { x = -382369.03, y = 5330.42, z = -180696.45 },
                            [ESP.NormalizeName("Treant Stub")] = { x = -377691.81, y = 6499.28, z = -187713.97 },
                            [ESP.NormalizeName("Treant Spirit")] = { x = -369879.69, y = 7517.61, z = -194287.11 },
                            [ESP.NormalizeName("Rooted Old Wood Treant")] = { x = -369879.69, y = 7517.61, z = -194287.11 },
                            [ESP.NormalizeName("Twin-Headed Treant")] = { x = -369879.69, y = 7517.61, z = -194287.11 },
                            [ESP.NormalizeName("Root Treant")] = { x = -369879.69, y = 7517.61, z = -194287.11 },
                            [ESP.NormalizeName("Old Tree Treant")] = { x = -369879.69, y = 7517.61, z = -194287.11 },
                            [ESP.NormalizeName("Khuruto Soldier")] = { x = -167707.45, y = -643.99, z = -1079.55 },
                            [ESP.NormalizeName("Khuruto Pot")] = { x = -167707.45, y = -643.99, z = -1079.55 },
                            [ESP.NormalizeName("Khuruto Fighter")] = { x = -167707.45, y = -643.99, z = -1079.55 },
                            [ESP.NormalizeName("Khuruto Wooden Totem")] = { x = -167707.45, y = -643.99, z = -1079.55 },
                            [ESP.NormalizeName("Khuruto Elite Soldier")] = { x = -167707.45, y = -643.99, z = -1079.55 },
                            [ESP.NormalizeName("Small Khuruto")] = { x = -167707.45, y = -643.99, z = -1079.55 },
                            [ESP.NormalizeName("Khuruto Tent")] = { x = -162951.88, y = -182.21, z = 3950.99 },
                            [ESP.NormalizeName("Khuruto Ration Depot")] = { x = -163985.56, y = -22.72, z = -10.42 },
                            [ESP.NormalizeName("Khuruto Prison")] = { x = -158731.80, y = 443.64, z = 376.55 },
                            [ESP.NormalizeName("Khuruto Resting Area")] = { x = -158731.80, y = 443.64, z = 376.55 },
                            [ESP.NormalizeName("Khuruto Shaman")] = { x = -156541.78, y = 1167.25, z = -9201.21 },
                            [ESP.NormalizeName("Khuruto Amulet")] = { x = -159780.41, y = -5007.00, z = -20709.80 },
                            [ESP.NormalizeName("Khuruto Sacrifice")] = { x = -160760.12, y = -4590.52, z = -22425.19 },
                            [ESP.NormalizeName("Plain Stoneback Crab")] = { x = -70121.57, y = -2858.44, z = 80963.66 },
                            [ESP.NormalizeName("Mature Tree Spirit")] = { x = -49738.61, y = -4270.30, z = 26561.13 },
                            [ESP.NormalizeName("Immature Tree Spirit")] = { x = -49458.45, y = -4263.28, z = 25150.95 },
                            [ESP.NormalizeName("Small Tree Spirit")] = { x = -48776.53, y = -4209.69, z = 28618.30 },
                            [ESP.NormalizeName("Cron Castle Barricade")] = { x = 21111.30, y = 1152.14, z = 122891.34 },
                            [ESP.NormalizeName("Cron Castle Supply")] = { x = 21111.30, y = 1152.14, z = 122891.34 },
                            [ESP.NormalizeName("Senior Soldier")] = { x = 21111.30, y = 1152.14, z = 122891.34 },
                            [ESP.NormalizeName("Operation Chief")] = { x = 11428.51, y = 3587.30, z = 134982.56 },
                            [ESP.NormalizeName("Scout")] = { x = 21111.30, y = 1152.14, z = 122891.34 },
                            [ESP.NormalizeName("Rookie Soldier")] = { x = 21111.30, y = 1152.14, z = 122891.34 },
                            [ESP.NormalizeName("Cron Castle Flag")] = { x = 21111.30, y = 1152.14, z = 122891.34 },
                            [ESP.NormalizeName("Cron Castle Watchtower")] = { x = 21111.30, y = 1152.14, z = 122891.34 },
                            [ESP.NormalizeName("Red Foot Assassin")] = { x = -348780.31, y = -7133.07, z = 382757.03 },
                            [ESP.NormalizeName("Deck Elite Combatant")] = { x = -348780.31, y = -7133.07, z = 382757.03 },
                            [ESP.NormalizeName("Deck Combatant")] = { x = -348780.31, y = -7133.07, z = 382757.03 },
                            [ESP.NormalizeName("Elite Sentinel")] = { x = -348780.31, y = -7133.07, z = 382757.03 },
                            [ESP.NormalizeName("Cox Elite Gladiator")] = { x = -348780.31, y = -7133.07, z = 382757.03 },
                            [ESP.NormalizeName("Pirate Treasure Chest")] = { x = -342263.78, y = -6825.35, z = 379972.31 },
                            [ESP.NormalizeName("Drunk Treasure Hunter")] = { x = -342263.78, y = -6825.35, z = 379972.31 },
                            [ESP.NormalizeName("Pirate Watchtower")] = { x = -342263.78, y = -6825.35, z = 379972.31 },
                            [ESP.NormalizeName("Cox Prison")] = { x = -351093.62, y = -4437.81, z = 392767.09 },
                            [ESP.NormalizeName("Crazy Jack")] = { x = -351093.62, y = -4437.81, z = 392767.09 },
                            [ESP.NormalizeName("Pirate Flag")] = { x = -348794.69, y = -4574.67, z = 392322.94 },
                            [ESP.NormalizeName("Iron Combatant")] = { x = -350264.16, y = -5672.31, z = 408364.12 },
                            [ESP.NormalizeName("Megimegi")] = { x = -358954.81, y = -5067.32, z = 325789.00 },
                            [ESP.NormalizeName("One-Eyed Outlaw")] = { x = -358954.81, y = -5067.32, z = 325789.00 },
                            [ESP.NormalizeName("Captain Khuru")] = { x = -358954.81, y = -5067.32, z = 325789.00 },
                            [ESP.NormalizeName("Cox Elite Warrior")] = { x = 43062.83, y = -6785.12, z = 209263.41 },
                            [ESP.NormalizeName("Cox Female Warrior")] = { x = 43062.83, y = -6785.12, z = 209263.41 },
                            [ESP.NormalizeName("Cox Raider")] = { x = 43062.83, y = -6785.12, z = 209263.41 },
                            [ESP.NormalizeName("Cox Warrior")] = { x = 43062.83, y = -6785.12, z = 209263.41 },
                            [ESP.NormalizeName("Bumblin' Outlaw")] = { x = -166650.42, y = -7089.53, z = 166199.88 },
                            [ESP.NormalizeName("Bumblin' Buccaneers Barracks")] = { x = -181092.33, y = -4886.47, z = 155047.69 },
                            [ESP.NormalizeName("Bumblin' Megimegi")] = { x = -166650.42, y = -7089.53, z = 166199.88 },
                            [ESP.NormalizeName("Bumblin' Combatant")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Buccaneer's Flag")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Captain")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Watchtower")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Cannoneer")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Elite Warrior")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Female Warrior")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Raider")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Warrior")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Assassin")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Madcap")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Watchman")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Sniper")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Bumblin' Gladiator")] = { x = -161362.67, y = -4594.54, z = 152680.39 },
                            [ESP.NormalizeName("Kaz Protty")] = { x = 44914.70, y = -15890.92, z = 260106.61 },
                            [ESP.NormalizeName("Zera Protty")] = { x = 33245.82, y = -14416.91, z = 261930.03 },
                            [ESP.NormalizeName("Protty")] = { x = 33245.82, y = -14416.91, z = 261930.03 },
                            [ESP.NormalizeName("Protty Ootheca")] = { x = 33245.82, y = -14416.91, z = 261930.03 },
                            [ESP.NormalizeName("Black Crystal Seaweed")] = { x = 33245.82, y = -14416.91, z = 261930.03 },
                            [ESP.NormalizeName("Ocean Crystal Seaweed")] = { x = 44914.70, y = -15890.92, z = 260106.61 },
                            [ESP.NormalizeName("Sid Protty")] = { x = 54791.33, y = -19692.51, z = 256545.31 },
                            [ESP.NormalizeName("Sycrak")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Sycrid")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Eyes of the Deep Sea")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Tower of Restoration")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Force Field Defender")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Damaged Lykin")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Damaged Pirash")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Elmermol")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Kureba")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Lykin")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Pirash")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Damaged Kureba")] = { x = 135624.00, y = -28176.00, z = 444780.00 },
                            [ESP.NormalizeName("Imp Altar")] = { x = -66199.84, y = -2604.58, z = 80372.28 },
                            [ESP.NormalizeName("Imp Defense Tower")] = { x = -66199.84, y = -2604.58, z = 80372.28 },
                            [ESP.NormalizeName("Steel Imp Wizard")] = { x = -66199.84, y = -2604.58, z = 80372.28 },
                            [ESP.NormalizeName("Steel Imp Warrior")] = { x = -66199.84, y = -2604.58, z = 80372.28 },
                            [ESP.NormalizeName("Steel Imp")] = { x = -66199.84, y = -2604.58, z = 80372.28 },
                            [ESP.NormalizeName("Imp Amulet")] = { x = -64867.35, y = -3477.09, z = 66072.58 },
                            [ESP.NormalizeName("Imp Wizard")] = { x = -64867.35, y = -3477.09, z = 66072.58 },
                            [ESP.NormalizeName("Imp Raider")] = { x = -64867.35, y = -3477.09, z = 66072.58 },
                            [ESP.NormalizeName("Imp Soldier")] = { x = -64867.35, y = -3477.09, z = 66072.58 },
                        }
                        local islandSeenHint = "Seen on Taramura Island, Paratama Island, Mariveno Island, Delinghart Island, Eveto Island and Marlene Island"
                        local cobwebHint = "Can be obtained from Amaranto for 200+ amity."
                        local beehiveHint = "Shoot them with a matchlock"
                        local spiderHint = "Knowledge from Allan in Glisch. Amity from 250."
                        local altarImpPrisonHint = "climb half way up the wizard tower and attack the prison cages"
                        local wickedCultistHint = "Get 30 amity with Carlo DeRose (south east of Glish). Pick up the Wicked Cultist quest and then they will spawn nearby at night time (22:00 - 07:00)"
                        local cultistAssassinHint = "Once you have finished this quest in the main story [Witch Story] Cultist Subjugation, you can get the knowledge from Annalyn."
                        local ambushingStoneSpiderHint = "Stand near the little cave burrow holes opening and they should come out."
                        local brownBearHint = "they spawn scattered starting here and to the east a bit"
                        local waragonHint = "This is the coordinates to the cave entrance"
                        local batHint = "Call your horse underneath the bats to make them come down"
                        local toxicCavePlantHint = "Plants are inside the cave"
                        local khurutoCaveHint = "Inside Khuruto Cave"
                        local sidProttyHint = "When the parasitic sid protties spawn, you need to damage them but don't kill them and follow them around as they move. After they move for a little while they should evolve."
                        local entryHints = {
                            [ESP.NormalizeName("Cobweb")] = cobwebHint,
                            [ESP.NormalizeName("Beehive")] = beehiveHint,
                            [ESP.NormalizeName("Altar Imp Prison")] = altarImpPrisonHint,
                            [ESP.NormalizeName("Wicked Cultist")] = wickedCultistHint,
                            [ESP.NormalizeName("Cultist Assassin")] = cultistAssassinHint,
                            [ESP.NormalizeName("Ambushing Stone Spider")] = ambushingStoneSpiderHint,
                            [ESP.NormalizeName("Brown Bear")] = brownBearHint,
                            [ESP.NormalizeName("Baby Waragon")] = waragonHint,
                            [ESP.NormalizeName("Waragon")] = waragonHint,
                            [ESP.NormalizeName("Waragon Egg")] = waragonHint,
                            [ESP.NormalizeName("Explosive Waragon")] = waragonHint,
                            [ESP.NormalizeName("Calpheon Worm")] = waragonHint,
                            [ESP.NormalizeName("Bat")] = batHint,
                            [ESP.NormalizeName("Toxic Cave Plant")] = toxicCavePlantHint,
                            [ESP.NormalizeName("Khuruto Amulet")] = khurutoCaveHint,
                            [ESP.NormalizeName("Khuruto Sacrifice")] = khurutoCaveHint,
                            [ESP.NormalizeName("Cox Elite Warrior")] = islandSeenHint,
                            [ESP.NormalizeName("Cox Female Warrior")] = islandSeenHint,
                            [ESP.NormalizeName("Cox Raider")] = islandSeenHint,
                            [ESP.NormalizeName("Cox Warrior")] = islandSeenHint,
                            [ESP.NormalizeName("Spider")] = spiderHint,
                        }
                        local entryNotesBelow = {
                            [ESP.NormalizeName("Sid Protty")] = sidProttyHint,
                        }
                        local goblinDefaultTarget = { x = 21660.49, y = -2191.41, z = 103528.36 }

                        local navigateCoordsByGroup = {
                            ["Goblins"] = {
                                ["Giant Goblin Totem"] = { 21660.49, -2191.41, 103528.36 },
                                ["Giant Goblin Tower"] = { 21660.49, -2191.41, 103528.36 },
                                ["Goblin Cauldron"] = { 21660.49, -2191.41, 103528.36 },
                                ["Goblin Watchtower"] = { 21660.49, -2191.41, 103528.36 },
                                ["Goblin Elite Soldier"] = { 21660.49, -2191.41, 103528.36 },
                                ["Goblin Shaman"] = { 21660.49, -2191.41, 103528.36 },
                                ["Goblin Thrower"] = { 21660.49, -2191.41, 103528.36 },
                                ["Goblin Fighter"] = { 21660.49, -2191.41, 103528.36 },
                                ["Goblin"] = { 21660.49, -2191.41, 103528.36 }
                            },
                            ["Quint Hill"] = {
                                ["Troll Warrior"] = { -303670.47, -1374.44, 12226.66 },
                                ["Troll Buff Tower"] = { -303670.47, -1374.44, 12226.66 },
                                ["Troll Protection Tower"] = { -303670.47, -1374.44, 12226.66 },
                                ["Troll Cow"] = { -305057.69, -1603.50, 21382.87 },
                                ["Troll"] = { -305057.69, -1603.50, 21382.87 },
                                ["Troll Elite Warrior"] = { -305057.69, -1603.50, 21382.87 },
                                ["Troll Thrower"] = { -305057.69, -1603.50, 21382.87 },
                                ["Troll Ration Depot"] = { -305057.69, -1603.50, 21382.87 },
                                ["Troll Hut"] = { -309162.81, -1893.63, 24423.84 },
                                ["Troll Shaman"] = { -300532.94, -1662.97, 24258.22 },
                                ["Ancient Troll"] = { -314532.44, -1210.68, 10552.16 },
                                ["Ancient Troll Warrior"] = { -314532.44, -1210.68, 10552.16 },
                                ["Ancient Troll Elite Warrior"] = { -314532.44, -1210.68, 10552.16 },
                                ["Troll Wagon"] = { -314532.44, -1210.68, 10552.16 },
                                ["Ancient Troll Shaman"] = { -321337.12, -254.80, 14677.51 },
                                ["Ancient Troll Thrower"] = { -328272.31, 12.76, 16924.17 },
                                ["Dragon Protection Tower"] = { -336849.16, -161.74, 14288.14 },
                                ["Surrendered Khuruto Soldier"] = { -286258.25, -2380.30, 3939.13 },
                                ["Surrendered Khuruto Elite Soldier"] = { -286258.25, -2380.30, 3939.13 },
                                ["Troll Catapult"] = { -286258.25, -2380.30, 3939.13 },
                                ["Troll Porter"] = { -284687.12, -1791.90, 11490.38 },
                                ["Troll Barricade"] = { -270196.00, -2670.26, 10029.82 },
                                ["Young Troll Ox"] = { -269132.22, 1963.69, 56321.03 },
                                ["Troll Siege Soldier"] = { -258720.66, -1813.34, 8897.38 }
                            },
                            ["Marni's House"] = {
                                ["Mad Screaming Orc Wizard"] = { -191449.89, 5777.82, -125489.99 },
                                ["Mad Scientist Bomb"] = { -191480.00, 5952.57, -122112.94 },
                                ["Mad Screaming Harpy"] = { -190241.16, 6105.63, -120284.55 },
                                ["Mad Screaming Orc Warrior"] = { -192547.72, 5983.59, -117673.51 },
                                ["Mad Screaming Saunil"] = { -190546.17, 6095.10, -122393.04 },
                                ["Mad Scientist Cannon"] = { -190546.17, 6095.10, -122393.04 },
                                ["Chimera"] = { -180440.27, 6141.56, -136431.41 },
                                ["Horn Chimera"] = { -180440.27, 6141.56, -136431.41 },
                                ["Orc Test Subject"] = { -185608.56, 6002.12, -135637.19 },
                                ["Unidentified Cauldron"] = { -183269.64, 6858.53, -130751.13 }
                            }
                        }

                        for eIdx, entry in ipairs(subgroupEntries) do
                            ImGui.PushID(700000 + (i * 10000) + (j * 100) + eIdx)
                            local entryName = tostring(entry)
                            local entryNk = ESP.NormalizeName(entryName)
                            local entryGrade = gradeByName[entryNk] or "N/A"
                            local subgroupCoords = navigateCoordsByGroup[subTitle] or {}
                            local navCoords = subgroupCoords[entryName]
                            local hasNavigateCoords = navCoords ~= nil
                            local isQuestOnlyEntry = (subTitle == "Goblins" and entryName == "Giath's Secret")
                            local navigateTarget = navigateTargets[entryNk]
                            if not navigateTarget and subTitle == "Goblins" and not isQuestOnlyEntry then
                                navigateTarget = goblinDefaultTarget
                            end
                            ImGui.TextColored(ESP.GetGradeColor(entryGrade), "[" .. tostring(entryGrade) .. "]")

                            ImGui.SameLine()
                            ImGui.Text(entryName)
                            if isQuestOnlyEntry then
                                ImGui.SameLine()
                                ImGui.TextColored(ImVec4(1.00, 0.90, 0.20, 1.0), "Obtained via a quest")
                            else
                                ImGui.SameLine()
                                if hasNavigateCoords then
                                    ImGui.PushStyleColor(ImGuiCol_Button, ImVec4(0.00, 0.70, 1.00, 1.0))
                                    ImGui.PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.15, 0.85, 1.00, 1.0))
                                    ImGui.PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0.00, 0.55, 0.90, 1.0))
                                    ImGui.PushStyleColor(ImGuiCol_Text, ImVec4(0.05, 0.05, 0.05, 1.0))
                                end
                                if ImGui.Button("Navigate") then
                                    if hasNavigateCoords then
                                        ESP.NavigateToLocation(navCoords[1], navCoords[2], navCoords[3])
                                    end
                                end

                                if hasNavigateCoords then
                                    ImGui.PopStyleColor(4)
                                end

                                ImGui.SameLine()
                                local isFocused = ESP.IsFocusEnabledByName(entryName)
                                local toggleLabel = isFocused and "Disable ESP" or "Enable ESP"
                                local buttonColor = isFocused and ImVec4(0.20, 0.78, 0.30, 1.0) or ImVec4(1.00, 0.95, 0.10, 1.0)
                                local buttonHoverColor = isFocused and ImVec4(0.30, 0.88, 0.40, 1.0) or ImVec4(1.00, 0.98, 0.30, 1.0)
                                local buttonActiveColor = isFocused and ImVec4(0.12, 0.65, 0.22, 1.0) or ImVec4(0.92, 0.82, 0.00, 1.0)
                                ImGui.PushStyleColor(ImGuiCol_Button, buttonColor)
                                ImGui.PushStyleColor(ImGuiCol_ButtonHovered, buttonHoverColor)
                                ImGui.PushStyleColor(ImGuiCol_ButtonActive, buttonActiveColor)
                                ImGui.PushStyleColor(ImGuiCol_Text, ImVec4(0.00, 0.00, 0.00, 1.0))
                                if ImGui.Button(toggleLabel) then
                                    if isFocused then
                                        ESP.SetFocusEnabledByName(entryName, false)
                                    else
                                        ESP.SetFocusEnabledByName(entryName, true)
                                    end
                                end
                                ImGui.PopStyleColor(4)
                                local entryHint = entryHints[entryNk]
                                if entryHint then
                                    ImGui.SameLine()
                                    ImGui.TextColored(ImVec4(1.00, 0.90, 0.20, 1.0), entryHint)
                                end
                                local entryNoteBelow = entryNotesBelow[entryNk]
                                if entryNoteBelow then
                                    ImGui.Indent(28)
                                    ImGui.PushStyleColor(ImGuiCol_Text, ImVec4(1.00, 0.90, 0.20, 1.0))
                                    ImGui.TextWrapped(entryNoteBelow)
                                    ImGui.PopStyleColor(1)
                                    ImGui.Unindent(28)
                                end
                            end
                            ImGui.PopID()
                        end
                    end
                end
                ImGui.PopID()
            end
        end
        ImGui.PopID()
    end
end

function ESP.NormalizeName(v)
    v = string.lower(tostring(v or ""))
    v = string.gsub(v, "<PA.->", "")
    v = string.gsub(v, "%b[]", "")
    v = string.gsub(v, "[^%w]", "")
    return v
end

function ESP.NowMs()
    if Infinity and Infinity.Win32 and Infinity.Win32.GetTickCount then
        return Infinity.Win32.GetTickCount()
    end
    return math.floor(os.clock() * 1000)
end

function ESP.RequestSave()
    ESP.State.SavePending = true
    ESP.State.LastSaveRequestTick = ESP.NowMs()
end

function ESP.SaveSettings()
    if not JSON then return end
    pcall(function() Pyx.FileSystem.CreateDirectory("Settings") end)

    local payload = {
        Global = {
            Enabled = ESP.Global.Enabled,
            ShowBox = ESP.Global.ShowBox,
            ShowSnaplines = ESP.Global.ShowSnaplines,
            ShowText = ESP.Global.ShowText,
            TextSizePx = ESP.Global.TextSizePx,
            ShowEcologyInfo = ESP.Global.ShowEcologyInfo,
            HideWhenDead = ESP.Global.HideWhenDead,
            ShowRadar = ESP.Global.ShowRadar,
            MaxDistance = ESP.Global.MaxDistance,
        },
        Actors = {},
        OpenSubHeaders = ESP.State.OpenSubHeaders or {},
        OpenRegionHeaders = ESP.State.OpenRegionHeaders or {}
    }

    for id, conf in pairs(ESP.Actors) do
        payload.Actors[tostring(id)] = {
            enabled = conf.enabled,
            color = { x = conf.color.x, y = conf.color.y, z = conf.color.z, w = conf.color.w }
        }
    end

    local okEnc, text = pcall(function() return JSON:encode(payload) end)
    if okEnc and text and text ~= "" then
        pcall(function() Pyx.FileSystem.WriteFile(ESP.SettingsPath, text) end)
        ESP.State.LastSaveTick = ESP.NowMs()
    end
end

function ESP.LoadSettings()
    if not JSON then return end
    local okRead, text = pcall(function() return Pyx.FileSystem.ReadFile(ESP.SettingsPath) end)
    if not okRead or not text or text == "" then return end

    local okDec, data = pcall(function() return JSON:decode(text) end)
    if not okDec or type(data) ~= "table" then return end

    if type(data.Global) == "table" then
        for k, v in pairs(data.Global) do
            if ESP.Global[k] ~= nil and type(v) ~= "table" then
                ESP.Global[k] = v
            end
        end
    end

    if type(data.Actors) == "table" then
        for id, saved in pairs(data.Actors) do
            local actorId = tonumber(id)
            local conf = actorId and ESP.Actors[actorId] or nil
            if conf and type(saved) == "table" then
                if type(saved.enabled) == "boolean" then conf.enabled = saved.enabled end
                if type(saved.color) == "table" then
                    local c = saved.color
                    local x, y, z, w = tonumber(c.x), tonumber(c.y), tonumber(c.z), tonumber(c.w)
                    if x and y and z and w then conf.color = ImVec4(x, y, z, w) end
                end
            end
        end
    end

    if type(data.OpenSubHeaders) == "table" then
        ESP.State.OpenSubHeaders = data.OpenSubHeaders
    else
        ESP.State.OpenSubHeaders = {}
    end
    if type(data.OpenRegionHeaders) == "table" then
        ESP.State.OpenRegionHeaders = data.OpenRegionHeaders
    else
        ESP.State.OpenRegionHeaders = {}
    end
    ESP.State.SavePending = false
end

function ESP.GetConfig(typeID)
    return ESP.Actors[typeID] or ESP.DefaultConfig
end

function ESP.RefreshActorNames(actors)
    if type(actors) ~= "table" or #actors == 0 then return end
    local now = os.clock()
    if (now - (tonumber(ESP.State.LastActorNameRefresh) or 0)) < 1.0 then return end
    ESP.State.LastActorNameRefresh = now

    local ids = {}
    local maxLookup = math.min(#actors, 220)
    for i = 1, maxLookup do
        local a = actors[i]
        local k = a and tonumber(a.Key)
        if k and k > 0 then ids[#ids + 1] = tostring(math.floor(k)) end
    end
    if #ids == 0 then return end

    local code = string.format([=[
        local ids = {%s}
        local out = ""
        for _, id in ipairs(ids) do
            local a = getActor(id)
            if a then
                local n = ""
                pcall(function() n = tostring(a:getName() or "") end)
                n = string.gsub(n or "", "[#$|]", "")
                if n ~= "" then out = out .. tostring(id) .. "#" .. n .. "$" end
            end
        end
        return out
    ]=], table.concat(ids, ","))

    local ok, raw = pcall(function() return Pyx.Game.Execute(code) end)
    if not ok or type(raw) ~= "string" or raw == "" then return end

    local cache = ESP.State.ActorNameCache or {}
    ESP.State.ActorNameCache = cache
    for item in string.gmatch(raw, "([^$]+)") do
        local key, name = item:match("([^#]+)#(.+)")
        local keyNum = tonumber(key)
        if keyNum and name and name ~= "" then cache[keyNum] = name end
    end
end

function ESP.GetActorDisplayName(actor, conf)
    local name = tostring((actor and (actor.Name or actor.ActorName)) or (conf and conf.name) or "Unknown")
    if name == "" or name == "Unknown" or name == "Monster" or name == "Npc" then
        local key = tonumber(actor and actor.Key) or 0
        if key > 0 then
            local cached = ESP.State.ActorNameCache and ESP.State.ActorNameCache[key]
            if cached and cached ~= "" then name = tostring(cached) end
        end
    end
    return name
end

function ESP.ExtractGradeFromCardName(name)
    local s = tostring(name or "")
    if s == "" then return nil end
    local g = s:match("%[([A%+?])%]%s*<PAColor")
    if not g then g = s:match("^([A%+?])%]%s*<PAColor") end
    if not g then g = s:match("^%[([A%+?])%]") end
    return g
end

function ESP.GetKnowledgeGradeStringByActorKey(actorKey, expectedNormalizedName)
    local key = tonumber(actorKey) or 0
    if key <= 0 then return nil end
    local ok, value = pcall(function()
        return Pyx.Game.Execute(string.format([=[
            local actorKey = %d
            local function normalizeName(v)
                v = string.lower(tostring(v or ""))
                v = string.gsub(v, "<PA.->", "")
                v = string.gsub(v, "%b[]", "")
                v = string.gsub(v, "[^%w]", "")
                return v
            end
            local resolvedCharacterKey = actorKey
            local actor = getActor(actorKey)
            if nil ~= actor then
                local ck = 0
                pcall(function() ck = tonumber(actor:getCharacterKeyRaw()) or 0 end)
                if ck > 0 then
                    resolvedCharacterKey = ck
                end
            end

            local mentalCardKey = ToClient_getMentalCardKey(resolvedCharacterKey)
            if nil == mentalCardKey or 0 == mentalCardKey then
                mentalCardKey = ToClient_getMentalCardKey(actorKey)
            end
            if nil == mentalCardKey or 0 == mentalCardKey then return "" end

            local selfPlayerWrapper = getSelfPlayer()
            if nil == selfPlayerWrapper then return "" end
            local selfPlayer = selfPlayerWrapper:get()
            if nil == selfPlayer then return "" end
            local knowledge = selfPlayer:getMentalKnowledge()
            if nil == knowledge then return "" end
            local mentalCard = knowledge:getCardByKeyRaw(mentalCardKey)
            if nil == mentalCard then return "" end
            local cardName = ""
            pcall(function() cardName = tostring(mentalCard:getName() or "") end)
            local level = tonumber(mentalCard:getLevel()) or -1
            local s = PAGetString(Defines.StringSheet_GAME, "MENTAL_OBJECTCARD_" .. tostring(level - 1))
            local grade = tostring(s or "")
            if grade == "" then return "" end
            return normalizeName(cardName) .. "#" .. grade
        ]=], key))
    end)
    if not ok or type(value) ~= "string" or value == "" then return nil end
    local resolvedNormalizedName, rawGrade = tostring(value):match("([^#]*)#(.+)")
    if not resolvedNormalizedName or not rawGrade then
        return nil
    end
    local expectedNk = ESP.NormalizeName(expectedNormalizedName)
    if expectedNk ~= "" and resolvedNormalizedName ~= expectedNk then
        return nil
    end
    local g = tostring(rawGrade):gsub("<PA.->", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if g == "" then return nil end
    return g
end

function ESP.RefreshKnowledgeNameGradeIndex()
    local now = os.clock()
    if (now - (tonumber(ESP.State.LastKnowledgeIndexRefresh) or 0)) < 10.0 then
        return
    end
    ESP.State.LastKnowledgeIndexRefresh = now

    local ok, raw = pcall(function()
        return Pyx.Game.Execute([=[
            local function normalizeName(v)
                v = string.lower(tostring(v or ""))
                v = string.gsub(v, "<PA.->", "")
                v = string.gsub(v, "%b[]", "")
                v = string.gsub(v, "[^%w]", "")

                return v
            end

            local out = ""
            local selfPlayerWrapper = getSelfPlayer()
            if nil == selfPlayerWrapper then return out end
            local selfPlayer = selfPlayerWrapper:get()
            if nil == selfPlayer then return out end
            local knowledge = selfPlayer:getMentalKnowledge()
            if nil == knowledge then return out end

            local function appendCard(card)
                if nil == card then return end
                local hasCard = false
                pcall(function() hasCard = card:hasCard() end)

                if true ~= hasCard then return end

                local name = ""
                local level = -1
                pcall(function() name = tostring(card:getName() or "") end)
                pcall(function() level = tonumber(card:getLevel()) or -1 end)
                if name == "" or level < 0 then return end

                local grade = PAGetString(Defines.StringSheet_GAME, "MENTAL_OBJECTCARD_" .. tostring(level - 1))
                grade = tostring(grade or "")
                if grade == "" then return end

                local nk = normalizeName(name)
                if nk == "" then return end

                name = string.gsub(name, "[#$|]", "")
                grade = string.gsub(grade, "[#$|]", "")
                out = out .. nk .. "#" .. grade .. "$"
            end

            local function walkTheme(theme)
                if nil == theme then return end
                local childThemeCount = 0
                local childCardCount = 0
                pcall(function() childThemeCount = tonumber(theme:getChildThemeCount()) or 0 end)
                pcall(function() childCardCount = tonumber(theme:getChildCardCount()) or 0 end)

                for i = 0, childCardCount - 1 do
                    local childCard = nil
                    pcall(function() childCard = theme:getChildCardByIndex(i) end)
                    appendCard(childCard)
                end

                for i = 0, childThemeCount - 1 do
                    local childTheme = nil
                    pcall(function() childTheme = theme:getChildThemeByIndex(i) end)
                    walkTheme(childTheme)
                end
            end

            walkTheme(knowledge:getMainTheme())
            return out
        ]=])
    end)

    if not ok or type(raw) ~= "string" or raw == "" then return end

    local idx = ESP.State.KnowledgeNameGradeIndex or {}
    ESP.State.KnowledgeNameGradeIndex = idx

    for item in string.gmatch(raw, "([^$]+)") do
        local nk, grade = item:match("([^#]+)#(.+)")
        if nk and grade then
            idx[nk] = ESP.KeepBestGrade(idx[nk], grade)
        end
    end
end

function ESP.RefreshEcologyGrades(actors, debugMode)
    local cache = ESP.State.EcologyGradeCache or {}
    ESP.State.EcologyGradeCache = cache
    local nameCache = ESP.State.NameGradeCache or {}
    ESP.State.NameGradeCache = nameCache
    if type(actors) ~= "table" then return end

    local now = os.clock()
    if not debugMode and (now - (tonumber(ESP.State.LastEcologyRefresh) or 0)) < 1.0 then
        return
    end
    ESP.State.LastEcologyRefresh = now
    if debugMode then ESP.State.EcologyDebugCache = {} end
    ESP.RefreshActorNames(actors)
    ESP.RefreshKnowledgeNameGradeIndex()

    for _, actor in ipairs(actors) do
        if tonumber(actor.Type) == 1 then
            local key = tonumber(actor and actor.Key) or 0
            if key <= 0 then goto continue_grade_actor end

            local actorName = ESP.GetActorDisplayName(actor, ESP.GetConfig(actor.Type))
            local actorNk = ESP.NormalizeName(actorName)
            local cachedByName = (actorNk ~= "") and nameCache[actorNk] or nil
            local knowledgeGrade = (actorNk ~= "") and (ESP.State.KnowledgeNameGradeIndex or {})[actorNk] or nil
            local existing = ESP.GetDisplayGrade(cache[key])
            local bestKnown = existing
            bestKnown = ESP.KeepBestGrade(bestKnown, cachedByName)
            bestKnown = ESP.KeepBestGrade(bestKnown, knowledgeGrade)

            if not debugMode and bestKnown ~= "N/A" then
                cache[key] = bestKnown
            end

            if not debugMode and bestKnown == "S" then
                goto continue_grade_actor
            end

            if not debugMode and existing ~= "N/A" and bestKnown == existing then
                goto continue_grade_actor
            end

            local grade = ESP.ExtractGradeFromCardName(actorName)
            local src = "name"

            if knowledgeGrade and ESP.GetDisplayGrade(knowledgeGrade) ~= "N/A" then
                grade = knowledgeGrade
                src = "knowledge_index"
            end

            if not grade then
                if cachedByName and ESP.GetDisplayGrade(cachedByName) ~= "N/A" then
                    grade = cachedByName
                    src = "name_cache"
                else
                    grade = ESP.GetKnowledgeGradeStringByActorKey(key, actorNk)
                    src = "mental"
                end
            end
            if grade then
                cache[key] = ESP.GetDisplayGrade(grade)
                if actorNk ~= "" then
                    nameCache[actorNk] = ESP.KeepBestGrade(nameCache[actorNk], cache[key])
                    cache[key] = nameCache[actorNk]
                end
            else
                if cachedByName and ESP.GetDisplayGrade(cachedByName) ~= "N/A" then
                    cache[key] = ESP.GetDisplayGrade(cachedByName)
                    src = "name_cache"
                else
                    cache[key] = cache[key] or "Unknown"
                    src = "none"
                end
            end
            if debugMode then
                ESP.State.EcologyDebugCache[key] = string.format("name=%s | parsed_grade=%s | source=%s", tostring(actorName), tostring(grade or "nil"), tostring(src))
            end

            ::continue_grade_actor::
        end
    end
end

function ESP.GetEcologyGrade(actor)
    local key = tonumber(actor and actor.Key) or 0
    if key <= 0 then return "Unknown" end
    local cache = ESP.State.EcologyGradeCache or {}
    local g = cache[key]
    if type(g) ~= "string" or g == "" then return "Unknown" end
    return g
end

function ESP.GetBestEcologyGrade(actor)
    local bestGrade = ESP.GetEcologyGrade(actor)
    local actorName = ESP.GetActorDisplayName(actor, ESP.GetConfig(actor and actor.Type))
    local actorNk = ESP.NormalizeName(actorName)
    if actorNk == "" then
        return bestGrade
    end

    local nameCache = ESP.State.NameGradeCache or {}
    local knowledgeIndex = ESP.State.KnowledgeNameGradeIndex or {}
    bestGrade = ESP.KeepBestGrade(bestGrade, nameCache[actorNk])
    bestGrade = ESP.KeepBestGrade(bestGrade, knowledgeIndex[actorNk])
    return bestGrade
end

function ESP.GetDisplayGrade(grade)
    local g = tostring(grade or "")
    g = g:gsub("<PA.->", ""):gsub("^%s+", ""):gsub("%s+$", "")
    g = g:gsub("^%[", ""):gsub("%]$", "")

    g = g:gsub("^%s+", ""):gsub("%s+$", "")

    if g == "" or g == "Unknown" or g == "nil" then
        return "N/A"
    end
    return g
end

function ESP.GetGradeScore(grade)
    local g = ESP.GetDisplayGrade(grade)
    if g == "S" then return 6 end
    if g == "A+" then return 5 end
    if g == "A" then return 4 end
    if g == "B" then return 3 end
    if g == "C" then return 2 end
    if g == "D" then return 1 end
    return 0
end

function ESP.KeepBestGrade(existingGrade, newGrade)
    local old = ESP.GetDisplayGrade(existingGrade)
    local new = ESP.GetDisplayGrade(newGrade)
    if ESP.GetGradeScore(new) > ESP.GetGradeScore(old) then
        return new
    end
    return old
end

function ESP.HasFocusSelection()
    local set = ESP.State.FocusMonsterNames or {}
    return next(set) ~= nil
end

function ESP.IsFocusEnabledByName(name)
    local nk = ESP.NormalizeName(name)
    if nk == "" then return false end
    local set = ESP.State.FocusMonsterNames or {}
    return set[nk] == true
end

function ESP.SetFocusEnabledByName(name, enabled)
    local nk = ESP.NormalizeName(name)
    if nk == "" then return end
    local set = ESP.State.FocusMonsterNames
    if type(set) ~= "table" then
        set = {}
        ESP.State.FocusMonsterNames = set
    end
    if enabled then
        set[nk] = true
    else
        set[nk] = nil
    end
end

function ESP.ClearFocusSelection()
    ESP.State.FocusMonsterName = ""
    ESP.State.FocusMonsterNames = {}
end

function ESP.GetGradeColor(grade)
    local g = ESP.GetDisplayGrade(grade)
    if g == "S" then return ImVec4(1.00, 0.84, 0.20, 1.0) end
    if g == "A+" then return ImVec4(0.73, 0.35, 1.00, 1.0) end
    if g == "A" then return ImVec4(0.95, 0.25, 0.25, 1.0) end
    if g == "B" then return ImVec4(0.20, 0.70, 1.00, 1.0) end
    if g == "C" then return ImVec4(0.45, 0.90, 0.45, 1.0) end
    if g == "D" then return ImVec4(0.85, 0.85, 0.85, 1.0) end
    return ImVec4(0.65, 0.65, 0.65, 1.0)
end

local function SetDebugPathTarget(target, label)
    if type(target) ~= "table" then
        return false
    end

    local x = tonumber(target.x)
    local y = tonumber(target.y)
    local z = tonumber(target.z)
    if not x or not y or not z then
        return false
    end

    ESP.State.DebugPathTarget = { x = x, y = y, z = z }

    local text = string.format("%.2f, %.2f, %.2f", x, y, z)
    local copied = false
    if ImGui and ImGui.SetClipboardText then
        copied = pcall(function()
            ImGui.SetClipboardText(text)
        end)
    end

    if copied then
        ESP.State.DebugPathStatus = string.format("Copied %s: %s", tostring(label or "location"), text)
    else
        ESP.State.DebugPathStatus = string.format("Captured %s (clipboard unavailable): %s", tostring(label or "location"), text)
    end
    return true
end

local function CacheDebugWaypointTarget(target)
    if type(target) ~= "table" then
        return false
    end

    local x = tonumber(target.x)
    local y = tonumber(target.y)
    local z = tonumber(target.z)
    if not x or not y or not z then
        return false
    end

    ESP.State.DebugWaypointTarget = { x = x, y = y, z = z }
    return true
end

function ESP.InstallWaypointCaptureHook()
    if _G.ESP_EcologyHelperWaypointHookInstalled == true then
        return true
    end

    local hookedAny = false

    if type(_G.FromClient_RClickWorldmapPanel) == "function" then
        if type(_G.ESP_EcologyHelper_OriginalRClickWorldmapPanel) ~= "function" then
            _G.ESP_EcologyHelper_OriginalRClickWorldmapPanel = _G.FromClient_RClickWorldmapPanel
        end

        _G.FromClient_RClickWorldmapPanel = function(pos3D, immediately, isTopPicking)
            if type(_G.ESP_EcologyHelper_OriginalRClickWorldmapPanel) == "function" then
                _G.ESP_EcologyHelper_OriginalRClickWorldmapPanel(pos3D, immediately, isTopPicking)
            end
            CacheDebugWaypointTarget(pos3D)
        end
        hookedAny = true
    end

    if type(_G.ToClient_WorldMapNaviStart) == "function" then
        if type(_G.ESP_EcologyHelper_OriginalWorldMapNaviStart) ~= "function" then
            _G.ESP_EcologyHelper_OriginalWorldMapNaviStart = _G.ToClient_WorldMapNaviStart
        end

        _G.ToClient_WorldMapNaviStart = function(pos3D, guideParam, immediately, isTopPicking)
            CacheDebugWaypointTarget(pos3D)
            return _G.ESP_EcologyHelper_OriginalWorldMapNaviStart(pos3D, guideParam, immediately, isTopPicking)
        end
        hookedAny = true
    end

    if type(_G.ToClient_WorldMapNaviStartFromConsole) == "function" then
        if type(_G.ESP_EcologyHelper_OriginalWorldMapNaviStartFromConsole) ~= "function" then
            _G.ESP_EcologyHelper_OriginalWorldMapNaviStartFromConsole = _G.ToClient_WorldMapNaviStartFromConsole
        end

        _G.ToClient_WorldMapNaviStartFromConsole = function(pos3D, guideParam, immediately, isTopPicking)
            CacheDebugWaypointTarget(pos3D)
            return _G.ESP_EcologyHelper_OriginalWorldMapNaviStartFromConsole(pos3D, guideParam, immediately, isTopPicking)
        end
        hookedAny = true
    end

    if type(_G.FromWeb_SelfPlayerWorldMapNaviStart_Console) == "function" then
        if type(_G.ESP_EcologyHelper_OriginalWorldMapNaviStartConsole) ~= "function" then
            _G.ESP_EcologyHelper_OriginalWorldMapNaviStartConsole = _G.FromWeb_SelfPlayerWorldMapNaviStart_Console
        end

        _G.FromWeb_SelfPlayerWorldMapNaviStart_Console = function(x, y, z)
            if type(_G.ESP_EcologyHelper_OriginalWorldMapNaviStartConsole) == "function" then
                _G.ESP_EcologyHelper_OriginalWorldMapNaviStartConsole(x, y, z)
            end
            CacheDebugWaypointTarget({ x = x, y = y, z = z })
        end
        hookedAny = true
    end

    if hookedAny then
        _G.ESP_EcologyHelperWaypointHookInstalled = true
        return true
    end

    return false
end

function ESP.CopyCurrentLocationToClipboard()
    if not Pyx.Game.LocalPlayer.IsValid() then
        ESP.State.DebugPathStatus = "Get current location failed: local player not valid."
        return false
    end

    local x, y, z = Pyx.Game.LocalPlayer.GetPos()
    return SetDebugPathTarget({ x = x, y = y, z = z }, "current location")
end

function ESP.CopyWaypointLocationToClipboard()
    if not ESP.InstallWaypointCaptureHook() then
        ESP.State.DebugPathStatus = "Get WP location failed: world map click hook not available."
        return false
    end

    local target = ESP.State.DebugWaypointTarget
    if type(target) ~= "table" then
        ESP.State.DebugPathStatus = "Get WP location failed: no cached waypoint yet. Set or refresh a waypoint on the world map, then click again."
        return false
    end

    return SetDebugPathTarget(target, "WP location")
end

ESP.InstallWaypointCaptureHook()

function ESP.PathToDebugLocation()
    local target = ESP.State.DebugPathTarget
    if type(target) ~= "table" then
        ESP.State.DebugPathStatus = "Path to location failed: no copied location yet."
        return false
    end

    local ok, result = pcall(function()
        return Pyx.Game.Execute(string.format([=[
            local selfPlayerWrapper = getSelfPlayer()
            if nil == selfPlayerWrapper then return "NO_PLAYER" end
            local selfPlayer = selfPlayerWrapper:get()
            if nil == selfPlayer then return "NO_PLAYER" end
            pcall(function() ToClient_WorldMapNaviClear() end)
            local targetPos = float3(%f, %f, %f)
            local key = ToClient_WorldMapNaviStart(targetPos, NavigationGuideParam(), true, true)
            if nil == key then return "NO_PATH_KEY" end
            selfPlayer:setNavigationMovePath(key)
            pcall(function() selfPlayer:checkNaviPathUI(key) end)
            return "OK"
        ]=], tonumber(target.x) or 0, tonumber(target.y) or 0, tonumber(target.z) or 0))
    end)

    if not ok then
        ESP.State.DebugPathStatus = "Path to location failed: execute error."
        return false
    end

    if tostring(result) == "OK" then
        ESP.State.DebugPathStatus = string.format("Pathing started to: %.2f, %.2f, %.2f", target.x, target.y, target.z)
        return true
    end

    ESP.State.DebugPathStatus = "Path to location failed: " .. tostring(result)
    return false
end

function ESP.NavigateToLocation(x, y, z)
    local ok, result = pcall(function()
        return Pyx.Game.Execute(string.format([=[
            local selfPlayerWrapper = getSelfPlayer()
            if nil == selfPlayerWrapper then return "NO_PLAYER" end
            local selfPlayer = selfPlayerWrapper:get()
            if nil == selfPlayer then return "NO_PLAYER" end
            pcall(function() ToClient_WorldMapNaviClear() end)
            local targetPos = float3(%f, %f, %f)
            local key = ToClient_WorldMapNaviStart(targetPos, NavigationGuideParam(), true, true)
            if nil == key then return "NO_PATH_KEY" end
            selfPlayer:setNavigationMovePath(key)
            pcall(function() selfPlayer:checkNaviPathUI(key) end)
            return "OK"
        ]=], tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0))
    end)

    return ok and tostring(result) == "OK"
end

function ESP.GetDistance3D(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function ESP.PackColor(v)
    local r = math.floor(v.x * 255)
    local g = math.floor(v.y * 255)
    local b = math.floor(v.z * 255)
    local a = math.floor(v.w * 255)
    return (a << 24) | (b << 16) | (g << 8) | r
end

function ESP.DrawOutlinedText(dl, x, y, u32Color, text, sizePx)
    local size = tonumber(sizePx) or 16
    if size < 12 then size = 12 end
    if size > 36 then size = 36 end
    local function drawSized(pos, color, value)
        if dl and dl.AddTextSized then
            local ok = pcall(function()
                dl:AddTextSized(size, pos, color, value)
            end)
            if ok then return true end
            ok = pcall(function()
                dl:AddTextSized(pos, color, value, size)
            end)
            if ok then return true end
        end
        local ok = pcall(function()
            dl:AddText(nil, size, pos, color, value)
        end)
        return ok
    end
    local okShadow = drawSized(ImVec2(x + 1, y + 1), 0xFF000000, text)
    local okMain = drawSized(ImVec2(x, y), u32Color, text)
    if not (okShadow and okMain) then
        dl:AddText(ImVec2(x + 1, y + 1), 0xFF000000, text)
        dl:AddText(ImVec2(x, y), u32Color, text)
    end
end

function ESP.GetScaledTextSize(text, sizePx)
    local size = tonumber(sizePx) or 16
    local defaultWidth = #tostring(text or "") * 7
    local defaultHeight = 13

    local okCalc, measured = pcall(function()
        return ImGui.CalcTextSize(tostring(text or ""))
    end)
    if okCalc and measured then
        if measured.x then defaultWidth = tonumber(measured.x) or defaultWidth end
        if measured.y then defaultHeight = tonumber(measured.y) or defaultHeight end
    end

    if defaultHeight <= 0 then defaultHeight = 13 end

    -- `AddTextSized` appears to increase width less aggressively than a pure
    -- height ratio, so temper the width scaling to keep labels visually centered.
    local rawScale = size / defaultHeight
    local widthScale = 1 + ((rawScale - 1) * 0.6)
    if widthScale < 1 then widthScale = 1 end

    return defaultWidth * widthScale, size
end

function ESP.RefreshActorHp(actors)
    if type(actors) ~= "table" or #actors == 0 then return end
    local now = os.clock()
    if (now - (tonumber(ESP.State.LastHpRefresh) or 0)) < 0.2 then return end
    ESP.State.LastHpRefresh = now

    local ids = {}
    local maxLookup = math.min(#actors, 220)
    for i = 1, maxLookup do
        local a = actors[i]
        local k = a and tonumber(a.Key)
        if k and k > 0 and tonumber(a.Type) == 1 then
            ids[#ids + 1] = tostring(math.floor(k))
        end
    end
    if #ids == 0 then return end

    local code = string.format([=[
        local ids = {%s}
        local out = ""
        for _, id in ipairs(ids) do
            local a = getActor(id)
            local hp = -1
            if a then
                pcall(function() hp = tonumber(a:get():getHp() or -1) or -1 end)
                if hp < 0 then
                    pcall(function() hp = tonumber(a:getHp() or -1) or -1 end)
                end
            end
            out = out .. tostring(id) .. "#" .. tostring(hp) .. "$"
        end
        return out
    ]=], table.concat(ids, ","))

    local ok, raw = pcall(function() return Pyx.Game.Execute(code) end)
    if not ok or type(raw) ~= "string" or raw == "" then return end

    local cache = ESP.State.HpCache or {}
    ESP.State.HpCache = cache
    for item in string.gmatch(raw, "([^$]+)") do
        local key, hp = item:match("([^#]+)#([^#]+)")
        local keyNum = tonumber(key)
        local hpNum = tonumber(hp)
        if keyNum and hpNum then
            cache[keyNum] = hpNum
        end
    end
end

function ESP.IsActorDead(actor)
    if not ESP.Global.HideWhenDead then return false end
    local hp = nil
    local key = tonumber(actor and actor.Key) or 0
    if key > 0 then
        hp = tonumber(ESP.State.HpCache and ESP.State.HpCache[key])
    end
    if hp == nil then
        hp = tonumber(actor and (actor.Hp or actor.hp) or 1) or 1
    end
    return hp <= 0
end

function ESP.OnRender()
    if not ESP.Global.Enabled then return end

    local dl = ImGui.GetForegroundDrawList()
    local io = ImGui.GetIO()
    local screenW = io.DisplaySize.x
    local screenH = io.DisplaySize.y
    local centerX = screenW / 2
    local bottomY = screenH

    local actors = Pyx.Game.Actors.GetList() or {}
    local hasFocus = ESP.HasFocusSelection()

    local needsActorNames = hasFocus or ESP.Global.ShowText or ESP.Global.ShowEcologyInfo
    if needsActorNames then
        ESP.RefreshActorNames(actors)
    end
    if ESP.Global.HideWhenDead then
        ESP.RefreshActorHp(actors)
    end
    if ESP.Global.ShowEcologyInfo == true or hasFocus then
        ESP.RefreshEcologyGrades(actors)
    end

    local hasLocalPlayer = Pyx.Game.LocalPlayer.IsValid()
    local lx, ly, lz = 0, 0, 0
    if hasLocalPlayer then
        lx, ly, lz = Pyx.Game.LocalPlayer.GetPos()
    end

    for _, actor in ipairs(actors) do
        local conf = ESP.GetConfig(actor.Type)
        local actorName = ESP.GetActorDisplayName(actor, conf)
        local passesFocus = ESP.IsFocusEnabledByName(actorName)

        local canDraw = conf.enabled and actor.Type ~= 9
        if hasFocus then
            canDraw = passesFocus
        end

        if canDraw and not (actor.X == 0 and actor.Y == 0 and actor.Z == 0) then
            if ESP.IsActorDead(actor) then
                goto continue_actor_draw
            end

            local inRange = true
            local distance = 0
            if hasLocalPlayer then
                distance = ESP.GetDistance3D(lx, ly, lz, actor.X, actor.Y, actor.Z)
                if distance > ESP.Global.MaxDistance then
                    inRange = false
                end
            end

            if inRange then
                local worldY_Base = actor.Y + conf.offY
                local s1, x1, y1 = Pyx.Render.WorldToScreen(actor.X, worldY_Base, actor.Z)
                local worldY_Head = worldY_Base + conf.boxH
                local s2, _, y2 = Pyx.Render.WorldToScreen(actor.X, worldY_Head, actor.Z)

                if s1 and s2 then
                    local height = math.abs(y1 - y2)
                    local width = height / 2.0
                    if height > 5 and height < screenH * 2 then
                        local drawColor = conf.color
                        if hasFocus and passesFocus then
                            drawColor = ESP.GetGradeColor(ESP.GetBestEcologyGrade(actor))
                        end
                        local colorU32 = ESP.PackColor(drawColor)
                        local forceFocus = hasFocus and passesFocus

                        if ESP.Global.ShowSnaplines and not hasFocus then
                            dl:AddLine(ImVec2(centerX, bottomY), ImVec2(x1, y1), colorU32, 1.0)
                        end

                        if ESP.Global.ShowBox or forceFocus then
                            dl:AddRect(ImVec2(x1 - (width / 2), y2), ImVec2(x1 + (width / 2), y1), colorU32, 0.0, 0, 1.5)
                        end

                        if ESP.Global.ShowText or forceFocus then
                            local distMeters = math.floor(distance / 100)
                            local textToDraw = string.format("%s [%dm]", actorName, distMeters)
                            local textSizePx = tonumber(ESP.Global.TextSizePx) or 16
                            if textSizePx < 12 then textSizePx = 12 end
                            if textSizePx > 36 then textSizePx = 36 end
                            local textWidth, textHeight = ESP.GetScaledTextSize(textToDraw, textSizePx)
                            local textX = x1 - (textWidth / 2)
                            local textY = y2 - textHeight - 4
                            ESP.DrawOutlinedText(dl, textX, textY, colorU32, textToDraw, textSizePx)
                        end
                    end
                end
            end
        end
        ::continue_actor_draw::
    end
end
-- ============================================================
-- 4. RADAR & MEMORY INSPECTOR
-- ============================================================

function ESP.DrawRadarWindow()
    if not ESP.Global.ShowRadar then return end

    local opened = ImGui.Begin("Radar / Actor List", 0)
    if opened then
        local okRadar, errRadar = pcall(function()
            ImGui.Columns(3, "radar_cols", true)
            ImGui.Separator()
            ImGui.Text("Type") ; ImGui.NextColumn()
            ImGui.Text("Distance") ; ImGui.NextColumn()
            ImGui.Text("Color / Inspect") ; ImGui.NextColumn()
            ImGui.Separator()

            local actors = Pyx.Game.Actors.GetList() or {}
            if ESP.Global.HideWhenDead then
                ESP.RefreshActorHp(actors)
            end

            local hasLocalPlayer = Pyx.Game.LocalPlayer.IsValid()

            local lx, ly, lz = 0, 0, 0
            if hasLocalPlayer then
                lx, ly, lz = Pyx.Game.LocalPlayer.GetPos()
            end

            for i, actor in ipairs(actors) do
                local conf = ESP.GetConfig(actor.Type)
                
                if conf.enabled and actor.Type ~= 9 and not (actor.X == 0 and actor.Y == 0) then
                    if ESP.IsActorDead(actor) then
                        goto continue_actor_radar
                    end
                    
                    local inRange = true
                    local distance = 0

                    if hasLocalPlayer then
                        distance = ESP.GetDistance3D(lx, ly, lz, actor.X, actor.Y, actor.Z)
                        if distance > ESP.Global.MaxDistance then
                            inRange = false
                        end
                    end

                    if inRange then
                        ImGui.TextColored(conf.color, conf.name .. " [" .. actor.Type .. "]")
                        ImGui.NextColumn()

                        local distMeters = math.floor(distance / 100)
                        ImGui.Text(distMeters .. " m")
                        ImGui.NextColumn()

                        ImGui.PushID(i * 100)
                        local changed, newCol = ImGui.ColorEdit4("##radarcol", conf.color)
                        if changed then 
                            conf.color = newCol
                            ESP.RequestSave()
                        end
                        ImGui.PopID()
                        
                        ImGui.SameLine()
                        
                        ImGui.PushID(i * 200)
                        if ImGui.SmallButton("Inspect") then
                            ESP.Global.SelectedActorAddr = actor.Addr
                        end
                        ImGui.PopID()

                        ImGui.NextColumn()
                    end
                end
                ::continue_actor_radar::
            end
            ImGui.Columns(1)
        end)

        if not okRadar then
            pcall(function()
                ImGui.Columns(1)
                ImGui.TextColored(ImVec4(1.0, 0.35, 0.35, 1.0), "Radar error")
                ImGui.TextDisabled(tostring(errRadar))
            end)
        end
    end
    ImGui.End()
end

ESP.Global.SearchValue = 0
ESP.Global.SearchResults = {}

function ESP.DrawMemoryInspector()
    if ESP.Global.SelectedActorAddr == 0 then return end

    if ImGui.Begin("Memory Auto-Scanner", 0) then
        ImGui.Text("Inspecting Actor: 0x" .. string.format("%X", ESP.Global.SelectedActorAddr))
        
        if ImGui.Button("Close") then 
            ESP.Global.SelectedActorAddr = 0 
            ESP.Global.SearchResults = {}
        end
        
        ImGui.Separator()
        ImGui.Text("1. Tape les HP exacts que tu vois dans le jeu :")
        
        local changed, val = ImGui.InputInt("##searchval", ESP.Global.SearchValue)
        if changed then ESP.Global.SearchValue = val end
        
        ImGui.SameLine()
        if ImGui.Button("Scan Memory") then
            ESP.Global.SearchResults = {}
            local target = ESP.Global.SearchValue
            local resultsFound = 0
            
            for offset = 0, 0x8000, 4 do
                local valInt = Pyx.Game.Memory.ReadInt(ESP.Global.SelectedActorAddr, offset)
                
                if valInt == target then
                    local maxHpCheck = Pyx.Game.Memory.ReadInt(ESP.Global.SelectedActorAddr, offset + 4)
                    table.insert(ESP.Global.SearchResults, string.format("BINGO ! HP trouvés à l'Offset: 0x%X (MaxHP à coté ? %d)", offset, maxHpCheck))
                    resultsFound = resultsFound + 1
                    
                    -- Limite de sécurité pour éviter le lag LUA
                    if resultsFound >= 15 then
                        table.insert(ESP.Global.SearchResults, "[!] Trop de résultats trouvés, affinage nécessaire.")
                        break
                    end
                end
            end
            
            if #ESP.Global.SearchResults == 0 then
                table.insert(ESP.Global.SearchResults, "Non trouvé. La valeur est dans un sous-pointeur.")
            end
        end

        ImGui.Separator()
        ImGui.Text("Resultats :")
        
        for _, res in ipairs(ESP.Global.SearchResults) do
            if res:find("BINGO") then
                ImGui.TextColored(ImVec4(0.2, 1.0, 0.2, 1.0), res)
            else
                ImGui.TextColored(ImVec4(1.0, 0.2, 0.2, 1.0), res)
            end
        end
    end
    ImGui.End()
end

-- ============================================================
-- 5. GUI (CONTROLLER)
-- ============================================================

function ESP.DrawGui()
    if ImGui.Begin("[Pyx] - Ecology Helper", 0) then
        if ImGui.BeginTabBar("EcoTabs") then
        if ImGui.BeginTabItem("Settings") then
        if ImGui.CollapsingHeader("Global Settings", 32) then
            local c1, v1 = ImGui.Checkbox("Enable ESP", ESP.Global.Enabled)
            if c1 then ESP.Global.Enabled = v1; ESP.RequestSave() end

            local c2, v2 = ImGui.Checkbox("Show Box", ESP.Global.ShowBox)
            if c2 then ESP.Global.ShowBox = v2; ESP.RequestSave() end

            local c3, v3 = ImGui.Checkbox("Show Snaplines", ESP.Global.ShowSnaplines)
            if c3 then ESP.Global.ShowSnaplines = v3; ESP.RequestSave() end

            local c4, v4 = ImGui.Checkbox("Show Text", ESP.Global.ShowText)
            if c4 then ESP.Global.ShowText = v4; ESP.RequestSave() end

            local changedTextSize, newTextSize = ImGui.SliderInt("Text Size", tonumber(ESP.Global.TextSizePx) or 17, 12, 36)
            if changedTextSize then ESP.Global.TextSizePx = newTextSize; ESP.RequestSave() end

            local c4eco, v4eco = ImGui.Checkbox("Show Ecology information", ESP.Global.ShowEcologyInfo)
            if c4eco then ESP.Global.ShowEcologyInfo = v4eco; ESP.RequestSave() end

            local c4b, v4b = ImGui.Checkbox("Hide when Dead", ESP.Global.HideWhenDead)
            if c4b then ESP.Global.HideWhenDead = v4b; ESP.RequestSave() end
            
            ImGui.Separator()
            local c5, v5 = ImGui.Checkbox("Open Radar / List", ESP.Global.ShowRadar)
            if c5 then ESP.Global.ShowRadar = v5; ESP.RequestSave() end
   
            ImGui.Spacing()
            local changedDist, newDist = ImGui.SliderInt("Max Render Distance", ESP.Global.MaxDistance, 500, 20000)
            if changedDist then ESP.Global.MaxDistance = newDist; ESP.RequestSave() end
        end

        ImGui.Spacing()

        if ImGui.CollapsingHeader("Actors Filter & Colors", 32) then
            ImGui.TextDisabled("Configure types and colors:")
            ImGui.Spacing()

            for id, conf in pairs(ESP.Actors) do
                ImGui.PushID(id)
                
                local changed, val = ImGui.Checkbox("##chk", conf.enabled)
                if changed then conf.enabled = val; ESP.RequestSave() end
                
                ImGui.SameLine()
                
                local changedCol, newCol = ImGui.ColorEdit4("##pk", conf.color)
                if changedCol then
                     conf.color = newCol
                     ESP.RequestSave()
                end
                
                ImGui.SameLine()
                ImGui.Text(conf.name .. " [" .. id .. "]")

                ImGui.PopID()
            end
        end
        ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem("Ecology") then
            ImGui.Text("Ecology")
            ImGui.SameLine()
            if ImGui.Button("Collapse all") then
                ESP.State.OpenSubHeaders = {}
                ESP.State.OpenRegionHeaders = {}
                ESP.RequestSave()
            end
            ImGui.Separator()
            local okEco, errEco = pcall(DrawEcologySections)
            if not okEco then
                ImGui.TextColored(ImVec4(1.0, 0.35, 0.35, 1.0), "Ecology draw error:")
                ImGui.TextDisabled(tostring(errEco))
            end
            ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem("Debug") then
            ImGui.Text("Ecology Debug")
            ImGui.Separator()
            if ImGui.Button("Get current location") then
                ESP.CopyCurrentLocationToClipboard()
            end
            ImGui.SameLine()
            if ImGui.Button("Get WP location") then
                ESP.CopyWaypointLocationToClipboard()
            end
            ImGui.SameLine()
            if ImGui.Button("Path to location") then
                ESP.PathToDebugLocation()
            end
            if ESP.State.DebugPathTarget then
                ImGui.TextDisabled(string.format("Target: %.2f, %.2f, %.2f", ESP.State.DebugPathTarget.x, ESP.State.DebugPathTarget.y, ESP.State.DebugPathTarget.z))
            else
                ImGui.TextDisabled("Target: none")
            end
            if ESP.State.DebugPathStatus and ESP.State.DebugPathStatus ~= "" then
                ImGui.TextDisabled(ESP.State.DebugPathStatus)
            end
            ImGui.Separator()
            local actors = Pyx.Game.Actors.GetList() or {}
            local okRefresh, errRefresh = pcall(function()
                ESP.RefreshEcologyGrades(actors, true)
            end)
            if not okRefresh then
                ImGui.TextDisabled("refresh_err: " .. tostring(errRefresh))
            end
            local shown = 0
            for _, actor in ipairs(actors) do
                if tonumber(actor.Type) == 1 then
                    local key = tonumber(actor.Key) or 0
                    if key > 0 then
                        local name = ESP.GetActorDisplayName(actor, ESP.GetConfig(actor.Type))
                        local grade = ESP.GetEcologyGrade(actor)
                        local dbg = tostring((ESP.State.EcologyDebugCache and ESP.State.EcologyDebugCache[key]) or "")

                        if dbg == "" then
                            dbg = "no_cache_entry;last_refresh=" .. tostring(ESP.State.LastEcologyRefresh or 0)
                        end
                        ImGui.Text(string.format("%s | grade=%s", tostring(name), tostring(grade)))
                        ImGui.TextDisabled("  " .. (dbg ~= "" and dbg or (okRefresh and "no_dbg" or "refresh_failed")))

                        shown = shown + 1
                        if shown >= 20 then break end
                    end
                end
            end
            if shown == 0 then
                ImGui.TextDisabled("No monsters in range.")
            end
            ImGui.EndTabItem()
        end

        ImGui.EndTabBar()
        end
    end
    ImGui.End()
end

-- ============================================================
-- 6. REGISTER
-- ============================================================

local currentScript = Pyx.Scripting.CurrentScript

pcall(ESP.LoadSettings)

currentScript:RegisterCallback("Pyx.OnPulse", function()
    local state = ESP.State
    if state.SavePending then
        local now = ESP.NowMs()
        if (now - (state.LastSaveRequestTick or 0)) >= 500 and (now - (state.LastSaveTick or 0)) >= 250 then
            state.SavePending = false
            pcall(ESP.SaveSettings)
        end
    end
end)

currentScript:RegisterCallback("Pyx.OnRenderESP", function()
    pcall(ESP.OnRender)
end)

currentScript:RegisterCallback("Pyx.OnRender", function()
    pcall(ESP.OnRender)
    pcall(ESP.DrawRadarWindow)
    pcall(ESP.DrawGui)
    pcall(ESP.DrawMemoryInspector)
end)