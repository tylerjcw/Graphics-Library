#Requires AutoHotkey v2.0
#Include <Geometry\Point>

class GDIObj
{
    hdc          := 0
    Control      := 0
    hMemDC       := 0
    hBitmap      := 0
    hOldBitmap   := 0
    RefreshTimer := 0

    HDCRefreshRate := 60000

    __New(Control)
    {
        SetTimer(this.RefreshHDC.Bind(this), this.HDCRefreshRate)
        this.Control := Control
        this.RefreshHDC()
    }

    __Delete()
    {
        ; Clean up resources
        SetTimer(this.RefreshHDC.Bind(this), 0)
        GDI.SelectObject(this.hMemDC, this.hOldBitmap)
        GDI.DeleteObject(this.hBitmap)
        GDI.DeleteDC(this.hMemDC)
        GDI.ReleaseDC(this.Control.Hwnd, this.hdc)
    }

    static CreateWindow(width, height, options := "-Caption +ToolWindow +AlwaysOnTop")
    {
        gdipGui := Gui(options)
        gdipGui.Show("w" width " h" height)

        ;DllCall("SetLayeredWindowAttributes", "Ptr", gdipGui.Hwnd, "UInt", 0, "UChar", 255, "UInt", 2)

        gdi := GDIObj(gdipGui)
        return gdi
    }

    SetTransColor(color)
    {
        WinSetTransColor(color.ToInt(3), "ahk_id" this.Control.Hwnd)
    }

    SetRefreshRate(newRate)
    {
        this.HDCRefreshRate := 1000 * newRate
        SetTimer(this.RefreshHDC.Bind(this), this.HDCRefreshRate)
    }

    RefreshHDC(*)
    {
        this.hdc := GDI.GetDC(this.Control.Hwnd)

        ; Create a compatible DC for double buffering
        this.hMemDC := GDI.CreateCompatibleDC(this.hdc)

        ; Get the dimensions of the control
        this.Control.GetPos(,, &w, &h)

        ; Create a compatible bitmap
        this.hBitmap := GDI.CreateCompatibleBitmap(this.hdc, w, h)

        ; Select the bitmap into the memory DC
        this.hOldBitmap := GDI.SelectObject(this.hMemDC, this.hBitmap)
    }

    Clear(col := Color.White)
    {
        this.Control.GetPos(,, &w, &h)
        hBrush := GDI.CreateSolidBrush(col.ToInt(2))
        GDI.SelectObject(this.hMemDC, hBrush)
        GDI.PatBlt(this.hMemDC, 0, 0, w, h, 0xF00062) ; PATCOPY
        GDI.DeleteObject(hBrush)
    }

    Render()
    {
        ; Blit the contents of the memory DC to the screen
        this.Control.GetPos(,, &w, &h)
        GDI.BitBlt(this.hdc, 0, 0, w, h, this.hMemDC, 0, 0, 0xCC0020) ; SRCCOPY
    }

    DrawRectangle(rect, pen, brush := 0)
    {
        ; Calculate all corner points
        points := []
        points.Push(rect.TopLeft)
        points.Push(Point(rect.BottomRight.X, rect.TopLeft.Y))
        points.Push(rect.BottomRight)
        points.Push(Point(rect.TopLeft.X, rect.BottomRight.Y))

        ; Apply rotation for drawing only
        for i, pt in points
            points[i] := RotatePoint(pt, rect.Center, rect.Rotation)

        ; Draw the rotated rectangle
        oldPen := GDI.SelectObject(this.hMemDC, pen.Handle)

        if (brush != 0)
        {
            oldBrush := GDI.SelectObject(this.hMemDC, brush.Handle)
            GDI.Polygon(this.hMemDC, points)
            GDI.SelectObject(this.hMemDC, oldBrush)
        }
        else
        {
            GDI.PolyLine(this.hMemDC, points)
            GDI.LineTo(this.hMemDC, points[1].X, points[1].Y) ; Close the rectangle
        }

        GDI.SelectObject(this.hMemDC, oldPen)

        RotatePoint(pt, center, angle)
        {
            angle := angle * (3.14159 / 180)  ; Convert to radians
            x := pt.X - center.X
            y := pt.Y - center.Y
            newX := x * Cos(angle) - y * Sin(angle) + center.X
            newY := x * Sin(angle) + y * Cos(angle) + center.Y
            return {X: newX, Y: newY}
        }
    }

    DrawEllipse(ellipse, pen, brush := 0)
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

