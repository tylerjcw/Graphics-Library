#Requires AutoHotkey v2.0
#Include Color.ahk
#Include Point.ahk
#Include Vector.ahk
#Include Line.ahk
#Include Ellipse.ahk
#Include Rectangle.ahk

class GDIObj
{
    hdc := ""

    __New(ctrl)
    {
        this.ctrl := ctrl
        this.hdc := DllCall("GetDC", "Ptr", this.ctrl.Hwnd, "Ptr")

        ; Create a compatible DC for double buffering
        this.hMemDC := DllCall("CreateCompatibleDC", "Ptr", this.hdc)

        ; Get the dimensions of the control
        this.ctrl.GetPos(,, &w, &h)

        ; Create a compatible bitmap
        this.hBitmap := DllCall("CreateCompatibleBitmap", "Ptr", this.hdc, "Int", w, "Int", h)

        ; Select the bitmap into the memory DC
        this.hOldBitmap := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", this.hBitmap)
    }

    __Delete()
    {
        ; Clean up resources
        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", this.hOldBitmap)
        DllCall("DeleteObject", "Ptr", this.hBitmap)
        DllCall("DeleteDC", "Ptr", this.hMemDC)
        DllCall("ReleaseDC", "Ptr", this.ctrl.Hwnd, "Ptr", this.hdc)
    }

    Clear(col := Color.White)
    {
        this.ctrl.GetPos(,, &w, &h)
        hBrush := DllCall("CreateSolidBrush", "UInt", col.ToHex("0x{B}{G}{R}").Full)
        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", hBrush)
        DllCall("PatBlt", "Ptr", this.hMemDC, "Int", 0, "Int", 0, "Int", w, "Int", h, "UInt", 0xF00062) ; PATCOPY
        DllCall("DeleteObject", "Ptr", hBrush)
    }

    Render()
    {
        ; Blit the contents of the memory DC to the screen
        this.ctrl.GetPos(,, &w, &h)
        DllCall("BitBlt", "Ptr", this.hdc, "Int", 0, "Int", 0, "Int", w, "Int", h, "Ptr", this.hMemDC, "Int", 0, "Int", 0, "UInt", 0xCC0020) ; SRCCOPY
    }

    DrawRectangle(rect, borderColor := Color.Black, fillColor := Color.White, filled := true, borderThickness := 1)
    {
        if (filled)
        {
            brush := DllCall("CreateSolidBrush", "UInt", fillColor.ToHex("0x{B}{G}{R}").Full)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", brush)

            if (borderColor != 0)
            {
                pen := DllCall("CreatePen", "Int", 0, "Int", borderThickness, "UInt", borderColor.ToHex("0x{B}{G}{R}").Full)
                oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)
            }
            else
            {
                pen := DllCall("GetStockObject", "Int", 5)  ; NULL_PEN
                oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)
            }

