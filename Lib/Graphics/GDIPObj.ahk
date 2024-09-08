#Requires AutoHotkey v2.0

class GDIPlusObj
{
    ; Private properties
    hWnd := 0
    Control := 0
    graphics := 0
    width := 0
    height := 0
    static token := 0
    bufferBitmap := 0
    bufferGraphics := 0
    lastX := 0
    lastY := 0
    BoundingRect => Rectangle(Point(0, 0), this.width, this.height)

    static __New()
    {
        if (!DllCall("LoadLibrary", "str", "gdiplus", "UPtr"))
        {
            throw Error("Could not load GDI+ library")
        }

        si := Buffer(A_PtrSize = 4 ? 20:32, 0) ; sizeof(GdiplusStartupInputEx) = 20, 32
        NumPut("uint", 0x2, si)
        NumPut("uint", 0x4, si, A_PtrSize = 4 ? 16:24)
        GDIP.Startup(&pToken := 0, si, 0)

        if (!pToken)
        {
            throw Error("Gdiplus failed to start. Please ensure you have gdiplus on your system")
        }
        GDIPlusObj.token := pToken
    }

    static __Delete()
    {
        if (GDIPlusObj.token)
        {
            GDIP.Shutdown(GDIPlusObj.token)
            hModule := DllCall("GetModuleHandle", "str", "gdiplus", "UPtr")
            if (hModule)
            {
                DllCall("FreeLibrary", "UPtr", hModule)
            }
            GDIPlusObj.token := 0
        }
    }

    __New(control)
    {
        this.hWnd := control.Hwnd
        this.Control := control

        ; Get control dimensions
        x := 0, y := 0, w := 0, h := 0
        control.GetPos(&x, &y, &w, &h)
        this.width := w
        this.height := h

        ; Create graphics object from window handle
        GDIP.CreateFromHWND(this.hWnd, &graphics := 0)
        this.graphics := graphics

        ; Create buffer bitmap and graphics
        GDIP.CreateBitmapFromGraphics(this.width, this.height, this.graphics, &bufferBitmap := 0)
        GDIP.GetImageGraphicsContext(bufferBitmap, &bufferGraphics := 0)
        this.bufferBitmap := bufferBitmap
        this.bufferGraphics := bufferGraphics
    }

    __Delete()
    {
        if (this.bufferGraphics)
            GDIP.DeleteGraphics(this.bufferGraphics)
        if (this.bufferBitmap)
            GDIP.DisposeImage(this.bufferBitmap)
        if (this.graphics)
            GDIP.DeleteGraphics(this.graphics)
    }

    static CreateWindow(width, height, options := "-Caption +ToolWindow +AlwaysOnTop")
    {
        gdipGui := Gui(options)
        gdipGui.Show("w" width " h" height)

        LayeredWindow.SetLayeredWindowAttributes(gdipGui.Hwnd, 0, 255, 2)

        canvas := GDIPlusObj(gdipGui)
        canvas.SetSmoothingMode(GDIP.SMode.AntiAlias)
        canvas.SetCompositingMode(GDIP.CMode.Blended)
        canvas.SetInterpolationMode(GDIP.IMode.HighQualityBicubic)
        return canvas
    }

    SetTransColor(color)
    {
        WinSetTransColor(color.ToInt(3), "ahk_id" this.Control.Hwnd)
    }

    DrawLine(line, pen) => GDIP.DrawLine(this.bufferGraphics, pen.Ptr, line.Start.X, line.Start.Y, line.End.X, line.End.Y)

    DrawRectangle(rectangle, pen, brush := 0)
    {
        x := rectangle.TopLeft.X
        y := rectangle.TopLeft.Y
        width := rectangle.Width
        height := rectangle.Height

        penWidth := 0
        GDIP.GetPenWidth(pen.Ptr, &penWidth)
        halfPenWidth := penWidth / 2

        if (rectangle.Rotation != 0)
        {
            GDIP.SaveGraphics(this.bufferGraphics, &state := 0)
            GDIP.TranslateWorldTransform(this.bufferGraphics, x + width / 2, y + height / 2)
            GDIP.RotateWorldTransform(this.bufferGraphics, rectangle.Rotation)
            GDIP.TranslateWorldTransform(this.bufferGraphics, -(x + width / 2), -(y + height / 2))
        }

        if (brush)
        {
            GDIP.FillRectangle(this.bufferGraphics, brush.Ptr, x + halfPenWidth, y + halfPenWidth, width - penWidth, height - penwidth)
        }

        GDIP.DrawRectangle(this.bufferGraphics, pen.Ptr, x, y, width, height)

        if (rectangle.Rotation != 0)
            GDIP.RestoreGraphics(this.bufferGraphics, state)
    }

