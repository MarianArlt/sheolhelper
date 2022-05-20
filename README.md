# SheolHelper
A windower addon for Final Fantasy XI

This addon is supposed to help you on your farming sessions by displaying a segment counter, a resistance table of your current target including cruel joke and on-command maps (maps are work in progress).

This addon is for your sole convenience while farming segments. Overlays will only be shown in Odyssey.
Try to always load before entering. You can drag segments and resistances around individually.
**The resistance table is not a completely accurate representation of actual game data**.
Segments might get lost to "lag" but will catch up if you keep killing mobs.
This means that the last (few) mob(s) you kill in a run might not count if you lag too much.
**Use as orientation only**!

    //shh toggle [segments/resistances/joke] : Shows/hides either info
    //shh bg [segments/resistances/all] [0-255] : Sets the alpha channel for backgrounds
    //shh conserve : Toggles segments being shown in Rabao after a run
    //shh map : Toggle the current floor's map
    //shh map center : Repositions the map to the center of the screen
    //shh map size [size] : Sets the map to the new [size]
    //shh map floor [floor] : Sets the map to reflect [floor]

Most resistances are there but in some rare instances there might be a monsters data missing. If you don't get any resistances shown for a certain mob, please let me know in the issue tracker.
Sheol A mobs do not have information on weapon type resistance bonuses yet, these need testing and should probably also be added to clopedias once known.

If you find certain resistances to be way off or have proof of testing and similar to show different values, please feel free to open an issue or even make a PR.