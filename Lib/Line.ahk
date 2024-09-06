#Requires AutoHotkey v2.0
#Include Point.ahk

class Line
{
    Start := Point()
    End := Point()

    __New(start, end)
    {
        this.Start := start
        this.End   := end
    }

    Length => this.Start.Distance(this.End)

    Slope => (this.End.Y - this.Start.Y) / (this.End.X - this.Start.X)

    Midpoint => Point((this.Start.X + this.End.X) / 2, (this.Start.Y + this.End.Y) / 2)


    Intersects(otherLine)
    {
        x1 := this.Start.X
        y1 := this.Start.Y
        x2 := this.End.X
        y2 := this.End.Y
        x3 := otherLine.Start.X
        y3 := otherLine.Start.Y
        x4 := otherLine.End.X
        y4 := otherLine.End.Y

        denominator := (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        if (denominator == 0)
            return false  ; Lines are parallel

        t := ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
        u := -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator

        return (t >= 0 && t <= 1) && (u >= 0 && u <= 1)
    }

    IntersectionPoint(otherLine)
    {
        if (!this.Intersects(otherLine))
            return false

        x1 := this.Start.X
        y1 := this.Start.Y
        x2 := this.End.X
        y2 := this.End.Y
        x3 := otherLine.Start.X
        y3 := otherLine.Start.Y
        x4 := otherLine.End.X
        y4 := otherLine.End.Y

        denominator := (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        t := ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator

        intersectionX := x1 + t * (x2 - x1)
        intersectionY := y1 + t * (y2 - y1)

        return Point(intersectionX, intersectionY)
    }

    Move(dx, dy)
    {
        this.Start.X += dx
        this.Start.Y += dy
        this.End.X += dx
        this.End.Y += dy
    }

    Rotate(angle, center := 0)
    {
        if (center = 0)
            center := this.Midpoint

        this.Start := this.Start.Rotate(angle, center)
        this.End := this.End.Rotate(angle, center)
    }

    Scale(factor, center := 0)
    {
        if (center = 0)
            center := this.Midpoint

        this.Start := Point(
            center.X + (this.Start.X - center.X) * factor,
            center.Y + (this.Start.Y - center.Y) * factor
        )
        this.End := Point(
            center.X + (this.End.X - center.X) * factor,
            center.Y + (this.End.Y - center.Y) * factor
        )
    }
}