#Requires AutoHotkey v2.0

#Include Point.ahk

rect := Rectangle(Point(2, 3), Point(4, 10))
MsgBox(rect.ToString())

class Rectangle
{
    TopLeft := Point()
    BottomRight := Point()

    /**
     * The width of the rectangle.
     * @returns {Number}
     */
    Width     => this.BottomRight.X - this.TopLeft.X

    /**
     * The height of the rectangle.
     * @returns {Number}
     */
    Height    => this.BottomRight.Y - this.TopLeft.Y

    /**
     * The area of the rectangle.
     * @returns {Number}
     */
    Area      => this.Width * this.Height

    /**
     * The center point of the rectangle.
     * @returns {Point}
     */
    Center    => Point((this.TopLeft.X + this.BottomRight.X) / 2, (this.TopLeft.Y + this.BottomRight.Y) / 2)

    /**
     * The perimeter of the rectangle.
     * @returns {Number}
     */
    Perimeter => 2 * (this.Width + this.Height)

    /**
     * Creates a new Rectangle instance.
     * @param {Number} x1 - The x-coordinate of the first point.
     * @param {Number} y1 - The y-coordinate of the first point.
     * @param {Number} x2 - The x-coordinate of the second point.
     * @param {Number} y2 - The y-coordinate of the second point.
     */
    __New(args*)
    {
        this.TopLeft     := Point()
        this.BottomRight := Point()

        if (args.Length == 2) and (args[1] is Point) and (args[2] is Point)
        {
            this.TopLeft.X := args[1].X
            this.TopLeft.Y := args[1].Y

            this.BottomRight.X := args[2].X
            this.BottomRight.Y := args[2].Y
        }
        else if (args.Length ==4)
        {
            this.TopLeft.X := args[1]
            this.TopLeft.Y := args[2]

            this.BottomRight.X := args[3]
            this.BottomRight.Y := args[4]
        }
    }

    /**
     * Checks if the rectangle contains a given point.
     * @param {Point} pt - The point to check.
     * @returns {Boolean}
     */
    Contains(pt) => (this.TopLeft.X <= pt.X) and (pt.X <=this.BottomRight.X) and (this.TopLeft.Y <= pt.X) and (pt.X <= this.BottomRight.Y)

    /**
     * Creates a new rectangle that is the union of this rectangle and another.
     * @param {Rectangle} rect - The other rectangle.
     * @returns {Rectangle}
     */
    Union(rect) => Rectangle(Min(this.TopLeft.X, rect.TopLeft.X), Min(this.TopLeft.Y, rect.TopLeft.Y), Max(this.BottomRight.X, rect.BottomRight.X), Max(this.BottomRight.Y, rect.BottomRight.Y))


    /**
     * Checks if this rectangle intersects with another.
     * @param {Rectangle} rect - The other rectangle.
     * @returns {Boolean}
     */
    Intersects(rect) => !((this.TopLeft.X > rect.BottomRight.X) or (this.BottomRight.X < rect.TopLeft.X) or (this.TopLeft.Y > rect.BottomRight.Y) or (this.BottomRight.Y < rect.TopLeft.Y))

    /**
     * Creates a new rectangle that is the intersection of this rectangle and another.
     * @param {Rectangle} rect - The other rectangle.
     * @returns {Rectangle|Number} The intersection rectangle, or 0 if there is no intersection.
     */
    Intersection(rect) => this.Intersects(rect) ? Rectangle(Max(this.TopLeft.X, rect.TopLeft.X), Max(this.TopLeft.Y, rect.TopLeft.Y), Max(this.BottomRight.X, rect.BottomRight.X), Max(this.BottomRight.Y, rect.BottomRight.Y)) : 0

    /**
     * Expands the rectangle by a given amount in all directions.
     * @param {Number} amount - The amount to expand by.
     * @returns {Rectangle}
     */
    Expand(amount) => Rectangle(this.TopLeft.X - amount, this.TopLeft.Y - amount, this.BottomRight.X + amount, this.BottomRight.Y + amount)

    /**
     * Checks if the rectangle is a square.
     * @returns {Boolean}
     */
    IsSquare() => this.Width == this.Height

    /**
     * Calculates the aspect ratio of the rectangle.
     * @returns {Number}
     */
    AspectRatio() => this.Width / this.Height

    /**
     * Returns a string representation of the rectangle.
     * @returns {String}
     */
    ToString() => Format("Rectangle(TopLeft: {}, BottomRight: {})", this.TopLeft.ToString(), this.BottomRight.ToString())

    /**
     * Gets the corners of the rectangle.
     * @returns {Array<Point>}
     */
    GetCorners() => [this.TopLeft, Point(this.BottomRight.X, this.TopLeft.Y), this.BottomRight, Point(this.TopLeft.X, this.BottomRight.Y)]

    /**
     * Calculates the distance from the rectangle to a point.
     * @param {Point} pt - The point to calculate distance to.
     * @returns {Number}
     */
    DistanceTo(pt)
    {
        dx := Max(this.TopLeft.X - pt.X, 0, pt.X - this.BottomRight.X)
        dy := Max(this.TopLeft.Y - pt.Y, 0, pt.Y - this.BottomRight.Y)
        return Sqrt(dx * dx + dy * dy)
    }

    /**
     * Translates the rectangle by a given amount.
     * @param {Number} dx - The amount to translate in the x direction.
     * @param {Number} dy - The amount to translate in the y direction.
     * @returns {Rectangle}
     */
    Translate(dx, dy)
    {
        this.TopLeft.X += dx
        this.TopLeft.Y += dy
        this.BottomRight.X += dx
        this.BottomRight.Y += dx
        return this
    }

    /**
     * Scales the rectangle by a given factor.
     * @param {Number} factor - The scaling factor.
     * @returns {Rectangle}
     */
    Scale(factor)
    {
        halfWidth := this.Width * factor / 2
        halfHeight := this.Height * factor / 2
        this.TopLeft.X := this.Center.X - halfwidth
        this.TopLeft.Y := this.Center.Y - halfWidth
        this.BottomRight.X := this.Center.X + halfWidth
        this.BottomRight.Y := this.Center.Y + halfWidth
    }

    /**
     * Creates a new rectangle from a center point and dimensions.
     * @param {Point} centerPoint - The center point of the rectangle.
     * @param {Number} width - The width of the rectangle.
     * @param {Number} height - The height of the rectangle.
     * @returns {Rectangle}
     */
    static FromCenter(centerPoint, width, height)
    {
        halfWidth := width / 2
        halfHeight := height / 2
        return Rectangle(
            centerPoint.X - halfWidth,
            centerPoint.Y - halfHeight,
            centerPoint.X + halfWidth,
            centerPoint.Y + halfHeight
        )
    }
}