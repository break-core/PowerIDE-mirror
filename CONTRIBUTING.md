# Contribution guide for PowerIDE
This guide served as the fundamental method of contributing to PowerIDE. It is important that you read this guide before making any contributions.

## How do I edit code?
Your best bet is to either download the repo or grab a copy of the code from the Releases if you want to edit the code in Studio. You will need SOME way to copy your code back to this repository when PR'ing your changes.

## Structure of PowerIDE
Admittedly, the structure of PowerIDE is not clean, so I'll just document it here really quickly:
- `IDEPlugin` is the main folder for the source code.
- `BuildGui.rbxmx` and `MainGui.rbxmx` are `RBXMX` files for 2 of the core GUIs used in PowerIDE. For right now (until we get Rojo), export any changes you make to these GUIs as RBXMX.
- `Main.server.luau` is a `Script` which acts as a bootstrapper for the entire plugin. Without it, nothing would load.
- `Libraries` contains misc. libraries that are used by PowerIDE, like NativeMessageBox.
- `Powerlang` contains primary Powerlang modules, as well as the `PowerlangCore` (the backbone of Powerlang)
- `PowerlangCore` is the core of Powerlang. This is what holds everything together, like glue!
- `AbstractLibraries` contains code to handle various libraries, services, and types within Powerlang. Essentially it's an extra layer of glue for your Powerlang code.
- `Tests` contains... well, testing code! All of it is disabled within the PowerIDE plugin, so you probably shouldn't enable these unless you know what you're doing.
- `VisualLibrary` contains an implementation of the library used to generate valid visual block data within compilation. Currently, the V2 format is the only one supported. A half-baked V3 implementation exists here too, but DON'T use it. DO NOT USE IT.

## What can I add to PowerIDE/Powerlang?
Well, anything you want. Just make sure it works! Also, don't add things that are very specific, like built-in "macros" for things that only you will use. You can have your own private fork for that.

If you want to write core code for Powerlang, this guide gives you no advice. Just look around until you can piece things together.