#Requires AutoHotkey v2.0

#Include <Geometry>

class GDIPlusObj
{
    ; Private properties
    hWnd := 0
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
        OutputDebug("Initializing GDI+")
        if (!DllCall("LoadLibrary", "str", "gdiplus", "UPtr"))
        {
            throw Error("Could not load GDI+ library")
        }

        si := Buffer(A_PtrSize = 4 ? 20:32, 0) ; sizeof(GdiplusStartupInputEx) = 20, 32
        NumPut("uint", 0x2, si)
        NumPut("uint", 0x4, si, A_PtrSize = 4 ? 16:24)
        DllCall("gdiplus\GdiplusStartup", "UPtr*", &pToken:=0, "Ptr", si, "UPtr", 0)
        if (!pToken)
        {
            throw Error("Gdiplus failed to start. Please ensure you have gdiplus on your system")
        }
        GDIPlusObj.token := pToken
        OutputDebug("pToken: " pToken)
    }

    static __Delete()
    {
        if (GDIPlusObj.token)
        {
            DllCall("gdiplus\GdiplusShutdown", "UPtr", GDIPlusObj.token)
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

        ; Get control dimensions
        x := 0, y := 0, w := 0, h := 0
        control.GetPos(&x, &y, &w, &h)
        this.width := w
        this.height := h

        ; Create graphics object from window handle
        DllCall("Gdiplus\GdipCreateFromHWND", "Ptr", this.hWnd, "Ptr*", &graphics := 0)
        this.graphics := graphics

        ; Create buffer bitmap and graphics
        DllCall("Gdiplus\GdipCreateBitmapFromGraphics", "Int", this.width, "Int", this.height, "Ptr", this.graphics, "Ptr*", &bufferBitmap := 0)
        DllCall("Gdiplus\GdipGetImageGraphicsContext", "Ptr", bufferBitmap, "Ptr*", &bufferGraphics := 0)
        this.bufferBitmap := bufferBitmap
        this.bufferGraphics := bufferGraphics
    }

    __Delete()
    {
        if (this.bufferGraphics)
            DllCall("Gdiplus\GdipDeleteGraphics", "Ptr", this.bufferGraphics)
        if (this.bufferBitmap)
            DllCall("Gdiplus\GdipDisposeImage", "Ptr", this.bufferBitmap)
        if (this.graphics)
            DllCall("Gdiplus\GdipDeleteGraphics", "Ptr", this.graphics)
    }

    DrawLine(line, pen)
    {
        DllCall("Gdiplus\GdipDrawLine",
                "Ptr", this.bufferGraphics,
                "Ptr", pen.Ptr,
                "Float", line.Start.X,
                "Float", line.Start.Y,
                "Float", line.End.X,
                "Float", line.End.Y)
    }

    DrawRectangle(rectangle, pen, brush := 0)
    {
        x := rectangle.TopLeft.X
        y := rectangle.TopLeft.Y
        width := rectangle.Width
        height := rectangle.Height

        penWidth := 0
        DllCall("gdiplus\GdipGetPenWidth", "Ptr", pen.Ptr, "float*", &penWidth)
        halfPenWidth := penWidth / 2

        if (rectangle.Rotation != 0)
        {
            DllCall("gdiplus\GdipSaveGraphics", "Ptr", this.bufferGraphics, "Ptr*", &state := 0)
            DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", x + width / 2, "Float", y + height / 2, "Int", 0)
            DllCall("gdiplus\GdipRotateWorldTransform", "Ptr", this.bufferGraphics, "Float", rectangle.Rotation, "Int", 0)
            DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", -(x + width / 2), "Float", -(y + height / 2), "Int", 0)
        }

        if (brush)
        {
            DllCall("Gdiplus\GdipFillRectangle", "Ptr", this.bufferGraphics, "Ptr", brush.Ptr,
                    "Float", x + halfPenWidth, "Float", y + halfPenWidth,
                    "Float", width - penWidth, "Float", height - penWidth)
        }

        DllCall("Gdiplus\GdipDrawRectangle", "Ptr", this.bufferGraphics, "Ptr", pen.Ptr, "Float", x, "Float", y, "Float", width, "Float", height)

        if (rectangle.Rotation != 0)
            DllCall("gdiplus\GdipRestoreGraphics", "Ptr", this.bufferGraphics, "Ptr", state)
    }

    DrawEllipse(ellipse, pen := 0, brush := 0)
    {
        x := ellipse.Center.X - ellipse.SemiMajorAxis
        y := ellipse.Center.Y - ellipse.SemiMinorAxis
        width := ellipse.SemiMajorAxis * 2
        height := ellipse.SemiMinorAxis * 2

        if (ellipse.Rotation != 0)
        {
            DllCall("gdiplus\GdipSaveGraphics", "Ptr", this.bufferGraphics, "Ptr*", &state := 0)
            DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", ellipse.Center.X, "Float", ellipse.Center.Y, "Int", 0)
            DllCall("gdiplus\GdipRotateWorldTransform", "Ptr", this.bufferGraphics, "Float", ellipse.Rotation, "Int", 0)
            DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", -ellipse.Center.X, "Float", -ellipse.Center.Y, "Int", 0)
        }

        if (brush)
            DllCall("Gdiplus\GdipFillEllipse", "Ptr", this.bufferGraphics, "Ptr", brush.Ptr, "Float", x, "Float", y, "Float", width, "Float", height)

        DllCall("Gdiplus\GdipDrawEllipse", "Ptr", this.bufferGraphics, "Ptr", pen.Ptr, "Float", x, "Float", y, "Float", width, "Float", height)

        if (ellipse.Rotation != 0)
            DllCall("gdiplus\GdipRestoreGraphics", "Ptr", this.bufferGraphics, "Ptr", state)
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
            DllCall("Gdiplus\GdipFillPolygon", "Ptr", this.bufferGraphics, "Ptr", brush.Ptr, "Ptr", points, "Int", pointsCount, "Int", 0)

        DllCall("Gdiplus\GdipDrawPolygon", "Ptr", this.bufferGraphics, "Ptr", pen.Ptr, "Ptr", points, "Int", pointsCount)
    }

    DrawBezier(bezier, pen)
    {
        points := bezier.Points
        n := points.Length

        if (n < 4)
            return

        pointsF := Buffer(8 * n)
        Loop n
        {
            NumPut("float", points[A_Index].X, pointsF, (A_Index - 1) * 8)
            NumPut("float", points[A_Index].Y, pointsF, (A_Index - 1) * 8 + 4)
        }

        DllCall("gdiplus\GdipDrawBeziers", "Ptr", this.bufferGraphics, "Ptr", pen.Ptr, "Ptr", pointsF, "Int", n)
    }

    DrawBezier2(bezier, _pen, resolution := 1)
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

        DllCall("gdiplus\GdipDrawLines", "Ptr", this.bufferGraphics, "Ptr", _pen.Ptr, "Ptr", pointsBuffer, "Int", points.Length)
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
        {
            DllCall("gdiplus\GdipDrawRectangle",
                    "Ptr", this.bufferGraphics,
                    "Ptr", gradient.Pens[A_Index].Ptr,
                    "Float", x + i - 1,
                    "Float", y,
                    "Float", 2,
                    "Float", height)
        }
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
            DllCall("Gdiplus\GdipDrawEllipse",
                    "Ptr", this.bufferGraphics,
                    "Ptr", gradient.Pens[A_Index].Ptr,
                    "Float", x - currentRadius,
                    "Float", y - currentRadius,
                    "Float", currentRadius * 2,
                    "Float", currentRadius * 2)
            _pen := ""  ; Delete the pen
        }
    }

    DrawText(textObj, font, brush)
    {
        stringFormat := 0
        DllCall("gdiplus\GdipCreateStringFormat", "Int", 0, "Int", 0, "Ptr*", &stringFormat)
        DllCall("gdiplus\GdipSetStringFormatAlign", "Ptr", stringFormat, "Int", textObj.Alignment.Horizontal)
        DllCall("gdiplus\GdipSetStringFormatLineAlign", "Ptr", stringFormat, "Int", textObj.Alignment.Vertical)

        rect := Buffer(16, 0)
        NumPut("Float", textObj.Position.X, "Float", textObj.Position.Y, rect)

        if (textObj.Rotation != 0)
        {
            DllCall("gdiplus\GdipSaveGraphics", "Ptr", this.bufferGraphics, "Ptr*", &state := 0)
            DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", textObj.Position.X, "Float", textObj.Position.Y, "Int", 0)
            DllCall("gdiplus\GdipRotateWorldTransform", "Ptr", this.bufferGraphics, "Float", textObj.Rotation, "Int", 0)
            DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", this.bufferGraphics, "Float", -textObj.Position.X, "Float", -textObj.Position.Y, "Int", 0)
        }

        DllCall("Gdiplus\GdipDrawString"
            , "Ptr", this.bufferGraphics
            , "Str", textObj.Text
            , "Int", -1
            , "Ptr", font.Ptr
            , "Ptr", rect
            , "Ptr", stringFormat
            , "Ptr", brush.Ptr)

        if (textObj.Rotation != 0)
            DllCall("gdiplus\GdipRestoreGraphics", "Ptr", this.bufferGraphics, "Ptr", state)

        DllCall("gdiplus\GdipDeleteStringFormat", "Ptr", stringFormat)
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
        image := 0
        DllCall("Gdiplus\GdipLoadImageFromFile", "Str", filename, "Ptr*", &image)
        return image
    }

    DrawImage(image, rect)
    {
        if (!rect.Width && !rect.Height)
            DllCall("gdiplus\GdipDrawImage",
                    "Ptr", this.bufferGraphics,
                    "Ptr", image,
                    "Float", rect.TopLeft.X,
                    "Float", rect.TopLeft.Y)
        else
            DllCall("gdiplus\GdipDrawImageRect",
                    "Ptr", this.bufferGraphics,
                    "Ptr", image,
                    "Float", rect.TopLeft.X,
                    "Float", rect.TopLeft.Y,
                    "Float", rect.Width,
                    "Float", rect.Height)
    }

    SetInterpolationMode(mode := IMode.Bicubic)
    {
        this.IMode := mode
        DllCall("Gdiplus\GdipSetInterpolationMode", "Ptr", this.graphics, "Int", mode)
        DllCall("Gdiplus\GdipSetInterpolationMode", "Ptr", this.bufferGraphics, "Int", mode)
    }

    SetSmoothingMode(mode := SMode.AntiAlias)
    {
        this.SMode := mode
        DllCall("Gdiplus\GdipSetSmoothingMode", "Ptr", this.graphics, "Int", mode)
        DllCall("Gdiplus\GdipSetSmoothingMode", "Ptr", this.bufferGraphics, "Int", mode)
    }

    SetCompositingMode(mode := CMode.Blended)
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
        this.SetCompositingMode(CMode.Overwrite)
        DllCall("Gdiplus\GdipGraphicsClear", "Ptr", this.bufferGraphics, "UInt", col.ToInt(1))
        this.SetCompositingMode(cm)
    }

    Render()
    {
        DllCall("Gdiplus\GdipDrawImage", "Ptr", this.graphics, "Ptr", this.bufferBitmap, "Float", 0, "Float", 0)
    }
}

class Pen
{
    Ptr := 0

    __New(color := Color.Black, width := 1)
    {
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
    __New(color := Color.Black)
    {
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