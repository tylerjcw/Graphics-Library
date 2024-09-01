#Requires AutoHotkey v2.0

#Include Point.ahk

class Vector extends Point
{
    /**
     * The magnitude (length) of the vector.
     */
    Magnitude => Sqrt(this.X ** 2 + this.Y ** 2)

    /**
     * Creates a new Vector instance.
     * @param {Number} x The x-component of the vector.
     * @param {Number} y The y-component of the vector.
     */
    __New(x, y)
    {
        super.__New(x, y)
    }

    /**
     * Adds another vector to this vector.
     * @param {Vector} otherVector The vector to add.
     * @returns {Vector} A new vector representing the sum.
     */
    Add(otherVector) => Vector(this.X + otherVector.X, this.Y + otherVector.Y)

    /**
     * Subtracts another vector from this vector.
     * @param {Vector} otherVector The vector to subtract.
     * @returns {Vector} A new vector representing the difference.
     */
    Subtract(otherVector) => Vector(this.X - otherVector.X, this.Y - otherVector.Y)

    /**
     * Scales the vector by a scalar value.
     * @param {Number} scalar The scaling factor.
     * @returns {Vector} A new vector representing the scaled vector.
     */
    Scale(scalar) => Vector(this.X * scalar, this.Y * scalar)

    /**
     * Normalizes the vector to a unit vector.
     * @returns {Vector} A new vector representing the normalized vector.
     */
    Normalize() => this.Magnitude != 0 ? this.Scale(1 / this.Magnitude) : Vector(0, 0)

    /**
     * Calculates the dot product of this vector with another vector.
     * @param {Vector} otherVector The other vector.
     * @returns {Number} The dot product.
     */
    DotProduct(otherVector) => this.X * otherVector.X + this.Y * otherVector.Y

    /**
     * Calculates the cross product of this vector with another vector.
     * @param {Vector} otherVector The other vector.
     * @returns {Number} The cross product.
     */
    CrossProduct(otherVector) => this.X * otherVector.Y - this.Y * otherVector.X

    /**
     * Calculates the angle between this vector and another vector.
     * @param {Vector} otherVector The other vector.
     * @returns {Number} The angle in radians.
     */
    Angle(otherVector) => ATan2(otherVector.Y - this.Y, otherVector.X - this.X)

    /**
     * Performs linear interpolation between this vector and another vector.
     * @param {Vector} otherVector The vector to interpolate towards.
     * @param {Number} t The interpolation factor (0 to 1).
     * @returns {Vector} A new vector representing the interpolated position.
     */
    Lerp(otherVector, t) => Vector(this.X + (otherVector.X - this.X) * t, this.Y + (otherVector.Y - this.Y) * t)

    /**
     * Rotates the vector by a given angle around a center point.
     * @param {Number} angle The rotation angle in degrees.
     * @param {Vector} [center=Vector(0, 0)] The center of rotation.
     * @returns {Vector} A new vector representing the rotated vector.
     */
    Rotate(angle, center := 0)
    {
        if (center = 0)
            center := Vector(0, 0)

        radians := angle * (3.14159 / 180)
        cos := Cos(radians)
        sin := Sin(radians)

        translatedX := this.X - center.X
        translatedY := this.Y - center.Y

        rotatedX := translatedX * cos - translatedY * sin
        rotatedY := translatedX * sin + translatedY * cos

        return Vector(rotatedX + center.X, rotatedY + center.Y)
    }

    /**
     * Projects this vector onto another vector.
     * @param {Vector} otherVector The vector to project onto.
     * @returns {Vector} A new vector representing the projection.
     */
    Project(otherVector)
    {
        if (otherVector.X == 0 && otherVector.Y == 0)
            return Vector(0, 0)

        dp := this.DotProduct(otherVector)
        magnitude := otherVector.Magnitude()
        scale := dp / (magnitude * magnitude)
        return otherVector.Scale(scale)
    }

    /**
     * Reflects this vector across a normal vector.
     * @param {Vector} normal The normal vector to reflect across.
     * @returns {Vector} A new vector representing the reflected vector.
     */
    Reflect(normal)
    {
        normalizedNormal := normal.Normalize()
        return this.Subtract(normalizedNormal.Scale(2 * this.DotProduct(normalizedNormal)))
    }

    ToPoint() => Point(this.X, this.Y)

    static FromPoint(pt) => Vector(pt.X, pt.Y)
}
