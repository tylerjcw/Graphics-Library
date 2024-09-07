#Requires AutoHotkey v2.0

#Include <Graphics>
#Include <Geometry>
#Include <ColorPicker>

; Create a GUI with a picture
mygui  := Gui()
mygui.OnEvent("Close", (*) => ExitApp())

canvasWidth  := 800
canvasHeight := 600

gdipRadio := mygui.Add("Radio", "x10 y10 Checked", "GDI+")
gdiRadio  := myGui.Add("Radio", "x60 y10", "GDI")
colSelect := myGui.Add("Picture", "x110 y9 w50 h15 +Border +BackgroundFFFFFF")
picture    := mygui.Add("Picture", "x10 y30 w" canvasWidth " h" canvasHeight " +Border")
colText   := mygui.Add("Text", "x170 y10", "<-- Click to select ellipse fill color")
colSelect.OnEvent("Click", UpdateEllipseBrush)
gdipRadio.OnEvent("Click", ActivateGDIP)
gdiRadio.OnEvent("Click", ActivateGDI)
mygui.Show()

colSelectGdip := GDIPlusObj(colSelect)
colSelectGdip.SetCompositingMode(GDIP.CMode.Blended)
colSelectGdip.SetSmoothingMode(GDIP.SMode.AntiAlias)
colSelectGdip.SetInterpolationMode(GDIP.IMode.HighQualityBicubic)

; Initialize GDI+ object
canvas := GDIPlusObj(picture)
canvas.SetCompositingMode(GDIP.CMode.Blended)
canvas.SetSmoothingMode(GDIP.SMode.AntiAlias)
canvas.SetInterpolationMode(GDIP.IMode.HighQualityBicubic)

;Load Image - This needs to be re-loaded when the Rendering Mode is switched
image := canvas.LoadImage("KT_s.png")

pathSpeedX := 1
pathSpeedY := 1

; Create shapes
bouncingrect    := Rectangle(Point(100, 100), 100, 50)
morphingellipse := Ellipse(Point(300, 300), 75, 50)
rotatingline    := Line(Point(50, 500), Point(200, 550))
morphingpolygon := Polygon.CreateRegularPolygon(Point(600, 300), 50, 6)
textObj         := Text("Well, Hello There!", Point(160, 15), 0)
textFont        := Font("Maple Mono", 16)
textSize        := canvas.MeasureString(textObj.Text, textFont)

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

colSelectGdip.DrawRectangle(Rectangle(Point(0, 0), colSelectGdip.width, colSelectGdip.height), Pen(Color.Lime, 1), limeBrush)
colSelectGdip.Render()

; Destination and source rectangles for screen Bit Blit, and other variables
destRect := Rectangle(Point(10, 120), 64, 64)
mouseRect := Rectangle(Point(0, 0), 64, 64)
bltSpeedX := 3
bltSpeedY := 3
bltRotation := 2

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
    .MoveTo(Point(262, 275))

;Gradient
alpha := 20
alphaChange := 1
spectrum := Gradient(360, Color.Red, Color.Yellow, Color.Lime, Color.Aqua, Color.Blue, Color.Fuchsia)

; Red to White
redToWhite := Gradient(100, Color.Red, Color("00FFFFFF"))

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
    global canvas
    canvas.Clear()
    UpdateGradient()
    UpdateBezier()
    UpdateRectangle()
    UpdateEllipse()
    UpdateLine()
    UpdatePolygon()
    UpdateText()
    UpdatePath()
    UpdateBitBlt()
}

Draw()
{
    global canvas, bluepen, tealbrush, greenpen, limebrush, redpen, purplepen, yellowbrush, wavyBezier, destRect, mouseRect, destRect

    ; Draw the Shapes
    canvas.DrawRectangle(bouncingrect, bluepen, tealbrush)
    canvas.DrawEllipse(morphingellipse, greenpen, limebrush)
    canvas.DrawLine(rotatingline, redpen)
    canvas.DrawPolygon(morphingpolygon, purplepen, yellowbrush)
    canvas.DrawBezier(wavyBezier, bluePen, resolution)

    ; Draw The Image
    canvas.DrawImage(image, Rectangle(Point(10, 10), 100, 100))

    ; Draw the Gradient
    canvas.DrawGradient(spectrum, Point(150, 10), 30)
    canvas.DrawRadialGradient(redToWhite, Point(600, 500), 50)
    canvas.DrawRadialGradient(spectrum, Point(600, 150), 100)

    ; Draw the Text
    canvas.DrawText(textObj, textFont, tealBrush)

    ; Draw the Path
    canvas.DrawPath(myPath, bluePen, pathBrush)

    ; Draw the BitBlt Screen capture
    canvas.BitBltScreen(mouseRect, destRect)

    ; Render the frame
    canvas.Render()
}

ActivateGDI(*)
{
    global canvas, image
    canvas := GDIObj(picture)
    canvas.SetRefreshRate(60)
    image := canvas.LoadImage("KT_s.bmp")
}

ActivateGDIP(*)
{
    global canvas, image
    canvas := GDIPlusObj(picture)
    canvas.SetCompositingMode(GDIP.CMode.Blended)
    canvas.SetSmoothingMode(GDIP.SMode.AntiAlias)
    canvas.SetInterpolationMode(GDIP.IMode.HighQualityBicubic)
    image := canvas.LoadImage("KT_s.png")
}

UpdateEllipseBrush(*)
{
    global colSelect, limebrush

    SetTimer(Main, 0)
    picker := ColorPicker(False, , ChangeColor)
    picker.DefaultCaptureSize := 9
    picker.Start()
    SetTimer(Main, 16)

    ChangeColor(col)
    {
        limebrush := Brush(col)
        colSelectGdip.Clear()
        colSelectGdip.DrawRectangle(Rectangle(Point(0, 0), colSelectGdip.width, colSelectGdip.height), Pen(col, 1), limebrush)
        colSelectGdip.Render()
    }
}

UpdateBitBlt()
{
    global mouseRect, destRect, bltSpeedX, bltSpeedY, bltRotation
    CoordMode("Mouse", "Screen")
    MouseGetPos(&xPos, &yPos)
    CoordMode("Mouse", "Window")
    mouseRect := Rectangle(Point(xPos - 32, yPos - 32), 64, 64)
    destRect.Rotate(bltRotation)
    destRect.Translate(bltSpeedX, bltSpeedY)
    if (destRect.TopLeft.X <= 0 || destRect.TopLeft.X + destRect.Width >= canvasWidth)
        bltSpeedX *= -1
    if (destRect.TopLeft.Y <= 0 || destRect.TopLeft.Y + destRect.Height >= canvasHeight)
        bltSpeedY *= -1
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
    if (bouncingrect.TopLeft.X <= 0 || bouncingrect.TopLeft.X + bouncingrect.Width >= canvasWidth)
        rectspeedx *= -1
    if (bouncingrect.TopLeft.Y <= 0 || bouncingrect.TopLeft.Y + bouncingrect.Height >= canvasHeight)
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
    global textObj, textFont, textSpeed, textSize

    textObj.Position.X += textSpeed
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
    if (nextX - nextRadius <= 0) or (nextX + nextRadius >= canvasWidth)
    {
        polygonspeedx *= -1
        nextX := Max(nextRadius, Min(canvasWidth - nextRadius, nextX))
    }

    ; Check and respond to vertical collisions
    if (nextY - nextRadius <= 0) or (nextY + nextRadius >= canvasHeight)
    {
        polygonspeedy *= -1
        nextY := Max(nextRadius, Min(canvasHeight - nextRadius, nextY))
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