#Requires AutoHotkey v2.0

#Include Point.ahk

class Ellipse
{
    Center := Point()
    SemiMajorAxis := 0
    SemiMinorAxis := 0
    Rotation := 0

    __New(center, semiMajorAxis, semiMinorAxis, rotation := 0)
    {
        this.Center := center
        this.SemiMajorAxis := semiMajorAxis
        this.SemiMinorAxis := semiMinorAxis
        this.Rotation := rotation
    }

    Area => 3.14159265358979323846 * this.SemiMajorAxis * this.SemiMinorAxis

    Circumference => 2 * 3.14159265358979323846 * Sqrt((this.SemiMajorAxis ** 2 + this.SemiMinorAxis ** 2) / 2)

    Eccentricity => Sqrt(1 - (this.SemiMinorAxis ** 2 / this.SemiMajorAxis ** 2))

    Contains(pt)
    {
        cosTheta := Cos(this.Rotation)
        sinTheta := Sin(this.Rotation)
        dx := pt.X - this.Center.X
        dy := pt.Y - this.Center.Y
        xRotated := dx * cosTheta + dy * sinTheta
        yRotated := -dx * sinTheta + dy * cosTheta
        return ((xRotated ** 2) / (this.SemiMajorAxis ** 2) + (yRotated ** 2) / (this.SemiMinorAxis ** 2)) <= 1
    }

    GetPointOnEllipse(angle)
    {
        x := this.SemiMajorAxis * Cos(angle)
        y := this.SemiMinorAxis * Sin(angle)
        rotatedX := x * Cos(this.Rotation) - y * Sin(this.Rotation)
        rotatedY := x * Sin(this.Rotation) + y * Cos(this.Rotation)
        return Point(this.Center.X + rotatedX, this.Center.Y + rotatedY)
    }

    ToString() => Format("Ellipse(Center: {}, SemiMajorAxis: {}, SemiMinorAxis: {}, Rotation: {})", this.Center.ToString(), this.SemiMajorAxis, this.SemiMinorAxis, this.Rotation)
}
