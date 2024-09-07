#Requires AutoHotkey v2.0
#Include <GDI+Obj>

Magnifier.Start()

class Magnifier
{
    static gui := ""
    static gdi := ""
    static captureSize := 64
    static scale := 4
    static BorderPen := Pen(Color.Black, 2)

    static Start()
    {
        ; Set the coordinate mode to screen relative
        CoordMode("Mouse", "Screen")

        ; Set the cursor to crosshair
        hCross := DllCall("LoadCursor", "Ptr", 0, "Ptr", 32515)
        for cursorId in [32512, 32513, 32514, 32515, 32516, 32631, 32640, 32641, 32642, 32643, 32644, 32645, 32646, 32648, 32649, 32650, 32651]
            DllCall("SetSystemCursor", "Ptr", DllCall("CopyImage", "Ptr", hCross, "UInt", 2, "Int", 0, "Int", 0, "UInt", 0), "UInt", cursorId)

        ; Create the window and GDI+ Object
        this.gdi := GDIPlusObj.CreateWindow(this.captureSize * this.scale + 1, this.captureSize * this.scale + 1)

        ; Set the update timer
        SetTimer(() => this.Update(), 16)

        ; Set some hotkeys to exit the app
        Hotkey("LButton", (*) => Magnifier.Exit())
        Hotkey("Q"      , (*) => Magnifier.Exit())
    }

    static Update()
    {
        ; Get the mouse position and calculate offset
        MouseGetPos(&x, &y)
        halfSize := this.captureSize // 2

        ; Move the Gui to the mouse position, plus the offset
        this.gdi.Control.Move(x + halfSize, y + halfSize)

        ; Set up the source and destination rectangles
        srcRect := Rectangle(Point(x - halfSize, y - halfSize), this.captureSize, this.captureSize)
        destRect := Rectangle(Point(0, 0), this.captureSize * this.scale, this.captureSize * this.scale)

        ; Blit the screen capture and draw a border around it
        this.gdi.BitBltScreen(srcRect, destRect)
        this.gdi.DrawRectangle(destRect, this.BorderPen)

        ; Render the frame
        this.gdi.Render()
    }

    static Exit()
    {
        ; Reset the cursor and exit
        DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, "Ptr", 0, "UInt", 0)
        ExitApp(0)
    }
}