    DrawEllipse(ellipse, pen := 0, brush := 0)
    {
        x := ellipse.Center.X - ellipse.SemiMajorAxis
        y := ellipse.Center.Y - ellipse.SemiMinorAxis
        width := ellipse.SemiMajorAxis * 2
        height := ellipse.SemiMinorAxis * 2

        if (ellipse.Rotation != 0)
        {
            GDIP.SaveGraphics(this.bufferGraphics, &state := 0)
            GDIP.TranslateWorldTransform(this.bufferGraphics, ellipse.Center.X, ellipse.Center.Y)
            GDIP.RotateWorldTransform(this.bufferGraphics, ellipse.Rotation)
            GDIP.TranslateWorldTransform(this.bufferGraphics, -ellipse.Center.X, -ellipse.Center.Y)
        }

        if (brush)
            GDIP.FillEllipse(this.bufferGraphics, brush.Ptr, x, y, width, height)

        GDIP.DrawEllipse(this.bufferGraphics, pen.Ptr, x, y, width, height)

        if (ellipse.Rotation != 0)
            GDIP.RestoreGraphics(this.bufferGraphics, state)
    }

    DrawPolygon(polygon, pen, brush := 0)
    {
        pointsCount := polygon.Vertices.Length
        points := Buffer(8 * pointsCount)

        for i, vertex in polygon.Vertices
        {
            NumPut("Float", vertex.X, "Float", vertex.Y, points, (i - 1) * 8)
        }

        if (brush)
            GDIP.FillPolygon(this.bufferGraphics, brush.Ptr, points, pointsCount)

        GDIP.DrawPolygon(this.bufferGraphics, pen.Ptr, points, pointsCount)
    }

    DrawBezier(bezier, _pen, resolution := 1)
    {
        if (resolution != 1)
            points := bezier.GetPoints(bezier.Points.Length * resolution)
        else
            points := bezier.Points

        pointsBuffer := Buffer(8 * points.Length)
        for i, point in points
        {
            NumPut("Float", point.X, "Float", point.Y, pointsBuffer, (i - 1) * 8)
        }

        GDIP.DrawLines(this.bufferGraphics, _pen.Ptr, pointsBuffer, points.Length)
    }


    DrawGradient(gradient, pos, height := 0)
    {
        x := pos.X
        y := pos.Y

        if (height == 0)
            height := this.height

        if (gradient.Pens.Length != gradient.Length)
            gradient.CreatePens(2)

        for i, col in gradient
            GDIP.DrawRectangle(this.bufferGraphics, gradient.Pens[i].Ptr, x + i - 1, y, 2, height)
    }

    DrawRadialGradient(gradient, center, radius)
    {
        x := center.X
        y := center.Y

        if (gradient.Pens.Length != gradient.Length)
            gradient.CreatePens(2)

        for i, col in gradient
        {
            currentRadius := radius * (i / gradient.Length)
            GDIP.DrawEllipse(this.bufferGraphics, gradient.Pens[A_Index].Ptr, x - currentRadius, y - currentRadius, currentRadius * 2, currentRadius * 2)
        }
    }

    DrawText(textObj, font, brush)
    {
        stringFormat := 0
        GDIP.CreateStringFormat(0, 0, &stringFormat)
        GDIP.SetStringFormatAlign(stringFormat, textObj.Alignment.Horizontal)
        GDIP.SetStringFormatLineAlign(stringFormat, textObj.Alignment.Vertical)

        rect := Buffer(16, 0)
        NumPut("Float", textObj.Position.X, "Float", textObj.Position.Y, rect)

        if (textObj.Rotation != 0)
        {
            GDIP.SaveGraphics(this.bufferGraphics, &state := 0)
            GDIP.TranslateWorldTransform(this.bufferGraphics, textObj.Position.X, textObj.Position.Y)
            GDIP.RotateWorldTransform(this.bufferGraphics, textObj.Rotation)
            GDIP.TranslateWorldTransform(this.bufferGraphics, -textObj.Position.X, -textObj.Position.Y)
        }

        GDIP.DrawString(this.bufferGraphics, textObj.Text, -1, font.Ptr, rect, stringFormat, brush.Ptr)

        if (textObj.Rotation != 0)
            GDIP.RestoreGraphics(this.bufferGraphics, state)

        GDIP.DeleteStringFormat(stringFormat)
    }

