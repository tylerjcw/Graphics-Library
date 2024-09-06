#Include <Point>
#Include <Ellipse>
#Include <Rectangle>

class Path {
    Data := []
    StartPoint := Point(0, 0)
    CurrentPoint := Point(0, 0)
    Closed := false
    FillMode := 1 ; 0 for Alternate, 1 for Winding

    __New(startPoint := 0) {
        if (startPoint != 0)
            this.StartPoint := this.CurrentPoint := startPoint
    }

    Translate(dx, dy) {
        for element in this.Data {
            switch element.Type {
                case "MoveTo", "LineTo":
                    element.Point.X += dx
                    element.Point.Y += dy
                case "ArcTo":
                    element.Point.X += dx
                    element.Point.Y += dy
                case "QuadraticBezierTo":
                    element.ControlPoint.X += dx
                    element.ControlPoint.Y += dy
                    element.EndPoint.X += dx
                    element.EndPoint.Y += dy
                case "CubicBezierTo":
                    element.ControlPoint1.X += dx
                    element.ControlPoint1.Y += dy
                    element.ControlPoint2.X += dx
                    element.ControlPoint2.Y += dy
                    element.EndPoint.X += dx
                    element.EndPoint.Y += dy
            }
        }
        this.StartPoint.X += dx
        this.StartPoint.Y += dy
        this.CurrentPoint.X += dx
        this.CurrentPoint.Y += dy
        return this
    }

    SetPen(pen) {
        this.Pen := pen
        return this
    }

    MoveTo(point) {
        this.Data.Push({Type: "MoveTo", Point: point})
        this.CurrentPoint := point
        return this
    }

    LineTo(point) {
        this.Data.Push({Type: "LineTo", Point: point})
        this.CurrentPoint := point
        return this
    }

    ArcTo(point, radius, startAngle, sweepAngle) {
        this.Data.Push({Type: "ArcTo", Point: point, Radius: radius, StartAngle: startAngle, SweepAngle: sweepAngle})
        this.CurrentPoint := point
        return this
    }

    QuadraticBezierTo(controlPoint, endPoint) {
        this.Data.Push({Type: "QuadraticBezierTo", ControlPoint: controlPoint, EndPoint: endPoint})
        this.CurrentPoint := endPoint
        return this
    }

    CubicBezierTo(controlPoint1, controlPoint2, endPoint) {
        this.Data.Push({Type: "CubicBezierTo", ControlPoint1: controlPoint1, ControlPoint2: controlPoint2, EndPoint: endPoint})
        this.CurrentPoint := endPoint
        return this
    }

    AddLine(_line) {
        this.MoveTo(_line.Start)
        this.LineTo(_line.End)
        return this
    }

    AddRectangle(rect) {
        this.MoveTo(rect.TopLeft)
            .LineTo(Point(rect.Right, rect.Top))
            .LineTo(rect.BottomRight)
            .LineTo(Point(rect.Left, rect.Bottom))
            .ClosePath()
        return this
    }

    AddEllipse(ellipse) {
        kappa := 0.5522847498
        cx := ellipse.Center.X
        cy := ellipse.Center.Y
        rx := ellipse.SemiMajorAxis
        ry := ellipse.SemiMinorAxis

        this.MoveTo(Point(cx - rx, cy))
            .CubicBezierTo(Point(cx - rx, cy - ry * kappa), Point(cx - rx * kappa, cy - ry), Point(cx, cy - ry))
        this.MoveTo(Point(cx, cy - ry))
            .CubicBezierTo(Point(cx + rx * kappa, cy - ry), Point(cx + rx, cy - ry * kappa), Point(cx + rx, cy))
        this.MoveTo(Point(cx + rx, cy))
            .CubicBezierTo(Point(cx + rx, cy + ry * kappa), Point(cx + rx * kappa, cy + ry), Point(cx, cy + ry))
        this.MoveTo(Point(cx, cy + ry))
            .CubicBezierTo(Point(cx - rx * kappa, cy + ry), Point(cx - rx, cy + ry * kappa), Point(cx - rx, cy))
        ;this.MoveTo(Point(cx - rx, cy))

        return this
    }

    AddArc(center, radius, startAngle, endAngle) {
        startPoint := Point(center.X + radius * Cos(startAngle), center.Y + radius * Sin(startAngle))
        this.MoveTo(startPoint)
        this.ArcTo(Point(center.X + radius * Cos(endAngle), center.Y + radius * Sin(endAngle)), radius, startAngle, endAngle - startAngle)
        return this
    }

    AddCurve(points, tension := 0.5) {
        if (points.Length < 3)
            return this

        this.MoveTo(points[1])

        Loop points.Length - 1 {
            i := A_Index + 1
            prevPoint := points[i - 1]
            currentPoint := points[i]
            nextPoint := (i < points.Length) ? points[i + 1] : points[1]

            controlPoint1 := Point(
                prevPoint.X + tension * (currentPoint.X - prevPoint.X),
                prevPoint.Y + tension * (currentPoint.Y - prevPoint.Y)
            )
            controlPoint2 := Point(
                currentPoint.X - tension * (nextPoint.X - prevPoint.X),
                currentPoint.Y - tension * (nextPoint.Y - prevPoint.Y)
            )

            this.CubicBezierTo(controlPoint1, controlPoint2, currentPoint)
        }

        return this
    }

    ClosePath() {
        this.Data.Push({Type: "ClosePath"})
        this.Closed := true
        this.CurrentPoint := this.StartPoint
        return this
    }

    SetFillMode(mode) {
        this.FillMode := mode
        return this
    }

    Clear() {
        this.Data := []
        this.StartPoint := this.CurrentPoint := Point(0, 0)
        this.Closed := false
        return this
    }

    Clone() {
        newPath := Path()
        newPath.Data := this.Data.Clone()
        newPath.StartPoint := this.StartPoint.Clone()
        newPath.CurrentPoint := this.CurrentPoint.Clone()
        newPath.Closed := this.Closed
        newPath.FillMode := this.FillMode
        return newPath
    }
}
