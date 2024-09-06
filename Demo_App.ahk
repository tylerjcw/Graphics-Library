#Requires AutoHotkey v2.0

#Include <GDI+Obj>
#Include <GDIObj>
#Include <Graphics\GDI+_Tools>

; Create a GUI with a canvas
mygui  := Gui()
mygui.OnEvent("Close", (*) => ExitApp())

gdipRadio := mygui.Add("Radio", "x10 y10 Checked", "GDI+")
gdiRadio  := myGui.Add("Radio", "x60 y10", "GDI")
canvas    := mygui.Add("Picture", "x10 y30 w800 h600 +Border")
canvas2   := mygui.Add("Picture", "x10 y30 w800 h600 +Border")
mygui.Show()

; Initialize GDI Object
gdi := GDIObj(canvas2)

; Initialize GDI+ object
gdip := GDIPlusObj(canvas)
gdip.SetCompositingMode(CMode.Blended)
gdip.SetSmoothingMode(SMode.AntiAlias)
gdip.SetInterpolationMode(IMode.HighQualityBicubic)

;Load Image
image := gdip.LoadImage("KT_s.png")
image2 := gdi.LoadImage("KT_s.png")

pathSpeedX := 1
pathSpeedY := 1

; Create a pen for drawing

; Create shapes
bouncingrect    := Rectangle(Point(100, 100), 100, 50)
morphingellipse := Ellipse(Point(300, 300), 75, 50)
rotatingline    := Line(Point(50, 500), Point(200, 550))
morphingpolygon := Polygon.CreateRegularPolygon(Point(600, 300), 50, 6)
textObj         := TextObject("Well, Hello There!", Point(160, 15), 0)
textFont        := Font("Maple Mono", 16)

; Create pens and brushes
bluepen     := Pen(Color.Blue, 2)
tealbrush   := Brush(Color.Teal)
greenpen    := Pen(Color.Green, 2)
limebrush   := Brush(Color.Lime)
redpen      := Pen(Color.Red, 2)
purplepen   := Pen(Color.Purple, 6)
yellowbrush := Brush(Color(255, 255, 0, 128))
pathBrush   := Brush(Color(212, 80, 77, 128))
blackbrush  := Brush(Color.Black)
blackPen2   := Pen(Color.Black, 2)
blackPen5   := Pen(Color.Black, 5)

; Create a new path
myPath := Path(Point(100, 100)).MoveTo(Point(100, 200))  ; Left wall
    .LineTo(Point(200, 100))    ; Roof peak
    .LineTo(Point(300, 200))
    .LineTo(Point(300, 300))    ; Right wall
    .LineTo(Point(100, 300))    ; Base
    .ClosePath()                ; Close the main shape
    .MoveTo(Point(175, 250))    ; Start of door
    .AddRectangle(Rectangle(Point(175, 250), 50, 50))
    .MoveTo(Point(137, 250))    ; Left window
    .AddEllipse(Ellipse(Point(137, 250), 25, 25))
    .MoveTo(Point(262, 250))    ; Right window
    .AddEllipse(Ellipse(Point(262, 250), 25, 25))
    .ClosePath()

;Gradient
alpha := 20
alphaChange := 1
spectrum := Gradient(360, Color.Red, Color.Yellow, Color.Lime, Color.Aqua, Color.Blue, Color.Fuchsia)

; Shape movement
angle := 0
textSpeed := 1
newSides := 3
rectspeedx := 4
rectspeedy := 4
polygonspeedx := -2
polygonspeedy := 2
polygonradius := 50
polygonradiusmin := 20
polygonradiusmax := 100
polygonradiuschange := 1

; Initialize Bezier
waveWidth := 800
waveHeight := 75
waveSpeed := 0.2
time := 0
resolution := 2.5

wavyBezier := Bezier([
    Vector(0, 200),
    Vector(waveWidth / 9, 200),
    Vector(waveWidth * 2 / 9, 200),
    Vector(waveWidth * 3 / 9, 200),
    Vector(waveWidth * 4 / 9, 200),
    Vector(waveWidth * 5 / 9, 200),
    Vector(waveWidth * 6 / 9, 200),
    Vector(waveWidth * 7 / 9, 200),
    Vector(waveWidth * 8 / 9, 200),
    Vector(waveWidth, 200)
])

; Main loop
SetTimer(Main, 16)  ; ~60 FPS

Main()
{
    Update()
    Draw()
}

Update()
{
    UpdateGradient()
    UpdateBezier()
    UpdateRectangle()
    UpdateEllipse()
    UpdateLine()
    UpdatePolygon()
    UpdateText()
    UpdatePath()
}

Draw()
{
    if gdiRadio.Value
    {
        canvas2.Visible := true
        DrawGDI()
    }
    else
    {
        canvas2.Visible := false
    }

    if gdipRadio.Value
    {
        canvas.Visible := true
        DrawGDIP()
    }
    else
    {
        canvas.Visible := false
    }
}

DrawGDI()
{
    global gdip, bluepen, tealbrush, greenpen, limebrush, redpen, purplepen, yellowbrush, wavyBezier
    ; Clear the canvas
    gdi.Clear()

    ; Draw the shapes
    gdi.DrawRectangle(bouncingrect, bluepen, tealbrush)
    gdi.DrawEllipse(morphingellipse, greenpen, limebrush)
    gdi.DrawLine(rotatingline, redpen)
    gdi.DrawPolygon(morphingpolygon, purplepen, yellowbrush)
    gdi.DrawBezier(wavyBezier, bluePen, resolution)
    gdi.DrawImage(image, Rectangle(Point(10, 10), 100, 100))

    ; Sadly, no images yet

    ; Draw the Gradient
    gdi.DrawGradient(spectrum, Point(150, 10), 30)
    gdi.DrawRadialGradient(spectrum, Point(600, 150), 100)

    ; Draw the text later in this one, so it shows above the gradient
    gdi.DrawText(textObj, textFont, tealBrush)

    ; Draw the path
    gdi.DrawPath(myPath, bluePen, pathBrush)

    ; Render the frame
    gdi.Render()
}

