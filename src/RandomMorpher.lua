--[[
    Script is done by Krisande#5411
    If you have any questions, please contact me via discord!
    You also can hire me if you want to for some lua scripts!
]]-- 

local NPC_MORPHER = 500030 

local function MorpherOnGossipHello (event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "|TInterface/ICONS/racechange:45:45:-30:0|t Random Morph Myself|r", 0, 1)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/racechange:45:45:-30:0|t Demorph Myself|r", 0, 2)
    if (player:GetClass() == 3) or (player:GetClass() == 9) or (player:GetClass() == 6 and player:HasSpell(52143)) then -- checks for hunter (class 3), for dk with permanent ghoul ability (class 6, spellid from talent 52143) and for warlock (class 9)
        player:GossipMenuAddItem(0, "|TInterface/ICONS/ability_druid_healinginstincts:45:45:-30:0|t Random Morph my Pet|r", 0, 5)
        player:GossipMenuAddItem(0, "|TInterface/ICONS/ability_druid_healinginstincts:45:45:-30:0|t Demorph my Pet|r", 0, 6)
    end
    player:GossipMenuAddItem(0, "|TInterface/ICONS/inv_misc_questionmark:45:45:-30:0|t Show me my Display ID|r", 0, 4)
    player:GossipMenuAddItem(0, "|TInterface/ICONS/misc_arrowleft:45:45:-30:0|t Close|r", 0, 3)
    
    player:GossipSendMenu(1, creature, 100)
end

RegisterCreatureGossipEvent(NPC_MORPHER, 1, MorpherOnGossipHello)

local function MorpherOnGossipSelect(event, player, creature, sender, intid, code)
    local DisplayID = math.random(32781) -- if u have some custom models as well, just raise the number here inside the ()... the 32781 is the last blizzlike wotlk model at creaturedisplayinfo.dbc =)
    local ID = player:GetDisplayId() -- gets the players display id
    local petGUID = player:GetPetGUID() -- gets the pets guid
    local petEntry = GetGUIDEntry(petGUID) -- gets the extact guid entry of the pet!
    local target = player:GetNearestCreature(3, nil, 2, 1) -- checks for a target near the player which is friendly and alive (pet)
    if (intid == 1) then
        player:SetDisplayId(DisplayID) -- sets the display id to a random taken number from math.random(#numbervalue)
        player:GossipComplete() -- closes the gossip menu
    end
        
    if (intid == 2) then
        player:DeMorph() -- demorphs the player
        player:GossipComplete()
    end

    if (intid == 3) then
        player:GossipComplete()
    end
    
    if (intid == 4) then
        player:SendAreaTriggerMessage("Your Display ID is rn "..ID..".") -- sends the display id as areatriggermessage to the player
        player:GossipComplete()
    end

    if (intid == 5) then
        if(petGUID > 0) then -- checks if there is a pet
            if (petEntry ~= nil) then -- double checking it with the exact guid value...
                target:SetDisplayId(DisplayID) -- sets the pets display id to a random number from math.random(#numbervalue)
                player:GossipComplete()
            end
        else -- in case no pet is spawned... send the areatriggermessage to the player
            player:GossipComplete()
            player:SendAreaTriggerMessage("You don't have a pet spawned. Please spawn a pet first to use this feature")
        end
    end

    if (intid == 6) then
        if (petGUID > 0) then
            if (petEntry ~= nil) then
                if (target:GetNativeDisplayId() == target:GetDisplayId()) then -- checks for the original display id of the pet... if it is equal to the actual id then it sends an areatriggermessage
                    player:GossipComplete()
                    player:SendAreaTriggerMessage("Your pet already has its original display id.")
                else -- else your pet id is different from original pet display id then demorph it
                    target:DeMorph() -- demorph the pet
                    player:GossipComplete()
                end
            end
        else 
            player:GossipComplete()
            player:SendAreaTriggerMessage("You don't have a spawned pet. Please spawn a pet first to use this feature")
        end
    end    
end



RegisterCreatureGossipEvent(NPC_MORPHER, 2, MorpherOnGossipSelect)
