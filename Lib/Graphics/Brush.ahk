#Requires AutoHotkey v2.0
#Include <GDITools>

class Brush
{
    Color := Color.Black

    __New(color := Color.Black)
    {
        this.Color := color
        if GDIPTools.IsStarted()
        {
            OutputDebug("Creating Brush with color: " . Format("{1:X}", color.ToInt(1)))
            brushPtr := 0
            result := DllCall("Gdiplus\GdipCreateSolidFill", "UInt", color.ToInt(1), "Ptr*", &brushPtr)

            if (result != 0 || !brushPtr)
            {
                throw Error("Failed to create GDI+ Brush. Error code: " . result . ". Color: " . color.ToInt(1))
            }

            this.Ptr := brushPtr
            OutputDebug("Brush created with Ptr: " . this.Ptr)
        }
    }

    __Delete()
    {
        if (this.Ptr) and GDIPTools.IsStarted()
            DllCall("Gdiplus\GdipDeleteBrush", "Ptr", this.Ptr)
    }
}