            points.Push(Point(ellipse.Center.X + rotatedX, ellipse.Center.Y + rotatedY))
        }

        oldPen := GDI.SelectObject(this.hMemDC, pen.Handle)

        if (brush != 0)
        {
            oldBrush := GDI.SelectObject(this.hMemDC, brush.Handle)
            GDI.Polygon(this.hMemDC, points)
            GDI.SelectObject(this.hMemDC, oldBrush)
        }
        else
        {
            GDI.PolyLine(this.hMemDC, points)
        }

        GDI.SelectObject(this.hMemDC, oldPen)
    }

    DrawLine(line, pen)
    {
        oldPen := GDI.SelectObject(this.hMemDC, pen.Handle)

        GDI.MoveToEx(this.hMemDC, line.Start.X, line.Start.Y, 0)
        GDI.LineTo(this.hMemDC, line.End.X, line.End.Y)

        GDI.SelectObject(this.hMemDC, oldPen)
    }

    DrawBezier(bezier, pen, resolution := 1)
    {
        points := bezier.GetPoints(bezier.Points.Length * resolution)  ; Get points along the Bezier curve

        oldPen := GDI.SelectObject(this.hMemDC, pen.Handle)

        GDI.MoveToEx(this.hMemDC, points[1].X, points[1].Y, 0)

        for i, pt in points
        {
            if (i > 1)
            {
                GDI.LineTo(this.hMemDC, pt.X, pt.Y)
            }
        }

        GDI.SelectObject(this.hMemDC, oldPen)
    }

    DrawGradient(gradient, pos, height := 0)
    {
        x := pos.X
        y := pos.Y

        if (height == 0)
            height := this.Control.Pos.H

        for i, col in gradient
        {
            hBrush := GDI.CreateSolidBrush(col.ToInt(2))
            GDI.SelectObject(this.hMemDC, hBrush)

            rect := Rectangle(Point(x + i - 1, y), 3, height)

            GDI.FillRect(this.hMemDC, rect, hBrush)
            GDI.DeleteObject(hBrush)
        }
    }

    DrawRadialGradient(gradient, center, radius)
    {
        x := center.X
        y := center.Y
        stepSize := 1

        Loop gradient.Length
        {
            i := gradient.Length - A_Index + 1
            currentRadius := radius * (i / gradient.Length)
            col := gradient[i]
            _brush := GDI.CreateSolidBrush(col.ToInt(2))
            _pen := GDI.CreatePen(PenStyle.SOLID, 1, col.ToInt(2))

            oldBrush := GDI.SelectObject(this.hMemDC, _brush)
            oldPen := GDI.SelectObject(this.hMemDC, _pen)

            GDI.Ellipse(this.hMemDC, x - currentRadius, y - currentRadius, x + currentRadius, y + currentRadius)

            GDI.SelectObject(this.hMemDC, oldBrush)
            GDI.SelectObject(this.hMemDC, oldPen)
            GDI.DeleteObject(_brush)
            GDI.DeleteObject(_pen)

            A_Index += stepSize - 1
        }
    }

    DrawText(textObj, font, brush)
    {
        GDI.SetTextColor(this.hMemDC, brush.Color.ToInt(2))
        GDI.SetBkMode(this.hMemDC, BackgroundModes.TRANSPARENT)
        GDI.SelectObject(this.hMemDC, font.Handle)

        rect := Rectangle(textObj.Position, 1000, 1000)

        format := 0
        if (textObj.Alignment.Horizontal = Alignment.H.Center)
            format |= TextAlignment.CENTER  ; DT_CENTER
        else if (textObj.Alignment.Horizontal = Alignment.H.Right)
            format |= TextAlignment.RIGHT  ; DT_RIGHT
        if (textObj.Alignment.Vertical = Alignment.V.Center)
            format |= TextAlignment.BASELINE  ; DT_VCENTER
        else if (textObj.Alignment.Vertical = Alignment.V.Bottom)
            format |= TextAlignment.BOTTOM  ; DT_BOTTOM

        GDI.DrawText(this.hMemDC, textObj.Text, rect, format)
    }

    DrawPolygon(polygon, pen, brush := 0)
    {
        points := polygon.Vertices.Clone()

        ; Apply rotation if present
        if (polygon.Rotation != 0)
        {
            center := polygon.GetCenter()
            for i, pt in points
                points[i] := pt.RotateAround(center, polygon.Rotation)
        }

        ; Draw the polygon
        oldPen := GDI.SelectObject(this.hMemDC, pen.Handle)

        if (brush != 0)
        {
            oldBrush := GDI.SelectObject(this.hMemDC, brush.Handle)
            GDI.Polygon(this.hMemDC, points)
            GDI.SelectObject(this.hMemDC, oldBrush)
        }
        else
        {
            GDI.PolyLine(this.hMemDC, points)
            GDI.LineTo(this.hMemDC, points[1].X, points[1].Y) ; Close the polygon
        }

        GDI.SelectObject(this.hMemDC, oldPen)
    }

    LoadImage(filename) => GDI.LoadImage(0, filename, 0, 100, 100, 0x10 | 0x40)

    DrawImage(image, rect)
    {
        hdcMem := GDI.CreateCompatibleDC(this.hMemDC)
        hOldBitmap := GDI.SelectObject(hdcMem, image)

        if (!rect.Width && !rect.Height)
            GDI.BitBlt(this.hMemDC, rect.Left, rect.Top, rect.Width, rect.Height, hdcMem, 0, 0, BinaryRaster.SRCCOPY)
        else
            GDI.StretchBlt(this.hMemDC, rect.Left, rect.Top, rect.Width, rect.Height, hdcMem, 0, 0, 1, 1, BinaryRaster.SRCCOPY)

        GDI.SelectObject(hdcMem, hOldBitmap)
        GDI.DeleteDC(hdcMem)
    }

    DrawPath(path, pen, brush := 0)
    {
        oldPen := GDI.SelectObject(this.hMemDC, pen.Handle)

        if (brush != 0)
        {
            oldBrush := GDI.SelectObject(this.hMemDC, brush.Handle)
        }
        else
        {
            oldBrush := GDI.GetStockObject(StockObject.NULL_BRUSH)
            oldBrush := GDI.SelectObject(this.hMemDC, oldBrush)
        }

        GDI.SetPolyFillMode(this.hMemDC, path.FillMode + 1)
        GDI.BeginPath(this.hMemDC)

        for element in path.Data
        {
            switch element.Type
            {
                case "MoveTo":
                    GDI.MoveToEx(this.hMemDC, element.Point.X, element.Point.Y, 0)
                    path.CurrentPoint := element.Point
                case "LineTo":
                    GDI.LineTo(this.hMemDC, element.Point.X, element.Point.Y)
                    path.CurrentPoint := element.Point
                case "ArcTo":
                    GDI.AngleArc(this.hMemDC,
                        element.Point.X - element.Radius,
                        element.Point.Y - element.Radius,
                        element.Point.X + element.Radius,
                        element.Point.Y + element.Radius,
                        element.StartAngle,
                        element.SweepAngle)
                    path.CurrentPoint := element.Point
                case "QuadraticBezierTo":
                    points := [path.CurrentPoint, element.ControlPoint, element.EndPoint]
                    GDI.PolyBezier(this.hMemDC, points)
                    path.CurrentPoint := element.EndPoint
                case "CubicBezierTo":
                    points := [path.CurrentPoint, element.ControlPoint1, element.ControlPoint2, element.EndPoint]
                    GDI.PolyBezier(this.hMemDC, points)
                    path.CurrentPoint := element.EndPoint
                case "ClosePath":
                    GDI.CloseFigure(this.hMemDC)
                    path.CurrentPoint := path.StartPoint
            }
        }

        GDI.EndPath(this.hMemDC)

        if (brush != 0)
        {
            GDI.FillPath(this.hMemDC)
            GDI.BeginPath(this.hMemDC)

            for element in path.Data
            {
                switch element.Type
                {
                    case "MoveTo":
                        GDI.MoveToEx(this.hMemDC, element.Point.X, element.Point.Y, 0)
                        path.CurrentPoint := element.Point
                    case "LineTo":
                        GDI.LineTo(this.hMemDC, element.Point.X, element.Point.Y)
                        path.CurrentPoint := element.Point
                    case "ArcTo":
                        GDI.AngleArc(this.hMemDC,
                            element.Point.X - element.Radius,
                            element.Point.Y - element.Radius,
                            element.Point.X + element.Radius,
                            element.Point.Y + element.Radius,
                            element.StartAngle,
                            element.SweepAngle)
                        path.CurrentPoint := element.Point
                    case "QuadraticBezierTo":
                        points := [path.CurrentPoint, element.ControlPoint, element.EndPoint]
                        GDI.PolyBezier(this.hMemDC, points)
                        path.CurrentPoint := element.EndPoint
                    case "CubicBezierTo":
                        points := [path.CurrentPoint, element.ControlPoint1, element.ControlPoint2, element.EndPoint]
                        GDI.PolyBezier(this.hMemDC, points)
                        path.CurrentPoint := element.EndPoint
                    case "ClosePath":
                        GDI.CloseFigure(this.hMemDC)
                        path.CurrentPoint := path.StartPoint
                }
            }
            GDI.EndPath(this.hMemDC)
        }

        GDI.StrokePath(this.hMemDC)
        GDI.SelectObject(this.hMemDC, oldPen)

        if (brush != 0)
        {
            GDI.SelectObject(this.hMemDC, oldBrush)
        }
    }

    /**
     * Bit Blits an area of the screen defined by the source rectangle to the
     * destination rectangle on the control.
     * @param sourceRect The source rectangle, in screen coordinates
     * @param destRect The destination rectangle, in control coordinates
     */
    BitBltScreen(sourceRect, destRect)
    {
        hScreenDC := GDI.GetDC(0)
        GDI.SetStretchBltMode(this.hMemDC, StretchMode.HALFTONE) ; HALFTONE for better quality
        GDI.StretchBlt(this.hMemDC,
            destRect.TopLeft.X, destRect.TopLeft.Y,
            destRect.Width, destRect.Height,
            hScreenDC,
            sourceRect.TopLeft.X, sourceRect.TopLeft.Y,
            sourceRect.Width, sourceRect.Height,
            BinaryRaster.SRCCOPY)

        GDI.ReleaseDC(0, hScreenDC)
    }
}