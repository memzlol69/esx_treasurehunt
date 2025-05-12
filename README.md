# ESX Treasure Hunt

A FiveM resource that adds a treasure hunting system to your server. Players can use treasure maps to find and dig up treasures across the map.

## Features

- Treasure map item system
- Dynamic treasure locations
- Digging animation and interaction
- Configurable rewards
- Cooldowns to prevent spam
- ESX Framework Integration

## Dependencies

- ESX Framework (or QBCore, if you can manage basic modifications)

## Installation

1. Download the resource
2. Place it in your server's resources folder
3. Add `ensure esx_treasurehunt` to your server.cfg
4. Configure the resource to match your server's needs
5. Restart your server

## Configuration

The resource requires configuration to match your server's framework and systems. Here are the main configuration points:

### Framework Functions

```lua
SvConfig.functions = {
    -- Notification system
    SendNotification = function(source, type, title, message, duration)
        -- Replace with your notification system
        -- Example for my server:
        -- exports["bc_hud"]:sendNotification(source, type, title, message, duration)
    end,

    -- Reward system
    GiveReward = function(source)
        -- Modify to adjust rewards appropriately
    end
}
```

### Other Configurations

```lua
Config = {
    -- The item name that will be used as the treasure map
    Item = "treasure_map",

    -- Locale settings
    Locale = {
        ["Schatzkarte"] = "Treasure Map",
        ["AlreadySearching"] = "You are already searching for a treasure!",
        ["TreasureMarked"] = "The treasure location has been marked on your map!",
        ["WaitBeforeDigging"] = "You need to wait before digging again!",
        -- Add more locale strings as needed
    }
}

SvConfig = {
    -- Time in milliseconds for the digging interaction
    interactionTimer = 5000,

    -- Add more server-side configurations as needed
}
```

## Usage

1. Players need to obtain a treasure map item
2. Using the item will mark a random treasure location on their map
3. When players reach the location, they can dig for the treasure
4. After a short digging animation, players receive their reward

## Security Considerations

The resource includes basic security measures:
- Cooldown system to prevent spam
- Distance validation
- State management

However, you should:
2. Add logging (GiveReward)
3. Configure rate limiting based on your server's needs
4. Add proper cleanup for disconnected players

## Support

There will be no support for this resource.

## License

This resource is licensed under the MIT License. See the LICENSE file for details.