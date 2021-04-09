state("eggcelerate", "1.1.2")
{
    /*
        NOTE:
        You might notice I don't use else if's and return false instead...
        The "Auto Spliting Language" plugin for Visual Studio Code appears to be broken and prevent proper formatting and highlighting.
        To avoid issues with this, we use return false at the end of some "if" statements.
        Apparently this plugin uses a syntax file located in microsoft/vscode on github, no sure why else-if isn't covered there.
        (and the 4800 open issues isn't making this easier to get attention to and not breaking half of Visual Studio code while at it).

        NOTE:
        As I have prior experience with reverse engineering or using cheat engine at all... the persistence for these variables across versions is up for debate.
        Looking back, most of the version 1.1.1 variables, if not all survived the 1.1.2 change.
        I have no clue how these pointer paths work or how they would persist, I did the roundabout thing to grab them again from memory using the same process.
        I am noting that some of these values occasionally error out and produce invalid pointers, people suggest AOB scanning for more consistent results.
        Then again, I have no clue how to go about this to the point where this is 99.9999% reliable.
    */

    // version 1.1.1
    // int GameManager_theCurrentTrack: "UnityPlayer.dll", 0x176F740, 0x0, 0x20, 0xF0, 0x130, 0x100, 0x154, 0x4;
    // bool GameManager_slsGamePaused: "UnityPlayer.dll", 0x1776100, 0x8, 0x8, 0xA0, 0x118, 0xC0, 0x60, 0x8;
    // bool GameManager_CanPausekBackingField: "UnityPlayer.dll", 0x1762010, 0x20, 0x0, 0xD0, 0x38, 0x180, 0x50, 0x724;

    //version 1.1.2
    int GameManager_theCurrentTrack: "UnityPlayer.dll", 0x1776100, 0x8, 0x8, 0xA0, 0x118, 0xC0, 0x60, 0x48;
    bool GameManager_mHasEggBeenDroppedOrALevelSkipped: "UnityPlayer.dll", 0x1776100, 0x8, 0x8, 0xA0, 0x118, 0xD0, 0x28, 0x48;
    int Racecar_mCheckpoint: "UnityPlayer.dll", 0x1776000, 0x38, 0x0, 0x30, 0x20, 0x188, 0x330, 0xF7C;
    bool CursorManager_mIsInGame: "UnityPlayer.dll", 0x1776100, 0x8, 0x8, 0xA0, 0x118, 0xC0, 0x60, 0x44;
}

startup
{
    version = "1.1.2";

    settings.Add("all_tracks", true, "All Tracks (1 to 30)");
    settings.Add("any", true, "Any% category", "all_tracks");
    settings.Add("kia", false, "KeepItAlive% category", "all_tracks");

    settings.Add("single_tracks", false, "Single Track");

    for(int i = 0; i < 30; i++) {
        settings.Add("track_" + (i + 1), false, "Track " + (i + 1), "single_tracks");
    }
}

start 
{
    //We are still in the menu's if this bit is false.
    if(current.CursorManager_mIsInGame == false) {
        return false;
    }

    if(settings["all_tracks"]) 
    {
        //We are at the first track.
        if(current.GameManager_theCurrentTrack == 0) {
            return true;
        }

        return false;
    }
    
    if (settings["single_tracks"])
    {
        //Car did not cross the starting line yet.
        if(current.Racecar_mCheckpoint != 0)
            return false;

        if(current.Racecar_mCheckpoint == old.Racecar_mCheckpoint)
            return false;

        for(int i = 0; i < 30; i++)
        {
            if(settings["track_"+ (i + 1)] && current.GameManager_theCurrentTrack == i) {
                return true;
            }
        }

        return false;
    }
}

split 
{
    if(settings["all_tracks"])
    {
        return current.GameManager_theCurrentTrack > old.GameManager_theCurrentTrack;
    }

    if(settings["single_tracks"])
    {
        return current.Racecar_mCheckpoint > old.Racecar_mCheckpoint;
    }
}

reset
{
    if(settings["single_tracks"] && current.Racecar_mCheckpoint == -1)
    {
        for(int i = 0; i < 30; i++)
        {
            if(settings["track_" + (i + 1)] && current.GameManager_theCurrentTrack == i) {
                return true;
            }
        }

        return false;
    }

    if(settings["all_tracks"] && settings["kia"])
    {
        //The egg was dropped this frame.
        if(current.GameManager_mHasEggBeenDroppedOrALevelSkipped == true 
           && current.GameManager_mHasEggBeenDroppedOrALevelSkipped != old.GameManager_mHasEggBeenDroppedOrALevelSkipped) 
        {
            return true;
        }
    }
}