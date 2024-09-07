#Requires AutoHotkey v2.0

class Font
{
    Ptr    := 0
    Family := 0
    Handle := 0
    Name   := ""
    Size   := 12
    Style  := 0

    __New(family := "Arial", size := 12, style := 0)
    {
        this.Name  := family
        this.Size  := size
        this.Style := style

        weight    := (style & 1) ? 700 : 400
        italic    := (style & 2) ? true : false
        underline := (style & 4) ? true : false
        strikeout := (style & 8) ? true : false

        this.Handle := DllCall("CreateFont"
            , "Int", -size
            , "Int", 0
            , "Int", 0
            , "Int", 0
            , "Int", weight
            , "UInt", italic
            , "UInt", underline
            , "UInt", strikeout
            , "UInt", 1  ; DEFAULT_CHARSET
            , "UInt", 0  ; OUT_DEFAULT_PRECIS
            , "UInt", 0  ; CLIP_DEFAULT_PRECIS
            , "UInt", 0  ; DEFAULT_QUALITY
            , "UInt", 0  ; DEFAULT_PITCH | FF_DONTCARE
            , "Str", family)


        if GDIP.IsStarted()
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
    }

    __Delete()
    {
        if (this.Ptr) and GDIP.IsStarted()
            DllCall("Gdiplus\GdipDeleteFont", "Ptr", this.Ptr)
        if (this.Family) and GDIP.IsStarted()
            DllCall("Gdiplus\GdipDeleteFontFamily", "Ptr", this.Family)
        if (this.Handle)
            DllCall("DeleteObject", "Ptr", this.Handle)
    }
}

class Text
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