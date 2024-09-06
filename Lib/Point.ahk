#Requires AutoHotkey v2.0

/** Data structure to hold `X, Y` coordinates. */
class Point
{
    X := 0
    Y := 0

    __New(x := 0, y := 0)
    {
        this.X := x
        this.Y := y
    }

    RotateAround(center, angleDegrees)
    {
        angleRadians := angleDegrees * 3.14159265358979323846 / 180
        cosTheta := Cos(angleRadians)
        sinTheta := Sin(angleRadians)

        dx := this.X - center.X
        dy := this.Y - center.Y

        this.X := center.X + dx * cosTheta - dy * sinTheta
        this.Y := center.Y + dx * sinTheta + dy * cosTheta

        return this
    }

    /**
     * Calculates the distance between this `Point` and a given `Point`
     * @param {Point} point The point to calculate distance to
     * @returns {Float}
     */
    Distance(otherPoint) => Sqrt((this.X - otherPoint.X) ** 2 + (this.Y - otherPoint.Y) ** 2)

    /**
     * Calculates the midpoint between this `Point` and another `Point`.
     * @param {Point} pt The other point.
     * @returns {Point} A new Point representing the midpoint.
     */
    Midpoint(pt) => Point((this.X + pt.X) / 2, (this.Y + pt.Y) / 2)

    /**
     * Clamps the point within a rectangular area.
     * @param {Number} minX The minimum X coordinate.
     * @param {Number} minY The minimum Y coordinate.
     * @param {Number} maxX The maximum X coordinate.
     * @param {Number} maxY The maximum Y coordinate.
     * @returns {Point} A new Point representing the clamped point.
     */
    Clamp(rect)
    {
        return Point(
            Max(rect.TopLeft.X, Min(this.X, rect.BottomRight.X)),
            Max(rect.TopLeft.Y, Min(this.Y, rect.BottomRight.Y))
        )
    }

    /**
     * Checks if this point is equal to another point.
     * @param {Point} otherPoint The point to compare with.
     * @returns {Boolean} True if the points are equal, false otherwise.
     */
    IsEqual(otherPoint) => (this.X == otherPoint.X) and (this.Y == otherPoint.Y)

    /**
    * Returns a string representation of the point.
    * @param {string} [format="X: {X}, Y: {Y}"] The format string with {X} and {Y} as placeholders.
    * @returns {string} A formatted string representation of the point.
    */
    ToString(formatStr := "({X}, {Y})") => Format(RegExReplace(formatStr, "i){(X|Y)}", (m) => "{" . InStr("XY", m[1]) . "}"), this.X, this.Y)

    /**
     * Returns the X and Y coordinates as an array.
     * @returns {Array} An array containing [X, Y].
     */
    ToArray() => [this.X, this.Y]

    /**
    * Creates a new Point from an array of coordinates.
    * @param {Array} arr An array containing [X, Y].
    * @returns {Point} A new Point created from the array.
    */
    static FromArray(arr) => (arr.Length > 1) and (arr[1] is Number) and (arr[2] is Number) ? Point(arr[1], arr[2]) : Throw(Error("Invalid array"))

    /**
     * Returns the X and Y coordinates as a Map.
     * @returns {Map} `Map("X", x, "Y", y).`
     */
    ToMap() => Map("X", this.X, "Y", this.Y)

    /**
    * Creates a new Point from a Map of coordinates.
    * @param {Map} arr A Map containing `Map("X", x, "Y", y)`.
    * @returns {Point} A new Point created from the array.
    */
    static FromMap(map) => (map.Length == 1) and (map.X is Number) and (map.Y is Number) ? Point(map.X, map.Y) : Throw(Error("Invalid Map"))

    /**
     * Creates a new Point with random X and Y coordinates within specified ranges.
     * @param {Number} [xLow=0] The lower bound for the X coordinate.
     * @param {Number} [xHigh=0] The upper bound for the X coordinate.
     * @param {Number} [yLow=0] The lower bound for the Y coordinate.
     * @param {Number} [yHigh=0] The upper bound for the Y coordinate.
     * @returns {Point} A new Point with random coordinates within the specified ranges.
     */
    static Random(xLow := 0, xHigh := 0, yLow := 0, yHigh := 0) => Point(Random(xLow, xHigh), Random(yLow, yHigh))

    /**
     * Creates a new Point from polar coordinates.
     * @param {Number} r The radius (distance from origin).
     * @param {Number} theta The angle in radians.
     * @returns {Point} A new Point created from the polar coordinates.
     */
    static FromPolar(r, theta) => Point(r * Cos(theta), r * Sin(theta))
}