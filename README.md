# AutoHotKey v2 Graphics Library
___
A GDI and GDI+ library of mine currently in development for AutoHotKey v2.0. It needs a better name.

This library provides two main classes - `GDIObj` and `GDIPlusObj`, along with a host of supporting classes like `Brush`, `Pen`, `Ellipse`, `Vector`, etc...
It's main goal is to provide another way to access and use GDI and GDI+ in AutoHotKey v2.0.
It does not currently support layered windows, they are on the list of features to add.
Right now it is currently in active development, and nowhere near complete.
Expect a lot of changes, frequently.

___

The two main classes are designed to be as close to "drop-in replacement" interchangeable as possible.

For example, drawing a rotated rectangle with GDI:
```
; Create a 480x340 window and draw directly to it.
canvas := GDIObj.CreateWindow(480, 340)

; Make the Rectangle
topLeft := Point(176, 106)
width   := 128
height  := 128
rect    := Rectangle(topLeft, width, height)

; Rotate the Rectangle around it's center 45°
rect.Rotate(45)

; Make the Pen and Brush
borderPen := Pen(Color.Teal, 5)
fillBrush := Brush(Color.Purple)

; Draw the Rectangle
canvas.DrawRectangle(rect, borderPen, fillBrush)
canvas.Render()
```

And with GDI+
```
; Create a 480x340 window and draw directly to it.
canvas := GDIPlusObj.CreateWindow(480, 340)

; Make the Rectangle
topLeft := Point(176, 106)
width   := 128
height  := 128
rect    := Rectangle(topLeft, width, height)

; Rotate the Rectangle around it's center 45°
rect.Rotate(45)

; Make the Pen and Brush
borderPen := Pen(Color.Teal, 5)
fillBrush := Brush(Color.Purple)

; Draw the Rectangle
canvas.DrawRectangle(rect, borderPen, fillBrush)
canvas.Render()
```

Did you see the difference on your first read through?

If you wanted to do that in one line, for whatever reason, you can (GDI or GDI+):
```
GDIPlusObj.CreateWindow(480, 340).DrawRectangle(Rectangle(Point(176, 106), 128, 128).Rotate(45), Pen(Color.Teal, 5), Brush(Color.Purple)).Render()
```
