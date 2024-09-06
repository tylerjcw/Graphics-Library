#Requires AutoHotkey v2.0

#Include Point.ahk

class Polygon
{
    Vertices := []
    Rotation := 0
    Center => this.GetCenter()
    RotationCenter := Point()

    __New(vertices)
    {
        this.Vertices := vertices
    }

    static CreateRegularPolygon(center, radius, numSides)
    {
        vertices := []
        angle := 2 * 3.14159265358979323846 / numSides
        Loop numSides {
            i := A_Index - 1
            x := center.X + radius * Cos(i * angle)
            y := center.Y + radius * Sin(i * angle)
            vertices.Push(Point(x, y))
        }
        OutputDebug("Made polygon")
        return Polygon(vertices)
    }

    static CreateTriangle(p1, p2, p3)
    {
        return Polygon([p1, p2, p3])
    }

    Rotate(rotation, rotationCenter := this.Center)
    {
        this.Rotation += rotation
        this.RotationCenter := rotationCenter

        angle := this.Rotation * 0.017453292519943295
        cosA := Cos(angle)
        sinA := Sin(angle)

        RotatedVertices := []
        for vertex in this.Vertices
        {
            dx := vertex.X - this.RotationCenter.X
            dy := vertex.Y - this.RotationCenter.Y
            RotatedVertices.Push(Point(
                this.RotationCenter.X + dx * cosA - dy * sinA,
                this.RotationCenter.Y + dx * sinA + dy * cosA
            ))
        }

        this.Vertices := RotatedVertices
    }

    GetCenter()
    {
        sumX := 0
        sumY := 0
        for vertex in this.Vertices
        {
            sumX += vertex.X
            sumY += vertex.Y
        }
        return Point(sumX / this.Vertices.Length, sumY / this.Vertices.Length)
    }

    AddVertex(point)
    {
        this.Vertices.Push(point)
    }

    GetNumSides()
    {
        return this.Vertices.Length
    }

    GetPerimeter()
    {
        perimeter := 0
        for i, vertex in this.Vertices
        {
            nextVertex := this.Vertices[Mod(i, this.Vertices.Length) + 1]
            perimeter += vertex.DistanceTo(nextVertex)
        }
        return perimeter
    }

    Contains(point) {
        ; Implement point-in-polygon algorithm (e.g., ray casting)
    }

    GetArea() {
        ; Implement area calculation (e.g., shoelace formula)
    }

    Translate(dx, dy)
    {
        for vertex in this.Vertices
        {
            vertex.X += dx
            vertex.Y += dy
        }
        return this
    }

    ToString()
    {
        return "Polygon with " . this.GetNumSides() . " sides"
    }
}
