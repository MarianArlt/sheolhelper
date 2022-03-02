--[[
    First value represents an additional resistance bonus supposedly given to mobs of that type inside Odyssey.
    Said bonus is strictly made up from observations made by the user base and has not been confirmed by SquareEnix
    as of the writing of this addon.
--]]

return {
    -- Nostos mobs and NMs
    ['Amorph']   = {'Magic',    'Allergorhai','Bes','Black Pudding','Clot','Flan','Gloios','Hecteyes','Leech','Slime','Worm'},
    ['Aquan']    = {'Slashing', 'Brachys','Crab','Fish','Jagil','Kraken','Nerites','Pugil','Taniwha','Uragnite'},
    ['Arcana']   = {'Piercing', 'Bendigeidfran','Bomb','Bygul','Cluster','Evil Weapon','Fornax','Giant','Harpe','Ishum','Magic Pot','Mimic','Shara','Weapon'},
    ['Beast']    = {'Piercing', 'Ailuros','Asena','Buffalo','Bugard','Chnubis','Coeurl','Dabbat al-Ard','Dhalmel','Karakul','Kusarikku','Leopard','Manticore','Marid','Opo-opo','Ptesan Wi','Ram','Rarab','Sheep','Tiger'},
    ['Bird']     = {'Blunt',    'Aegypius','Apkallu','Bat','Bats','Bigbird','Colibri','Cockatrice','Gandji','Langmeidong','Leucippe','Megaera','Roc','Simir','Vulture','Zacatzontli','Ziz'},
    ['Demon']    = {'Piercing', 'Ahriman','Chaos Steward','Imp','Soulflayer','Taurus'},
    ['Dragon']   = {'Blunt',    'Azdaha','Dahak','Drake','Kuk','Lotanu','Puk','Wayra Tata','Wyvern'},
    ['Lizard']   = {'Blunt',    'Eft','Kurmajara','Lizard','Raptor','Salmandra'},
    ['Plantoid'] = {'Magic',    'Ameretat','Cynara','Damysus','Dione','Eurytus','Flytrap','Funguar','Goobbue','Korrigan','Mandragora','Maverick Maude','Morbol','Physis','Ptelea','Sabotender','Sapling','Treant'},
    ['Undead']   = {'Slashing', 'Bhoot','Corse','Count Malefis','Doom Toad','Draugar','Ghost','Ghoul','Gravehaunter','Hound','Qutrub','Skeleton','Spyrysyon'},
    ['Vermin']   = {'Magic',    'Akidu','Beetle','Chelamma','Chigoe','Crawler','Damselfly','Defoliator','Diremite','Eruca','Fly','Gaganbo','Man-kheper-re','Scorpion','Spider','Spinner','Tabitjet','Tipuli','Wamoura','Wamouracampa','Wasp'},
    ['Goblin']   = {'Unknown',  'Tripix'},
    -- Agon beastmen and a few NMs (cleric appears twice, for the sake of simplicity resistances.lua will refer to the Mamool cleric)
    -- TODO: Testing needed in Sheol A for the respective agon beastmen weapon resistances, also Tripix
    ['Orc']      = {'Unknown',  'Archer','Black Belt','Crusader','Fighter','Pugilist','Renegade','Thaumaturge','Villifier'},
    ['Yagudo']   = {'Unknown',  'Archon','Bruiser','Chirurgeon','Lyricist','Magus','Samurai','Shinobi','Spiritualist'},
    ['Quadav']   = {'Unknown',  'Champion','Cleric','Enchanter','Evoker','Marauder','Pillager','Ravager','Squire'},
    ['Antica']   = {'Blunt',    'Apollinaris VII-II','Cleaver','Culler','Errant','Magister','Man-at-Arms','Soldier','Swiftcaster','Warden'},
    ['Sahagin']  = {'Piercing', 'Chemister','Dragonmaster','Healer','Lancer','Mendicant','Muse','Stoicist','Tamer'},
    ['Tonberry'] = {'Slashing', 'Agent','Assassin','Channeler','Fleet-footed Lokberry','Hexer','Kunoichi','Pickpocket','Rogue','Spy'},
    ['Mamool']   = {'Piercing', 'Cleric','Heretic','Initiate','Instigator','Marquess','Phalanx','Pilferer','Praetor'},
    ['Troll']    = {'Blunt',    'Clearmind','Defender','Footsoldier','Infidel','Ritualist','Sharpshooter','Shieldsaint','Viscount'},
    ['Lamia']    = {'Slashing', 'Adjudicator','Dignitary','Marksman','Monarch','Rabblerouser','Scallywag','Vizier','Yojimbo'},
}