    DrawPath(path, pen, brush := Brush(Color.Transparent))
    {
        DllCall("gdiplus\GdipCreatePath", "Int", 0, "Ptr*", &gdiPath := 0)
        DllCall("gdiplus\GdipSetPathFillMode", "Ptr", gdiPath, "Int", path.FillMode)

        for element in path.Data
        {
            switch element.Type
            {
                case "MoveTo":
                    DllCall("gdiplus\GdipStartPathFigure", "Ptr", gdiPath)
                    DllCall("gdiplus\GdipAddPathLine", "Ptr", gdiPath, "Float", element.Point.X, "Float", element.Point.Y, "Float", element.Point.X, "Float", element.Point.Y)
                    path.CurrentPoint := element.Point

                case "LineTo":
                    DllCall("gdiplus\GdipAddPathLine", "Ptr", gdiPath, "Float", path.CurrentPoint.X, "Float", path.CurrentPoint.Y, "Float", element.Point.X, "Float", element.Point.Y)
                    path.CurrentPoint := element.Point

                case "ArcTo":
                    DllCall("gdiplus\GdipAddPathArc", "Ptr", gdiPath, "Float", element.Point.X - element.Radius, "Float", element.Point.Y - element.Radius, "Float", element.Radius * 2, "Float", element.Radius * 2, "Float", element.StartAngle, "Float", element.SweepAngle)
                    path.CurrentPoint := element.Point

                case "QuadraticBezierTo":
                    DllCall("gdiplus\GdipAddPathBezier", "Ptr", gdiPath, "Float", path.CurrentPoint.X, "Float", path.CurrentPoint.Y, "Float", element.ControlPoint.X, "Float", element.ControlPoint.Y, "Float", element.EndPoint.X, "Float", element.EndPoint.Y)
                    path.CurrentPoint := element.EndPoint

                case "CubicBezierTo":
                    DllCall("gdiplus\GdipAddPathBezier", "Ptr", gdiPath, "Float", path.CurrentPoint.X, "Float", path.CurrentPoint.Y, "Float", element.ControlPoint1.X, "Float", element.ControlPoint1.Y, "Float", element.ControlPoint2.X, "Float", element.ControlPoint2.Y, "Float", element.EndPoint.X, "Float", element.EndPoint.Y)
                    path.CurrentPoint := element.EndPoint

                case "ClosePath":
                    DllCall("gdiplus\GdipClosePathFigure", "Ptr", gdiPath)
                    path.CurrentPoint := path.StartPoint
            }
        }

        DllCall("gdiplus\GdipFillPath", "Ptr", this.bufferGraphics, "Ptr", brush.Ptr, "Ptr", gdiPath)
        DllCall("gdiplus\GdipDrawPath", "Ptr", this.bufferGraphics, "Ptr", pen.Ptr, "Ptr", gdiPath)
        DllCall("gdiplus\GdipDeletePath", "Ptr", gdiPath)
    }

    AddCurve(path, points, tension := 0.5)
    {
        pointsCount := points.Length
        pointsArr := Buffer(8 * pointsCount)
        for i, point in points {
            NumPut("Float", point.x, pointsArr, (i-1)*8)
            NumPut("Float", point.y, pointsArr, (i-1)*8+4)
        }
        DllCall("gdiplus\GdipAddPathCurve", "Ptr", path, "Ptr", pointsArr, "Int", pointsCount, "Float", tension)
    }

    LoadImage(filename)
    {
        GDIP.LoadImageFromFile(filename, &image := 0)
        return image
    }

    DrawImage(image, rect)
    {
        if (!rect.Width && !rect.Height)
            GDIP.DrawImage(this.bufferGraphics, image, rect.TopLeft.X, rect.TopLeft.Y)
        else
            GDIP.DrawImageRect(this.bufferGraphics, image, rect.TopLeft.X, rect.TopLeft.Y, rect.Width, rect.Height)
    }

