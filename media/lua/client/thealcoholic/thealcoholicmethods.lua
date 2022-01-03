--functions

function increaseFatigue(player, fatigue, chance)
    if chance == 0 
    then
        local currentFatigue = player:getStats():getFatigue();
        player:getStats():setFatigue(currentFatigue + fatigue);
        if player:getStats():getFatigue() > 0.99 
        then
            player:getStats():setFatigue(0.99);
        end
    end
end

function decreaseEndurance(player, endurance, chance)
    if chance == 0 
    then
        local currentEndurance = player:getStats():getEndurance();
        player:getStats():setEndurance(currentEndurance - endurance);
        if player:getStats():getEndurance() < 0 
        then
            player:getStats():setEndurance(0);
        end
    end
end

function increaseStress(player, stress)
    local currentStress = player:getStats():getStress();
    player:getStats():setStress(currentStress + stress);
    if player:getStats():getStress() > 0.99 
    then
        player:getStats():setStress(0.99);
    end
end

function decreaseStress(player, stress)
    local currentStress = player:getStats():getStress();
    player:getStats():setStress(currentStress - stress);
    if player:getStats():getStress() < 0 
    then
        player:getStats():setStress(0);
    end
end

function alcoholicStress(player)
    local currentStress = player:getStats():getStress();
    if currentStress < player:getModData().AlcoholicStress
    then
        player:getStats():setStress(player:getModData().AlcoholicStress)
    end
end

function increaseHappiness(player, happiness)
    local currentUnhappiness = player:getBodyDamage():getUnhappynessLevel();
    player:getBodyDamage():setUnhappynessLevel(currentUnhappiness + happiness);
    if player:getBodyDamage():getUnhappynessLevel() > 99 
    then
        player:getBodyDamage():setUnhappynessLevel(99);
    end
end

function decreaseHappiness(player, unhappiness)
    local currentUnhappiness = player:getBodyDamage():getUnhappynessLevel();
    player:getBodyDamage():setUnhappynessLevel(currentUnhappiness - unhappiness);
    if player:getBodyDamage():getUnhappynessLevel() < 0 then
        player:getBodyDamage():setUnhappynessLevel(0);
    end
end

function increasePain(player, bodyPart, pain, chance)
    if chance == 0 
    then
        local bodyPartType = BodyPartType.FromString(bodyPart);
        local playerBodyPart = player:getBodyDamage():getBodyPart(bodyPartType);
        local currentPain = playerBodyPart:getPain();
        playerBodyPart:setAdditionalPain(currentPain + pain);
        if playerBodyPart:getPain() > 99 
        then
            playerBodyPart:setAdditionalPain(99);
        end
    end
end

function increasePoison(player, poison, chance)
    local currentFoodPoison = player:getBodyDamage():getFoodSicknessLevel();
    if chance == 0 
    then
        if player:HasTrait("WeakStomach") 
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 1.25));
        elseif player:HasTrait("WeakStomach") and player:HasTrait("ProneToIllness")
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 1.5));
        elseif player:HasTrait("WeakStomach") and player:HasTrait("Resilient")
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 1.1));
        elseif player:HasTrait("ProneToIllness")
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 1.2));
        elseif player:HasTrait("ProneToIllness") and player:HasTrait("IronGut")
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 0.95));
        elseif player:HasTrait("IronGut") 
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 0.7));
        elseif player:HasTrait("IronGut") and player:HasTrait("Resilient")
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 0.5));
        elseif player:HasTrait("Resilient")
        then
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + (poison * 0.8));
        else
            player:getBodyDamage():setFoodSicknessLevel(currentFoodPoison + poison);
        end
        if player:getBodyDamage():getFoodSicknessLevel() > 90 then
            player:getBodyDamage():setFoodSicknessLevel(90);
        end
    end
end

function decreaseSanity(player, sanity, chance)
    local currentSanity = player:getStats():getSanity();
end

-- reduces how drunk we are by half
function drunkResistance(player)
    if player:HasTrait("Alcoholic") 
    then
        player:getStats():setDrunkenness(player:getStats():getDrunkenness() * 0.5);
    end
end

function drankAlcohol(player)
    player:getModData().AlcoholicTimeSinceLastDrink = 0;
    player:getModData().AlcoholicThreshold = player:getModData().AlcoholicThreshold + 48;
    if player:getModData().AlcoholicThreshold > THEALCOHOLIC.VALUES.drop9[THEALCOHOLIC.SETTINGS.options.drop9]+1
    then
        player:getModData().AlcoholicThreshold = THEALCOHOLIC.VALUES.drop9[THEALCOHOLIC.SETTINGS.options.drop9]+1
    end
    player:getModData().AlcoholicStress = 0;
    drunkResistance(player);
end

function noDrinkAlcohol(player)
    player:getModData().AlcoholicTimeSinceLastDrink = player:getModData().AlcoholicTimeSinceLastDrink + 1;
    if player:getModData().AlcoholicTimeSinceLastDrink > THEALCOHOLIC.VALUES.drop8[THEALCOHOLIC.SETTINGS.options.drop8]+1
    then
        player:getModData().AlcoholicTimeSinceLastDrink = THEALCOHOLIC.VALUES.drop8[THEALCOHOLIC.SETTINGS.options.drop8]+1
    end
    player:getModData().AlcoholicThreshold = player:getModData().AlcoholicThreshold - 1;
    if player:getModData().AlcoholicThreshold < 0
    then
        player:getModData().AlcoholicThreshold = 0
    end
    player:getModData().AlcoholicStress = player:getModData().AlcoholicStress + 0.005;
    if player:getModData().AlcoholicStress > THEALCOHOLIC.VALUES.drop14[THEALCOHOLIC.SETTINGS.options.drop14]
    then
        player:getModData().AlcoholicStress = THEALCOHOLIC.VALUES.drop14[THEALCOHOLIC.SETTINGS.options.drop14]
    end
end