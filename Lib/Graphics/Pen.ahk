#Requires AutoHotkey v2.0

class Pen
{
    Ptr    := 0
    Handle := 0
    Color  := Color.Black
    Width  := 1

    __New(color := Color.Black, width := 1)
    {
        local penPtr := 0
        this.Color := color
        this.Width := width

        this.Handle := DllCall("CreatePen", "Int", 0, "Int", width, "UInt", color.ToInt(2))

        ; Check if GDI+ is Started, if it is Create the Pen for it
        if GDIP.IsStarted()
        {
            result := DllCall("Gdiplus\GdipCreatePen1", "UInt", color.ToInt(1), "Float", width, "Int", 2, "Ptr*", &penPtr)

            if (result != 0 || !penPtr)
            {
                throw Error("Failed to create GDI+ Pen. Error code: " result ". Color: " color.ToInt(1) ", Width: " width)
            }

            this.Ptr := penPtr
        }
    }

    __Delete()
    {
        if (this.Ptr) and GDIP.IsStarted()
            DllCall("Gdiplus\GdipDeletePen", "Ptr", this.Ptr)

        if (this.Handle)
            DllCall("DeleteObject", "Ptr", this.Handle)
    }

    UpdatePen()
    {

    }
}