#Requires AutoHotkey v2.0
#Include <GDITools>

class Pen
{
    Ptr := 0
    Color := Color.Black
    Width := 1

    __New(color := Color.Black, width := 1)
    {
        this.Color := color
        this.Width := width
        colorValue := color.ToInt(1)
        penPtr := 0

        ; Check if GDI+ is Started

        if GDIPTools.IsStarted()
        {
               result := DllCall("Gdiplus\GdipCreatePen1", "UInt", colorValue, "Float", width, "Int", 2, "Ptr*", &penPtr)

               if (result != 0 || !penPtr)
               {
                throw Error("Failed to create GDI+ Pen. Error code: " . result . ". Color: " . colorValue . ", Width: " . width)
            }

            this.Ptr := penPtr
        }
    }

    __Delete()
    {
        if (this.Ptr) and GDIPTools.IsStarted()
            DllCall("Gdiplus\GdipDeletePen", "Ptr", this.Ptr)
    }

    static IsGdiPlusStarted()
    {
        token := Buffer(A_PtrSize, 0)
        startupInput := Buffer(3 * A_PtrSize, 0)
        NumPut("UInt", 1, startupInput)

        result := DllCall("gdiplus\GdiplusStartup", "Ptr*", token.Ptr, "Ptr", startupInput.Ptr, "Ptr", 0)

        if (result = 0)
        {
            DllCall("gdiplus\GdiplusShutdown", "Ptr", NumGet(token, "Ptr"))
            return true
        }

        return false
    }
}