            DllCall("Rectangle", "Ptr", this.hMemDC,
                                 "Int", rect.TopLeft.X,
                                 "Int", rect.TopLeft.Y,
                                 "Int", rect.BottomRight.X,
                                 "Int", rect.BottomRight.Y)

            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
            DllCall("DeleteObject", "Ptr", brush)
            if (borderColor != 0)
                DllCall("DeleteObject", "Ptr", pen)
        }
        else
        {
            pen := DllCall("CreatePen", "Int", 0, "Int", borderThickness, "UInt", borderColor.ToHex("0x{B}{G}{R}").Full)
            oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)
            DllCall("Rectangle", "Ptr", this.hMemDC,
                                 "Int", rect.TopLeft.X,
                                 "Int", rect.TopLeft.Y,
                                 "Int", rect.BottomRight.X,
                                 "Int", rect.BottomRight.Y)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
            DllCall("DeleteObject", "Ptr", pen)
        }
    }

    DrawEllipse(ellipse, borderColor := Color.Black, fillColor := Color.White, filled := true, borderThickness := 1)
    {
        steps := 360
        points := []

        Loop steps + 1
        {
            i := A_Index - 1
            angle := (i / steps) * 2 * 3.14159
            x := ellipse.SemiMajorAxis * Cos(angle)
            y := ellipse.SemiMinorAxis * Sin(angle)

            rotatedX := x * Cos(ellipse.Rotation * (3.14159 / 180)) - y * Sin(ellipse.Rotation * (3.14159 / 180))
            rotatedY := x * Sin(ellipse.Rotation * (3.14159 / 180)) + y * Cos(ellipse.Rotation * (3.14159 / 180))

            points.Push([ellipse.Center.X + rotatedX, ellipse.Center.Y + rotatedY])
        }

        if (filled)
        {
            brush := DllCall("CreateSolidBrush", "UInt", fillColor.ToHex("0x{B}{G}{R}").Full)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", brush)

            if (borderColor != 0)
            {
                pen := DllCall("CreatePen", "Int", 0, "Int", borderThickness, "UInt", borderColor.ToHex("0x{B}{G}{R}").Full)
                oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)
            }
            else
            {
                pen := DllCall("GetStockObject", "Int", 5)  ; NULL_PEN
                oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)
            }

            DllCall("Polygon", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", points.Length)

            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
            DllCall("DeleteObject", "Ptr", brush)
            if (borderColor != 0)
                DllCall("DeleteObject", "Ptr", pen)
        }
        else
        {
            pen := DllCall("CreatePen", "Int", 0, "Int", borderThickness, "UInt", borderColor.ToHex("0x{B}{G}{R}").Full)
            oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)
            DllCall("Polyline", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", points.Length)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
            DllCall("DeleteObject", "Ptr", pen)
        }

        PointsToBuffer(points)
        {
            buf := Buffer(8 * points.Length)
            for i, point in points
                NumPut("Int", point[1], "Int", point[2], buf, (i - 1) * 8)
            return buf
        }
    }

    DrawLine(line, lineColor, thickness := 1)
    {
        x1 := line.Start.X
        y1 := line.Start.Y
        x2 := line.End.X
        y2 := line.End.Y
        pen := DllCall("CreatePen", "Int", 0, "Int", thickness, "UInt", lineColor.ToHex("0x{B}{G}{R}").Full)
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)

        DllCall("MoveToEx", "Ptr", this.hMemDC, "Int", x1, "Int", y1, "Ptr", 0)
        DllCall("LineTo", "Ptr", this.hMemDC, "Int", x2, "Int", y2)

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", pen)
    }

    DrawBezier(bezier, color, thickness := 1, pts := 100)
    {
        points := bezier.GetPoints(pts)  ; Get 100 points along the Bezier curve

        pen := DllCall("CreatePen", "Int", 0, "Int", thickness, "UInt", color.ToHex("0x{B}{G}{R}").Full)
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)

        DllCall("MoveToEx", "Ptr", this.hMemDC, "Int", points[1].X, "Int", points[1].Y, "Ptr", 0)

        for i, point in points
        {
            if (i > 1)
            {
                DllCall("LineTo", "Ptr", this.hMemDC, "Int", point.X, "Int", point.Y)
            }
        }

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", pen)
    }

    DrawGradient(x, y, width, height, colors, angle := 0)
    {
        steps := colors.Length

        if (angle == 90 || angle == 270) ; Vertical gradient
        {
            stepHeight := height / steps
            for i, col in colors
            {
                startY := y + (i - 1) * stepHeight
                endY := startY + stepHeightBrush := DllCall("CreateSolidBrush", "UInt", col.ToHex("0x{B}{G}{R}").Full)
                DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", hBrush)

                rect := Buffer(16)
                NumPut("Int", x, rect, 0)
                NumPut("Int", Round(startY), rect, 4)
                NumPut("Int", x + width, rect, 8)
                NumPut("Int", Round(endY), rect, 12)

                DllCall("FillRect", "Ptr", this.hMemDC, "Ptr", rect, "Ptr", hBrush)
                DllCall("DeleteObject", "Ptr", hBrush)
            }
        }
        else ; Horizontal gradient (default) or any other angle
        {
            stepWidth := width / steps
            for i, col in colors
            {
                startX := x + (i - 1) * stepWidth
                endX := startX + stepWidth

                hBrush := DllCall("CreateSolidBrush", "UInt", col.ToHex("0x{B}{G}{R}").Full)
                DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", hBrush)

                rect := Buffer(16)
                NumPut("Int", Round(startX), rect, 0)
                NumPut("Int", y, rect, 4)
                NumPut("Int", Round(endX), rect, 8)
                NumPut("Int", y + height, rect, 12)

                DllCall("FillRect", "Ptr", this.hMemDC, "Ptr", rect, "Ptr", hBrush)
                DllCall("DeleteObject", "Ptr", hBrush)
            }
        }
    }

    CreateGradientBrush(x1, y1, x2, y2, color1, color2)
    {
        pBrush := Buffer(40)
        NumPut("Int", x1, pBrush, 0)
        NumPut("Int", y1, pBrush, 4)
        NumPut("Int", x2, pBrush, 8)
        NumPut("Int", y2, pBrush, 12)
        NumPut("UInt", color1.ToHex("0x{B}{G}{R}").Full, pBrush, 16)
        NumPut("UInt", color2.ToHex("0x{B}{G}{R}").Full, pBrush, 20)
        return pBrush
    }

    DrawText(x, y, width, height, text, col := Color.Black, fontSize := 15, fontName := "Arial", align := "left")
    {
        DllCall("SetTextColor", "Ptr", this.hMemDC, "UInt", col.ToHex("0x{B}{G}{R}").Full)
        DllCall("SetBkMode", "Ptr", this.hMemDC, "Int", 1)  ; TRANSPARENT

        hFont := DllCall("CreateFont", "Int", fontSize, "Int", 0, "Int", 0, "Int", 0
            , "Int", 400, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0
            , "UInt", 0, "UInt", 0, "UInt", 0, "Str", fontName)

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", hFont)

        rect := Buffer(16)
        NumPut("Int", x, rect, 0)
        NumPut("Int", y, rect, 4)
        NumPut("Int", x + width, rect, 8)
        NumPut("Int", y + height, rect, 12)

        format := 0
        if (align = "center")
            format |= 0x1  ; DT_CENTER
        else if (align = "right")
            format |= 0x2  ; DT_RIGHT
        format |= 0x100  ; DT_VCENTER

        DllCall("DrawText", "Ptr", this.hMemDC, "Str", text, "Int", -1, "Ptr", rect, "UInt", format)

        DllCall("DeleteObject", "Ptr", hFont)
    }
}

/**; Create a GUI with a picture control
MyGui := Gui()
pic := MyGui.Add("Pic", "w300 h200")
MyGui.Show()

; Create a GDIObj instance for the picture control
gdi := GDIObj(pic)

; Clear the background to white
gdi.Clear(Color.White)

; Draw a blue ellipse
gdi.DrawGradient(0, 0, 300, 200, 45, Color.Red, Color.Green, Color.Blue)
; Render the drawing
gdi.Render()

; Keep the script running
SetTimer((*) => true, 10)