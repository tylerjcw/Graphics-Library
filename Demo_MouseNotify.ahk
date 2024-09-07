#Requires AutoHotkey v2.0

#Include <GDIObj>
#Include <Geometry>
#Include <GDIClasses>

notify := MouseNotify(15, 15, Color.White) ; White will be the background color and transparency color
Hotkey("W", (*) => notify.Toggle("msg1", "Test 1", Color.Purple))
Hotkey("A", (*) => notify.Toggle("msg2", "Test 2", Color.Maroon))
Hotkey("S", (*) => notify.Toggle("msg3", "Test 3", Color.Green))
Hotkey("D", (*) => notify.Toggle("msg4", "Test 4", Color.Teal))

class MouseNotify
{
    __New(offsetX := 15, offsetY := 15, bgColor := Color.White)
    {
        CoordMode("Mouse", "Screen")
        this.offsetX := offsetX
        this.offsetY := offsetY
        this.bgColor := bgColor
        this.messages := Map()
        this.width := 200
        this.height := 100
        this.font := Font("Maple Mono", 14)

        this.Gdi := GDIObj.CreateWindow(this.width, this.height)
        this.Gdi.SetTransColor(this.bgColor)
        this.Redraw()

        SetTimer((*) => this.Update(), 16)
        Hotkey("Q", (*) => ExitApp())
    }

    Add(key, text, color := Color.White)
    {
        this.messages[key] := {text: text, color: color}
        this.Redraw()
    }

    Remove(key)
    {
        this.messages.Delete(key)
        this.Redraw()
    }

    Toggle(key, text, color := Color.White)
    {
        if this.messages.Has(key)
            this.Remove(key)
        else
            this.Add(key, text, color)
    }

    Redraw()
    {
        this.Gdi.Clear(this.bgColor)
        this.Gdi.DrawRectangle(Rectangle(Point(0, 0), 2, 2), Pen(Color.Green), Brush(Color.Green))
        y := 5
        for key, msg in this.messages
        {
            textObj := TextObject(msg.text, Point(25, y))
            this.Gdi.DrawText(textObj, this.font, Brush(msg.color))
            this.Gdi.DrawRectangle(Rectangle(Point(5, y), 15, 15), Pen(msg.color.Invert(), 1), Brush(msg.color))
            y += 20
        }
        this.Gdi.Render()
    }

    Update()
    {
        MouseGetPos(&x, &y)
        x += this.offsetX
        y += this.offsetY
        this.Gdi.Control.Move(x, y)
    }
}