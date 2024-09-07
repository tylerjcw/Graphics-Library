#Requires AutoHotkey v2.0

class Brush
{
    Ptr    := 0
    Handle := 0
    Color  := Color.Black

    __New(color := Color.Black)
    {
        this.Color := color

        this.Handle := DllCall("CreateSolidBrush", "UInt", color.ToInt(2))

        if GDIPTools.IsStarted()
        {
            brushPtr := 0
            result := DllCall("Gdiplus\GdipCreateSolidFill", "UInt", color.ToInt(1), "Ptr*", &brushPtr)

            if (result != 0 || !brushPtr)
            {
                throw Error("Failed to create GDI+ Brush. Error code: " . result . ". Color: " . color.ToInt(1))
            }

            this.Ptr := brushPtr
        }
    }

    __Delete()
    {
        if (this.Ptr) and GDIPTools.IsStarted()
            DllCall("Gdiplus\GdipDeleteBrush", "Ptr", this.Ptr)

        if (this.Handle)
            DllCall("DeleteObject", "Ptr", this.Handle)
    }
}