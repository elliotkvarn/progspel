require "ruby2d"
set title: "slem"
set background: "gray"
set width: 1
set height: 1

$goreraegnalatar = Music.new("sound//Goreraegnalatar.kys.mp3")
$slutasnomindaniel = Music.new("sound//NiSugerochbordeavinstalleravisualstudiocodeSlutasnominDaniel.mp3")
$untitled3 = Music.new("sound//untitled3.mp3")
$sword_slash = Sound.new("sound//sword-slash.mp3")

$player_inventory = []
$player_equipment = []
$player_name = "",
$player_skills = [],
$player_spells = []
$player_race = ""
$player_xp = 0
$player_level = 1 + (0.14 * Math.sqrt($player_xp))

$path = []

$player_defense = 1
$player_coinage = 0

#core stats
$player_health = 20
$player_max_health = 20
$player_strength = 5
$player_charisma = 5
$player_dexterity = 5
$player_intelligence = 5
$map = []

#map/world

class Map_tile
    attr_accessor :location, :revealed, :monster, :treasure, :player

    def initialize(location, revealed, monster, treasure, player)
        @monster = monster
        @location = location
        @treasure = treasure 
        @revealed = revealed
        @player = player
    end

    def reveal
        @revealed = true
    end

    def position_change
        @player = !@player
    end

    def show_location
        if @revealed 
            return @location
        else
            return "   X    "
        end
    end

    def monster_died
        @monster = nil
    end

    def look
        if self.location == "  city  "
            return "The bustling metropolis stretches out before you, alive with the hustle and bustle of its inhabitants. Tall skyscrapers pierce the sky, their windows reflecting the sunlight in a dazzling display. The streets below are filled with people going about their daily lives, merchants peddling their wares, and the occasional street performer entertaining the crowds. The air is thick with the scent of food from the myriad of restaurants lining the sidewalks, while the distant sounds of traffic and chatter create a symphony of urban life."
        elsif self.location == " guild  "
            return "You find yourself within the walls of a grand guild hall, its interior adorned with trophies, banners, and relics of past adventures. Tables are scattered about, where guild members gather to discuss quests, share tales of their exploits, and plan their next endeavors. A roaring fireplace casts a warm glow across the room, providing a cozy atmosphere despite the hall's vastness. Training dummies stand in one corner, where aspiring adventurers hone their skills, while the sound of clashing swords and spells being cast echoes through the halls."
        elsif self.location == "  shop  "
            return "The air is thick with the scent of exotic spices and rare herbs as you step into the shop. Shelves line the walls, filled to the brim with potions, scrolls, and magical artifacts of all kinds. A counter stretches across one side of the room, behind which a wizened old shopkeeper stands, ready to assist customers with their purchases. The room is dimly lit, with the glow of enchanted lanterns casting eerie shadows on the walls. Mysterious trinkets dangle from the ceiling, their faint glow adding to the shop's mystical ambiance."
        elsif self.location == " plains "
            return "The vast expanse of grassland stretches out before you, uninterrupted as far as the eye can see. Tall grass sways gently in the breeze, creating mesmerizing patterns across the landscape. In the distance, a herd of wild horses can be seen grazing peacefully, their movements graceful and free. The sky above is vast and open, painted with hues of orange and pink as the sun begins to set on the horizon. The air is filled with the sweet scent of wildflowers, carried on the wind as it whispers through the grass."
        elsif self.location == " forest "
            return "Towering trees loom overhead as you step into the dense forest, their branches stretching towards the sky like ancient guardians of the wilderness. Sunlight filters through the canopy above, dappling the forest floor in patches of golden light. The air is cool and refreshing, filled with the earthy scent of moss and damp soil. Birds sing melodies from hidden perches, while small animals scurry about in the underbrush. The forest seems to hum with life, every tree and plant contributing to its vibrant and enchanting atmosphere."
        end
    end


end


