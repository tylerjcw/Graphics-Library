#Requires AutoHotkey v2.0

class Rectangle
{
    TopLeft := Point()
    Width := 0
    Height := 0
    Rotation := 0
    RotationCenter := Point()

    BottomRight => Point(this.TopLeft.X + this.Width, this.TopLeft.Y + this.Height)

    Right  => this.BottomRight.X
    Left   => this.TopLeft.X
    Top    => this.TopLeft.Y
    Bottom => this.BottomRight.Y

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
    __New(topLeft, width, height)
    {
        this.TopLeft := topLeft
        this.Width := width
        this.Height := height
        this.RotationCenter := this.Center
    }

    Rotate(rotation, rotationCenter := this.Center)
    {
        this.Rotation += rotation
        this.RotationCenter := rotationCenter

        angle := this.Rotation * 0.017453292519943295
        cosA := Cos(angle)
        sinA := Sin(angle)

        corners := this.GetCorners()
        this.RotatedCorners := []

        for corner in corners {
            dx := corner.X - this.RotationCenter.X
            dy := corner.Y - this.RotationCenter.Y
            this.RotatedCorners.Push(Point(
                this.RotationCenter.X + dx * cosA - dy * sinA,
                this.RotationCenter.Y + dx * sinA + dy * cosA
            ))
        }
    }

    GetCorners() {
        return [
            this.TopLeft,
            Point(this.TopLeft.X + this.Width, this.TopLeft.Y),
            Point(this.TopLeft.X + this.Width, this.TopLeft.Y + this.Height),
            Point(this.TopLeft.X, this.TopLeft.Y + this.Height)
        ]
    }

    /**
     * Checks if the rectangle contains a given point.
     * @param {Point} pt - The point to check.
     * @returns {Boolean}
     */
    Contains(pt)
    {
        if (this.Rotation == 0)
            return (this.TopLeft.X <= pt.X) and (pt.X <= this.BottomRight.X) and (this.TopLeft.Y <= pt.Y) and (pt.Y <= this.BottomRight.Y)

        ; For rotated rectangles, transform the point back and check
        radians := -this.Rotation * 3.14159265358979323846 / 180
        cosTheta := Cos(radians)
        sinTheta := Sin(radians)
        centerX := this.Center.X
        centerY := this.Center.Y

        transformedX := centerX + (pt.X - centerX) * cosTheta - (pt.Y - centerY) * sinTheta
        transformedY := centerY + (pt.X - centerX) * sinTheta + (pt.Y - centerY) * cosTheta

        return (this.TopLeft.X <= transformedX) and (transformedX <= this.TopLeft.X + this.Width) and
               (this.TopLeft.Y <= transformedY) and (transformedY <= this.TopLeft.Y + this.Height)
    }

    ContainsRect(other)
    {
        return this.TopLeft.X <= other.TopLeft.X && this.TopLeft.Y <= other.TopLeft.Y &&
               this.TopLeft.X + this.Width >= other.TopLeft.X + other.Width &&
               this.TopLeft.Y + this.Height >= other.TopLeft.Y + other.Height
    }

    /**
     * Creates a new rectangle that is the union of this rectangle and another.
     * @param {Rectangle} rect - The other rectangle.
     * @returns {Rectangle}
     */
    Union(rect) => Rectangle(
        Point(Min(this.TopLeft.X, rect.TopLeft.X), Min(this.TopLeft.Y, rect.TopLeft.Y)),
        Max(this.BottomRight.X, rect.BottomRight.X) - Min(this.TopLeft.X, rect.TopLeft.X),
        Max(this.BottomRight.Y, rect.BottomRight.Y) - Min(this.TopLeft.Y, rect.TopLeft.Y)
    )

    Collides(other)
    {
        if (this.TopLeft.X < other.TopLeft.X + other.Width &&
            this.TopLeft.X + this.Width > other.TopLeft.X &&
            this.TopLeft.Y < other.TopLeft.Y + other.Height &&
            this.TopLeft.Y + this.Height > other.TopLeft.Y)
        {
            return true
        }
        return false
    }

    InternalCollides(rect)
    {
        leftCollision   := rect.TopLeft.X <= this.TopLeft.X
        rightCollision  := rect.TopLeft.X + rect.Width >= this.TopLeft.X + this.Width
        topCollision    := rect.TopLeft.Y <= this.TopLeft.Y
        bottomCollision := rect.TopLeft.Y + rect.Height >= this.TopLeft.Y + this.Height

        return (leftCollision || rightCollision || topCollision || bottomCollision)
    }

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
    Intersection(rect) => this.Intersects(rect) ? Rectangle(
        Point(Max(this.TopLeft.X, rect.TopLeft.X), Max(this.TopLeft.Y, rect.TopLeft.Y)),
        Min(this.BottomRight.X, rect.BottomRight.X) - Max(this.TopLeft.X, rect.TopLeft.X),
        Min(this.BottomRight.Y, rect.BottomRight.Y) - Max(this.TopLeft.Y, rect.TopLeft.Y)
    ) : 0

    /**
     * Expands the rectangle by a given amount in all directions.
     * @param {Number} amount - The amount to expand by.
     * @returns {Rectangle}
     */
    Expand(amount) => Rectangle(Point(this.TopLeft.X - amount, this.TopLeft.Y - amount), this.Width + 2 * amount, this.Height + 2 * amount)

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
    ToString() => Format("Rectangle(TopLeft: {}, Width: {}, Height: {}, Rotation: {})", this.TopLeft.ToString(), this.Width, this.Height, this.Rotation)

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
        return this
    }

    /**
     * Scales the rectangle by a given factor.
     * @param {Number} factor - The scaling factor.
     * @returns {Rectangle}
     */
    Scale(factor)
    {
        newWidth := this.Width * factor
        newHeight := this.Height * factor
        this.TopLeft.X += (this.Width - newWidth) / 2
        this.TopLeft.Y += (this.Height - newHeight) / 2
        this.Width := newWidth
        this.Height := newHeight
        return this
    }

    /**
     * Creates a new rectangle from a center point and dimensions.
     * @param {Point} centerPoint - The center point of the rectangle.
     * @param {Number} width - The width of the rectangle.
     * @param {Number} height - The height of the rectangle.
     * @returns {Rectangle}
     */
    static FromCenter(centerPoint, width, height, rotation := 0)
    {
        halfWidth := width / 2
        halfHeight := height / 2
        topLeft := Point(centerPoint.X - halfWidth, centerPoint.Y - halfHeight)

        return Rectangle(topLeft, width, height)
    }
}