    /**
     * Bit Blits an area of the screen defined by the source rectangle to the
     * destination rectangle on the control.
     * @param sourceRect The source rectangle, in screen coordinates
     * @param destRect The destination rectangle, in control coordinates
     */
    BitBltScreen(sourceRect, destRect)
    {
        ; Create a compatible DC and bitmap
        hScreenDC := DllCall("GetDC", "Ptr", 0, "Ptr")
        hMemDC := DllCall("CreateCompatibleDC", "Ptr", hScreenDC)
        hBitmap := DllCall("CreateCompatibleBitmap", "Ptr", hScreenDC, "Int", sourceRect.Width, "Int", sourceRect.Height, "Ptr")
        DllCall("SelectObject", "Ptr", hMemDC, "Ptr", hBitmap)

        ; Copy the screen area to our bitmap
        DllCall("BitBlt", "Ptr", hMemDC, "Int", 0, "Int", 0, "Int", sourceRect.Width, "Int", sourceRect.Height,
                         "Ptr", hScreenDC, "Int", sourceRect.TopLeft.X, "Int", sourceRect.TopLeft.Y, "UInt", 0x00CC0020) ; SRCCOPY

        ; Create a GDI+ bitmap from our bitmap
        DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hBitmap, "Ptr", 0, "Ptr*", &pBitmap:=0)

        ; Save the current graphics state
        DllCall("gdiplus\GdipSaveGraphics", "Ptr", this.bufferGraphics, "Ptr*", &state:=0)

        ; Set up the transformation for rotation
        DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", destRect.Center.X, "Float", destRect.Center.Y, "Int", 0)
        DllCall("gdiplus\GdipRotateWorldTransform", "Ptr", this.bufferGraphics, "Float", destRect.Rotation, "Int", 0)
        DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", -destRect.Center.X, "Float", -destRect.Center.Y, "Int", 0)

        ; Draw the captured bitmap onto our buffer with rotation applied
        DllCall("gdiplus\GdipDrawImageRectRect", "Ptr", this.bufferGraphics,
            "Ptr", pBitmap,
            "Float", destRect.TopLeft.X, "Float", destRect.TopLeft.Y,
            "Float", destRect.Width, "Float", destRect.Height,
            "Float", 0, "Float", 0,
            "Float", sourceRect.Width, "Float", sourceRect.Height,
            "Int", 2, "Ptr", 0, "Ptr", 0, "Ptr", 0)

        ; Restore the graphics state
        DllCall("gdiplus\GdipRestoreGraphics", "Ptr", this.bufferGraphics, "Ptr", state)

        ; Clean up
        DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
        DllCall("DeleteObject", "Ptr", hBitmap)
        DllCall("DeleteDC", "Ptr", hMemDC)
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hScreenDC)
    }

    SetInterpolationMode(mode := GDIP.IMode.Bicubic)
    {
        this.IMode := mode
        DllCall("Gdiplus\GdipSetInterpolationMode", "Ptr", this.graphics, "Int", mode)
        DllCall("Gdiplus\GdipSetInterpolationMode", "Ptr", this.bufferGraphics, "Int", mode)
    }

    SetSmoothingMode(mode := GDIP.SMode.AntiAlias)
    {
        this.SMode := mode
        DllCall("Gdiplus\GdipSetSmoothingMode", "Ptr", this.graphics, "Int", mode)
        DllCall("Gdiplus\GdipSetSmoothingMode", "Ptr", this.bufferGraphics, "Int", mode)
    }

    SetCompositingMode(mode := GDIP.CMode.Blended)
    {
        this.CMode := mode
        DllCall("Gdiplus\GdipSetCompositingMode", "Ptr", this.graphics, "Int", mode)
        DllCall("Gdiplus\GdipSetCompositingMode", "Ptr", this.bufferGraphics, "Int", mode)
    }

    MeasureString(text, font)
    {
        rect := Buffer(16)
        layoutRect := Buffer(16)
        NumPut("Float", 0, "Float", 0, "Float", 10000, "Float", 10000, layoutRect)

        DllCall("gdiplus\GdipMeasureString"
            , "Ptr", this.bufferGraphics
            , "Str", text
            , "Int", -1
            , "Ptr", font.Ptr
            , "Ptr", layoutRect
            , "Ptr", 0
            , "Ptr", rect
            , "Ptr", 0
            , "Ptr", 0)

        return {
            Width: NumGet(rect, 8, "Float"),
            Height: NumGet(rect, 12, "Float")
        }
    }

    Clear(gc := 0, col := Color.White)
    {
        cm := this.CMode
        this.SetCompositingMode(GDIP.CMode.Overwrite)
        DllCall("Gdiplus\GdipGraphicsClear", "Ptr", this.bufferGraphics, "UInt", col.ToInt(1))
        this.SetCompositingMode(cm)
    }

    Render()
    {
        DllCall("Gdiplus\GdipDrawImage", "Ptr", this.graphics, "Ptr", this.bufferBitmap, "Float", 0, "Float", 0)
    }
}