class Enemy
    attr_accessor :monster, :health, :attack, :defense, :level, :drop

    def initialize(monster, health, attack, defense, level, drop)
        @monster = monster
        @health = health
        @attack = attack 
        @defense = defense
        @level = level
        @drop = drop
    end
    
end



def generate_map_act2


    $map = [
        [Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  city  ", true, nil, nil, false), Map_tile.new(" guild  ", true, nil, nil, true), Map_tile.new("  shop  ", true, nil, nil, false), Map_tile.new("  city  ", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)],
        [Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  city  ", true, nil, nil, false), Map_tile.new("  city  ", true, nil, nil, false), Map_tile.new("  city  ", true, nil, nil, false), Map_tile.new("  city  ", true, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)],
        [Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)],
        [Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, Enemy.new("goblin", 20, 2, 10, 3, nil), nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)],
        [Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)],
        [Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new(" plains ", false,  Enemy.new("wolf", 18, 4, 8, 4, "wolf fur"), nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new(" forest ", false,  Enemy.new("ogre", 20, 3, 14, 5, nil), nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)],
        [Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new("  lake  ", true, nil, nil, false), Map_tile.new(" plains ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new(" forest ", false, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)],
        [Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("  cave  ", false, Enemy.new("lesser dragon", 100, 5, 15, 10, "lesser dragon core"), nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false), Map_tile.new("mountain", true, nil, nil, false)]
    ]
    

end

def show_map
    map = []
    for row in $map
        for tile in row
            if tile.player
                map << "  You   "
            else
                map << tile.show_location 
            end
        end
    end
    slice_index = 0
    map_2d = []
    row_length = $map[0].length  

    while slice_index < map.length
        row_array = []
        for j in 0...row_length
            row_array << map[slice_index]
            slice_index += 1
        end
        map_2d << row_array
    end
    for row in map_2d
        p row
    end
end

def stats_randomize
    player_stats = [5, 5, 5, 5]
    
    while player_stats.sum <= 42
            player_stats[rand(0..3)] +=1
    end

    $player_dexterity = player_stats[0]
    $player_intelligence = player_stats[1]
    $player_charisma = player_stats[2]
    $player_strength = player_stats[3]

    p ["dex", "int", "cha", "str"]
    p player_stats
end

def death_and_rebirth
    redoer = "yes"
    legal = false
    age = -1
    free_time_ans = nil
    regret_ans = nil
    environment_ans = nil
    time = 0

    prologue = File.readlines("lines//prologue//prologue.txt").map(&:chomp)
    regret = File.readlines("lines//prologue//regret.txt").map(&:chomp)
    environment = File.readlines("lines//prologue//environment.txt").map(&:chomp)
    free_time = File.readlines("lines//prologue//free_time.txt").map(&:chomp)

    for sentence in prologue
        puts sentence
        sleep(time)
    end
    while redoer != "no"
        puts "--------------------"
        puts "Enter your name:"
        $player_name = gets.to_s.chomp
        puts "Your name is #{$player_name}"
        puts "do you want to change? yes/no"
        redoer = gets.to_s.chomp
    end

    #---------------
    #      AGE
    #---------------
    puts "--------------------"
    puts "What age are you mentally?" # Gives bonus intelligence for every 10 years (100+ increases chance of eilf by 20%)
    while legal == false
        age = gets.to_i
        if age >= 0
            legal = true
        end
        
    end
    
    #---------------
    #    REGRET
    #---------------
    legal = false
    for sentence in regret
        puts sentence
        sleep(time)
    end
    while legal == false
        regret_ans = gets.to_i
        if [1, 2, 3, 4].include?(regret_ans)
            legal = true
        end
    end
    
    #-----------------
    #    FREE TIME
    #-----------------
    legal = false
    for sentence in free_time
        puts sentence
        sleep(time)
    end
    while legal == false
        free_time_ans = gets.to_i
        if [1, 2, 3, 4].include?(free_time_ans)
            legal = true
        end
    end

    #------------------
    #   ENVIRONMENT
    #------------------
    legal = false
    for sentence in environment
        puts sentence
        sleep(time)
    end
    while legal == false
        environment_ans = gets.to_i
        if [1, 2, 3, 4].include?(environment_ans)
            legal = true
        end
    end
    

    #-------------------
    #  ADDING SKILLS
    #-------------------

    #mental age - intelligence boost
    if age <= 70
        $player_intelligence += age/10
    else
        $player_intelligence += 7
    end
    
    stats_randomize
    #regret - unique skill
    if regret_ans == 1
        $player_skills << "Predator"
    elsif regret_ans == 2
        $player_skills << "Sloth"
    elsif regret_ans == 3
        $player_skills << "Lust"
    elsif regret_ans == 4
        $player_skills << "Great Sage"
    end

    #free time - stat boosts
    if free_time_ans == 1
        $player_strength += 2
        $player_dexterity += 1
    elsif free_time_ans == 2
        $player_intelligence += 3
    elsif free_time_ans == 3
        $player_charisma += 2
        $player_intelligence +=1
    elsif free_time_ans == 4
        $player_dexterity += 1
        $player_intelligence += 1
        $player_charisma += 1
    end

    #environment
    if environment_ans == 1
        $player_race = "Slime"
        $player_skills << "Mimicry" << "Absorb/Disolve" << "Regeneration" #intrinsic skills will be changed to classes
    elsif environment_ans == 2
        $player_race = "Tengu"
    elsif environment_ans == 3
        $player_race = "Lizardman"
    elsif environment_ans == 4
        random = rand(1..10)
        if random >= 9
            $player_race = "Elf"
        else
            $player_race = "Human"
        end
    end

    #mental age - 100+ age -> elf chance
    if age >= 100
        random = rand(1..10)
        if random >= 9
            $player_race = "Elf"
        end
    end

    inspect_player_info

    $goreraegnalatar.play
    puts "♫ Now Playing - Goreraegnalatar ♫"
    puts "SLEM"
    puts "v0.1"
    sleep(5)
    puts "Made by: Andreas & Elliot"
    sleep(5)
    puts "Music: Daniel"
    sleep(5)
    $goreraegnalatar.fadeout(5000)

end

def inspect_player_info
    #
    puts $player_name 
    puts "Skills: #{$player_skills}"
    puts "Race: #{$player_race}"
    puts "Str #{$player_strength} / Cha #{$player_charisma} / Int #{$player_intelligence} / Dex #{$player_dexterity} / Max Hp #{$player_max_health} / Hp #{$player_health} / Def #{$player_defense}"
    puts "purse: #{$player_coinage}$"
    puts "level: #{$player_level}"
end

def open_inventory
    #
    p $player_inventory
end

def encounter(enemy,strength,defense,hp,lvl,drop)
    start_player_level = $player_level
    player_choice = ""
    puts "You have encountered #{enemy} lvl #{lvl}"
    while hp > 0 && $player_health > 0 
        puts "Attack / Defend / Flee / Inspect"
        player_choice = legal?(["attack","defend","flee","inspect"])
        if player_choice == "attack"
            puts "Base Attack / Skills / Spells"
            player_choice = legal?(["base attack","skills","spells"])
            if player_choice == "base attack"
                $sword_slash.play
                hp -= $player_strength**2/defense 
                puts "You hit #{enemy} for #{$player_strength**2/defense} dmg and #{enemy} now has #{hp} hp"
                if hp > 0
                    $player_health -= strength**2/($player_defense) 
                    puts "#{enemy} hit you for #{strength**2/($player_defense) } dmg and you now have #{$player_health} hp"
                end
            elsif player_choice == "spells"
                puts "Coming in 3-5 business days"
            elsif player_choice == "skills"
                puts "Coming in 3-5 business days"
            end
        elsif player_choice == "defend"
            puts "Block / Potion"
            player_choice = legal?(["block","potion"])
            if player_choice == "block"
                $player_health -= strength**2/($player_defense * 1.5) 
                puts "#{enemy} hit you for #{strength**2/($player_defense * 1.5) } dmg and you now have #{$player_health} hp"
            elsif player_choice == "potion"
                puts "Coming in 3-5 business days"
            end
        elsif player_choice == "flee"
            puts "you tried to  flee :sob: , will be fixed later"
        elsif player_choice == "inspect"
            if $player_skills.include?("Great Sage")
                puts enemy
                puts "Strength #{strength}"
                puts "Defense #{defense}"
                puts "health #{hp}"
            else 
                puts "you cant peer into your enemy"
            end
        end
    end
    if $player_health <= 0
        raise "You died"
    end

    if player_choice != "flee"
        $player_xp += lvl**2 * 10
        $player_level = 1 +(0.14 * Math.sqrt($player_xp)).floor
        level_up_times = $player_level - start_player_level
        for nbr in 1..level_up_times
            $player_intelligence +=1
            $player_charisma += 1
            $player_dexterity +=1
            $player_strength +=1
            $player_max_health += 4
        end
        if drop 
            puts "You gained #{drop}"
            $player_inventory << drop
        end
    end


end

def act1_slime

    #Major Changes will be made
    t = 0
    $path << "slime"

    puts "PART 1 - GELATINOUS GENESIS"
    sleep(5)

    part1_slime = File.readlines("lines//act1_slime//slime_p1.txt").map(&:chomp)
    part1_look = File.readlines("lines//act1_slime//slime_p1look.txt").map(&:chomp)
    part2_search = File.readlines("lines//act1_slime//slime_p2search.txt").map(&:chomp)
    part2_fool_around = File.readlines("lines//act1_slime//slime_p2fool_around.txt").map(&:chomp)
    part2_fight = File.readlines("lines//act1_slime//slime_p2fight.txt").map(&:chomp)
    part2_run = File.readlines("lines//act1_slime//slime_p2run.txt").map(&:chomp)
    part3_a_new_form_and_inherited_will = File.readlines("lines//act1_slime//slime_p3a_new_form_and_inherited_will.txt").map(&:chomp)

    for lines in part1_slime
        puts lines
        sleep(t)
    end
    user_input = gets.to_s.chomp

    if user_input == "look"
        for lines in part1_look
            puts lines
            sleep(t)
        end
    end

    for lines in part2_search
        puts lines
        sleep(t)
    end
    user_input = gets.to_s.chomp
    if user_input == "fool around"
        for lines in part2_fool_around
            puts lines
            sleep(t)
        end
        user_input = gets.to_s.chomp
        if user_input == "fight"
            encounter("wolf",3,3,15,5)
            for lines in part2_fight
                puts lines
                sleep(t)
            end
        elsif user_input == "run"
            for lines in part2_fight
                puts lines
                sleep(t)
            end
        end
    end

    for lines in part3_a_new_form_and_inherited_will
        puts lines
        sleep(t)
    end 
end

def act1_human
    t=0
    $path << "human"

    puts "PART 1 - THE RECKONING OF REBIRTH"
    sleep(5)

    part1_human = File.readlines("lines//act1_human//human_p1.txt").map(&:chomp)

    for lines in part1_human
        puts lines
        sleep(t)
    end

    user_input = legal?(["1","2"])
    if user_input == "1"
        $path << "p1_wake"
        part2_human = File.readlines("lines//act1_human//human_p2wake.txt").map(&:chomp)
    elsif user_input == "2"
        $path << "p1_sleep"
        part2_human = File.readlines("lines//act1_human//human_p2stay.txt").map(&:chomp)
    end

    for lines in part2_human
        puts lines
        sleep(t)
    end

    user_input = legal?(["1","2"])
    if user_input == "1"
        $path << "p2_follow"
    elsif user_input == "2"
        $path << "p2_notfollow"
    end

    
    if $path.include?("p2_follow")
        if $path.include?("p1_wake")
            part3_human = File.readlines("lines//act1_human//human_p3follow+wake.txt").map(&:chomp)
        elsif $path.include?("p1_stay")
            part3_human = File.readlines("lines//act1_human//human_p3follow+sleep.txt").map(&:chomp)
        end
    elsif $path.include?("p2_notfollow")
        part3_human = File.readlines("lines//act1_human//human_p3notfollow.txt").map(&:chomp)
    end

    for lines in part3_human
        puts lines
        sleep(t)
    end
    
    part4_human = File.readlines("lines//act1_human//human_p4.txt").map(&:chomp)

    for lines in part4_human
        puts lines
        sleep(t)
    end

    user_input = legal?(["1","2","3","4"])
    if user_input == "1" || user_input == "2"
        $path << "p4_question"
        part5_human = File.readlines("lines//act1_human//human_p5question.txt").map(&:chomp)
    elsif user_input == "3"
        $path << "p4_continue"
        part7_human = File.readlines("lines//act1_human//human_p7continue.txt").map(&:chomp)
    elsif user_input == "4"
        $path << "p4_encounter"
        part7_human = File.readlines("lines//act1_human//human_p7encounter.txt").map(&:chomp)
    end

    if $path.include?("p4_question")
        for lines in part5_human
            puts lines
            sleep(t)
        end
    end

    if $path.include?("p4_question")
        user_input = legal?(["1","2","3"])
        if user_input == "1"
            $path << "p4_continue"
            part7_human = File.readlines("lines//act1_human//human_p7continue.txt").map(&:chomp)
        elsif user_input == "2"
            $path << "p5_question_1"
            part6_human = File.readlines("lines//act1_human//human_p6question+1.txt").map(&:chomp)
        elsif user_input == "3"
            $path << "p5_question_2"
            part6_human = File.readlines("lines//act1_human//human_p6question+2.txt").map(&:chomp)
        end
    end

    if $path.include?("p5_question_1") || $path.include?("p5_question_2")
        for lines in part6_human
            puts lines
            sleep(t)
        end
        user_input = legal?(["1","2"])
        if user_input == "1"
            $path << "p4_continue"
            part7_human = File.readlines("lines//act1_human//human_p7continue.txt").map(&:chomp)
        elsif user_input == "2"
            $path << "p4_encounter"
            part7_human = File.readlines("lines//act1_human//human_p7encounter.txt").map(&:chomp)
        end
    end

    for lines in part7_human
        puts lines
        sleep(t)
    end

    user_input = legal?(["1","2"])
    if user_input == "2"
        $path << "p7_flee"
        part9_human = File.readlines("lines//act1_human//human_p9flee.txt").map(&:chomp)
    elsif user_input == "1"
        if $path.include?("p4_continue")
            $path << "p7_fight"
            part9_human = File.readlines("lines//act1_human//human_p9fight.txt").map(&:chomp)
        elsif $path.include?("p4_encounter")
            $path << "p7_follow"
            part8_human = File.readlines("lines//act1_human//human_p8encounter_follow.txt").map(&:chomp)
            for lines in part8_human
                puts lines
                sleep(t)
            end
            user_input = legal?("1","2")
            if user_input == "1"
                $path << "p7_fight"
                part9_human = File.readlines("lines//act1_human//human_p9fight.txt").map(&:chomp)
            elsif user_input == "2"
                $path << "p7_flee"
                part9_human = File.readlines("lines//act1_human//human_p9flee.txt").map(&:chomp)
            end
        end
    end
    
    for lines in part9_human
        puts lines
        sleep(t)
    end

    part10_human = File.readlines("lines//act1_human//human_p10arrival.txt").map(&:chomp)
    for lines in part10_human
        puts lines
        sleep(t)
    end
end

def act2
    $slutasnomindaniel.loop = true
    $slutasnomindaniel.play
    puts "Now Playing: ♫ NiSugerochbordeavinstalleravisualstuidocodeSlutasnominDaniel ♫"
    bossmusic = Music.new("sound//bossmusic.mp3")
    x = 5
    y = 0
    t = 1

    #quick intro
    puts "PART 2 - NEW HORIZONS"
    sleep(5)
    #info dump and free world
    part1 = File.readlines("lines//act2//act2_1.txt").map(&:chomp)
    for lines in part1
        puts lines
        sleep(t)
    end
    $slutasnomindaniel.fadeout(3000)

    while true
        puts "move / look / player info / inventory / map"
        action = legal?(["move","look","player info","inventory","map"])
        if action == "move"
            puts "south / north / east / west"
            player_movement = legal?(["south","north","east","west"])
            $map[y][x].position_change
            if player_movement == "south"
                y +=1
                if $map[y][x].location == "mountain" || $map[y][x].location == "  lake  "
                    puts "the passage is blocked and you head back"
                    y -=1
                end
            elsif player_movement == "north"
                y -= 1
                if $map[y][x].location == "mountain" || $map[y][x].location == "  lake  "
                    puts "the passage is blocked and you head back"
                    y +=1
                end
            elsif player_movement == "east"
                x +=1
                if $map[y][x].location == "mountain" || $map[y][x].location == "  lake  "
                    puts "the passage is blocked and you head back"
                    x -=1
                end
            elsif player_movement == "west"
                x -=1
                if $map[y][x].location == "mountain" || $map[y][x].location == "  lake  "
                    puts "the passage is blocked and you head back"
                    x +=1
                end
            end

            $map[y][x].position_change
            $map[y][x].reveal

            if $map[y][x].location == "  cave  "
                break
            elsif $map[y][x].monster
                encounter($map[y][x].monster.monster, $map[y][x].monster.attack, $map[y][x].monster.defense, $map[y][x].monster.health, $map[y][x].monster.level, $map[y][x].monster.drop)
                $map[y][x].monster_died
            end
        elsif action == "look"
            puts $map[y][x].look
        elsif action == "player info"
            inspect_player_info
        elsif action == "inventory"
            open_inventory
        elsif action == "map"
            show_map
        end
    end
    
    miniboss_battle = File.readlines("lines//act2//act2_1boss.txt").map(&:chomp)
    $untitled3.loop = true
    $untitled3.play
    puts "♫ Now Playing: Untitled 3 ♫"
    for lines in miniboss_battle
        puts lines
        sleep(t)
    end

    $untitled3.fadeout(2000)
    
    bossmusic.loop = true
    bossmusic.play
    encounter($map[y][x].monster.monster, $map[y][x].monster.attack, $map[y][x].monster.defense, $map[y][x].monster.health, $map[y][x].monster.level, $map[y][x].monster.drop)
    bossmusic.stop
    puts "PART 3 - PATH OF THE DRAGONSLAYER"


end

def legal?(choices)
    while 
        input = gets.to_s.chomp
        for i in 0..choices.length
            if input == choices[i]
                return choices[i]
            end
        end
        puts "Pwease put a valid answer! :3"
    end
end


def main
    death_and_rebirth

    if $player_race == "Human"
        act1_human
    elsif $player_race == "Slime"
        act1_slime
    elsif $player_race == "Elf"
        puts "Elf storyline does not exist yet. Launching human."
        sleep(2)
        act1_human
    elsif $player_race == "Tengu"
        puts "Tengu storyline does not exist yet. Launching slime."
        sleep(2)
        act1_slime
    elsif $player_race == "Lizardman"
        puts "Lizard storyline does not exist yet. Launching slime."
        sleep(2)
        act1_human
    end

    generate_map_act2
    act2
end

main