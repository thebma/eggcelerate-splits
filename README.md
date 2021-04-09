# Eggcelerate Splits
A repository holding all the required files for speedrunning [Eggcelerate](https://store.steampowered.com/app/1535490/Eggcelerate/).

Including:
- Autosplitter → [eggcelerate-splitter.asl](./eggcelerate-splitter.asl)
- Any% splits → [eggcelerate-any%.lss](./eggcelerate-any%.lss)
- KeepItAlive% splits → [eggcelerate-kia%.lss](./eggcelerate-kia%.lss)
- Individual Track splits → eggcelerate-trackN.lss

## Installing splits onto LiveSplit:
1. Open LiveSplit
2. Right Click → Open Splits
3. Choose "From File"...
4. Select one of the .lss files you want.
5. Done!

## Installing Auto Splitter onto LiveSplit:
1. Open LiveSplit
2. Right Click → Edit Layout
3. Click the "+" button
4. Choose Control → "Scriptable Auto Splitter"
5. Click "Browse..." and choose the .asl file.
6. Click OK to apply.

**For the options you have:**
- Start → This is the function that causes your time to start.
- Split → This is the function that splits for you.
→ Reset → Resets the timer if a run is aborted half-way.

You can toggle all these options.

**Advanced pane allows you to choose which category.**

**NOTE**: In order for this to work correctly, make sure you have only one option checked. Either "All Tracks" or "Single Tracks" is selected (not both!) and one of the corresponding options is checked.

- All Tracks (1 to 30) Any% splitter → Starts at level 1, Splits on level change, Resets before level 30.
- All Tracks (1 to 30) KeepItAlive% → Starts at level 1, Splits on level change, Resets if the egg is broken before level 30.
- Single Track → Starts at the selected level, splits on checkpoint changes, resets if the checkpoint is set to -1 (before the starting line).

## Using the lsstk.py tool:
The lsstk (LiveSplit Splits Toolkit) tool is a convient way to perform some actions.
An python installation is required to use this.

To clear user data from a .lss file:
```python
py ./tools/lsstk.py --input splits.lss --action cleardata
#or
py ./tools/lsstk.py --i splits.lss -a cd
```

## CheatEngine tables
The cheattable for Eggcelerate can be found in the `ce/Eggcelerate_112.ct` file.