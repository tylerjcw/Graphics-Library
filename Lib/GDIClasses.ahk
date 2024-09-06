#Requires AutoHotkey v2.0
#Include <Geometry>

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
        result := DllCall("Gdiplus\GdipCreatePen1", "UInt", colorValue, "Float", width, "Int", 2, "Ptr*", &penPtr)

        if (result != 0 || !penPtr)
        {
            throw Error("Failed to create GDI+ Pen. Error code: " . result . ". Color: " . colorValue . ", Width: " . width)
        }

        this.Ptr := penPtr
    }

    __Delete()
    {
        if (this.Ptr)
            DllCall("Gdiplus\GdipDeletePen", "Ptr", this.Ptr)
    }
}

class Brush
{
    Color := Color.Black

    __New(color := Color.Black)
    {
        this.Color := color
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

    __Delete()
    {
        if (this.Ptr)
            DllCall("Gdiplus\GdipDeleteBrush", "Ptr", this.Ptr)
    }
}

class Font
{
    Ptr := 0
    Family := 0

    __New(family := "Arial", size := 12, style := 0)
    {
        fontPtr := 0
        familyPtr := 0
        result := DllCall("Gdiplus\GdipCreateFontFamilyFromName", "Str", family, "Ptr", 0, "Ptr*", &familyPtr)
        if (result != 0 || !familyPtr)
        {
            throw Error("Failed to create GDI+ Font Family. Error code: " . result . ". Family: " . family)
        }
        this.family := familyPtr

        result := DllCall("Gdiplus\GdipCreateFont", "Ptr", this.family, "Float", size, "Int", style, "Int", 0, "Ptr*", &fontPtr)
        if (result != 0 || !fontPtr)
        {
            throw Error("Failed to create GDI+ Font. Error code: " . result . ". Size: " . size . ", Style: " . style)
        }
        this.ptr := fontPtr
    }

    __Delete()
    {
        if (this.Ptr)
            DllCall("Gdiplus\GdipDeleteFont", "Ptr", this.Ptr)
        if (this.Family)
            DllCall("Gdiplus\GdipDeleteFontFamily", "Ptr", this.Family)
    }
}

class TextObject
{
    Text := ""
    Position := Point()
    Alignment := {Horizontal: Alignment.H.Left, Vertical: Alignment.V.Top}
    Rotation := 0

    __New(text, position, rotation := 0, hAlign := Alignment.H.Left, vAlign := Alignment.V.Top)
    {
        this.Text := text
        this.Position := position
        this.Alignment.Horizontal := hAlign
        this.Alignment.Vertical := vAlign
        this.Rotation := rotation
    }
}

class Alignment
{
    class H
    {
        static Left   => 0
        static Center => 1
        static Right  => 2
    }

    class V
    {
        static Top    => 0
        static Center => 1
        static Bottom => 2
    }
}

class CMode
{
    static Blended   => 0
    static Overwrite => 1
}

class SMode
{
    static None        => 0
    static HighSpeed   => 1
    static HighQuality => 2
    static Default     => 3
    static AntiAlias   => 4
}

class IMode
{
    static Default             => 0
    static LowQuality          => 1
    static HighQuality         => 2
    static Bilinear            => 3
    static Bicubic             => 4
    static NearestNeighbor     => 5
    static HighQualityBilinear => 6
    static HighQualityBicubic  => 7
}