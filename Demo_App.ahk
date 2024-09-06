#Requires AutoHotkey v2.0

#Include <GDI+Obj>

; Create a GUI with a canvas
mygui  := Gui()
canvas := mygui.Add("Picture", "w800 h600")
mygui.OnEvent("Close", (*) => ExitApp())
mygui.Show()

; Initialize GDI+ object
gdip := GDIPlusObj(canvas)
gdip.SetCompositingMode(CMode.Blended)
gdip.SetSmoothingMode(SMode.AntiAlias)
gdip.SetInterpolationMode(IMode.HighQualityBicubic)

;Load Image
image := gdip.LoadImage("KT_s.png")

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
brushStroke := Pen(Color(128, 128, 0, 128), 20)
blackbrush  := Brush(Color.Black)
blackPen2   := Pen(Color.Black, 2)
blackPen5   := Pen(Color.Black, 5)

;Gradient
spectrum := ColorArray(Color.Red, Color.Yellow, Color.Lime, Color.Aqua, Color.Blue, Color.Fuchsia)
spectrum := spectrum.Gradient(360)

; Shape movement
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
resolution := 3

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

; Smiley Face
faceEllipse := Ellipse(Point(500, 500), 75, 75)
leftEyeEllipse := Ellipse(Point(462, 462), 15, 15)
rightEyeEllipse := Ellipse(Point(538, 462), 15, 15)
mouthPath := gdip.CreatePath()
mouthPoints := [
    Point(440, 520),
    Point(462, 543),
    Point(500, 550),
    Point(538, 543),
    Point(560, 520)
]
gdip.AddCurve(mouthPath, mouthPoints)

; Main loop
SetTimer(Main, 16)  ; ~60 FPS

Main()
{
    Update()
    Draw()
}

Update()
{
    global rectspeedx, rectspeedy, morphingpolygon, morphingellipse, rotatingline, bouncingrect, wavyBezier, polygonspeedx, polygonspeedy
    global polygonradius, polygonradiusmin, polygonradiusmax, polygonradiuschange, newSides, time, spectrum, textSpeed
    static angle := 0

    ; Shift the gradient hue
    spectrum := spectrum.Map((col) => Color(col.R, col.G, col.B, 64))
    spectrum.ShiftHue(textSpeed)

    ; Update Bezier curve (only even-indexed nodes)
    loop wavyBezier.Points.Length
        wavyBezier.Points[A_Index].Y := 200 + waveHeight * Sin(time + ((A_Index - 2) / 7 * 2 * 3.14159))

    ; Move and bounce rectangle
    bouncingrect.Translate(rectspeedx, rectspeedy)
    bouncingrect.Rotate(1)
    if (bouncingrect.TopLeft.X <= 0 || bouncingrect.TopLeft.X + bouncingrect.Width >= gdip.width)
        rectspeedx *= -1
    if (bouncingrect.TopLeft.Y <= 0 || bouncingrect.TopLeft.Y + bouncingrect.Height >= gdip.height)
        rectspeedy *= -1

    ; Rotate and morph ellipse
    morphingellipse.Rotate(-1)
    morphingellipse.SemiMajorAxis := 75 + 25 * Sin(angle * 0.05)
    morphingellipse.SemiMinorAxis := 50 + 25 * Cos(angle * 0.05)

    ; Rotate line around its midpoint
    linecenter := rotatingline.Midpoint
    rotatingline.Start.RotateAround(linecenter, 2)
    rotatingline.End.RotateAround(linecenter, 2)

    ; Rotate and morph polygon
    morphingpolygon.Rotate(1)
    if (Mod(angle, 120) == 0)
        newsides := 2 + Mod(morphingpolygon.GetNumSides() + 1, 10)

    ; Move polygon
    morphingpolygon.Translate(polygonspeedx, polygonspeedy)

    ; Grow and shrink polygon
    polygonradius += polygonradiuschange
    if (polygonradius >= polygonradiusmax || polygonradius <= polygonradiusmin)
        polygonradiuschange *= -1

    polygoncenter := morphingpolygon.GetCenter()

    ; Store the current rotation
    currentrotation := morphingpolygon.Rotation

    ; Create new polygon with updated radius and sides
    morphingpolygon := Polygon.CreateRegularPolygon(polygoncenter, polygonradius, newsides)

    ; Apply the stored rotation to the new polygon
    morphingpolygon.Rotate(currentrotation)

    ; Check for collisions with canvas boundaries
    polygoncenter := morphingpolygon.GetCenter()
    if (polygoncenter.X - polygonradius <= 0 || polygoncenter.X + polygonradius >= gdip.width)
        polygonspeedx *= -1
    if (polygoncenter.Y - polygonradius <= 0 || polygoncenter.Y + polygonradius >= gdip.height)
        polygonspeedy *= -1

    textObj.Position.X += textSpeed
    textSize := gdip.MeasureString(textObj.Text, textFont)
    OutputDebug("Width: " textSize.Width "`nHeight: " textSize.Height)
    if (textObj.Position.X + textSize.Width >= 510) or (textObj.Position.X <= 150)
        textSpeed *= -1

    angle += 1
    time += waveSpeed
}

Draw()
{
    global gdip, bluepen, tealbrush, greenpen, limebrush, redpen, purplepen, yellowbrush, brushStroke, wavyBezier
    ; Clear the canvas
    gdip.Clear()

    ; Draw the Shapes
    gdip.DrawRectangle(bouncingrect, bluepen, tealbrush)
    gdip.DrawEllipse(morphingellipse, greenpen, limebrush)
    gdip.DrawLine(rotatingline, redpen)
    gdip.DrawPolygon(morphingpolygon, purplepen, yellowbrush)
    gdip.DrawBezier2(wavyBezier, bluePen, resolution)
    gdip.DrawText(textObj, textFont, tealBrush)

    ; Draw The Image
    gdip.DrawImage(image, Rectangle(Point(10, 10), 100, 100))

    ; Draw the Gradient
    gdip.DrawGradient(spectrum, Point(150, 10), 30)

    ; Draw the smiley
    gdip.DrawEllipse(faceEllipse, blackPen5, yellowBrush)
    gdip.DrawEllipse(leftEyeEllipse, blackPen2, blackBrush)
    gdip.DrawEllipse(rightEyeEllipse, blackPen2, blackBrush)
    gdip.DrawPath(mouthPath, blackPen5)

    ; Render the frame
    gdip.Render()
}