--[[
Q1 - Fix or improve the implementation of the below methods

local function releaseStorage(player)
player:setStorageValue(1000, -1)
end

function onLogout(player)
if player:getStorageValue(1000) == 1 then
addEvent(releaseStorage, 1000, player)
end
return true
end
--]]

local function releaseStorage(player)
player:setStorageValue(1000, -1)
end

function onLogout(player)
if player:getStorageValue(1000) == 1 then
  addEvent(releaseStorage, 1000, player)  --Improved readability by tabbing out contents of the if statement
  return true
else                                      --Added else statement for insurance
  print("Player is already logged out!")
end
end

--[[
Q2 - Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
-- this method is supposed to print names of all guilds that have less than memberCount max members
local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
local guildName = result.getString("name")
print(guildName)
end
--]]
--Established proper loop  for printing out the guild names that were retrieved, as well as fixing the SQL Query Formatting
function printSmallGuildNames(memberCount)
    local selectGuildQuery = string.format("SELECT name FROM guilds WHERE max_members < %d;", memberCount)
    local resultId = db.storeQuery(selectGuildQuery)
    if resultId ~= 0 then
        repeat
            local guildName = resultId.getDataString(resultId, "name")
            print(guildName)
        until not resultId.next(resultId)
        resultId.free(resultId)
    else
        print("Error: Failed to execute database query.")
    end
end

--[[
Q3 - Fix or improve the name and the implementation of the below method

function do_sth_with_PlayerParty(playerId, membername)
player = Player(playerId)
local party = player:getParty()

for k,v in pairs(party:getMembers()) do
if v == Player(membername) then
party:removeMember(Player(membername))
end
end
end
--]]
--Improved readability and assigned proper name to function
function removePlayerFromParty(playerId, membername)
player = Player(playerId)
local party = player:getParty()

for k,v in pairs(party:getMembers()) do
  if v == Player(membername) then
    party:removeMember(Player(membername))
  end
end
end

--[[
Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
Player* player = g_game.getPlayerByName(recipient);
if (!player) {
player = new Player(nullptr);
if (!IOLoginData::loadPlayerByName(player, recipient)) {
return;
}
}

Item* item = Item::CreateItem(itemId);
if (!item) {
return;
}

g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

if (player->isOffline()) {
IOLoginData::savePlayer(player);
}
}
--]]

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        -- Create a temporary player object
        Player tempPlayer(nullptr);
        
        -- Load player data from storage
        if (!IOLoginData::loadPlayerByName(&tempPlayer, recipient)) {
            return;
        }
        
        -- Create a new player object and copy data from the temporary player
        player = new Player(tempPlayer);
        
        -- Add the new player to the game
        g_game.addPlayer(player);
    }
    
    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }
    
    -- Add the item to the player's inbox
    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
    
    if (player->isOffline()) {
        -- If the player is offline, save player data
        IOLoginData::savePlayer(player);
    }
    
    -- Delete the dynamically allocated player object when it is no longer needed
    delete player;
}
