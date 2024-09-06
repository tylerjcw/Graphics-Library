#Requires AutoHotkey v2.0
#Include <Geometry>
#Include <GDIClasses>

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

    DrawRectangle(rect, pen, brush := 0)
    {
        ; Calculate all corner points
        points := []
        points.Push([rect.TopLeft.X, rect.TopLeft.Y])
        points.Push([rect.BottomRight.X, rect.TopLeft.Y])
        points.Push([rect.BottomRight.X, rect.BottomRight.Y])
        points.Push([rect.TopLeft.X, rect.BottomRight.Y])

        ; Apply rotation for drawing only
        center := [rect.Center.X, rect.Center.Y]
        for i, point in points
            points[i] := RotatePoint(point, center, rect.Rotation)

        ; Draw the rotated rectangle
        oldPen := DllCall("CreatePen", "Int", 0, "Int", pen.Width, "UInt", pen.Color.ToHex("0x{B}{G}{R}").Full)
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)

        if (brush != 0)
        {
            oldBrush := DllCall("CreateSolidBrush", "UInt", brush.Color.ToHex("0x{B}{G}{R}").Full)
            oldBrush := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("Polygon", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", points.Length)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("DeleteObject", "Ptr", oldBrush)
        }
        else
        {
            DllCall("Polyline", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", points.Length)
            DllCall("LineTo", "Ptr", this.hMemDC, "Int", points[1][1], "Int", points[1][2])  ; Close the rectangle
        }

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", oldPen)

        RotatePoint(point, center, angle)
        {
            angle := angle * (3.14159 / 180)  ; Convert to radians
            x := point[1] - center[1]
            y := point[2] - center[2]
            newX := x * Cos(angle) - y * Sin(angle) + center[1]
            newY := x * Sin(angle) + y * Cos(angle) + center[2]
            return [newX, newY]
        }

        PointsToBuffer(points)
        {
            buf := Buffer(8 * points.Length)
            for i, point in points
                NumPut("Int", point[1], "Int", point[2], buf, (i - 1) * 8)
            return buf
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

            points.Push([ellipse.Center.X + rotatedX, ellipse.Center.Y + rotatedY])
        }

        oldPen := DllCall("CreatePen", "Int", 0, "Int", pen.Width, "UInt", pen.Color.ToHex("0x{B}{G}{R}").Full)
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)

        if (brush != 0)
        {
            oldBrush := DllCall("CreateSolidBrush", "UInt", brush.Color.ToHex("0x{B}{G}{R}").Full)
            oldBrush := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("Polygon", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", points.Length)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("DeleteObject", "Ptr", oldBrush)
        }
        else
        {
            DllCall("Polyline", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", points.Length)
        }

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", oldPen)

        PointsToBuffer(points)
        {
            buf := Buffer(8 * points.Length)
            for i, pt in points
                NumPut("Int", pt[1], "Int", pt[2], buf, (i - 1) * 8)
            return buf
        }
    }

    DrawLine(line, pen)
    {
        x1 := line.Start.X
        y1 := line.Start.Y
        x2 := line.End.X
        y2 := line.End.Y
        pen := DllCall("CreatePen", "Int", 0, "Int", pen.Width, "UInt", pen.Color.ToInt(2))
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)

        DllCall("MoveToEx", "Ptr", this.hMemDC, "Int", x1, "Int", y1, "Ptr", 0)
        DllCall("LineTo", "Ptr", this.hMemDC, "Int", x2, "Int", y2)

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", pen)
    }

    DrawBezier(bezier, pen, resolution := 1)
    {
        points := bezier.GetPoints(bezier.Points.Length * resolution)  ; Get points along the Bezier curve

        oldPen := DllCall("CreatePen", "Int", 0, "Int", pen.Width, "UInt", pen.Color.ToHex("0x{B}{G}{R}").Full)
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)

        DllCall("MoveToEx", "Ptr", this.hMemDC, "Int", points[1].X, "Int", points[1].Y, "Ptr", 0)

        for i, point in points
        {
            if (i > 1)
            {
                DllCall("LineTo", "Ptr", this.hMemDC, "Int", point.X, "Int", point.Y)
            }
        }

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", oldPen)
    }

    DrawGradient(gradient, pos, height := 0)
    {
        x := pos.X
        y := pos.Y

        if (height == 0)
            height := this.ctrl.Pos.H

        for i, col in gradient
        {
            hBrush := DllCall("CreateSolidBrush", "UInt", col.ToInt(2))
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", hBrush)

            rect := Buffer(16)
            NumPut("Int", x + i - 1, rect, 0)
            NumPut("Int", y, rect, 4)
            NumPut("Int", x + i + 1, rect, 8)
            NumPut("Int", y + height, rect, 12)

            DllCall("FillRect", "Ptr", this.hMemDC, "Ptr", rect, "Ptr", hBrush)
            DllCall("DeleteObject", "Ptr", hBrush)
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
            brush := DllCall("CreateSolidBrush", "UInt", col.ToHex("0x{B}{G}{R}").Full)
            pen := DllCall("CreatePen", "Int", 0, "Int", 1, "UInt", col.ToHex("0x{B}{G}{R}").Full)

            oldBrush := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", brush)
            oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", pen)

            DllCall("Ellipse", "Ptr", this.hMemDC,
                    "Int", x - currentRadius,
                    "Int", y - currentRadius,
                    "Int", x + currentRadius,
                    "Int", y + currentRadius)

            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
            DllCall("DeleteObject", "Ptr", brush)
            DllCall("DeleteObject", "Ptr", pen)

            A_Index += stepSize - 1
        }
    }

    DrawText(textObj, font, brush)
    {
        DllCall("SetTextColor", "Ptr", this.hMemDC, "UInt", brush.Color.ToInt(2))
        DllCall("SetBkMode", "Ptr", this.hMemDC, "Int", 1)  ; TRANSPARENT

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", font.Ptr)

        rect := Buffer(16)
        NumPut("Int", textObj.Position.X, rect, 0)
        NumPut("Int", textObj.Position.Y, rect, 4)
        NumPut("Int", textObj.Position.X + 1000, rect, 8)  ; Arbitrary large width
        NumPut("Int", textObj.Position.Y + 1000, rect, 12)  ; Arbitrary large height

        format := 0
        if (textObj.Alignment.Horizontal = Alignment.H.Center)
            format |= 0x1  ; DT_CENTER
        else if (textObj.Alignment.Horizontal = Alignment.H.Right)
            format |= 0x2  ; DT_RIGHT
        if (textObj.Alignment.Vertical = Alignment.V.Center)
            format |= 0x4  ; DT_VCENTER
        else if (textObj.Alignment.Vertical = Alignment.V.Bottom)
            format |= 0x8  ; DT_BOTTOM

        DllCall("DrawText", "Ptr", this.hMemDC, "Str", textObj.Text, "Int", -1, "Ptr", rect, "UInt", format)
    }

    DrawPolygon(polygon, pen, brush := 0)
    {
        points := polygon.Vertices.Clone()

        ; Apply rotation if present
        if (polygon.Rotation != 0)
        {
            center := polygon.GetCenter()
            for i, point in points
                points[i] := point.RotateAround(center, polygon.Rotation)
        }

        ; Convert points to array format for PointsToBuffer
        arrayPoints := []
        for point in points
            arrayPoints.Push([point.X, point.Y])

        ; Draw the polygon
        oldPen := DllCall("CreatePen", "Int", 0, "Int", pen.Width, "UInt", pen.Color.ToHex("0x{B}{G}{R}").Full)
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)

        if (brush != 0)
        {
            oldBrush := DllCall("CreateSolidBrush", "UInt", brush.Color.ToHex("0x{B}{G}{R}").Full)
            oldBrush := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("Polygon", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(arrayPoints), "Int", arrayPoints.Length)
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("DeleteObject", "Ptr", oldBrush)
        }
        else
        {
            DllCall("Polyline", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(arrayPoints), "Int", arrayPoints.Length)
            DllCall("LineTo", "Ptr", this.hMemDC, "Int", arrayPoints[1][1], "Int", arrayPoints[1][2])  ; Close the polygon
        }

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", oldPen)

        PointsToBuffer(points)
        {
            buf := Buffer(8 * points.Length)
            for i, point in points
                NumPut("Int", point[1], "Int", point[2], buf, (i - 1) * 8)
            return buf
        }
    }

    LoadImage(filename)
    {
        hBitmap := DllCall("LoadImage", "Ptr", 0, "Str", filename, "UInt", 0, "Int", 100, "Int", 100, "UInt", 0x10 | 0x40)
        return hBitmap
    }

    DrawImage(image, rect)
    {
        hdcMem := DllCall("CreateCompatibleDC", "Ptr", this.hMemDC)
        hOldBitmap := DllCall("SelectObject", "Ptr", hdcMem, "Ptr", image)

        if (!rect.Width && !rect.Height)
        {
            DllCall("BitBlt"
                , "Ptr", this.hMemDC
                , "Int", rect.TopLeft.X
                , "Int", rect.TopLeft.Y
                , "Int", 1
                , "Int", 1
                , "Ptr", hdcMem
                , "Int", 0
                , "Int", 0
                , "UInt", 0xCC0020) ; SRCCOPY
        }
        else
        {
            DllCall("StretchBlt"
                , "Ptr", this.hMemDC
                , "Int", rect.TopLeft.X
                , "Int", rect.TopLeft.Y
                , "Int", rect.Width
                , "Int", rect.Height
                , "Ptr", hdcMem
                , "Int", 0
                , "Int", 0
                , "Int", 1
                , "Int", 1
                , "UInt", 0xCC0020) ; SRCCOPY
        }

        DllCall("SelectObject", "Ptr", hdcMem, "Ptr", hOldBitmap)
        DllCall("DeleteDC", "Ptr", hdcMem)
    }

    DrawPath(path, pen, brush := 0)
    {
        oldPen := DllCall("CreatePen", "Int", 0, "Int", pen.Width, "UInt", pen.Color.ToHex("0x{B}{G}{R}").Full)
        oldPen := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)

        if (brush != 0)
        {
            oldBrush := DllCall("CreateSolidBrush", "UInt", brush.Color.ToHex("0x{B}{G}{R}").Full)
            oldBrush := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
        }
        else
        {
            oldBrush := DllCall("GetStockObject", "Int", 5)  ; NULL_BRUSH
            oldBrush := DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
        }

        DllCall("SetPolyFillMode", "Ptr", this.hMemDC, "Int", path.FillMode + 1) ; WINDING : ALTERNATE

        DllCall("BeginPath", "Ptr", this.hMemDC)

        for element in path.Data
        {
            switch element.Type
            {
                case "MoveTo":
                    DllCall("MoveToEx", "Ptr", this.hMemDC, "Int", element.Point.X, "Int", element.Point.Y, "Ptr", 0)
                    path.CurrentPoint := element.Point

                case "LineTo":
                    DllCall("LineTo", "Ptr", this.hMemDC, "Int", element.Point.X, "Int", element.Point.Y)
                    path.CurrentPoint := element.Point

                case "ArcTo":
                    DllCall("Arc", "Ptr", this.hMemDC,
                            "Int", element.Point.X - element.Radius,
                            "Int", element.Point.Y - element.Radius,
                            "Int", element.Point.X + element.Radius,
                            "Int", element.Point.Y + element.Radius,
                            "Int", element.StartAngle,
                            "Int", element.SweepAngle)
                    path.CurrentPoint := element.Point

                case "QuadraticBezierTo":
                    points := [path.CurrentPoint, element.ControlPoint, element.EndPoint]
                    DllCall("PolyBezier", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", 3)
                    path.CurrentPoint := element.EndPoint

                case "CubicBezierTo":
                    points := [path.CurrentPoint, element.ControlPoint1, element.ControlPoint2, element.EndPoint]
                    DllCall("PolyBezier", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", 4)
                    path.CurrentPoint := element.EndPoint

                case "ClosePath":
                    DllCall("CloseFigure", "Ptr", this.hMemDC)
                    path.CurrentPoint := path.StartPoint
            }
        }

        DllCall("EndPath", "Ptr", this.hMemDC)

        if (brush != 0)
        {
            DllCall("FillPath", "Ptr", this.hMemDC)
            DllCall("BeginPath", "Ptr", this.hMemDC)
            for element in path.Data
            {
                switch element.Type
                {
                    case "MoveTo":
                        DllCall("MoveToEx", "Ptr", this.hMemDC, "Int", element.Point.X, "Int", element.Point.Y, "Ptr", 0)
                        path.CurrentPoint := element.Point
                    case "LineTo":
                        DllCall("LineTo", "Ptr", this.hMemDC, "Int", element.Point.X, "Int", element.Point.Y)
                        path.CurrentPoint := element.Point
                    case "ArcTo":
                        DllCall("Arc", "Ptr", this.hMemDC,
                                "Int", element.Point.X - element.Radius,
                                "Int", element.Point.Y - element.Radius,
                                "Int", element.Point.X + element.Radius,
                                "Int", element.Point.Y + element.Radius,
                                "Int", element.StartAngle,
                                "Int", element.SweepAngle)
                        path.CurrentPoint := element.Point
                    case "QuadraticBezierTo":
                        points := [path.CurrentPoint, element.ControlPoint, element.EndPoint]
                        DllCall("PolyBezier", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", 3)
                        path.CurrentPoint := element.EndPoint
                    case "CubicBezierTo":
                        points := [path.CurrentPoint, element.ControlPoint1, element.ControlPoint2, element.EndPoint]
                        DllCall("PolyBezier", "Ptr", this.hMemDC, "Ptr", PointsToBuffer(points), "Int", 4)
                        path.CurrentPoint := element.EndPoint
                    case "ClosePath":
                        DllCall("CloseFigure", "Ptr", this.hMemDC)
                        path.CurrentPoint := path.StartPoint
                }
            }
            DllCall("EndPath", "Ptr", this.hMemDC)
        }

        DllCall("StrokePath", "Ptr", this.hMemDC)

        DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldPen)
        DllCall("DeleteObject", "Ptr", oldPen)

        if (brush != 0)
        {
            DllCall("SelectObject", "Ptr", this.hMemDC, "Ptr", oldBrush)
            DllCall("DeleteObject", "Ptr", oldBrush)
        }

        PointsToBuffer(points)
        {
            buf := Buffer(8 * points.Length)
            for i, point in points
                NumPut("Int", point.X, "Int", point.Y, buf, (i - 1) * 8)
            return buf
        }
    }
}