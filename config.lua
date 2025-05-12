Config = {
    functions = {
        ShowHelpNotification = function(message)
            exports["bc_hud"]:sendPress(message)
        end
    },
    PropTreasure = "xm_prop_x17_chest_closed",
    PropShovel = "prop_ld_shovel",
    Item = "schatzkarte", -- Treasure Map Item

    Anims = {
        -- Schaufeln
        ShovelDict = "random@burial",
        ShovelAnim = "a_burial",
        ShovelStop = "a_burial_stop",

        -- Kiste öffnen
        ChestOpenDict = "anim@TreasureHunt@DoubleAction@Action",
        ChestOpenAnim = "HOLD_CHEST",

        -- Bücken
        PickupDict = "anim@treasurehunt@hatchet@action",
        PickupAnim = "hatchet_pickup",
    },

    Locale = {
        ["Schatzkarte"] = "Schatzkarte",
        ["AlreadySearching"] = "Du suchst bereits einen Schatz!",
        ["TreasureMarked"] = "Der Schatz wurde auf deinem GPS markiert!",
        ["WaitBeforeDigging"] = "Bitte warte ein paar Sekunden, bevor du erneut versuchst, zu graben!",
        ["PressToDig"] = "Drücke ~INPUT_PICKUP~ um zu graben!",

    }
}