DrawGDIP()
{
    global gdip, bluepen, tealbrush, greenpen, limebrush, redpen, purplepen, yellowbrush, wavyBezier
    ; Clear the canvas
    gdip.Clear()

    ; Draw the Shapes
    gdip.DrawRectangle(bouncingrect, bluepen, tealbrush)
    gdip.DrawEllipse(morphingellipse, greenpen, limebrush)
    gdip.DrawLine(rotatingline, redpen)
    gdip.DrawPolygon(morphingpolygon, purplepen, yellowbrush)
    gdip.DrawBezier(wavyBezier, bluePen, resolution)
    gdip.DrawText(textObj, textFont, tealBrush)

    ; Draw The Image
    gdip.DrawImage(image, Rectangle(Point(10, 10), 100, 100))

    ; Draw the Gradient
    gdip.DrawGradient(spectrum, Point(150, 10), 30)
    gdip.DrawRadialGradient(spectrum, Point(600, 150), 100)

    ; Draw the Path
    gdip.DrawPath(myPath, bluePen, pathBrush)

    ; Render the frame
    gdip.Render()
}

UpdateGradient()
{
    global alpha, alphaChange, spectrum

    ; Shift the gradient's hue and alpha
    alpha += alphaChange
    if (alpha >= 128) or (alpha <= 10)
        alphaChange *= -1
    spectrum := spectrum.Map((col) => Color(col.R, col.G, col.B, alpha))
    spectrum.ShiftHue(textSpeed * 2)
    spectrum.CreatePens(2)
}

UpdateBezier()
{
    global waveHeight, time, wavyBezier, waveSpeed
    ; Update Bezier curve
    loop wavyBezier.Points.Length
        wavyBezier.Points[A_Index].Y := 200 + waveHeight * Sin(time + ((A_Index - 2) / 7 * 2 * 3.14159))

    time += waveSpeed
}

UpdateRectangle()
{
    global bouncingrect, rectspeedx, rectspeedy

    ; Move and bounce rectangle
    bouncingrect.Translate(rectspeedx, rectspeedy)
    bouncingrect.Rotate(1)
    if (bouncingrect.TopLeft.X <= 0 || bouncingrect.TopLeft.X + bouncingrect.Width >= gdip.width)
        rectspeedx *= -1
    if (bouncingrect.TopLeft.Y <= 0 || bouncingrect.TopLeft.Y + bouncingrect.Height >= gdip.height)
        rectspeedy *= -1
}

UpdateEllipse()
{
    global morphingellipse, angle

    ; Rotate and morph ellipse
    morphingellipse.Rotate(-1)
    morphingellipse.SemiMajorAxis := 75 + 25 * Sin(angle * 0.05)
    morphingellipse.SemiMinorAxis := 50 + 25 * Cos(angle * 0.05)
}

UpdateLine()
{
    global rotatingline

    ; Rotate line around its midpoint
    linecenter := rotatingline.Midpoint
    rotatingline.Start.RotateAround(linecenter, 2)
    rotatingline.End.RotateAround(linecenter, 2)
}

UpdateText()
{
    global textObj, textFont, textSpeed

    textObj.Position.X += textSpeed
    textSize := gdip.MeasureString(textObj.Text, textFont)
    if (textObj.Position.X + textSize.Width >= 510) or (textObj.Position.X <= 150)
        textSpeed *= -1
}

UpdatePolygon()
{
    global morphingpolygon, polygonradius, polygonradiusmin, polygonradiusmax, polygonradiuschange, polygonspeedx, polygonspeedy, angle, newsides

    polygoncenter := morphingpolygon.GetCenter()
    nextRadius := polygonradius + polygonradiuschange

    ; Calculate the next position
    nextX := polygoncenter.X + polygonspeedx
    nextY := polygoncenter.Y + polygonspeedy

    ; Check and respond to horizontal collisions
    if (nextX - nextRadius <= 0) or (nextX + nextRadius >= gdip.width)
    {
        polygonspeedx *= -1
        nextX := Max(nextRadius, Min(gdip.width - nextRadius, nextX))
    }

    ; Check and respond to vertical collisions
    if (nextY - nextRadius <= 0) or (nextY + nextRadius >= gdip.height)
    {
        polygonspeedy *= -1
        nextY := Max(nextRadius, Min(gdip.height - nextRadius, nextY))
    }

    ; Update the polygon's position
    morphingpolygon.Translate(nextX - polygoncenter.X, nextY - polygoncenter.Y)

    ; Rotate and morph polygon
    morphingpolygon.Rotate(1)
    if (Mod(angle, 120) == 0)
        newsides := 2 + Mod(morphingpolygon.GetNumSides() + 1, 10)

    ; Grow and shrink polygon
    polygonradius += polygonradiuschange
    if (polygonradius >= polygonradiusmax) or (polygonradius <= polygonradiusmin)
        polygonradiuschange *= -1

    polygoncenter := morphingpolygon.GetCenter()

    ; Store the current rotation
    currentrotation := morphingpolygon.Rotation

    ; Create new polygon with updated radius and sides
    morphingpolygon := Polygon.CreateRegularPolygon(polygoncenter, polygonradius, newsides)

    ; Apply the stored rotation to the new polygon
    morphingpolygon.Rotate(currentrotation)
    angle += 1
}

UpdatePath()
{
    global myPath, textSpeed
    myPath.Translate(0, textSpeed * 2)
}