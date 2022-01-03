-- initialize variables in mod data

function alcoholicDataInit(playernum, character)
    local player = getSpecificPlayer(playernum); 

    -- hours since last drink
    if player:getModData().AlcoholicTimeSinceLastDrink == nil 
    then
        player:getModData().AlcoholicTimeSinceLastDrink = 0;
    end

    -- progress towards becoming an alcoholic
    if player:getModData().AlcoholicThreshold == nil 
    then
        player:getModData().AlcoholicThreshold = 0;
    end

    -- added stress from not drinking
    if player:getModData().AlcoholicStress == nil
    then
        player:getModData().AlcoholicStress = 0;
    end

    if player:HasTrait("Alcoholic")
    then
        player:getInventory():AddItem("Base.BeerEmpty");
    end
end

Events.OnCreatePlayer.Add(alcoholicDataInit);

function alcoholicExistingGameInit(player)
    if player:getModData().AlcoholicTimeSinceLastDrink == nil 
    then
        player:getModData().AlcoholicTimeSinceLastDrink = 0;
    end

    if player:getModData().AlcoholicThreshold == nil 
    then
        player:getModData().AlcoholicThreshold = 0;
    end
    if player:getModData().AlcoholicStress == nil
    then
        player:getModData().AlcoholicStress = 0;
    end
end

Events.OnPlayerUpdate.Add(alcoholicExistingGameInit);

function alcoholicTrait()
    for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
        local drunk = player:getStats():getDrunkenness();

        if drunk > 0 
        then
            drankAlcohol(player);
        else
            noDrinkAlcohol(player);
        end

        if player:HasTrait("Alcoholic") 
        then
            local timeSinceDrink = player:getModData().AlcoholicTimeSinceLastDrink;
            
            -- debug
            print("Hours since last drink:"..timeSinceDrink);
            print("Alcoholic stress level:"..player:getModData().AlcoholicStress);
            -- end debug
            
            if timeSinceDrink > THEALCOHOLIC.VALUES.drop4[THEALCOHOLIC.SETTINGS.options.drop4] and timeSinceDrink <= THEALCOHOLIC.VALUES.drop5[THEALCOHOLIC.SETTINGS.options.drop5]
            then
                increaseStress(player, 0.10)
                increaseFatigue(player, 0.05, ZombRand(7))
                decreaseHappiness(player, 2)
            elseif timeSinceDrink > THEALCOHOLIC.VALUES.drop5[THEALCOHOLIC.SETTINGS.options.drop5] and timeSinceDrink <= THEALCOHOLIC.VALUES.drop6[THEALCOHOLIC.SETTINGS.options.drop6]
            then
                increaseStress(player, 0.15)
                increaseFatigue(player, 0.05, ZombRand(4))
                decreaseHappiness(player, 6)
                if (THEALCOHOLIC.SETTINGS.options.box1) == true
                then
                    increasePain(player, "Head", ZombRand(THEALCOHOLIC.VALUES.drop11[THEALCOHOLIC.SETTINGS.options.drop11]), ZombRand(THEALCOHOLIC.VALUES.drop11[THEALCOHOLIC.SETTINGS.options.drop11]))
                end
            elseif timeSinceDrink > THEALCOHOLIC.VALUES.drop6[THEALCOHOLIC.SETTINGS.options.drop6] and timeSinceDrink <= THEALCOHOLIC.VALUES.drop7[THEALCOHOLIC.SETTINGS.options.drop7]
            then
                increaseStress(player, 0.25)
                increaseFatigue(player, 0.05, ZombRand(3))
                decreaseHappiness(player, 7)
                if (THEALCOHOLIC.SETTINGS.options.box1) == true
                then
                    increasePain(player, "Head", ZombRand(THEALCOHOLIC.VALUES.drop11[THEALCOHOLIC.SETTINGS.options.drop11]+10), ZombRand(THEALCOHOLIC.VALUES.drop11[THEALCOHOLIC.SETTINGS.options.drop11]-1))
                end
                if (THEALCOHOLIC.SETTINGS.options.box2) == true
                then
                    increasePoison(player, ZombRand(THEALCOHOLIC.VALUES.drop10[THEALCOHOLIC.SETTINGS.options.drop10]), ZombRand(THEALCOHOLIC.VALUES.drop12[THEALCOHOLIC.SETTINGS.options.drop12]))
                end
            elseif timeSinceDrink > THEALCOHOLIC.VALUES.drop7[THEALCOHOLIC.SETTINGS.options.drop7] and timeSinceDrink <= THEALCOHOLIC.VALUES.drop8[THEALCOHOLIC.SETTINGS.options.drop8]
            then
                increaseStress(player, 0.3)
                increaseFatigue(player, 0.1, ZombRand(2))
                decreaseHappiness(player, 10)
                if (THEALCOHOLIC.SETTINGS.options.box1) == true
                then
                    increasePain(player, "Head", ZombRand(THEALCOHOLIC.VALUES.drop11[THEALCOHOLIC.SETTINGS.options.drop11]+15), ZombRand(THEALCOHOLIC.VALUES.drop11[THEALCOHOLIC.SETTINGS.options.drop11]-2))
                end
                if (THEALCOHOLIC.SETTINGS.options.box2) == true
                then
                    increasePoison(player, ZombRand(THEALCOHOLIC.VALUES.drop10[THEALCOHOLIC.SETTINGS.options.drop10]+20), ZombRand(THEALCOHOLIC.VALUES.drop12[THEALCOHOLIC.SETTINGS.options.drop12]-1))
                end
            elseif timeSinceDrink > THEALCOHOLIC.VALUES.drop8[THEALCOHOLIC.SETTINGS.options.drop8] and (THEALCOHOLIC.SETTINGS.options.box3) == true
            then
                player:getTraits():remove("Alcoholic");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_AlcoholicLost"), true, HaloTextHelper.getColorGreen());
            end
        else
            if player:getModData().AlcoholicThreshold > THEALCOHOLIC.VALUES.drop9[THEALCOHOLIC.SETTINGS.options.drop9]  and (THEALCOHOLIC.SETTINGS.options.box3) == true
            then
                player:getTraits():add("Alcoholic");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Alcoholic"), true, HaloTextHelper.getColorRed());
            end
        end
    end
end

Events.EveryHours.Add(alcoholicTrait);

function alcoholicStressCheck()
    for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
        alcoholicStress(player)
    end
end

Events.EveryTenMinutes.Add(alcoholicStressCheck)

