#Requires AutoHotkey v2.0

#Include Bezier.ahk
#Include GDIObj.ahk
#Include Ellipse.ahk

startDemo := BezierDemo()

class BezierDemo
{
    curve := Bezier()
    ell := Ellipse(Point(200, 150), 100, 50, 45)
    gdi := unset
    selectedPoint := -1

    __New()
    {
        this.gui := Gui()
        this.canvas := this.gui.AddPicture("w800 h600")
        this.gdi := GDIObj(this.canvas)

        this.canvas.OnEvent("Click", (*) => this.OnClick())
        this.canvas.OnEvent("ContextMenu", (*) => this.OnRightClick())
        this.gui.OnEvent("Close", (*) => ExitApp())

        this.gui.Show()

        SetTimer(() => this.CheckMouseMove(), 10)
    }

    OnClick()
    {
        MouseGetPos(&x, &y)
        pt := Point(x, y)
        if (GetKeyState("Shift", "P")) ; If shift is down, select a point and begin moving it
        {
            this.selectedPoint := this.curve.FindNearestPoint(pt, 10)
            OutputDebug("Shift + Click. Selected point: " . this.selectedPoint "`n")
        }
        else if not this.curve.InsertPoint(pt) ; Otherwise, try inserting a point along the curve
        {
            this.curve.AddPoint(pt) ; If inserting a Point didn't work, add one to the end of the curve
            OutputDebug("Point added at: " . x . ", " . y "`n")
        }
        else
        {
            OutputDebug("Point inserted on curve at: " . x . ", " . y)
        }
        this.Draw()
    }

    OnRightClick()
    {
        MouseGetPos(&x, &y)
        if this.curve.RemoveNearestPoint(Point(x, y), 10) ; Remove the point nearest the mouse cursor (within a threshold)
            this.Draw()
        else if this.curve.RemovePoint(this.curve.Points.Length)
            this.Draw()
    }

    CheckMouseMove()
    {
        if (this.selectedPoint != -1)
        {
            MouseGetPos(&x, &y)
            if GetKeyState("Shift", "P") and GetKeyState("LButton", "P") ; Keep moving the selected Point
            {
                this.curve.Points[this.selectedPoint] := Vector(x, y)
                OutputDebug("Moving point: " . this.selectedPoint . " to " . x . ", " . y "`n")
                this.Draw()
            }
            else ; Release the point
            {
                this.selectedPoint := -1
                OutputDebug("Released point: " . this.selectedPoint "`n")
            }
        }
    }

    Draw()
    {
        this.gdi.Clear()

        ; Draw control points
        for pt in this.curve.Points
            this.gdi.DrawEllipse(Ellipse(pt, 10, 10), Color.Black, Color.Red, true, 1)

        this.gdi.DrawBezier(this.curve, Color.Blue, 2)
        this.gdi.DrawEllipse(this.ell, Color.Lime, Color.Green, false, 2)

        this.gdi.Render()
    }
}