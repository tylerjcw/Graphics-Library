#Requires AutoHotkey v2.0

#Include Vector.ahk

class Bezier
{
    Points := []

    __New(points := [])
    {
        this.Points := points
    }

    AddPoint(pt) => this.Points.Push(Vector.FromPoint(pt))

    RemovePoint(index)
    {
        if (0 < index) and (index <=this.Points.Length)
        {
            this.Points.RemoveAt(index)
            return true
        }

        return false
    }

    Evaluate(t)
    {
        if this.Points.Length < 2
            return Vector(0, 0)

        points := this.Points.Clone()
        n := points.Length

        loop n - 1
        {
            outer := A_Index
            loop n - outer
            {
                i := A_Index
                points[i] := points[i].Lerp(points[i + 1], t)
            }
        }

        return points[1]
    }

    GetPoints(numPoints := 100)
    {
        result := []
        step := 1 / (numPoints - 1)

        loop numPoints
        {
            t := (A_Index - 1) * step
            result.Push(this.Evaluate(t))
        }

        return result
    }

    FindNearestPoint(pt, threshold := 10)
    {
        minDist := threshold
        nearestIndex := -1
        for index, curPt in this.Points
        {
            dist := curPt.Distance(pt)
            if (dist < minDist)
            {
                minDist := dist
                nearestIndex := index
            }
        }
        return nearestIndex
    }

    RemoveNearestPoint(pt, threshold := 10)
    {
        index := this.FindNearestPoint(pt, threshold)
        if (index > 0)
        {
            this.Points.RemoveAt(index)
            return true
        }

        return false
    }

    InsertPoint(pt, numPoints := 100, threshold := 10)
    {
        if (this.Points.Length < 2)
            return this.AddPoint(pt)

        curvePoints := this.GetPoints(numPoints)
        nearestDistance := 999999
        nearestIndex := -1

        for i, curPt in curvePoints
        {
            distance := curPt.Distance(pt)
            if distance < nearestDistance
            {
                nearestDistance := distance
                nearestIndex := i
            }
        }

        if nearestDistance <= threshold
        {
            t := (nearestIndex - 1) / (curvePoints.Length - 1)
            newPoint := this.Evaluate(t)
            insertIndex := 1

            while (insertIndex < this.Points.Length) and (t > (insertIndex - 1) / (this.Points.Length - 1))
                insertIndex++

            this.Points.InsertAt(insertIndex, newPoint)
            return true
        }

        return false
    }
}