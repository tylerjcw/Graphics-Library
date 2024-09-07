#Requires AutoHotkey v2.0

class GDIP
{
    static IsStarted()
    {
        token := Buffer(A_PtrSize, 0)
        startupInput := Buffer(3 * A_PtrSize, 0)
        NumPut("UInt", 1, startupInput)

        result := DllCall("gdiplus\GdiplusStartup", "Ptr*", token.Ptr, "Ptr", startupInput.Ptr, "Ptr", 0)

        if (result = 0)
        {
            DllCall("gdiplus\GdiplusShutdown", "Ptr", NumGet(token, "Ptr"))
            return true
        }

        return false
    }

    /**
     * Initializes GDI+.
     * @param {Integer} token - A pointer to a variable that receives a token to use in other GDI+ functions.
     * @param {Pointer} input - A pointer to a StartupInput structure.
     * @param {Pointer} output - A pointer to a StartupOutput structure.
     * @returns {Integer} Status code.
     */
    static Startup(token, input, output) => DllCall("gdiplus\GdiplusStartup", "Ptr*", token, "Ptr", input, "Ptr", output)

    /**
     * Cleans up resources used by GDI+.
     * @param {Integer} token - The token returned by GdiplusStartup.
     */
    static Shutdown(token) => DllCall("gdiplus\GdiplusShutdown", "Ptr", token)

    /**
     * Allocates memory for GDI+ operations.
     * @param {Integer} size - The number of bytes to allocate.
     * @returns {Pointer} A pointer to the allocated memory.
     */
    static Alloc(size) => DllCall("gdiplus\GdipAlloc", "UInt", size, "Ptr")

    /**
     * Frees memory allocated by GdipAlloc.
     * @param {Pointer} ptr - A pointer to the memory to free.
     */
    static Free(ptr) => DllCall("gdiplus\GdipFree", "Ptr", ptr)

    /**
     * Creates a new GraphicsPath object.
     * @param {Integer} brushMode - The fill mode of the path.
     * @returns {Pointer} A pointer to the new GraphicsPath object.
     */
    static CreatePath(brushMode) => (path := 0, DllCall("gdiplus\GdipCreatePath", "Int", brushMode, "Ptr*", &path), path)

    /**
     * Creates a GraphicsPath object from an array of points and types.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Pointer} types - A pointer to an array of byte values that specify the point types.
     * @param {Integer} count - The number of points in the path.
     * @param {Integer} fillMode - The fill mode of the path.
     * @returns {Pointer} A pointer to the new GraphicsPath object.
     */
    static CreatePath2(points, types, count, fillMode) => (path := 0, DllCall("gdiplus\GdipCreatePath2", "Ptr", points, "Ptr", types, "Int", count, "Int", fillMode, "Ptr*", &path), path)

    /**
     * Creates a GraphicsPath object from an array of integer points and types.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Pointer} types - A pointer to an array of byte values that specify the point types.
     * @param {Integer} count - The number of points in the path.
     * @param {Integer} fillMode - The fill mode of the path.
     * @returns {Pointer} A pointer to the new GraphicsPath object.
     */
    static CreatePath2I(points, types, count, fillMode) => (path := 0, DllCall("gdiplus\GdipCreatePath2I", "Ptr", points, "Ptr", types, "Int", count, "Int", fillMode, "Ptr*", &path), path)

    /**
     * Creates a copy of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object to clone.
     * @returns {Pointer} A pointer to the cloned GraphicsPath object.
     */
    static ClonePath(path) => (clonePath := 0, DllCall("gdiplus\GdipClonePath", "Ptr", path, "Ptr*", &clonePath), clonePath)

    /**
     * Deletes a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object to delete.
     * @returns {Integer} Status code.
     */
    static DeletePath(path) => DllCall("gdiplus\GdipDeletePath", "Ptr", path)

    /**
     * Empties a GraphicsPath object of all points and figures.
     * @param {Pointer} path - A pointer to the GraphicsPath object to reset.
     * @returns {Integer} Status code.
     */
    static ResetPath(path) => DllCall("gdiplus\GdipResetPath", "Ptr", path)

    /**
     * Gets the number of points in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} The number of points in the path.
     */
    static GetPointCount(path) => (count := 0, DllCall("gdiplus\GdipGetPointCount", "Ptr", path, "Int*", &count), count)

    /**
     * Gets the types of all points in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} types - A pointer to an array that receives the point types.
     * @param {Integer} count - The number of points to retrieve.
     * @returns {Integer} Status code.
     */
    static GetPathTypes(path, types, count) => DllCall("gdiplus\GdipGetPathTypes", "Ptr", path, "Ptr", types, "Int", count)

    /**
     * Gets the points of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array that receives the points.
     * @param {Integer} count - The number of points to retrieve.
     * @returns {Integer} Status code.
     */
    static GetPathPoints(path, points, count) => DllCall("gdiplus\GdipGetPathPoints", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Gets the integer points of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array that receives the points.
     * @param {Integer} count - The number of points to retrieve.
     * @returns {Integer} Status code.
     */
    static GetPathPointsI(path, points, count) => DllCall("gdiplus\GdipGetPathPointsI", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Gets the fill mode of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} The fill mode of the path.
     */
    static GetPathFillMode(path) => (fillMode := 0, DllCall("gdiplus\GdipGetPathFillMode", "Ptr", path, "Int*", &fillMode), fillMode)

    /**
     * Sets the fill mode of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} fillMode - The new fill mode.
     * @returns {Integer} Status code.
     */
    static SetPathFillMode(path, fillMode) => DllCall("gdiplus\GdipSetPathFillMode", "Ptr", path, "Int", fillMode)

    /**
     * Gets the data from a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} pathData - A pointer to a PathData structure that receives the path data.
     * @returns {Integer} Status code.
     */
    static GetPathData(path, pathData) => DllCall("gdiplus\GdipGetPathData", "Ptr", path, "Ptr", pathData)

    /**
     * Starts a new figure in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} Status code.
     */
    static StartPathFigure(path) => DllCall("gdiplus\GdipStartPathFigure", "Ptr", path)

    /**
     * Closes the current figure in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} Status code.
     */
    static ClosePathFigure(path) => DllCall("gdiplus\GdipClosePathFigure", "Ptr", path)

    /**
     * Closes all open figures in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} Status code.
     */
    static ClosePathFigures(path) => DllCall("gdiplus\GdipClosePathFigures", "Ptr", path)

    /**
     * Sets a marker in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} Status code.
     */
    static SetPathMarker(path) => DllCall("gdiplus\GdipSetPathMarker", "Ptr", path)

    /**
     * Clears all markers from a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} Status code.
     */
    static ClearPathMarkers(path) => DllCall("gdiplus\GdipClearPathMarkers", "Ptr", path)

    /**
     * Reverses the order of points in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @returns {Integer} Status code.
     */
    static ReversePath(path) => DllCall("gdiplus\GdipReversePath", "Ptr", path)

    /**
     * Gets the last point in a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} lastPoint - A pointer to a PointF structure that receives the last point.
     * @returns {Integer} Status code.
     */
    static GetPathLastPoint(path, lastPoint) => DllCall("gdiplus\GdipGetPathLastPoint", "Ptr", path, "Ptr", lastPoint)

        /**
     * Adds a line to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x1 - The x-coordinate of the line's starting point.
     * @param {Float} y1 - The y-coordinate of the line's starting point.
     * @param {Float} x2 - The x-coordinate of the line's ending point.
     * @param {Float} y2 - The y-coordinate of the line's ending point.
     * @returns {Integer} Status code.
     */
    static AddPathLine(path, x1, y1, x2, y2) => DllCall("gdiplus\GdipAddPathLine", "Ptr", path, "Float", x1, "Float", y1, "Float", x2, "Float", y2)

    /**
     * Adds a series of connected lines to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathLine2(path, points, count) => DllCall("gdiplus\GdipAddPathLine2", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds an arc to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @param {Float} startAngle - The starting angle of the arc, in degrees.
     * @param {Float} sweepAngle - The sweep angle of the arc, in degrees.
     * @returns {Integer} Status code.
     */
    static AddPathArc(path, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipAddPathArc", "Ptr", path, "Float", x, "Float", y, "Float", width, "Float", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Adds a Bézier spline to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x1 - The x-coordinate of the starting point of the Bézier spline.
     * @param {Float} y1 - The y-coordinate of the starting point of the Bézier spline.
     * @param {Float} x2 - The x-coordinate of the first control point of the Bézier spline.
     * @param {Float} y2 - The y-coordinate of the first control point of the Bézier spline.
     * @param {Float} x3 - The x-coordinate of the second control point of the Bézier spline.
     * @param {Float} y3 - The y-coordinate of the second control point of the Bézier spline.
     * @param {Float} x4 - The x-coordinate of the ending point of the Bézier spline.
     * @param {Float} y4 - The y-coordinate of the ending point of the Bézier spline.
     * @returns {Integer} Status code.
     */
    static AddPathBezier(path, x1, y1, x2, y2, x3, y3, x4, y4) => DllCall("gdiplus\GdipAddPathBezier", "Ptr", path, "Float", x1, "Float", y1, "Float", x2, "Float", y2, "Float", x3, "Float", y3, "Float", x4, "Float", y4)

    /**
     * Adds a series of Bézier splines to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathBeziers(path, points, count) => DllCall("gdiplus\GdipAddPathBeziers", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds a cardinal spline to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathCurve(path, points, count) => DllCall("gdiplus\GdipAddPathCurve", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds a cardinal spline to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static AddPathCurve2(path, points, count, tension) => DllCall("gdiplus\GdipAddPathCurve2", "Ptr", path, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Adds a cardinal spline to the current figure of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @param {Integer} offset - The index of the first point in the array to use.
     * @param {Integer} numberOfSegments - The number of segments to create.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static AddPathCurve3(path, points, count, offset, numberOfSegments, tension) => DllCall("gdiplus\GdipAddPathCurve3", "Ptr", path, "Ptr", points, "Int", count, "Int", offset, "Int", numberOfSegments, "Float", tension)

    /**
     * Adds a closed cardinal spline to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathClosedCurve(path, points, count) => DllCall("gdiplus\GdipAddPathClosedCurve", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds a closed cardinal spline to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static AddPathClosedCurve2(path, points, count, tension) => DllCall("gdiplus\GdipAddPathClosedCurve2", "Ptr", path, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Adds a rectangle to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Float} width - The width of the rectangle.
     * @param {Float} height - The height of the rectangle.
     * @returns {Integer} Status code.
     */
    static AddPathRectangle(path, x, y, width, height) => DllCall("gdiplus\GdipAddPathRectangle", "Ptr", path, "Float", x, "Float", y, "Float", width, "Float", height)

    /**
     * Adds a series of rectangles to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} rects - A pointer to an array of RectF structures.
     * @param {Integer} count - The number of rectangles in the array.
     * @returns {Integer} Status code.
     */
    static AddPathRectangles(path, rects, count) => DllCall("gdiplus\GdipAddPathRectangles", "Ptr", path, "Ptr", rects, "Int", count)

    /**
     * Adds an ellipse to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @returns {Integer} Status code.
     */
    static AddPathEllipse(path, x, y, width, height) => DllCall("gdiplus\GdipAddPathEllipse", "Ptr", path, "Float", x, "Float", y, "Float", width, "Float", height)

    /**
     * Adds a pie to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @param {Float} startAngle - The starting angle of the pie, in degrees.
     * @param {Float} sweepAngle - The sweep angle of the pie, in degrees.
     * @returns {Integer} Status code.
     */
    static AddPathPie(path, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipAddPathPie", "Ptr", path, "Float", x, "Float", y, "Float", width, "Float", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Adds a polygon to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathPolygon(path, points, count) => DllCall("gdiplus\GdipAddPathPolygon", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds a GraphicsPath object to another GraphicsPath object.
     * @param {Pointer} path - A pointer to the destination GraphicsPath object.
     * @param {Pointer} addingPath - A pointer to the GraphicsPath object to be added.
     * @param {Boolean} connect - Specifies whether to connect the two paths.
     * @returns {Integer} Status code.
     */
    static AddPathPath(path, addingPath, connect) => DllCall("gdiplus\GdipAddPathPath", "Ptr", path, "Ptr", addingPath, "Int", connect)

    /**
     * Adds a text string to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {String} string - The string to add.
     * @param {Integer} length - The length of the string.
     * @param {Pointer} family - A pointer to a FontFamily object.
     * @param {Integer} style - The font style.
     * @param {Float} emSize - The em size of the font.
     * @param {Pointer} layoutRect - A pointer to a RectF structure that specifies the layout rectangle.
     * @param {Pointer} stringFormat - A pointer to a StringFormat object.
     * @returns {Integer} Status code.
     */
    static AddPathString(path, string, length, family, style, emSize, layoutRect, stringFormat) => DllCall("gdiplus\GdipAddPathString", "Ptr", path, "Str", string, "Int", length, "Ptr", family, "Int", style, "Float", emSize, "Ptr", layoutRect, "Ptr", stringFormat)

    /**
     * Adds a text string to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {String} string - The string to add.
     * @param {Integer} length - The length of the string.
     * @param {Pointer} family - A pointer to a FontFamily object.
     * @param {Integer} style - The font style.
     * @param {Float} emSize - The em size of the font.
     * @param {Pointer} layoutRect - A pointer to a Rect structure that specifies the layout rectangle.
     * @param {Pointer} stringFormat - A pointer to a StringFormat object.
     * @returns {Integer} Status code.
     */
    static AddPathStringI(path, string, length, family, style, emSize, layoutRect, stringFormat) => DllCall("gdiplus\GdipAddPathStringI", "Ptr", path, "Str", string, "Int", length, "Ptr", family, "Int", style, "Float", emSize, "Ptr", layoutRect, "Ptr", stringFormat)

    /**
     * Adds a line to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x1 - The x-coordinate of the line's starting point.
     * @param {Integer} y1 - The y-coordinate of the line's starting point.
     * @param {Integer} x2 - The x-coordinate of the line's ending point.
     * @param {Integer} y2 - The y-coordinate of the line's ending point.
     * @returns {Integer} Status code.
     */
    static AddPathLineI(path, x1, y1, x2, y2) => DllCall("gdiplus\GdipAddPathLineI", "Ptr", path, "Int", x1, "Int", y1, "Int", x2, "Int", y2)

    /**
     * Adds a series of connected lines to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathLine2I(path, points, count) => DllCall("gdiplus\GdipAddPathLine2I", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds an arc to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} width - The width of the rectangle that bounds the ellipse.
     * @param {Integer} height - The height of the rectangle that bounds the ellipse.
     * @param {Float} startAngle - The starting angle of the arc, in degrees.
     * @param {Float} sweepAngle - The sweep angle of the arc, in degrees.
     * @returns {Integer} Status code.
     */
    static AddPathArcI(path, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipAddPathArcI", "Ptr", path, "Int", x, "Int", y, "Int", width, "Int", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Adds a Bézier spline to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x1 - The x-coordinate of the starting point of the Bézier spline.
     * @param {Integer} y1 - The y-coordinate of the starting point of the Bézier spline.
     * @param {Integer} x2 - The x-coordinate of the first control point of the Bézier spline.
     * @param {Integer} y2 - The y-coordinate of the first control point of the Bézier spline.
     * @param {Integer} x3 - The x-coordinate of the second control point of the Bézier spline.
     * @param {Integer} y3 - The y-coordinate of the second control point of the Bézier spline.
     * @param {Integer} x4 - The x-coordinate of the ending point of the Bézier spline.
     * @param {Integer} y4 - The y-coordinate of the ending point of the Bézier spline.
     * @returns {Integer} Status code.
     */
    static AddPathBezierI(path, x1, y1, x2, y2, x3, y3, x4, y4) => DllCall("gdiplus\GdipAddPathBezierI", "Ptr", path, "Int", x1, "Int", y1, "Int", x2, "Int", y2, "Int", x3, "Int", y3, "Int", x4, "Int", y4)

    /**
     * Adds a series of Bézier splines to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathBeziersI(path, points, count) => DllCall("gdiplus\GdipAddPathBeziersI", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds a cardinal spline to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathCurveI(path, points, count) => DllCall("gdiplus\GdipAddPathCurveI", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds a cardinal spline to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static AddPathCurve2I(path, points, count, tension) => DllCall("gdiplus\GdipAddPathCurve2I", "Ptr", path, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Adds a cardinal spline to the current figure of a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @param {Integer} offset - The index of the first point in the array to use.
     * @param {Integer} numberOfSegments - The number of segments to create.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static AddPathCurve3I(path, points, count, offset, numberOfSegments, tension) => DllCall("gdiplus\GdipAddPathCurve3I", "Ptr", path, "Ptr", points, "Int", count, "Int", offset, "Int", numberOfSegments, "Float", tension)

    /**
     * Adds a closed cardinal spline to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathClosedCurveI(path, points, count) => DllCall("gdiplus\GdipAddPathClosedCurveI", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Adds a closed cardinal spline to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static AddPathClosedCurve2I(path, points, count, tension) => DllCall("gdiplus\GdipAddPathClosedCurve2I", "Ptr", path, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Adds a rectangle to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} width - The width of the rectangle.
     * @param {Integer} height - The height of the rectangle.
     * @returns {Integer} Status code.
     */
    static AddPathRectangleI(path, x, y, width, height) => DllCall("gdiplus\GdipAddPathRectangleI", "Ptr", path, "Int", x, "Int", y, "Int", width, "Int", height)

    /**
     * Adds a series of rectangles to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} rects - A pointer to an array of Rect structures.
     * @param {Integer} count - The number of rectangles in the array.
     * @returns {Integer} Status code.
     */
    static AddPathRectanglesI(path, rects, count) => DllCall("gdiplus\GdipAddPathRectanglesI", "Ptr", path, "Ptr", rects, "Int", count)

    /**
     * Adds an ellipse to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} width - The width of the rectangle that bounds the ellipse.
     * @param {Integer} height - The height of the rectangle that bounds the ellipse.
     * @returns {Integer} Status code.
     */
    static AddPathEllipseI(path, x, y, width, height) => DllCall("gdiplus\GdipAddPathEllipseI", "Ptr", path, "Int", x, "Int", y, "Int", width, "Int", height)

    /**
     * Adds a pie to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} width - The width of the rectangle that bounds the ellipse.
     * @param {Integer} height - The height of the rectangle that bounds the ellipse.
     * @param {Float} startAngle - The starting angle of the pie, in degrees.
     * @param {Float} sweepAngle - The sweep angle of the pie, in degrees.
     * @returns {Integer} Status code.
     */
    static AddPathPieI(path, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipAddPathPieI", "Ptr", path, "Int", x, "Int", y, "Int", width, "Int", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Adds a polygon to a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static AddPathPolygonI(path, points, count) => DllCall("gdiplus\GdipAddPathPolygonI", "Ptr", path, "Ptr", points, "Int", count)

    /**
     * Applies a transformation to a GraphicsPath object to flatten its curves.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @param {Float} flatness - The maximum error between the path and its flattened approximation.
     * @returns {Integer} Status code.
     */
    static FlattenPath(path, matrix, flatness) => DllCall("gdiplus\GdipFlattenPath", "Ptr", path, "Ptr", matrix, "Float", flatness)

    /**
     * Transforms and flattens a path, and then converts it to a region.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @param {Float} flatness - The maximum error between the path and its flattened approximation.
     * @returns {Integer} Status code.
     */
    static WindingModeOutline(path, matrix, flatness) => DllCall("gdiplus\GdipWindingModeOutline", "Ptr", path, "Ptr", matrix, "Float", flatness)

    /**
     * Widens the stroke of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} pen - A pointer to a Pen object that specifies the width and style of the widened stroke.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transformation.
     * @param {Float} flatness - The maximum error between the path and its flattened approximation.
     * @returns {Integer} Status code.
     */
    static WidenPath(path, pen, matrix, flatness) => DllCall("gdiplus\GdipWidenPath", "Ptr", path, "Ptr", pen, "Ptr", matrix, "Float", flatness)

    /**
     * Applies a warp transformation to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the warp.
     * @param {Integer} count - The number of points in the array.
     * @param {Float} srcx - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcy - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcwidth - The width of the source rectangle.
     * @param {Float} srcheight - The height of the source rectangle.
     * @param {Integer} warpMode - The warp mode.
     * @param {Float} flatness - The maximum error between the path and its flattened approximation.
     * @returns {Integer} Status code.
     */
    static WarpPath(path, matrix, points, count, srcx, srcy, srcwidth, srcheight, warpMode, flatness) => DllCall("gdiplus\GdipWarpPath", "Ptr", path, "Ptr", matrix, "Ptr", points, "Int", count, "Float", srcx, "Float", srcy, "Float", srcwidth, "Float", srcheight, "Int", warpMode, "Float", flatness)

    /**
     * Applies a transformation matrix to a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @returns {Integer} Status code.
     */
    static TransformPath(path, matrix) => DllCall("gdiplus\GdipTransformPath", "Ptr", path, "Ptr", matrix)

    /**
     * Gets the bounding rectangle for a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transformation.
     * @param {Pointer} pen - A pointer to a Pen object that specifies the width and style of the path.
     * @param {Pointer} bounds - A pointer to a RectF structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetPathWorldBounds(path, matrix, pen, bounds) => DllCall("gdiplus\GdipGetPathWorldBounds", "Ptr", path, "Ptr", bounds, "Ptr", matrix, "Ptr", pen)

    /**
     * Gets the bounding rectangle for a GraphicsPath object using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transformation.
     * @param {Pointer} pen - A pointer to a Pen object that specifies the width and style of the path.
     * @param {Pointer} bounds - A pointer to a Rect structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetPathWorldBoundsI(path, matrix, pen, bounds) => DllCall("gdiplus\GdipGetPathWorldBoundsI", "Ptr", path, "Ptr", bounds, "Ptr", matrix, "Ptr", pen)

    /**
     * Determines whether a point lies in the area that is filled when a GraphicsPath object is filled by a Graphics object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x - The x-coordinate of the point to test.
     * @param {Float} y - The y-coordinate of the point to test.
     * @param {Pointer} graphics - A pointer to a Graphics object that specifies the world and page transformations.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsVisiblePathPoint(path, x, y, graphics, result) => DllCall("gdiplus\GdipIsVisiblePathPoint", "Ptr", path, "Float", x, "Float", y, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether a point lies in the area that is filled when a GraphicsPath object is filled by a Graphics object, using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x - The x-coordinate of the point to test.
     * @param {Integer} y - The y-coordinate of the point to test.
     * @param {Pointer} graphics - A pointer to a Graphics object that specifies the world and page transformations.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsVisiblePathPointI(path, x, y, graphics, result) => DllCall("gdiplus\GdipIsVisiblePathPointI", "Ptr", path, "Int", x, "Int", y, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether a point lies on the outline of a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Float} x - The x-coordinate of the point to test.
     * @param {Float} y - The y-coordinate of the point to test.
     * @param {Pointer} pen - A pointer to a Pen object that specifies the width and style of the path's outline.
     * @param {Pointer} graphics - A pointer to a Graphics object that specifies the world and page transformations.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsOutlineVisiblePathPoint(path, x, y, pen, graphics, result) => DllCall("gdiplus\GdipIsOutlineVisiblePathPoint", "Ptr", path, "Float", x, "Float", y, "Ptr", pen, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether a point lies on the outline of a GraphicsPath object, using integer coordinates.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} x - The x-coordinate of the point to test.
     * @param {Integer} y - The y-coordinate of the point to test.
     * @param {Pointer} pen - A pointer to a Pen object that specifies the width and style of the path's outline.
     * @param {Pointer} graphics - A pointer to a Graphics object that specifies the world and page transformations.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsOutlineVisiblePathPointI(path, x, y, pen, graphics, result) => DllCall("gdiplus\GdipIsOutlineVisiblePathPointI", "Ptr", path, "Int", x, "Int", y, "Ptr", pen, "Ptr", graphics, "Ptr", result)

    /**
     * Creates a new PathIterator object and associates it with a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} iterator - A pointer to a variable that receives a pointer to the new PathIterator object.
     * @returns {Integer} Status code.
     */
    static CreatePathIter(iterator, path) => DllCall("gdiplus\GdipCreatePathIter", "Ptr*", iterator, "Ptr", path)

    /**
     * Deletes a PathIterator object.
     * @param {Pointer} iterator - A pointer to the PathIterator object to be deleted.
     * @returns {Integer} Status code.
     */
    static DeletePathIter(iterator) => DllCall("gdiplus\GdipDeletePathIter", "Ptr", iterator)

    /**
     * Uses a PathIterator object to move to the next subpath in a GraphicsPath object.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} resultCount - A pointer to a variable that receives the number of points in the subpath.
     * @param {Pointer} startIndex - A pointer to a variable that receives the index of the subpath's starting point.
     * @param {Pointer} endIndex - A pointer to a variable that receives the index of the subpath's ending point.
     * @param {Pointer} isClosed - A pointer to a variable that receives TRUE if the subpath is closed and FALSE otherwise.
     * @returns {Integer} Status code.
     */
    static PathIterNextSubpath(iterator, resultCount, startIndex, endIndex, isClosed) => DllCall("gdiplus\GdipPathIterNextSubpath", "Ptr", iterator, "Ptr", resultCount, "Ptr", startIndex, "Ptr", endIndex, "Ptr", isClosed)

    /**
     * Uses a PathIterator object to move to the next subpath in a GraphicsPath object and retrieves the subpath.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} resultCount - A pointer to a variable that receives the number of points in the subpath.
     * @param {Pointer} path - A pointer to a GraphicsPath object that receives the subpath.
     * @param {Pointer} isClosed - A pointer to a variable that receives TRUE if the subpath is closed and FALSE otherwise.
     * @returns {Integer} Status code.
     */
    static PathIterNextSubpathPath(iterator, resultCount, path, isClosed) => DllCall("gdiplus\GdipPathIterNextSubpathPath", "Ptr", iterator, "Ptr", resultCount, "Ptr", path, "Ptr", isClosed)

    /**
     * Uses a PathIterator object to move to the next group of data points of the same type in a GraphicsPath object.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} resultCount - A pointer to a variable that receives the number of points in the group.
     * @param {Pointer} pathType - A pointer to a variable that receives the type of the points in the group.
     * @param {Pointer} startIndex - A pointer to a variable that receives the index of the group's starting point.
     * @param {Pointer} endIndex - A pointer to a variable that receives the index of the group's ending point.
     * @returns {Integer} Status code.
     */
    static PathIterNextPathType(iterator, resultCount, pathType, startIndex, endIndex) => DllCall("gdiplus\GdipPathIterNextPathType", "Ptr", iterator, "Ptr", resultCount, "Ptr", pathType, "Ptr", startIndex, "Ptr", endIndex)

    /**
     * Uses a PathIterator object to move to the next marker-delimited section in a GraphicsPath object.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} resultCount - A pointer to a variable that receives the number of points in the marker-delimited section.
     * @param {Pointer} startIndex - A pointer to a variable that receives the index of the section's starting point.
     * @param {Pointer} endIndex - A pointer to a variable that receives the index of the section's ending point.
     * @returns {Integer} Status code.
     */
    static PathIterNextMarker(iterator, resultCount, startIndex, endIndex) => DllCall("gdiplus\GdipPathIterNextMarker", "Ptr", iterator, "Ptr", resultCount, "Ptr", startIndex, "Ptr", endIndex)

    /**
     * Uses a PathIterator object to move to the next marker-delimited section in a GraphicsPath object and retrieves the section.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} resultCount - A pointer to a variable that receives the number of points in the marker-delimited section.
     * @param {Pointer} path - A pointer to a GraphicsPath object that receives the marker-delimited section.
     * @returns {Integer} Status code.
     */
    static PathIterNextMarkerPath(iterator, resultCount, path) => DllCall("gdiplus\GdipPathIterNextMarkerPath", "Ptr", iterator, "Ptr", resultCount, "Ptr", path)

    /**
     * Gets the number of data points in a GraphicsPath object.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} count - A pointer to a variable that receives the number of data points.
     * @returns {Integer} Status code.
     */
    static PathIterGetCount(iterator, count) => DllCall("gdiplus\GdipPathIterGetCount", "Ptr", iterator, "Ptr", count)

    /**
     * Gets the number of subpaths in a GraphicsPath object.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} count - A pointer to a variable that receives the number of subpaths.
     * @returns {Integer} Status code.
     */
    static PathIterGetSubpathCount(iterator, count) => DllCall("gdiplus\GdipPathIterGetSubpathCount", "Ptr", iterator, "Ptr", count)

    /**
     * Determines whether a PathIterator object is valid.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} valid - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static PathIterIsValid(iterator, valid) => DllCall("gdiplus\GdipPathIterIsValid", "Ptr", iterator, "Ptr", valid)

    /**
     * Determines whether a GraphicsPath object contains any curves.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} hasCurve - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static PathIterHasCurve(iterator, hasCurve) => DllCall("gdiplus\GdipPathIterHasCurve", "Ptr", iterator, "Ptr", hasCurve)

    /**
     * Resets a PathIterator object so that it points to the first point in the GraphicsPath object.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @returns {Integer} Status code.
     */
    static PathIterRewind(iterator) => DllCall("gdiplus\GdipPathIterRewind", "Ptr", iterator)

    /**
     * Enumerates the data points in a GraphicsPath object.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} resultCount - A pointer to a variable that receives the number of data points enumerated.
     * @param {Pointer} points - A pointer to an array that receives the data points.
     * @param {Pointer} types - A pointer to an array that receives the point types.
     * @param {Integer} count - The size of the points and types arrays.
     * @returns {Integer} Status code.
     */
    static PathIterEnumerate(iterator, resultCount, points, types, count) => DllCall("gdiplus\GdipPathIterEnumerate", "Ptr", iterator, "Ptr", resultCount, "Ptr", points, "Ptr", types, "Int", count)

    /**
     * Copies the data points from a GraphicsPath object to arrays.
     * @param {Pointer} iterator - A pointer to the PathIterator object.
     * @param {Pointer} resultCount - A pointer to a variable that receives the number of data points copied.
     * @param {Pointer} points - A pointer to an array that receives the data points.
     * @param {Pointer} types - A pointer to an array that receives the point types.
     * @param {Integer} startIndex - The index of the first point to be copied.
     * @param {Integer} endIndex - The index of the last point to be copied.
     * @returns {Integer} Status code.
     */
    static PathIterCopyData(iterator, resultCount, points, types, startIndex, endIndex) => DllCall("gdiplus\GdipPathIterCopyData", "Ptr", iterator, "Ptr", resultCount, "Ptr", points, "Ptr", types, "Int", startIndex, "Int", endIndex)

    /**
     * Creates a new Matrix object and initializes it to the identity matrix.
     * @param {Pointer} matrix - A pointer to a variable that receives a pointer to the new Matrix object.
     * @returns {Integer} Status code.
     */
    static CreateMatrix(matrix) => DllCall("gdiplus\GdipCreateMatrix", "Ptr*", matrix)

    /**
     * Creates a new Matrix object based on six numbers that define an affine transformation.
     * @param {Float} m11 - The element in the first row and first column.
     * @param {Float} m12 - The element in the first row and second column.
     * @param {Float} m21 - The element in the second row and first column.
     * @param {Float} m22 - The element in the second row and second column.
     * @param {Float} dx - The element in the third row and first column.
     * @param {Float} dy - The element in the third row and second column.
     * @param {Pointer} matrix - A pointer to a variable that receives a pointer to the new Matrix object.
     * @returns {Integer} Status code.
     */
    static CreateMatrix2(m11, m12, m21, m22, dx, dy, matrix) => DllCall("gdiplus\GdipCreateMatrix2", "Float", m11, "Float", m12, "Float", m21, "Float", m22, "Float", dx, "Float", dy, "Ptr*", matrix)

    /**
     * Creates a new Matrix object based on a rectangle and a point array.
     * @param {Pointer} rect - A pointer to a RectF structure that specifies the rectangle.
     * @param {Pointer} dstplg - A pointer to an array of three PointF structures that specify the destination parallelogram.
     * @param {Pointer} matrix - A pointer to a variable that receives a pointer to the new Matrix object.
     * @returns {Integer} Status code.
     */
    static CreateMatrix3(rect, dstplg, matrix) => DllCall("gdiplus\GdipCreateMatrix3", "Ptr", rect, "Ptr", dstplg, "Ptr*", matrix)

    /**
     * Creates a new Matrix object based on a rectangle and a point array using integer coordinates.
     * @param {Pointer} rect - A pointer to a Rect structure that specifies the rectangle.
     * @param {Pointer} dstplg - A pointer to an array of three Point structures that specify the destination parallelogram.
     * @param {Pointer} matrix - A pointer to a variable that receives a pointer to the new Matrix object.
     * @returns {Integer} Status code.
     */
    static CreateMatrix3I(rect, dstplg, matrix) => DllCall("gdiplus\GdipCreateMatrix3I", "Ptr", rect, "Ptr", dstplg, "Ptr*", matrix)

    /**
     * Creates a new Matrix object and initializes it with the same elements as another Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object to be cloned.
     * @param {Pointer} cloneMatrix - A pointer to a variable that receives a pointer to the new Matrix object.
     * @returns {Integer} Status code.
     */
    static CloneMatrix(matrix, cloneMatrix) => DllCall("gdiplus\GdipCloneMatrix", "Ptr", matrix, "Ptr*", cloneMatrix)

    /**
     * Deletes a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object to be deleted.
     * @returns {Integer} Status code.
     */
    static DeleteMatrix(matrix) => DllCall("gdiplus\GdipDeleteMatrix", "Ptr", matrix)

    /**
     * Sets the elements of a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Float} m11 - The element in the first row and first column.
     * @param {Float} m12 - The element in the first row and second column.
     * @param {Float} m21 - The element in the second row and first column.
     * @param {Float} m22 - The element in the second row and second column.
     * @param {Float} dx - The element in the third row and first column.
     * @param {Float} dy - The element in the third row and second column.
     * @returns {Integer} Status code.
     */
    static SetMatrixElements(matrix, m11, m12, m21, m22, dx, dy) => DllCall("gdiplus\GdipSetMatrixElements", "Ptr", matrix, "Float", m11, "Float", m12, "Float", m21, "Float", m22, "Float", dx, "Float", dy)

    /**
     * Multiplies a Matrix object by another Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object to be multiplied.
     * @param {Pointer} matrix2 - A pointer to the Matrix object to multiply by.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static MultiplyMatrix(matrix, matrix2, order) => DllCall("gdiplus\GdipMultiplyMatrix", "Ptr", matrix, "Ptr", matrix2, "Int", order)

    /**
     * Applies a translation to a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Float} offsetX - The horizontal translation.
     * @param {Float} offsetY - The vertical translation.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static TranslateMatrix(matrix, offsetX, offsetY, order) => DllCall("gdiplus\GdipTranslateMatrix", "Ptr", matrix, "Float", offsetX, "Float", offsetY, "Int", order)

    /**
     * Applies a scaling transformation to a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Float} scaleX - The horizontal scaling factor.
     * @param {Float} scaleY - The vertical scaling factor.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static ScaleMatrix(matrix, scaleX, scaleY, order) => DllCall("gdiplus\GdipScaleMatrix", "Ptr", matrix, "Float", scaleX, "Float", scaleY, "Int", order)

    /**
     * Applies a rotation transformation to a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Float} angle - The angle of rotation in degrees.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static RotateMatrix(matrix, angle, order) => DllCall("gdiplus\GdipRotateMatrix", "Ptr", matrix, "Float", angle, "Int", order)

    /**
     * Applies a shearing transformation to a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Float} shearX - The horizontal shear factor.
     * @param {Float} shearY - The vertical shear factor.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static ShearMatrix(matrix, shearX, shearY, order) => DllCall("gdiplus\GdipShearMatrix", "Ptr", matrix, "Float", shearX, "Float", shearY, "Int", order)

    /**
     * Inverts a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @returns {Integer} Status code.
     */
    static InvertMatrix(matrix) => DllCall("gdiplus\GdipInvertMatrix", "Ptr", matrix)

    /**
     * Applies a Matrix object to an array of points.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Pointer} pts - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static TransformMatrixPoints(matrix, pts, count) => DllCall("gdiplus\GdipTransformMatrixPoints", "Ptr", matrix, "Ptr", pts, "Int", count)

    /**
     * Applies a Matrix object to an array of points using integer coordinates.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Pointer} pts - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static TransformMatrixPointsI(matrix, pts, count) => DllCall("gdiplus\GdipTransformMatrixPointsI", "Ptr", matrix, "Ptr", pts, "Int", count)

    /**
     * Applies the vector transformation of a matrix to an array of points.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Pointer} pts - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static VectorTransformMatrixPoints(matrix, pts, count) => DllCall("gdiplus\GdipVectorTransformMatrixPoints", "Ptr", matrix, "Ptr", pts, "Int", count)

    /**
     * Applies the vector transformation of a matrix to an array of points using integer coordinates.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Pointer} pts - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static VectorTransformMatrixPointsI(matrix, pts, count) => DllCall("gdiplus\GdipVectorTransformMatrixPointsI", "Ptr", matrix, "Ptr", pts, "Int", count)

    /**
     * Gets the elements of a Matrix object.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Pointer} matrixOut - A pointer to an array that receives the matrix elements.
     * @returns {Integer} Status code.
     */
    static GetMatrixElements(matrix, matrixOut) => DllCall("gdiplus\GdipGetMatrixElements", "Ptr", matrix, "Ptr", matrixOut)

    /**
     * Determines whether a Matrix object is invertible.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsMatrixInvertible(matrix, result) => DllCall("gdiplus\GdipIsMatrixInvertible", "Ptr", matrix, "Ptr", result)

    /**
     * Determines whether a Matrix object is the identity matrix.
     * @param {Pointer} matrix - A pointer to the Matrix object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsMatrixIdentity(matrix, result) => DllCall("gdiplus\GdipIsMatrixIdentity", "Ptr", matrix, "Ptr", result)

    /**
     * Determines whether two Matrix objects are equal.
     * @param {Pointer} matrix - A pointer to the first Matrix object.
     * @param {Pointer} matrix2 - A pointer to the second Matrix object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the comparison.
     * @returns {Integer} Status code.
     */
    static IsMatrixEqual(matrix, matrix2, result) => DllCall("gdiplus\GdipIsMatrixEqual", "Ptr", matrix, "Ptr", matrix2, "Ptr", result)

    /**
     * Creates a Region object.
     * @param {Pointer} region - A pointer to a variable that receives a pointer to the new Region object.
     * @returns {Integer} Status code.
     */
    static CreateRegion(region) => DllCall("gdiplus\GdipCreateRegion", "Ptr*", region)

    /**
     * Creates a Region object from a rectangle.
     * @param {Pointer} rect - A pointer to a RectF structure that specifies the rectangle.
     * @param {Pointer} region - A pointer to a variable that receives a pointer to the new Region object.
     * @returns {Integer} Status code.
     */
    static CreateRegionRect(rect, region) => DllCall("gdiplus\GdipCreateRegionRect", "Ptr", rect, "Ptr*", region)

    /**
     * Creates a Region object from a rectangle using integer coordinates.
     * @param {Pointer} rect - A pointer to a Rect structure that specifies the rectangle.
     * @param {Pointer} region - A pointer to a variable that receives a pointer to the new Region object.
     * @returns {Integer} Status code.
     */
    static CreateRegionRectI(rect, region) => DllCall("gdiplus\GdipCreateRegionRectI", "Ptr", rect, "Ptr*", region)

    /**
     * Creates a Region object from a GraphicsPath object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Pointer} region - A pointer to a variable that receives a pointer to the new Region object.
     * @returns {Integer} Status code.
     */
    static CreateRegionPath(path, region) => DllCall("gdiplus\GdipCreateRegionPath", "Ptr", path, "Ptr*", region)

    /**
     * Creates a Region object from a byte array.
     * @param {Pointer} regionData - A pointer to a byte array that contains the region data.
     * @param {Integer} size - The size of the byte array.
     * @param {Pointer} region - A pointer to a variable that receives a pointer to the new Region object.
     * @returns {Integer} Status code.
     */
    static CreateRegionRgnData(regionData, size, region) => DllCall("gdiplus\GdipCreateRegionRgnData", "Ptr", regionData, "Int", size, "Ptr*", region)

    /**
     * Creates a Region object from a Windows handle to a region.
     * @param {Pointer} hRgn - A handle to a Windows region.
     * @param {Pointer} region - A pointer to a variable that receives a pointer to the new Region object.
     * @returns {Integer} Status code.
     */
    static CreateRegionHrgn(hRgn, region) => DllCall("gdiplus\GdipCreateRegionHrgn", "Ptr", hRgn, "Ptr*", region)

    /**
     * Creates a new Region object and initializes it with the same data as another Region object.
     * @param {Pointer} region - A pointer to the Region object to be cloned.
     * @param {Pointer} cloneRegion - A pointer to a variable that receives a pointer to the new Region object.
     * @returns {Integer} Status code.
     */
    static CloneRegion(region, cloneRegion) => DllCall("gdiplus\GdipCloneRegion", "Ptr", region, "Ptr*", cloneRegion)

    /**
     * Deletes a Region object.
     * @param {Pointer} region - A pointer to the Region object to be deleted.
     * @returns {Integer} Status code.
     */
    static DeleteRegion(region) => DllCall("gdiplus\GdipDeleteRegion", "Ptr", region)

    /**
     * Sets a Region object to an infinite interior.
     * @param {Pointer} region - A pointer to the Region object.
     * @returns {Integer} Status code.
     */
    static SetInfinite(region) => DllCall("gdiplus\GdipSetInfinite", "Ptr", region)

    /**
     * Sets a Region object to an empty interior.
     * @param {Pointer} region - A pointer to the Region object.
     * @returns {Integer} Status code.
     */
    static SetEmpty(region) => DllCall("gdiplus\GdipSetEmpty", "Ptr", region)

    /**
     * Updates a Region object by combining it with a rectangle.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} rect - A pointer to a RectF structure that specifies the rectangle.
     * @param {Integer} combineMode - The combine mode to use.
     * @returns {Integer} Status code.
     */
    static CombineRegionRect(region, rect, combineMode) => DllCall("gdiplus\GdipCombineRegionRect", "Ptr", region, "Ptr", rect, "Int", combineMode)

    /**
     * Updates a Region object by combining it with a rectangle using integer coordinates.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} rect - A pointer to a Rect structure that specifies the rectangle.
     * @param {Integer} combineMode - The combine mode to use.
     * @returns {Integer} Status code.
     */
    static CombineRegionRectI(region, rect, combineMode) => DllCall("gdiplus\GdipCombineRegionRectI", "Ptr", region, "Ptr", rect, "Int", combineMode)

    /**
     * Updates a Region object by combining it with a GraphicsPath object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} path - A pointer to the GraphicsPath object.
     * @param {Integer} combineMode - The combine mode to use.
     * @returns {Integer} Status code.
     */
    static CombineRegionPath(region, path, combineMode) => DllCall("gdiplus\GdipCombineRegionPath", "Ptr", region, "Ptr", path, "Int", combineMode)

    /**
     * Updates a Region object by combining it with another Region object.
     * @param {Pointer} region - A pointer to the Region object to be updated.
     * @param {Pointer} region2 - A pointer to the Region object to combine with.
     * @param {Integer} combineMode - The combine mode to use.
     * @returns {Integer} Status code.
     */
    static CombineRegionRegion(region, region2, combineMode) => DllCall("gdiplus\GdipCombineRegionRegion", "Ptr", region, "Ptr", region2, "Int", combineMode)

    /**
     * Translates a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Float} dx - The horizontal translation.
     * @param {Float} dy - The vertical translation.
     * @returns {Integer} Status code.
     */
    static TranslateRegion(region, dx, dy) => DllCall("gdiplus\GdipTranslateRegion", "Ptr", region, "Float", dx, "Float", dy)

    /**
     * Translates a Region object using integer coordinates.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Integer} dx - The horizontal translation.
     * @param {Integer} dy - The vertical translation.
     * @returns {Integer} Status code.
     */
    static TranslateRegionI(region, dx, dy) => DllCall("gdiplus\GdipTranslateRegionI", "Ptr", region, "Int", dx, "Int", dy)

    /**
     * Transforms a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @returns {Integer} Status code.
     */
    static TransformRegion(region, matrix) => DllCall("gdiplus\GdipTransformRegion", "Ptr", region, "Ptr", matrix)

    /**
     * Gets the bounding rectangle of a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} rect - A pointer to a RectF structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetRegionBounds(region, graphics, rect) => DllCall("gdiplus\GdipGetRegionBounds", "Ptr", region, "Ptr", graphics, "Ptr", rect)

    /**
     * Gets the bounding rectangle of a Region object using integer coordinates.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} rect - A pointer to a Rect structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetRegionBoundsI(region, graphics, rect) => DllCall("gdiplus\GdipGetRegionBoundsI", "Ptr", region, "Ptr", graphics, "Ptr", rect)

    /**
     * Gets a Windows handle to a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} hRgn - A pointer to a variable that receives the handle.
     * @returns {Integer} Status code.
     */
    static GetRegionHRgn(region, graphics, hRgn) => DllCall("gdiplus\GdipGetRegionHRgn", "Ptr", region, "Ptr", graphics, "Ptr*", hRgn)

    /**
     * Determines whether a Region object has an empty interior.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsEmptyRegion(region, graphics, result) => DllCall("gdiplus\GdipIsEmptyRegion", "Ptr", region, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether a Region object has an infinite interior.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsInfiniteRegion(region, graphics, result) => DllCall("gdiplus\GdipIsInfiniteRegion", "Ptr", region, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether two Region objects are equal.
     * @param {Pointer} region - A pointer to the first Region object.
     * @param {Pointer} region2 - A pointer to the second Region object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the comparison.
     * @returns {Integer} Status code.
     */
    static IsEqualRegion(region, region2, graphics, result) => DllCall("gdiplus\GdipIsEqualRegion", "Ptr", region, "Ptr", region2, "Ptr", graphics, "Ptr", result)

    /**
     * Gets the size of the buffer needed to store the data for a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} bufferSize - A pointer to a variable that receives the buffer size.
     * @returns {Integer} Status code.
     */
    static GetRegionDataSize(region, bufferSize) => DllCall("gdiplus\GdipGetRegionDataSize", "Ptr", region, "Ptr", bufferSize)

    /**
     * Gets the data for a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} buffer - A pointer to a buffer that receives the region data.
     * @param {Integer} bufferSize - The size of the buffer.
     * @param {Pointer} sizeFilled - A pointer to a variable that receives the number of bytes written to the buffer.
     * @returns {Integer} Status code.
     */
    static GetRegionData(region, buffer, bufferSize, sizeFilled) => DllCall("gdiplus\GdipGetRegionData", "Ptr", region, "Ptr", buffer, "UInt", bufferSize, "Ptr", sizeFilled)

    /**
     * Determines whether a point is inside a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Float} x - The x-coordinate of the point.
     * @param {Float} y - The y-coordinate of the point.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsVisibleRegionPoint(region, x, y, graphics, result) => DllCall("gdiplus\GdipIsVisibleRegionPoint", "Ptr", region, "Float", x, "Float", y, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether a point is inside a Region object using integer coordinates.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Integer} x - The x-coordinate of the point.
     * @param {Integer} y - The y-coordinate of the point.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsVisibleRegionPointI(region, x, y, graphics, result) => DllCall("gdiplus\GdipIsVisibleRegionPointI", "Ptr", region, "Int", x, "Int", y, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether a rectangle intersects with a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Float} width - The width of the rectangle.
     * @param {Float} height - The height of the rectangle.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsVisibleRegionRect(region, x, y, width, height, graphics, result) => DllCall("gdiplus\GdipIsVisibleRegionRect", "Ptr", region, "Float", x, "Float", y, "Float", width, "Float", height, "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether a rectangle intersects with a Region object using integer coordinates.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} width - The width of the rectangle.
     * @param {Integer} height - The height of the rectangle.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} result - A pointer to a variable that receives the result of the test.
     * @returns {Integer} Status code.
     */
    static IsVisibleRegionRectI(region, x, y, width, height, graphics, result) => DllCall("gdiplus\GdipIsVisibleRegionRectI", "Ptr", region, "Int", x, "Int", y, "Int", width, "Int", height, "Ptr", graphics, "Ptr", result)

    /**
     * Gets the number of rectangles that approximate a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transformation.
     * @param {Pointer} count - A pointer to a variable that receives the number of rectangles.
     * @returns {Integer} Status code.
     */
    static GetRegionScansCount(region, count, matrix) => DllCall("gdiplus\GdipGetRegionScansCount", "Ptr", region, "Ptr", count, "Ptr", matrix)

    /**
     * Gets an array of rectangles that approximate a Region object.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} rects - A pointer to an array of RectF structures that receives the rectangles.
     * @param {Pointer} count - A pointer to a variable that specifies the size of the array and receives the number of rectangles.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transformation.
     * @returns {Integer} Status code.
     */
    static GetRegionScans(region, rects, count, matrix) => DllCall("gdiplus\GdipGetRegionScans", "Ptr", region, "Ptr", rects, "Ptr", count, "Ptr", matrix)

    /**
     * Gets an array of rectangles that approximate a Region object using integer coordinates.
     * @param {Pointer} region - A pointer to the Region object.
     * @param {Pointer} rects - A pointer to an array of Rect structures that receives the rectangles.
     * @param {Pointer} count - A pointer to a variable that specifies the size of the array and receives the number of rectangles.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transformation.
     * @returns {Integer} Status code.
     */
    static GetRegionScansI(region, rects, count, matrix) => DllCall("gdiplus\GdipGetRegionScansI", "Ptr", region, "Ptr", rects, "Ptr", count, "Ptr", matrix)

    /**
     * Creates a new ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to a variable that receives a pointer to the new ImageAttributes object.
     * @returns {Integer} Status code.
     */
    static CreateImageAttributes(imageattr) => DllCall("gdiplus\GdipCreateImageAttributes", "Ptr*", imageattr)

    /**
     * Creates a new ImageAttributes object and initializes it with the same data as another ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object to be cloned.
     * @param {Pointer} cloneImageattr - A pointer to a variable that receives a pointer to the new ImageAttributes object.
     * @returns {Integer} Status code.
     */
    static CloneImageAttributes(imageattr, cloneImageattr) => DllCall("gdiplus\GdipCloneImageAttributes", "Ptr", imageattr, "Ptr*", cloneImageattr)

    /**
     * Deletes an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object to be deleted.
     * @returns {Integer} Status code.
     */
    static DisposeImageAttributes(imageattr) => DllCall("gdiplus\GdipDisposeImageAttributes", "Ptr", imageattr)

    /**
     * Sets the color-adjustment matrix of an ImageAttributes object to identity.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of color adjustment.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesToIdentity(imageattr, type) => DllCall("gdiplus\GdipSetImageAttributesToIdentity", "Ptr", imageattr, "Int", type)

    /**
     * Clears all color-adjustment settings for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of color adjustment.
     * @returns {Integer} Status code.
     */
    static ResetImageAttributes(imageattr, type) => DllCall("gdiplus\GdipResetImageAttributes", "Ptr", imageattr, "Int", type)

    /**
     * Sets the color-adjustment matrix of an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of color adjustment.
     * @param {Integer} enableFlag - Specifies whether to use the color-adjustment matrix.
     * @param {Pointer} colorMatrix - A pointer to a ColorMatrix structure.
     * @param {Pointer} grayMatrix - A pointer to a ColorMatrix structure for grayscale adjustment.
     * @param {Integer} flags - Specifies the color-adjustment mode.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesColorMatrix(imageattr, type, enableFlag, colorMatrix, grayMatrix, flags) => DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "Ptr", imageattr, "Int", type, "Int", enableFlag, "Ptr", colorMatrix, "Ptr", grayMatrix, "Int", flags)

    /**
     * Sets the threshold value of an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of threshold adjustment.
     * @param {Integer} enableFlag - Specifies whether to use the threshold.
     * @param {Float} threshold - The threshold value.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesThreshold(imageattr, type, enableFlag, threshold) => DllCall("gdiplus\GdipSetImageAttributesThreshold", "Ptr", imageattr, "Int", type, "Int", enableFlag, "Float", threshold)

    /**
     * Sets the gamma value of an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of gamma adjustment.
     * @param {Integer} enableFlag - Specifies whether to use the gamma value.
     * @param {Float} gamma - The gamma value.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesGamma(imageattr, type, enableFlag, gamma) => DllCall("gdiplus\GdipSetImageAttributesGamma", "Ptr", imageattr, "Int", type, "Int", enableFlag, "Float", gamma)

    /**
     * Disables color adjustment for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of color adjustment to disable.
     * @param {Integer} enableFlag - Specifies whether to disable the color adjustment.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesNoOp(imageattr, type, enableFlag) => DllCall("gdiplus\GdipSetImageAttributesNoOp", "Ptr", imageattr, "Int", type, "Int", enableFlag)

    /**
     * Sets the color keys for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of color key.
     * @param {Integer} enableFlag - Specifies whether to use the color keys.
     * @param {Integer} colorLow - The low color key.
     * @param {Integer} colorHigh - The high color key.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesColorKeys(imageattr, type, enableFlag, colorLow, colorHigh) => DllCall("gdiplus\GdipSetImageAttributesColorKeys", "Ptr", imageattr, "Int", type, "Int", enableFlag, "UInt", colorLow, "UInt", colorHigh)

    /**
     * Sets the output channel for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of output channel adjustment.
     * @param {Integer} enableFlag - Specifies whether to use the output channel.
     * @param {Integer} channelFlags - Specifies which channels to use.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesOutputChannel(imageattr, type, enableFlag, channelFlags) => DllCall("gdiplus\GdipSetImageAttributesOutputChannel", "Ptr", imageattr, "Int", type, "Int", enableFlag, "Int", channelFlags)

    /**
     * Sets the output channel color profile for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of color profile adjustment.
     * @param {Integer} enableFlag - Specifies whether to use the color profile.
     * @param {Pointer} colorProfileFilename - A pointer to a null-terminated string that specifies the color profile filename.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesOutputChannelColorProfile(imageattr, type, enableFlag, colorProfileFilename) => DllCall("gdiplus\GdipSetImageAttributesOutputChannelColorProfile", "Ptr", imageattr, "Int", type, "Int", enableFlag, "Ptr", colorProfileFilename)

    /**
     * Sets the color-remap table for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} type - The type of remap adjustment.
     * @param {Integer} enableFlag - Specifies whether to use the remap table.
     * @param {Integer} mapSize - The number of entries in the remap table.
     * @param {Pointer} map - A pointer to an array of ColorMap structures.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesRemapTable(imageattr, type, enableFlag, mapSize, map) => DllCall("gdiplus\GdipSetImageAttributesRemapTable", "Ptr", imageattr, "Int", type, "Int", enableFlag, "UInt", mapSize, "Ptr", map)

    /**
     * Sets the wrap mode for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} wrap - The wrap mode.
     * @param {Integer} argb - The color to use for the wrap mode.
     * @param {Integer} clamp - Specifies whether to use color clamping.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesWrapMode(imageattr, wrap, argb, clamp) => DllCall("gdiplus\GdipSetImageAttributesWrapMode", "Ptr", imageattr, "Int", wrap, "UInt", argb, "Int", clamp)

    /**
     * Enables or disables color management for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Integer} on - Specifies whether to enable or disable color management.
     * @returns {Integer} Status code.
     */
    static SetImageAttributesICMMode(imageattr, on) => DllCall("gdiplus\GdipSetImageAttributesICMMode", "Ptr", imageattr, "Int", on)

    /**
     * Gets an adjusted palette for an ImageAttributes object.
     * @param {Pointer} imageattr - A pointer to the ImageAttributes object.
     * @param {Pointer} colorPalette - A pointer to a ColorPalette structure that receives the adjusted palette.
     * @param {Integer} colorAdjustType - The type of color adjustment.
     * @returns {Integer} Status code.
     */
    static GetImageAttributesAdjustedPalette(imageattr, colorPalette, colorAdjustType) => DllCall("gdiplus\GdipGetImageAttributesAdjustedPalette", "Ptr", imageattr, "Ptr", colorPalette, "Int", colorAdjustType)

    /**
     * Creates a Bitmap object from an IStream interface.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromStream(stream, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromStream", "Ptr", stream, "Ptr*", bitmap)

    /**
     * Creates a Bitmap object from a file.
     * @param {Pointer} filename - A pointer to a null-terminated string that specifies the name of the file.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromFile(filename, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", filename, "Ptr*", bitmap)

    /**
     * Creates a Bitmap object from a block of pixel data.
     * @param {Integer} width - The width, in pixels, of the bitmap.
     * @param {Integer} height - The height, in pixels, of the bitmap.
     * @param {Integer} stride - The stride (bytes per row) of the bitmap.
     * @param {Integer} format - The pixel format of the bitmap.
     * @param {Pointer} scan0 - A pointer to the pixel data.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromScan0(width, height, stride, format, scan0, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", width, "Int", height, "Int", stride, "Int", format, "Ptr", scan0, "Ptr*", bitmap)

    /**
     * Creates a Bitmap object from a Graphics object.
     * @param {Integer} width - The width, in pixels, of the bitmap.
     * @param {Integer} height - The height, in pixels, of the bitmap.
     * @param {Pointer} target - A pointer to a Graphics object.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromGraphics(width, height, target, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromGraphics", "Int", width, "Int", height, "Ptr", target, "Ptr*", bitmap)

    /**
     * Creates a Bitmap object from a DirectDraw surface.
     * @param {Pointer} surface - A pointer to an IDirectDrawSurface7 interface.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromDirectDrawSurface(surface, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromDirectDrawSurface", "Ptr", surface, "Ptr*", bitmap)

    /**
     * Creates a Bitmap object from a GDI device-independent bitmap (DIB).
     * @param {Pointer} gdiBitmapInfo - A pointer to a BITMAPINFO structure that describes the DIB.
     * @param {Pointer} gdiBitmapData - A pointer to the pixel data.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromGdiDib(gdiBitmapInfo, gdiBitmapData, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromGdiDib", "Ptr", gdiBitmapInfo, "Ptr", gdiBitmapData, "Ptr*", bitmap)

    /**
     * Creates a Bitmap object from a Windows handle to a bitmap (HBITMAP).
     * @param {Integer} hbm - A handle to a bitmap.
     * @param {Integer} hpal - A handle to a palette. Can be 0.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromHBITMAP(hbm, hpal, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hbm, "Ptr", hpal, "Ptr*", bitmap)

    /**
     * Creates a Windows handle to a bitmap (HBITMAP) from a Bitmap object.
     * @param {Pointer} bitmap - A pointer to the Bitmap object.
     * @param {Integer} hbmColor - A handle to a color palette. Can be 0.
     * @param {Pointer} hbmReturn - A pointer to a variable that receives the handle of the new bitmap.
     * @returns {Integer} Status code.
     */
    static CreateHBITMAPFromBitmap(bitmap, hbmColor, hbmReturn) => DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "Ptr", bitmap, "Ptr*", hbmReturn, "UInt", hbmColor)

    /**
     * Creates a Bitmap object from a Windows handle to an icon (HICON).
     * @param {Integer} hicon - A handle to an icon.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromHICON(hicon, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromHICON", "Ptr", hicon, "Ptr*", bitmap)

    /**
     * Creates a Windows handle to an icon (HICON) from a Bitmap object.
     * @param {Pointer} bitmap - A pointer to the Bitmap object.
     * @param {Pointer} hbmColor - A pointer to a variable that receives the handle of the new icon.
     * @returns {Integer} Status code.
     */
    static CreateHICONFromBitmap(bitmap, hbmColor) => DllCall("gdiplus\GdipCreateHICONFromBitmap", "Ptr", bitmap, "Ptr*", hbmColor)

    /**
     * Creates a Bitmap object from a resource in a module.
     * @param {Integer} hInstance - A handle to the module that contains the resource.
     * @param {String} lpBitmapName - The name of the resource.
     * @param {Pointer} bitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CreateBitmapFromResource(hInstance, lpBitmapName, bitmap) => DllCall("gdiplus\GdipCreateBitmapFromResource", "Ptr", hInstance, "Str", lpBitmapName, "Ptr*", bitmap)

    /**
     * Creates a new Bitmap object from a specified region of another Bitmap object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} width - The width of the source rectangle.
     * @param {Float} height - The height of the source rectangle.
     * @param {Integer} format - The pixel format of the new Bitmap object.
     * @param {Pointer} srcBitmap - A pointer to the source Bitmap object.
     * @param {Pointer} dstBitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CloneBitmapArea(x, y, width, height, format, srcBitmap, dstBitmap) => DllCall("gdiplus\GdipCloneBitmapArea", "Float", x, "Float", y, "Float", width, "Float", height, "Int", format, "Ptr", srcBitmap, "Ptr*", dstBitmap)

    /**
     * Creates a new Bitmap object from a specified region of another Bitmap object using integer coordinates.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} width - The width of the source rectangle.
     * @param {Integer} height - The height of the source rectangle.
     * @param {Integer} format - The pixel format of the new Bitmap object.
     * @param {Pointer} srcBitmap - A pointer to the source Bitmap object.
     * @param {Pointer} dstBitmap - A pointer to a variable that receives a pointer to the new Bitmap object.
     * @returns {Integer} Status code.
     */
    static CloneBitmapAreaI(x, y, width, height, format, srcBitmap, dstBitmap) => DllCall("gdiplus\GdipCloneBitmapAreaI", "Int", x, "Int", y, "Int", width, "Int", height, "Int", format, "Ptr", srcBitmap, "Ptr*", dstBitmap)

    /**
     * Locks a rectangular portion of a Bitmap object for reading or writing.
     * @param {Pointer} bitmap - A pointer to the Bitmap object.
     * @param {Pointer} rect - A pointer to a RECT structure that specifies the rectangle to lock.
     * @param {Integer} flags - A combination of ImageLockMode flags that specify the access mode.
     * @param {Integer} pixelFormat - The pixel format of the bitmap data.
     * @param {Pointer} lockedBitmapData - A pointer to a BitmapData structure that receives information about the locked region.
     * @returns {Integer} Status code.
     */
    static BitmapLockBits(bitmap, rect, flags, pixelFormat, lockedBitmapData) => DllCall("gdiplus\GdipBitmapLockBits", "Ptr", bitmap, "Ptr", rect, "UInt", flags, "Int", pixelFormat, "Ptr", lockedBitmapData)

    /**
     * Unlocks a portion of a Bitmap object that was previously locked.
     * @param {Pointer} bitmap - A pointer to the Bitmap object.
     * @param {Pointer} lockedBitmapData - A pointer to a BitmapData structure that contains information about the locked region.
     * @returns {Integer} Status code.
     */
    static BitmapUnlockBits(bitmap, lockedBitmapData) => DllCall("gdiplus\GdipBitmapUnlockBits", "Ptr", bitmap, "Ptr", lockedBitmapData)

    /**
     * Gets the color of a specified pixel in a Bitmap object.
     * @param {Pointer} bitmap - A pointer to the Bitmap object.
     * @param {Integer} x - The x-coordinate of the pixel.
     * @param {Integer} y - The y-coordinate of the pixel.
     * @param {Pointer} color - A pointer to a variable that receives the color of the pixel.
     * @returns {Integer} Status code.
     */
    static BitmapGetPixel(bitmap, x, y, color) => DllCall("gdiplus\GdipBitmapGetPixel", "Ptr", bitmap, "Int", x, "Int", y, "Ptr*", color)

    /**
     * Sets the color of a specified pixel in a Bitmap object.
     * @param {Pointer} bitmap - A pointer to the Bitmap object.
     * @param {Integer} x - The x-coordinate of the pixel.
     * @param {Integer} y - The y-coordinate of the pixel.
     * @param {Integer} color - The color to set.
     * @returns {Integer} Status code.
     */
    static BitmapSetPixel(bitmap, x, y, color) => DllCall("gdiplus\GdipBitmapSetPixel", "Ptr", bitmap, "Int", x, "Int", y, "UInt", color)

    /**
     * Sets the resolution of a Bitmap object.
     * @param {Pointer} bitmap - A pointer to the Bitmap object.
     * @param {Float} xdpi - The horizontal resolution in dots per inch.
     * @param {Float} ydpi - The vertical resolution in dots per inch.
     * @returns {Integer} Status code.
     */
    static BitmapSetResolution(bitmap, xdpi, ydpi) => DllCall("gdiplus\GdipBitmapSetResolution", "Ptr", bitmap, "Float", xdpi, "Float", ydpi)

    /**
     * Creates an Image object based on a stream.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static CreateImageFromStream(stream, image) => DllCall("gdiplus\GdipCreateImageFromStream", "Ptr", stream, "Ptr*", image)

    /**
     * Creates an Image object based on a file.
     * @param {String} filename - A string that specifies the name of the file from which to create the Image object.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static CreateImageFromFile(filename, image) => DllCall("gdiplus\GdipCreateImageFromFile", "Str", filename, "Ptr*", image)

    /**
     * Creates an Image object based on a stream, using the Windows color management system.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static CreateImageFromStreamICM(stream, image) => DllCall("gdiplus\GdipCreateImageFromStreamICM", "Ptr", stream, "Ptr*", image)

    /**
     * Creates an Image object based on a file, using the Windows color management system.
     * @param {String} filename - A string that specifies the name of the file from which to create the Image object.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static CreateImageFromFileICM(filename, image) => DllCall("gdiplus\GdipCreateImageFromFileICM", "Str", filename, "Ptr*", image)

    /**
     * Creates an Image object based on a stream.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static LoadImageFromStream(stream, image) => DllCall("gdiplus\GdipLoadImageFromStream", "Ptr", stream, "Ptr*", image)

    /**
     * Creates an Image object based on a file.
     * @param {String} filename - A string that specifies the name of the file from which to create the Image object.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static LoadImageFromFile(filename, image) => DllCall("gdiplus\GdipLoadImageFromFile", "Str", filename, "Ptr*", image)

    /**
     * Creates an Image object based on a stream, using the Windows color management system.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static LoadImageFromStreamICM(stream, image) => DllCall("gdiplus\GdipLoadImageFromStreamICM", "Ptr", stream, "Ptr*", image)

    /**
     * Creates an Image object based on a file, using the Windows color management system.
     * @param {String} filename - A string that specifies the name of the file from which to create the Image object.
     * @param {Pointer} image - A pointer to a variable that receives a pointer to the new Image object.
     * @returns {Integer} Status code.
     */
    static LoadImageFromFileICM(filename, image) => DllCall("gdiplus\GdipLoadImageFromFileICM", "Str", filename, "Ptr*", image)

    /**
     * Creates a clone of the specified Image object.
     * @param {Pointer} image - A pointer to the Image object to clone.
     * @param {Pointer} cloneImage - A pointer to a variable that receives a pointer to the cloned Image object.
     * @returns {Integer} Status code.
     */
    static CloneImage(image, cloneImage) => DllCall("gdiplus\GdipCloneImage", "Ptr", image, "Ptr*", cloneImage)

    /**
     * Releases the operating system resources used by an Image object.
     * @param {Pointer} image - A pointer to the Image object to dispose.
     * @returns {Integer} Status code.
     */
    static DisposeImage(image) => DllCall("gdiplus\GdipDisposeImage", "Ptr", image)

    /**
     * Saves an Image object to a file.
     * @param {Pointer} image - A pointer to the Image object to save.
     * @param {String} filename - The name of the file to which to save the image.
     * @param {Pointer} clsidEncoder - A pointer to a CLSID that specifies the encoder to use.
     * @param {Pointer} encoderParams - A pointer to an EncoderParameters object. Can be 0.
     * @returns {Integer} Status code.
     */
    static SaveImageToFile(image, filename, clsidEncoder, encoderParams) => DllCall("gdiplus\GdipSaveImageToFile", "Ptr", image, "Str", filename, "Ptr", clsidEncoder, "Ptr", encoderParams)

    /**
     * Saves an Image object to an IStream interface.
     * @param {Pointer} image - A pointer to the Image object to save.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Pointer} clsidEncoder - A pointer to a CLSID that specifies the encoder to use.
     * @param {Pointer} encoderParams - A pointer to an EncoderParameters object. Can be 0.
     * @returns {Integer} Status code.
     */
    static SaveImageToStream(image, stream, clsidEncoder, encoderParams) => DllCall("gdiplus\GdipSaveImageToStream", "Ptr", image, "Ptr", stream, "Ptr", clsidEncoder, "Ptr", encoderParams)

    /**
     * Adds a new frame to a multiple-frame image.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} encoderParams - A pointer to an EncoderParameters object.
     * @returns {Integer} Status code.
     */
    static SaveAdd(image, encoderParams) => DllCall("gdiplus\GdipSaveAdd", "Ptr", image, "Ptr", encoderParams)

    /**
     * Adds a new frame to a multiple-frame image.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} newImage - A pointer to the Image object to be added as a new frame.
     * @param {Pointer} encoderParams - A pointer to an EncoderParameters object.
     * @returns {Integer} Status code.
     */
    static SaveAddImage(image, newImage, encoderParams) => DllCall("gdiplus\GdipSaveAddImage", "Ptr", image, "Ptr", newImage, "Ptr", encoderParams)

    /**
     * Gets the Graphics object associated with an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} graphics - A pointer to a variable that receives a pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static GetImageGraphicsContext(image, graphics) => DllCall("gdiplus\GdipGetImageGraphicsContext", "Ptr", image, "Ptr*", graphics)

    /**
     * Gets the bounding rectangle for an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} srcRect - A pointer to a RectF structure that receives the bounding rectangle.
     * @param {Integer} srcUnit - An element of the Unit enumeration that specifies the unit of measure for the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetImageBounds(image, srcRect, srcUnit) => DllCall("gdiplus\GdipGetImageBounds", "Ptr", image, "Ptr", srcRect, "Int", srcUnit)

    /**
     * Gets the width and height of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} width - A pointer to a variable that receives the width of the image.
     * @param {Pointer} height - A pointer to a variable that receives the height of the image.
     * @returns {Integer} Status code.
     */
    static GetImageDimension(image, width, height) => DllCall("gdiplus\GdipGetImageDimension", "Ptr", image, "Ptr", width, "Ptr", height)

    /**
     * Gets the type of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} type - A pointer to a variable that receives an element of the ImageType enumeration.
     * @returns {Integer} Status code.
     */
    static GetImageType(image, type) => DllCall("gdiplus\GdipGetImageType", "Ptr", image, "Ptr", type)

    /**
     * Gets the width, in pixels, of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} width - A pointer to a variable that receives the width of the image.
     * @returns {Integer} Status code.
     */
    static GetImageWidth(image, width) => DllCall("gdiplus\GdipGetImageWidth", "Ptr", image, "Ptr", width)

    /**
     * Gets the height, in pixels, of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} height - A pointer to a variable that receives the height of the image.
     * @returns {Integer} Status code.
     */
    static GetImageHeight(image, height) => DllCall("gdiplus\GdipGetImageHeight", "Ptr", image, "Ptr", height)

    /**
     * Gets the horizontal resolution of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} resolution - A pointer to a variable that receives the horizontal resolution in dots per inch.
     * @returns {Integer} Status code.
     */
    static GetImageHorizontalResolution(image, resolution) => DllCall("gdiplus\GdipGetImageHorizontalResolution", "Ptr", image, "Ptr", resolution)

    /**
     * Gets the vertical resolution of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} resolution - A pointer to a variable that receives the vertical resolution in dots per inch.
     * @returns {Integer} Status code.
     */
    static GetImageVerticalResolution(image, resolution) => DllCall("gdiplus\GdipGetImageVerticalResolution", "Ptr", image, "Ptr", resolution)

    /**
     * Gets a set of flags that indicate certain attributes of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} flags - A pointer to a variable that receives a set of flags from the ImageFlags enumeration.
     * @returns {Integer} Status code.
     */
    static GetImageFlags(image, flags) => DllCall("gdiplus\GdipGetImageFlags", "Ptr", image, "Ptr", flags)

    /**
     * Gets the format of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} format - A pointer to a GUID structure that receives the format identifier.
     * @returns {Integer} Status code.
     */
    static GetImageRawFormat(image, format) => DllCall("gdiplus\GdipGetImageRawFormat", "Ptr", image, "Ptr", format)

    /**
     * Gets the pixel format of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} format - A pointer to a variable that receives an element of the PixelFormat enumeration.
     * @returns {Integer} Status code.
     */
    static GetImagePixelFormat(image, format) => DllCall("gdiplus\GdipGetImagePixelFormat", "Ptr", image, "Ptr", format)

    /**
     * Gets a thumbnail image from an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Integer} thumbWidth - The desired width of the thumbnail.
     * @param {Integer} thumbHeight - The desired height of the thumbnail.
     * @param {Pointer} thumbImage - A pointer to a variable that receives a pointer to the thumbnail Image object.
     * @param {Pointer} callback - A pointer to a callback function. Can be 0.
     * @param {Pointer} callbackData - A pointer to callback data. Can be 0.
     * @returns {Integer} Status code.
     */
    static GetImageThumbnail(image, thumbWidth, thumbHeight, thumbImage, callback, callbackData) => DllCall("gdiplus\GdipGetImageThumbnail", "Ptr", image, "UInt", thumbWidth, "UInt", thumbHeight, "Ptr*", thumbImage, "Ptr", callback, "Ptr", callbackData)

    /**
     * Gets the size of the parameter list for a specified image encoder.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} clsidEncoder - A pointer to a CLSID that specifies the encoder.
     * @param {Pointer} size - A pointer to a variable that receives the size, in bytes, of the parameter list.
     * @returns {Integer} Status code.
     */
    static GetEncoderParameterListSize(image, clsidEncoder, size) => DllCall("gdiplus\GdipGetEncoderParameterListSize", "Ptr", image, "Ptr", clsidEncoder, "Ptr", size)

    /**
     * Gets a list of the parameters supported by a specified image encoder.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} clsidEncoder - A pointer to a CLSID that specifies the encoder.
     * @param {Integer} size - The size, in bytes, of the buffer pointed to by buffer.
     * @param {Pointer} buffer - A pointer to a buffer that receives the parameter list.
     * @returns {Integer} Status code.
     */
    static GetEncoderParameterList(image, clsidEncoder, size, buffer) => DllCall("gdiplus\GdipGetEncoderParameterList", "Ptr", image, "Ptr", clsidEncoder, "UInt", size, "Ptr", buffer)

    /**
     * Gets the number of frame dimensions in an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} count - A pointer to a variable that receives the number of frame dimensions.
     * @returns {Integer} Status code.
     */
    static ImageGetFrameDimensionsCount(image, count) => DllCall("gdiplus\GdipImageGetFrameDimensionsCount", "Ptr", image, "Ptr", count)

    /**
     * Gets the list of frame dimensions from an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} dimensionIDs - A pointer to an array that receives the GUIDs of the frame dimensions.
     * @param {Integer} count - The number of GUIDs to be retrieved.
     * @returns {Integer} Status code.
     */
    static ImageGetFrameDimensionsList(image, dimensionIDs, count) => DllCall("gdiplus\GdipImageGetFrameDimensionsList", "Ptr", image, "Ptr", dimensionIDs, "UInt", count)

    /**
     * Gets the number of frames in a specified dimension of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} dimensionID - A pointer to a GUID that specifies the dimension.
     * @param {Pointer} count - A pointer to a variable that receives the number of frames.
     * @returns {Integer} Status code.
     */
    static ImageGetFrameCount(image, dimensionID, count) => DllCall("gdiplus\GdipImageGetFrameCount", "Ptr", image, "Ptr", dimensionID, "Ptr", count)

    /**
     * Selects the active frame in a specified dimension of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} dimensionID - A pointer to a GUID that specifies the dimension.
     * @param {Integer} frameIndex - The index of the frame to be selected as the active frame.
     * @returns {Integer} Status code.
     */
    static ImageSelectActiveFrame(image, dimensionID, frameIndex) => DllCall("gdiplus\GdipImageSelectActiveFrame", "Ptr", image, "Ptr", dimensionID, "UInt", frameIndex)

    /**
     * Rotates and flips an image.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Integer} rotateFlipType - An element of the RotateFlipType enumeration that specifies the type of rotation and flip to apply.
     * @returns {Integer} Status code.
     */
    static ImageRotateFlip(image, rotateFlipType) => DllCall("gdiplus\GdipImageRotateFlip", "Ptr", image, "Int", rotateFlipType)

    /**
     * Gets the color palette of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} palette - A pointer to a ColorPalette structure that receives the color palette.
     * @param {Integer} size - The size, in bytes, of the ColorPalette structure.
     * @returns {Integer} Status code.
     */
    static GetImagePalette(image, palette, size) => DllCall("gdiplus\GdipGetImagePalette", "Ptr", image, "Ptr", palette, "Int", size)

    /**
     * Sets the color palette of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} palette - A pointer to a ColorPalette structure that specifies the color palette.
     * @param {Integer} size - The size, in bytes, of the ColorPalette structure.
     * @returns {Integer} Status code.
     */
    static SetImagePalette(image, palette) => DllCall("gdiplus\GdipSetImagePalette", "Ptr", image, "Ptr", palette)

    /**
     * Gets the size, in bytes, of the color palette of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} size - A pointer to a variable that receives the size, in bytes, of the color palette.
     * @returns {Integer} Status code.
     */
    static GetImagePaletteSize(image, size) => DllCall("gdiplus\GdipGetImagePaletteSize", "Ptr", image, "Ptr", size)

    /**
     * Gets the number of properties (pieces of metadata) stored in an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} numOfProperty - A pointer to a variable that receives the number of properties.
     * @returns {Integer} Status code.
     */
    static GetPropertyCount(image, numOfProperty) => DllCall("gdiplus\GdipGetPropertyCount", "Ptr", image, "Ptr", numOfProperty)

    /**
     * Gets a list of the property identifiers used in the metadata of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Integer} numOfProperty - The number of property identifiers to be retrieved.
     * @param {Pointer} list - A pointer to an array that receives the property identifiers.
     * @returns {Integer} Status code.
     */
    static GetPropertyIdList(image, numOfProperty, list) => DllCall("gdiplus\GdipGetPropertyIdList", "Ptr", image, "UInt", numOfProperty, "Ptr", list)

    /**
     * Gets the size, in bytes, of a specified property item of an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Integer} propId - The identifier of the property item.
     * @param {Pointer} size - A pointer to a variable that receives the size, in bytes, of the property item.
     * @returns {Integer} Status code.
     */
    static GetPropertyItemSize(image, propId, size) => DllCall("gdiplus\GdipGetPropertyItemSize", "Ptr", image, "UInt", propId, "Ptr", size)

    /**
     * Gets a specified property item from an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Integer} propId - The identifier of the property item to be retrieved.
     * @param {Integer} propSize - The size, in bytes, of the buffer pointed to by buffer.
     * @param {Pointer} buffer - A pointer to a buffer that receives the property item.
     * @returns {Integer} Status code.
     */
    static GetPropertyItem(image, propId, propSize, buffer) => DllCall("gdiplus\GdipGetPropertyItem", "Ptr", image, "UInt", propId, "UInt", propSize, "Ptr", buffer)

    /**
     * Gets the total size, in bytes, of all the property items stored in an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} totalBufferSize - A pointer to a variable that receives the total size, in bytes.
     * @param {Pointer} numProperties - A pointer to a variable that receives the number of property items.
     * @returns {Integer} Status code.
     */
    static GetPropertySize(image, totalBufferSize, numProperties) => DllCall("gdiplus\GdipGetPropertySize", "Ptr", image, "Ptr", totalBufferSize, "Ptr", numProperties)

    /**
     * Gets all the property items (metadata) stored in an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Integer} totalBufferSize - The size, in bytes, of the buffer pointed to by allItems.
     * @param {Integer} numProperties - The number of property items to be retrieved.
     * @param {Pointer} allItems - A pointer to an array of PropertyItem objects that receives the property items.
     * @returns {Integer} Status code.
     */
    static GetAllPropertyItems(image, totalBufferSize, numProperties, allItems) => DllCall("gdiplus\GdipGetAllPropertyItems", "Ptr", image, "UInt", totalBufferSize, "UInt", numProperties, "Ptr", allItems)

    /**
     * Removes a property item (piece of metadata) from an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Integer} propId - The identifier of the property item to be removed.
     * @returns {Integer} Status code.
     */
    static RemovePropertyItem(image, propId) => DllCall("gdiplus\GdipRemovePropertyItem", "Ptr", image, "UInt", propId)

    /**
     * Sets a property item (piece of metadata) for an Image object.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} item - A pointer to a PropertyItem object that specifies the property item to be set.
     * @returns {Integer} Status code.
     */
    static SetPropertyItem(image, item) => DllCall("gdiplus\GdipSetPropertyItem", "Ptr", image, "Ptr", item)

    /**
     * Finds the first item in an image metadata list.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} item - A pointer to an ImageItemData structure that receives information about the item.
     * @returns {Integer} Status code.
     */
    static FindFirstImageItem(image, item) => DllCall("gdiplus\GdipFindFirstImageItem", "Ptr", image, "Ptr", item)

    /**
     * Finds the next item in an image metadata list.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} item - A pointer to an ImageItemData structure that receives information about the item.
     * @returns {Integer} Status code.
     */
    static FindNextImageItem(image, item) => DllCall("gdiplus\GdipFindNextImageItem", "Ptr", image, "Ptr", item)

    /**
     * Gets the data for a specified item in an image metadata list.
     * @param {Pointer} image - A pointer to the Image object.
     * @param {Pointer} item - A pointer to an ImageItemData structure that specifies the item.
     * @param {Integer} size - The size, in bytes, of the buffer pointed to by buffer.
     * @param {Pointer} buffer - A pointer to a buffer that receives the item data.
     * @returns {Integer} Status code.
     */
    static GetImageItemData(image, item, size, buffer) => DllCall("gdiplus\GdipGetImageItemData", "Ptr", image, "Ptr", item, "UInt", size, "Ptr", buffer)

    /**
     * Creates a Metafile object from a Windows metafile.
     * @param {Integer} hWmf - A handle to a Windows metafile.
     * @param {Integer} deleteWmf - A Boolean value that specifies whether to delete the Windows metafile when the Metafile object is deleted.
     * @param {Pointer} wmfPlaceableFileHeader - A pointer to a WmfPlaceableFileHeader structure. Can be NULL.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static CreateMetafileFromWmf(hWmf, deleteWmf, wmfPlaceableFileHeader, metafile) => DllCall("gdiplus\GdipCreateMetafileFromWmf", "Ptr", hWmf, "Int", deleteWmf, "Ptr", wmfPlaceableFileHeader, "Ptr*", metafile)

    /**
     * Creates a Metafile object from an enhanced metafile.
     * @param {Integer} hEmf - A handle to an enhanced metafile.
     * @param {Integer} deleteEmf - A Boolean value that specifies whether to delete the enhanced metafile when the Metafile object is deleted.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static CreateMetafileFromEmf(hEmf, deleteEmf, metafile) => DllCall("gdiplus\GdipCreateMetafileFromEmf", "Ptr", hEmf, "Int", deleteEmf, "Ptr*", metafile)

    /**
     * Creates a Metafile object from an existing metafile.
     * @param {String} filename - A string that specifies the name of the metafile.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static CreateMetafileFromFile(filename, metafile) => DllCall("gdiplus\GdipCreateMetafileFromFile", "Str", filename, "Ptr*", metafile)

    /**
     * Creates a Metafile object from a Windows Metafile Format (WMF) file.
     * @param {String} filename - A string that specifies the name of the WMF file.
     * @param {Pointer} wmfPlaceableFileHeader - A pointer to a WmfPlaceableFileHeader structure. Can be NULL.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static CreateMetafileFromWmfFile(filename, wmfPlaceableFileHeader, metafile) => DllCall("gdiplus\GdipCreateMetafileFromWmfFile", "Str", filename, "Ptr", wmfPlaceableFileHeader, "Ptr*", metafile)

    /**
     * Creates a Metafile object from an IStream interface.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static CreateMetafileFromStream(stream, metafile) => DllCall("gdiplus\GdipCreateMetafileFromStream", "Ptr", stream, "Ptr*", metafile)

    /**
     * Records a new metafile.
     * @param {Integer} referenceHdc - A handle to a reference device context.
     * @param {Integer} type - An element of the EmfType enumeration that specifies the type of metafile to record.
     * @param {Pointer} frameRect - A pointer to a RectF structure that specifies the frame rectangle of the metafile.
     * @param {Integer} frameUnit - An element of the MetafileFrameUnit enumeration that specifies the unit of measure for the frame rectangle.
     * @param {String} description - A string that contains a description of the metafile.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static RecordMetafile(referenceHdc, type, frameRect, frameUnit, description, metafile) => DllCall("gdiplus\GdipRecordMetafile", "Ptr", referenceHdc, "Int", type, "Ptr", frameRect, "Int", frameUnit, "Str", description, "Ptr*", metafile)

    /**
     * Records a new metafile using integer coordinates.
     * @param {Integer} referenceHdc - A handle to a reference device context.
     * @param {Integer} type - An element of the EmfType enumeration that specifies the type of metafile to record.
     * @param {Pointer} frameRect - A pointer to a Rect structure that specifies the frame rectangle of the metafile.
     * @param {Integer} frameUnit - An element of the MetafileFrameUnit enumeration that specifies the unit of measure for the frame rectangle.
     * @param {String} description - A string that contains a description of the metafile.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static RecordMetafileI(referenceHdc, type, frameRect, frameUnit, description, metafile) => DllCall("gdiplus\GdipRecordMetafileI", "Ptr", referenceHdc, "Int", type, "Ptr", frameRect, "Int", frameUnit, "Str", description, "Ptr*", metafile)

    /**
     * Records a new metafile and saves it to a file.
     * @param {String} fileName - A string that specifies the name of the file to which to save the metafile.
     * @param {Integer} referenceHdc - A handle to a reference device context.
     * @param {Integer} type - An element of the EmfType enumeration that specifies the type of metafile to record.
     * @param {Pointer} frameRect - A pointer to a RectF structure that specifies the frame rectangle of the metafile.
     * @param {Integer} frameUnit - An element of the MetafileFrameUnit enumeration that specifies the unit of measure for the frame rectangle.
     * @param {String} description - A string that contains a description of the metafile.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static RecordMetafileFileName(fileName, referenceHdc, type, frameRect, frameUnit, description, metafile) => DllCall("gdiplus\GdipRecordMetafileFileName", "Str", fileName, "Ptr", referenceHdc, "Int", type, "Ptr", frameRect, "Int", frameUnit, "Str", description, "Ptr*", metafile)

    /**
     * Records a new metafile and saves it to a file using integer coordinates.
     * @param {String} fileName - A string that specifies the name of the file to which to save the metafile.
     * @param {Integer} referenceHdc - A handle to a reference device context.
     * @param {Integer} type - An element of the EmfType enumeration that specifies the type of metafile to record.
     * @param {Pointer} frameRect - A pointer to a Rect structure that specifies the frame rectangle of the metafile.
     * @param {Integer} frameUnit - An element of the MetafileFrameUnit enumeration that specifies the unit of measure for the frame rectangle.
     * @param {String} description - A string that contains a description of the metafile.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static RecordMetafileFileNameI(fileName, referenceHdc, type, frameRect, frameUnit, description, metafile) => DllCall("gdiplus\GdipRecordMetafileFileNameI", "Str", fileName, "Ptr", referenceHdc, "Int", type, "Ptr", frameRect, "Int", frameUnit, "Str", description, "Ptr*", metafile)

    /**
     * Records a new metafile and saves it to an IStream interface.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Integer} referenceHdc - A handle to a reference device context.
     * @param {Integer} type - An element of the EmfType enumeration that specifies the type of metafile to record.
     * @param {Pointer} frameRect - A pointer to a RectF structure that specifies the frame rectangle of the metafile.
     * @param {Integer} frameUnit - An element of the MetafileFrameUnit enumeration that specifies the unit of measure for the frame rectangle.
     * @param {String} description - A string that contains a description of the metafile.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static RecordMetafileStream(stream, referenceHdc, type, frameRect, frameUnit, description, metafile) => DllCall("gdiplus\GdipRecordMetafileStream", "Ptr", stream, "Ptr", referenceHdc, "Int", type, "Ptr", frameRect, "Int", frameUnit, "Str", description, "Ptr*", metafile)

    /**
     * Records a new metafile and saves it to an IStream interface using integer coordinates.
     * @param {Pointer} stream - A pointer to an IStream interface.
     * @param {Integer} referenceHdc - A handle to a reference device context.
     * @param {Integer} type - An element of the EmfType enumeration that specifies the type of metafile to record.
     * @param {Pointer} frameRect - A pointer to a Rect structure that specifies the frame rectangle of the metafile.
     * @param {Integer} frameUnit - An element of the MetafileFrameUnit enumeration that specifies the unit of measure for the frame rectangle.
     * @param {String} description - A string that contains a description of the metafile.
     * @param {Pointer} metafile - A pointer to a variable that receives a pointer to the new Metafile object.
     * @returns {Integer} Status code.
     */
    static RecordMetafileStreamI(stream, referenceHdc, type, frameRect, frameUnit, description, metafile) => DllCall("gdiplus\GdipRecordMetafileStreamI", "Ptr", stream, "Ptr", referenceHdc, "Int", type, "Ptr", frameRect, "Int", frameUnit, "Str", description, "Ptr*", metafile)

    /**
     * Sets the down-level rasterization limit for a metafile.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Integer} metafileRasterizationLimitDpi - The rasterization limit in dots per inch.
     * @returns {Integer} Status code.
     */
    static SetMetafileDownLevelRasterizationLimit(metafile, metafileRasterizationLimitDpi) => DllCall("gdiplus\GdipSetMetafileDownLevelRasterizationLimit", "Ptr", metafile, "UInt", metafileRasterizationLimitDpi)

    /**
     * Gets the down-level rasterization limit for a metafile.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Pointer} metafileRasterizationLimitDpi - A pointer to a variable that receives the rasterization limit in dots per inch.
     * @returns {Integer} Status code.
     */
    static GetMetafileDownLevelRasterizationLimit(metafile, metafileRasterizationLimitDpi) => DllCall("gdiplus\GdipGetMetafileDownLevelRasterizationLimit", "Ptr", metafile, "Ptr", metafileRasterizationLimitDpi)

    /**
     * Gets the size of the buffer required to store the image decoders.
     * @param {Pointer} numDecoders - A pointer to a variable that receives the number of decoders.
     * @param {Pointer} size - A pointer to a variable that receives the size, in bytes, of the buffer required to store the decoders.
     * @returns {Integer} Status code.
     */
    static GetImageDecodersSize(numDecoders, size) => DllCall("gdiplus\GdipGetImageDecodersSize", "Ptr", numDecoders, "Ptr", size)

    /**
     * Gets an array of image decoders.
     * @param {Integer} numDecoders - The number of decoders to retrieve.
     * @param {Integer} size - The size, in bytes, of the buffer pointed to by decoders.
     * @param {Pointer} decoders - A pointer to an array of ImageCodecInfo structures that receives the image decoders.
     * @returns {Integer} Status code.
     */
    static GetImageDecoders(numDecoders, size, decoders) => DllCall("gdiplus\GdipGetImageDecoders", "UInt", numDecoders, "UInt", size, "Ptr", decoders)

    /**
     * Gets the size of the buffer required to store the image encoders.
     * @param {Pointer} numEncoders - A pointer to a variable that receives the number of encoders.
     * @param {Pointer} size - A pointer to a variable that receives the size, in bytes, of the buffer required to store the encoders.
     * @returns {Integer} Status code.
     */
    static GetImageEncodersSize(numEncoders, size) => DllCall("gdiplus\GdipGetImageEncodersSize", "Ptr", numEncoders, "Ptr", size)

    /**
     * Gets an array of image encoders.
     * @param {Integer} numEncoders - The number of encoders to retrieve.
     * @param {Integer} size - The size, in bytes, of the buffer pointed to by encoders.
     * @param {Pointer} encoders - A pointer to an array of ImageCodecInfo structures that receives the image encoders.
     * @returns {Integer} Status code.
     */
    static GetImageEncoders(numEncoders, size, encoders) => DllCall("gdiplus\GdipGetImageEncoders", "UInt", numEncoders, "UInt", size, "Ptr", encoders)

    /**
     * Adds a comment to a metafile.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} sizeData - The size, in bytes, of the data pointed to by data.
     * @param {Pointer} data - A pointer to an array of bytes that contains the comment.
     * @returns {Integer} Status code.
     */
    static Comment(graphics, sizeData, data) => DllCall("gdiplus\GdipComment", "Ptr", graphics, "UInt", sizeData, "Ptr", data)

    /**
     * Begins a new graphics container.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} dstRect - A pointer to a RectF structure that specifies the bounding rectangle of the container.
     * @param {Pointer} srcRect - A pointer to a RectF structure that specifies the source rectangle.
     * @param {Integer} unit - An element of the Unit enumeration that specifies the unit of measure for the container.
     * @param {Pointer} state - A pointer to a variable that receives an identifier for the new container.
     * @returns {Integer} Status code.
     */
    static BeginContainer(graphics, dstRect, srcRect, unit, state) => DllCall("gdiplus\GdipBeginContainer", "Ptr", graphics, "Ptr", dstRect, "Ptr", srcRect, "Int", unit, "Ptr", state)

    /**
     * Begins a new graphics container using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} dstRect - A pointer to a Rect structure that specifies the bounding rectangle of the container.
     * @param {Pointer} srcRect - A pointer to a Rect structure that specifies the source rectangle.
     * @param {Integer} unit - An element of the Unit enumeration that specifies the unit of measure for the container.
     * @param {Pointer} state - A pointer to a variable that receives an identifier for the new container.
     * @returns {Integer} Status code.
     */
    static BeginContainerI(graphics, dstRect, srcRect, unit, state) => DllCall("gdiplus\GdipBeginContainerI", "Ptr", graphics, "Ptr", dstRect, "Ptr", srcRect, "Int", unit, "Ptr", state)

    /**
     * Begins a new graphics container with the current state of the Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} state - A pointer to a variable that receives an identifier for the new container.
     * @returns {Integer} Status code.
     */
    static BeginContainer2(graphics, state) => DllCall("gdiplus\GdipBeginContainer2", "Ptr", graphics, "Ptr", state)

    /**
     * Closes a graphics container that was previously opened by the BeginContainer method.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} state - The identifier of the container to be closed, as returned by BeginContainer.
     * @returns {Integer} Status code.
     */
    static EndContainer(graphics, state) => DllCall("gdiplus\GdipEndContainer", "Ptr", graphics, "UInt", state)

        /**
     * Enumerates the records of a metafile, using a destination point.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Float} destX - The x-coordinate of the destination point.
     * @param {Float} destY - The y-coordinate of the destination point.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileDestPoint(graphics, metafile, destX, destY, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileDestPoint", "Ptr", graphics, "Ptr", metafile, "Float", destX, "Float", destY, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using a destination point with integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Integer} x - The x-coordinate of the destination point.
     * @param {Integer} y - The y-coordinate of the destination point.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileDestPointI(graphics, metafile, x, y, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileDestPointI", "Ptr", graphics, "Ptr", metafile, "Int", x, "Int", y, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using a destination rectangle.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Float} destX - The x-coordinate of the upper-left corner of the destination rectangle.
     * @param {Float} destY - The y-coordinate of the upper-left corner of the destination rectangle.
     * @param {Float} destWidth - The width of the destination rectangle.
     * @param {Float} destHeight - The height of the destination rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileDestRect(graphics, metafile, destX, destY, destWidth, destHeight, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileDestRect", "Ptr", graphics, "Ptr", metafile, "Float", destX, "Float", destY, "Float", destWidth, "Float", destHeight, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using a destination rectangle with integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Integer} destX - The x-coordinate of the upper-left corner of the destination rectangle.
     * @param {Integer} destY - The y-coordinate of the upper-left corner of the destination rectangle.
     * @param {Integer} destWidth - The width of the destination rectangle.
     * @param {Integer} destHeight - The height of the destination rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileDestRectI(graphics, metafile, destX, destY, destWidth, destHeight, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileDestRectI", "Ptr", graphics, "Ptr", metafile, "Int", destX, "Int", destY, "Int", destWidth, "Int", destHeight, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using an array of destination points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Pointer} destPoints - A pointer to an array of PointF structures that specify the destination points.
     * @param {Integer} count - The number of points in the destPoints array.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileDestPoints(graphics, metafile, destPoints, count, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileDestPoints", "Ptr", graphics, "Ptr", metafile, "Ptr", destPoints, "Int", count, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using an array of destination points with integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Pointer} destPoints - A pointer to an array of Point structures that specify the destination points.
     * @param {Integer} count - The number of points in the destPoints array.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileDestPointsI(graphics, metafile, destPoints, count, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileDestPointsI", "Ptr", graphics, "Ptr", metafile, "Ptr", destPoints, "Int", count, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using a source rectangle and a destination point.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Float} destX - The x-coordinate of the destination point.
     * @param {Float} destY - The y-coordinate of the destination point.
     * @param {Float} srcX - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcY - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcWidth - The width of the source rectangle.
     * @param {Float} srcHeight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure for the source rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileSrcRectDestPoint(graphics, metafile, destX, destY, srcX, srcY, srcWidth, srcHeight, srcUnit, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileSrcRectDestPoint", "Ptr", graphics, "Ptr", metafile, "Float", destX, "Float", destY, "Float", srcX, "Float", srcY, "Float", srcWidth, "Float", srcHeight, "Int", srcUnit, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using a source rectangle and a destination point with integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Integer} destX - The x-coordinate of the destination point.
     * @param {Integer} destY - The y-coordinate of the destination point.
     * @param {Integer} srcX - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcY - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcWidth - The width of the source rectangle.
     * @param {Integer} srcHeight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure for the source rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileSrcRectDestPointI(graphics, metafile, destX, destY, srcX, srcY, srcWidth, srcHeight, srcUnit, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileSrcRectDestPointI", "Ptr", graphics, "Ptr", metafile, "Int", destX, "Int", destY, "Int", srcX, "Int", srcY, "Int", srcWidth, "Int", srcHeight, "Int", srcUnit, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using source and destination rectangles.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Float} destX - The x-coordinate of the upper-left corner of the destination rectangle.
     * @param {Float} destY - The y-coordinate of the upper-left corner of the destination rectangle.
     * @param {Float} destWidth - The width of the destination rectangle.
     * @param {Float} destHeight - The height of the destination rectangle.
     * @param {Float} srcX - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcY - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcWidth - The width of the source rectangle.
     * @param {Float} srcHeight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure for the source rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileSrcRectDestRect(graphics, metafile, destX, destY, destWidth, destHeight, srcX, srcY, srcWidth, srcHeight, srcUnit, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileSrcRectDestRect", "Ptr", graphics, "Ptr", metafile, "Float", destX, "Float", destY, "Float", destWidth, "Float", destHeight, "Float", srcX, "Float", srcY, "Float", srcWidth, "Float", srcHeight, "Int", srcUnit, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using source and destination rectangles with integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Integer} destX - The x-coordinate of the upper-left corner of the destination rectangle.
     * @param {Integer} destY - The y-coordinate of the upper-left corner of the destination rectangle.
     * @param {Integer} destWidth - The width of the destination rectangle.
     * @param {Integer} destHeight - The height of the destination rectangle.
     * @param {Integer} srcX - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcY - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcWidth - The width of the source rectangle.
     * @param {Integer} srcHeight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure for the source rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileSrcRectDestRectI(graphics, metafile, destX, destY, destWidth, destHeight, srcX, srcY, srcWidth, srcHeight, srcUnit, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileSrcRectDestRectI", "Ptr", graphics, "Ptr", metafile, "Int", destX, "Int", destY, "Int", destWidth, "Int", destHeight, "Int", srcX, "Int", srcY, "Int", srcWidth, "Int", srcHeight, "Int", srcUnit, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using a source rectangle and an array of destination points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Pointer} destPoints - A pointer to an array of PointF structures that specify the destination points.
     * @param {Integer} count - The number of points in the destPoints array.
     * @param {Float} srcX - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcY - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcWidth - The width of the source rectangle.
     * @param {Float} srcHeight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure for the source rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileSrcRectDestPoints(graphics, metafile, destPoints, count, srcX, srcY, srcWidth, srcHeight, srcUnit, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileSrcRectDestPoints", "Ptr", graphics, "Ptr", metafile, "Ptr", destPoints, "Int", count, "Float", srcX, "Float", srcY, "Float", srcWidth, "Float", srcHeight, "Int", srcUnit, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Enumerates the records of a metafile, using a source rectangle and an array of destination points with integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Pointer} destPoints - A pointer to an array of Point structures that specify the destination points.
     * @param {Integer} count - The number of points in the destPoints array.
     * @param {Integer} srcX - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcY - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcWidth - The width of the source rectangle.
     * @param {Integer} srcHeight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure for the source rectangle.
     * @param {Pointer} callback - A pointer to the callback function.
     * @param {Pointer} callbackData - A pointer to data to be passed to the callback function.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @returns {Integer} Status code.
     */
    static EnumerateMetafileSrcRectDestPointsI(graphics, metafile, destPoints, count, srcX, srcY, srcWidth, srcHeight, srcUnit, callback, callbackData, imageAttributes := 0) => DllCall("gdiplus\GdipEnumerateMetafileSrcRectDestPointsI", "Ptr", graphics, "Ptr", metafile, "Ptr", destPoints, "Int", count, "Int", srcX, "Int", srcY, "Int", srcWidth, "Int", srcHeight, "Int", srcUnit, "Ptr", callback, "Ptr", callbackData, "Ptr", imageAttributes)

    /**
     * Plays a metafile record.
     * @param {Pointer} metafile - A pointer to the Metafile object.
     * @param {Integer} recordType - The type of metafile record to play.
     * @param {Integer} flags - Flags that specify additional information about the record.
     * @param {Integer} dataSize - The size, in bytes, of the record data.
     * @param {Pointer} data - A pointer to the record data.
     * @returns {Integer} Status code.
     */
    static PlayMetafileRecord(metafile, recordType, flags, dataSize, data) => DllCall("gdiplus\GdipPlayMetafileRecord", "Ptr", metafile, "UInt", recordType, "UInt", flags, "UInt", dataSize, "Ptr", data)

    /**
     * Sets the clipping region of this Graphics object to the specified Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} srcGraphics - A pointer to the Graphics object that specifies the clipping region.
     * @param {Integer} combineMode - The combine mode to use when setting the clipping region.
     * @returns {Integer} Status code.
     */
    static SetClipGraphics(graphics, srcGraphics, combineMode) => DllCall("gdiplus\GdipSetClipGraphics", "Ptr", graphics, "Ptr", srcGraphics, "Int", combineMode)

    /**
     * Updates the clipping region of this Graphics object to a rectangle.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Float} width - The width of the rectangle.
     * @param {Float} height - The height of the rectangle.
     * @param {Integer} combineMode - The combine mode to use when updating the clipping region.
     * @returns {Integer} Status code.
     */
    static SetClipRect(graphics, x, y, width, height, combineMode) => DllCall("gdiplus\GdipSetClipRect", "Ptr", graphics, "Float", x, "Float", y, "Float", width, "Float", height, "Int", combineMode)

    /**
     * Updates the clipping region of this Graphics object to a rectangle with integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} width - The width of the rectangle.
     * @param {Integer} height - The height of the rectangle.
     * @param {Integer} combineMode - The combine mode to use when updating the clipping region.
     * @returns {Integer} Status code.
     */
    static SetClipRectI(graphics, x, y, width, height, combineMode) => DllCall("gdiplus\GdipSetClipRectI", "Ptr", graphics, "Int", x, "Int", y, "Int", width, "Int", height, "Int", combineMode)

    /**
     * Updates the clipping region of this Graphics object to a GraphicsPath object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} path - A pointer to the GraphicsPath object that specifies the new clipping region.
     * @param {Integer} combineMode - The combine mode to use when updating the clipping region.
     * @returns {Integer} Status code.
     */
    static SetClipPath(graphics, path, combineMode) => DllCall("gdiplus\GdipSetClipPath", "Ptr", graphics, "Ptr", path, "Int", combineMode)

    /**
     * Updates the clipping region of this Graphics object to a Region object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} region - A pointer to the Region object that specifies the new clipping region.
     * @param {Integer} combineMode - The combine mode to use when updating the clipping region.
     * @returns {Integer} Status code.
     */
    static SetClipRegion(graphics, region, combineMode) => DllCall("gdiplus\GdipSetClipRegion", "Ptr", graphics, "Ptr", region, "Int", combineMode)

    /**
     * Updates the clipping region of this Graphics object to a Windows handle to a region (HRGN).
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} hRgn - A Windows handle to a region (HRGN) that specifies the new clipping region.
     * @param {Integer} combineMode - The combine mode to use when updating the clipping region.
     * @returns {Integer} Status code.
     */
    static SetClipHrgn(graphics, hRgn, combineMode) => DllCall("gdiplus\GdipSetClipHrgn", "Ptr", graphics, "Ptr", hRgn, "Int", combineMode)

    /**
     * Resets the clipping region of this Graphics object to an infinite region.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static ResetClip(graphics) => DllCall("gdiplus\GdipResetClip", "Ptr", graphics)

    /**
     * Translates the clipping region of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} dx - The amount to translate along the x-axis.
     * @param {Float} dy - The amount to translate along the y-axis.
     * @returns {Integer} Status code.
     */
    static TranslateClip(graphics, dx, dy) => DllCall("gdiplus\GdipTranslateClip", "Ptr", graphics, "Float", dx, "Float", dy)

    /**
     * Translates the clipping region of this Graphics object using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} dx - The amount to translate along the x-axis.
     * @param {Integer} dy - The amount to translate along the y-axis.
     * @returns {Integer} Status code.
     */
    static TranslateClipI(graphics, dx, dy) => DllCall("gdiplus\GdipTranslateClipI", "Ptr", graphics, "Int", dx, "Int", dy)

    /**
     * Gets the clipping region of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} region - A pointer to a Region object that receives the clipping region.
     * @returns {Integer} Status code.
     */
    static GetClip(graphics, region) => DllCall("gdiplus\GdipGetClip", "Ptr", graphics, "Ptr", region)

    /**
     * Gets the bounding rectangle of the clipping region of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} rect - A pointer to a RectF structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetClipBounds(graphics, rect) => DllCall("gdiplus\GdipGetClipBounds", "Ptr", graphics, "Ptr", rect)

    /**
     * Gets the bounding rectangle of the clipping region of this Graphics object using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} rect - A pointer to a Rect structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetClipBoundsI(graphics, rect) => DllCall("gdiplus\GdipGetClipBoundsI", "Ptr", graphics, "Ptr", rect)

    /**
     * Determines whether the clipping region of this Graphics object is empty.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} result - A pointer to a BOOL that receives the result.
     * @returns {Integer} Status code.
     */
    static IsClipEmpty(graphics, result) => DllCall("gdiplus\GdipIsClipEmpty", "Ptr", graphics, "Ptr", result)

    /**
     * Gets the visible clipping bounds of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} rect - A pointer to a RectF structure that receives the visible clipping bounds.
     * @returns {Integer} Status code.
     */
    static GetVisibleClipBounds(graphics, rect) => DllCall("gdiplus\GdipGetVisibleClipBounds", "Ptr", graphics, "Ptr", rect)

    /**
     * Gets the visible clipping bounds of this Graphics object using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} rect - A pointer to a Rect structure that receives the visible clipping bounds.
     * @returns {Integer} Status code.
     */
    static GetVisibleClipBoundsI(graphics, rect) => DllCall("gdiplus\GdipGetVisibleClipBoundsI", "Ptr", graphics, "Ptr", rect)

    /**
     * Determines whether the visible clipping region of this Graphics object is empty.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} result - A pointer to a BOOL that receives the result.
     * @returns {Integer} Status code.
     */
    static IsVisibleClipEmpty(graphics, result) => DllCall("gdiplus\GdipIsVisibleClipEmpty", "Ptr", graphics, "Ptr", result)

    /**
     * Determines whether the specified point is inside the visible clipping region of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} x - The x-coordinate of the point to test.
     * @param {Float} y - The y-coordinate of the point to test.
     * @param {Pointer} result - A pointer to a BOOL that receives the result.
     * @returns {Integer} Status code.
     */
    static IsVisiblePoint(graphics, x, y, result) => DllCall("gdiplus\GdipIsVisiblePoint", "Ptr", graphics, "Float", x, "Float", y, "Ptr", result)

    /**
     * Determines whether the specified point is inside the visible clipping region of this Graphics object using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} x - The x-coordinate of the point to test.
     * @param {Integer} y - The y-coordinate of the point to test.
     * @param {Pointer} result - A pointer to a BOOL that receives the result.
     * @returns {Integer} Status code.
     */
    static IsVisiblePointI(graphics, x, y, result) => DllCall("gdiplus\GdipIsVisiblePointI", "Ptr", graphics, "Int", x, "Int", y, "Ptr", result)

    /**
     * Determines whether the specified rectangle intersects the visible clipping region of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle to test.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle to test.
     * @param {Float} width - The width of the rectangle to test.
     * @param {Float} height - The height of the rectangle to test.
     * @param {Pointer} result - A pointer to a BOOL that receives the result.
     * @returns {Integer} Status code.
     */
    static IsVisibleRect(graphics, x, y, width, height, result) => DllCall("gdiplus\GdipIsVisibleRect", "Ptr", graphics, "Float", x, "Float", y, "Float", width, "Float", height, "Ptr", result)

    /**
     * Determines whether the specified rectangle intersects the visible clipping region of this Graphics object using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle to test.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle to test.
     * @param {Integer} width - The width of the rectangle to test.
     * @param {Integer} height - The height of the rectangle to test.
     * @param {Pointer} result - A pointer to a BOOL that receives the result.
     * @returns {Integer} Status code.
     */
    static IsVisibleRectI(graphics, x, y, width, height, result) => DllCall("gdiplus\GdipIsVisibleRectI", "Ptr", graphics, "Int", x, "Int", y, "Int", width, "Int", height, "Ptr", result)

    /**
     * Saves the current state of this Graphics object and identifies the saved state with a state object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} state - A pointer to a variable that receives a handle to the saved state.
     * @returns {Integer} Status code.
     */
    static SaveGraphics(graphics, &state) => DllCall("gdiplus\GdipSaveGraphics", "Ptr", graphics, "Ptr*", &state)

    /**
     * Restores the state of this Graphics object to the state specified by a previous call to the GdipSaveGraphics method.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} state - A handle to the saved state.
     * @returns {Integer} Status code.
     */
    static RestoreGraphics(graphics, state) => DllCall("gdiplus\GdipRestoreGraphics", "Ptr", graphics, "UInt", state)

    /**
     * Begins a new graphics container.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} state - A pointer to a variable that receives a handle to the graphics container.
     * @returns {Integer} Status code.
     */
    static BeginGraphics(graphics, state) => DllCall("gdiplus\GdipBeginContainer", "Ptr", graphics, "Ptr", 0, "Ptr", 0, "Int", 0, "Ptr", state)

    /**
     * Closes a graphics container that was previously opened by the GdipBeginGraphics method.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} state - A handle to the graphics container to be closed.
     * @returns {Integer} Status code.
     */
    static EndGraphics(graphics, state) => DllCall("gdiplus\GdipEndContainer", "Ptr", graphics, "UInt", state)

    /**
     * Forces execution of all pending graphics operations and returns immediately without waiting for the operations to finish.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} intention - The flush intention.
     * @returns {Integer} Status code.
     */
    static Flush(graphics, intention := 0) => DllCall("gdiplus\GdipFlush", "Ptr", graphics, "Int", intention)

    /**
     * Creates a Graphics object from a device context handle (HDC).
     * @param {Pointer} hdc - A handle to a device context.
     * @param {Pointer} graphics - A pointer to a variable that receives a pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static CreateFromHDC(hdc, graphics) => DllCall("gdiplus\GdipCreateFromHDC", "Ptr", hdc, "Ptr", graphics)

    /**
     * Creates a Graphics object from a device context handle (HDC) and a device handle.
     * @param {Pointer} hdc - A handle to a device context.
     * @param {Pointer} hdevice - A handle to a device.
     * @param {Pointer} graphics - A pointer to a variable that receives a pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static CreateFromHDC2(hdc, hdevice, graphics) => DllCall("gdiplus\GdipCreateFromHDC2", "Ptr", hdc, "Ptr", hdevice, "Ptr", graphics)

    /**
     * Creates a Graphics object from a window handle (HWND).
     * @param {Pointer} hwnd - A handle to a window.
     * @param {Pointer} graphics - A pointer to a variable that receives a pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static CreateFromHWND(hwnd, graphics) => DllCall("gdiplus\GdipCreateFromHWND", "Ptr", hwnd, "Ptr", graphics)

    /**
     * Creates a Graphics object from a window handle (HWND) with ICM (Image Color Management) enabled.
     * @param {Pointer} hwnd - A handle to a window.
     * @param {Pointer} graphics - A pointer to a variable that receives a pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static CreateFromHWNDICM(hwnd, graphics) => DllCall("gdiplus\GdipCreateFromHWNDICM", "Ptr", hwnd, "Ptr", graphics)

    /**
     * Deletes the specified Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object to be deleted.
     * @returns {Integer} Status code.
     */
    static DeleteGraphics(graphics) => DllCall("gdiplus\GdipDeleteGraphics", "Ptr", graphics)

    /**
     * Gets a handle to the device context associated with this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} hdc - A pointer to a variable that receives the handle to the device context.
     * @returns {Integer} Status code.
     */
    static GetDC(graphics, hdc) => DllCall("gdiplus\GdipGetDC", "Ptr", graphics, "Ptr", hdc)

    /**
     * Releases a device context handle obtained by a previous call to the GdipGetDC method.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} hdc - The handle to the device context to be released.
     * @returns {Integer} Status code.
     */
    static ReleaseDC(graphics, hdc) => DllCall("gdiplus\GdipReleaseDC", "Ptr", graphics, "Ptr", hdc)

    /**
     * Sets the compositing mode for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} compositingMode - The compositing mode to be set.
     * @returns {Integer} Status code.
     */
    static SetCompositingMode(graphics, compositingMode) => DllCall("gdiplus\GdipSetCompositingMode", "Ptr", graphics, "Int", compositingMode)

    /**
     * Gets the compositing mode currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} compositingMode - A pointer to a variable that receives the compositing mode.
     * @returns {Integer} Status code.
     */
    static GetCompositingMode(graphics, compositingMode) => DllCall("gdiplus\GdipGetCompositingMode", "Ptr", graphics, "Ptr", compositingMode)

    /**
     * Sets the rendering origin for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} x - The x-coordinate of the rendering origin.
     * @param {Integer} y - The y-coordinate of the rendering origin.
     * @returns {Integer} Status code.
     */
    static SetRenderingOrigin(graphics, x, y) => DllCall("gdiplus\GdipSetRenderingOrigin", "Ptr", graphics, "Int", x, "Int", y)

    /**
     * Gets the rendering origin currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} x - A pointer to a variable that receives the x-coordinate of the rendering origin.
     * @param {Pointer} y - A pointer to a variable that receives the y-coordinate of the rendering origin.
     * @returns {Integer} Status code.
     */
    static GetRenderingOrigin(graphics, x, y) => DllCall("gdiplus\GdipGetRenderingOrigin", "Ptr", graphics, "Ptr", x, "Ptr", y)

    /**
     * Sets the compositing quality for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} compositingQuality - The compositing quality to be set.
     * @returns {Integer} Status code.
     */
    static SetCompositingQuality(graphics, compositingQuality) => DllCall("gdiplus\GdipSetCompositingQuality", "Ptr", graphics, "Int", compositingQuality)

    /**
     * Gets the compositing quality currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} compositingQuality - A pointer to a variable that receives the compositing quality.
     * @returns {Integer} Status code.
     */
    static GetCompositingQuality(graphics, compositingQuality) => DllCall("gdiplus\GdipGetCompositingQuality", "Ptr", graphics, "Ptr", compositingQuality)

    /**
     * Sets the smoothing mode for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} smoothingMode - The smoothing mode to be set.
     * @returns {Integer} Status code.
     */
    static SetSmoothingMode(graphics, smoothingMode) => DllCall("gdiplus\GdipSetSmoothingMode", "Ptr", graphics, "Int", smoothingMode)

    /**
     * Gets the smoothing mode currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} smoothingMode - A pointer to a variable that receives the smoothing mode.
     * @returns {Integer} Status code.
     */
    static GetSmoothingMode(graphics, smoothingMode) => DllCall("gdiplus\GdipGetSmoothingMode", "Ptr", graphics, "Ptr", smoothingMode)

    /**
     * Sets the pixel offset mode for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} pixelOffsetMode - The pixel offset mode to be set.
     * @returns {Integer} Status code.
     */
    static SetPixelOffsetMode(graphics, pixelOffsetMode) => DllCall("gdiplus\GdipSetPixelOffsetMode", "Ptr", graphics, "Int", pixelOffsetMode)

    /**
     * Gets the pixel offset mode currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pixelOffsetMode - A pointer to a variable that receives the pixel offset mode.
     * @returns {Integer} Status code.
     */
    static GetPixelOffsetMode(graphics, pixelOffsetMode) => DllCall("gdiplus\GdipGetPixelOffsetMode", "Ptr", graphics, "Ptr", pixelOffsetMode)

    /**
     * Sets the text rendering hint for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} textRenderingHint - The text rendering hint to be set.
     * @returns {Integer} Status code.
     */
    static SetTextRenderingHint(graphics, textRenderingHint) => DllCall("gdiplus\GdipSetTextRenderingHint", "Ptr", graphics, "Int", textRenderingHint)

    /**
     * Gets the text rendering hint currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} textRenderingHint - A pointer to a variable that receives the text rendering hint.
     * @returns {Integer} Status code.
     */
    static GetTextRenderingHint(graphics, textRenderingHint) => DllCall("gdiplus\GdipGetTextRenderingHint", "Ptr", graphics, "Ptr", textRenderingHint)

    /**
     * Sets the text contrast value for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} contrast - The text contrast value to be set.
     * @returns {Integer} Status code.
     */
    static SetTextContrast(graphics, contrast) => DllCall("gdiplus\GdipSetTextContrast", "Ptr", graphics, "UInt", contrast)

    /**
     * Gets the text contrast value currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} contrast - A pointer to a variable that receives the text contrast value.
     * @returns {Integer} Status code.
     */
    static GetTextContrast(graphics, contrast) => DllCall("gdiplus\GdipGetTextContrast", "Ptr", graphics, "Ptr", contrast)

    /**
     * Sets the interpolation mode for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} interpolationMode - The interpolation mode to be set.
     * @returns {Integer} Status code.
     */
    static SetInterpolationMode(graphics, interpolationMode) => DllCall("gdiplus\GdipSetInterpolationMode", "Ptr", graphics, "Int", interpolationMode)

    /**
     * Gets the interpolation mode currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} interpolationMode - A pointer to a variable that receives the interpolation mode.
     * @returns {Integer} Status code.
     */
    static GetInterpolationMode(graphics, interpolationMode) => DllCall("gdiplus\GdipGetInterpolationMode", "Ptr", graphics, "Ptr", interpolationMode)

    /**
     * Sets the world transform of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the world transform.
     * @returns {Integer} Status code.
     */
    static SetWorldTransform(graphics, matrix) => DllCall("gdiplus\GdipSetWorldTransform", "Ptr", graphics, "Ptr", matrix)

    /**
     * Resets the world transform of this Graphics object to the identity matrix.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static ResetWorldTransform(graphics) => DllCall("gdiplus\GdipResetWorldTransform", "Ptr", graphics)

    /**
     * Multiplies the world transform of this Graphics object by a specified matrix.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} matrix - A pointer to a Matrix object to multiply by.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static MultiplyWorldTransform(graphics, matrix, order := 0) => DllCall("gdiplus\GdipMultiplyWorldTransform", "Ptr", graphics, "Ptr", matrix, "Int", order)

    /**
     * Translates the world transform of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} dx - The amount to translate along the x-axis.
     * @param {Float} dy - The amount to translate along the y-axis.
     * @param {Integer} order - The order of translation.
     * @returns {Integer} Status code.
     */
    static TranslateWorldTransform(graphics, dx, dy, order := 0) => DllCall("gdiplus\GdipTranslateWorldTransform", "Ptr", graphics, "Float", dx, "Float", dy, "Int", order)

    /**
     * Scales the world transform of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} sx - The amount to scale along the x-axis.
     * @param {Float} sy - The amount to scale along the y-axis.
     * @param {Integer} order - The order of scaling.
     * @returns {Integer} Status code.
     */
    static ScaleWorldTransform(graphics, sx, sy, order := 0) => DllCall("gdiplus\GdipScaleWorldTransform", "Ptr", graphics, "Float", sx, "Float", sy, "Int", order)

    /**
     * Rotates the world transform of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} angle - The angle of rotation in degrees.
     * @param {Integer} order - The order of rotation.
     * @returns {Integer} Status code.
     */
    static RotateWorldTransform(graphics, angle, order := 0) => DllCall("gdiplus\GdipRotateWorldTransform", "Ptr", graphics, "Float", angle, "Int", order)

    /**
     * Gets the world transform of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} matrix - A pointer to a Matrix object that receives the world transform.
     * @returns {Integer} Status code.
     */
    static GetWorldTransform(graphics, matrix) => DllCall("gdiplus\GdipGetWorldTransform", "Ptr", graphics, "Ptr", matrix)

    /**
     * Resets the page transform for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @returns {Integer} Status code.
     */
    static ResetPageTransform(graphics) => DllCall("gdiplus\GdipResetPageTransform", "Ptr", graphics)

    /**
     * Gets the page unit currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} unit - A pointer to a variable that receives the page unit.
     * @returns {Integer} Status code.
     */
    static GetPageUnit(graphics, unit) => DllCall("gdiplus\GdipGetPageUnit", "Ptr", graphics, "Ptr", unit)

    /**
     * Gets the page scale currently set for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} scale - A pointer to a variable that receives the page scale.
     * @returns {Integer} Status code.
     */
    static GetPageScale(graphics, scale) => DllCall("gdiplus\GdipGetPageScale", "Ptr", graphics, "Ptr", scale)

    /**
     * Sets the page unit for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} unit - The page unit to set.
     * @returns {Integer} Status code.
     */
    static SetPageUnit(graphics, unit) => DllCall("gdiplus\GdipSetPageUnit", "Ptr", graphics, "Int", unit)

    /**
     * Sets the page scale for this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Float} scale - The page scale to set.
     * @returns {Integer} Status code.
     */
    static SetPageScale(graphics, scale) => DllCall("gdiplus\GdipSetPageScale", "Ptr", graphics, "Float", scale)

    /**
     * Gets the horizontal resolution of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} dpi - A pointer to a variable that receives the horizontal resolution.
     * @returns {Integer} Status code.
     */
    static GetDpiX(graphics, dpi) => DllCall("gdiplus\GdipGetDpiX", "Ptr", graphics, "Ptr", dpi)

    /**
     * Gets the vertical resolution of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} dpi - A pointer to a variable that receives the vertical resolution.
     * @returns {Integer} Status code.
     */
    static GetDpiY(graphics, dpi) => DllCall("gdiplus\GdipGetDpiY", "Ptr", graphics, "Ptr", dpi)

    /**
     * Transforms an array of points from one coordinate space to another using the world transform of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} destSpace - The destination coordinate space.
     * @param {Integer} srcSpace - The source coordinate space.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points to transform.
     * @returns {Integer} Status code.
     */
    static TransformPoints(graphics, destSpace, srcSpace, points, count) => DllCall("gdiplus\GdipTransformPoints", "Ptr", graphics, "Int", destSpace, "Int", srcSpace, "Ptr", points, "Int", count)

    /**
     * Transforms an array of points from one coordinate space to another using the world transform of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} destSpace - The destination coordinate space.
     * @param {Integer} srcSpace - The source coordinate space.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points to transform.
     * @returns {Integer} Status code.
     */
    static TransformPointsI(graphics, destSpace, srcSpace, points, count) => DllCall("gdiplus\GdipTransformPointsI", "Ptr", graphics, "Int", destSpace, "Int", srcSpace, "Ptr", points, "Int", count)

    /**
     * Gets the nearest color to a specified color in the palette of this Graphics object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} argb - A pointer to a 32-bit ARGB color.
     * @returns {Integer} Status code.
     */
    static GetNearestColor(graphics, argb) => DllCall("gdiplus\GdipGetNearestColor", "Ptr", graphics, "Ptr", argb)

    /**
     * Creates a halftone palette for the specified device context (HDC).
     * @param {Pointer} hdc - A handle to the device context.
     * @returns {Pointer} A handle to the created halftone palette.
     */
    static CreateHalftonePalette() => DllCall("gdiplus\GdipCreateHalftonePalette", "Ptr")

    /**
     * Draws a line connecting two points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the line.
     * @param {Float} x1 - The x-coordinate of the first point.
     * @param {Float} y1 - The y-coordinate of the first point.
     * @param {Float} x2 - The x-coordinate of the second point.
     * @param {Float} y2 - The y-coordinate of the second point.
     * @returns {Integer} Status code.
     */
    static DrawLine(graphics, pen, x1, y1, x2, y2) => DllCall("gdiplus\GdipDrawLine", "Ptr", graphics, "Ptr", pen, "Float", x1, "Float", y1, "Float", x2, "Float", y2)

    /**
     * Draws a line connecting two points using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the line.
     * @param {Integer} x1 - The x-coordinate of the first point.
     * @param {Integer} y1 - The y-coordinate of the first point.
     * @param {Integer} x2 - The x-coordinate of the second point.
     * @param {Integer} y2 - The y-coordinate of the second point.
     * @returns {Integer} Status code.
     */
    static DrawLineI(graphics, pen, x1, y1, x2, y2) => DllCall("gdiplus\GdipDrawLineI", "Ptr", graphics, "Ptr", pen, "Int", x1, "Int", y1, "Int", x2, "Int", y2)

    /**
     * Draws a series of line segments that connect an array of points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the line.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static DrawLines(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawLines", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a series of line segments that connect an array of points using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the line.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static DrawLinesI(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawLinesI", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws an arc.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the arc.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @param {Float} startAngle - The starting angle measured in degrees clockwise from the x-axis to the starting point of the arc.
     * @param {Float} sweepAngle - The angle measured in degrees clockwise from the startAngle parameter to the ending point of the arc.
     * @returns {Integer} Status code.
     */
    static DrawArc(graphics, pen, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipDrawArc", "Ptr", graphics, "Ptr", pen, "Float", x, "Float", y, "Float", width, "Float", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Draws an arc using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the arc.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} width - The width of the rectangle that bounds the ellipse.
     * @param {Integer} height - The height of the rectangle that bounds the ellipse.
     * @param {Integer} startAngle - The starting angle measured in degrees clockwise from the x-axis to the starting point of the arc.
     * @param {Integer} sweepAngle - The angle measured in degrees clockwise from the startAngle parameter to the ending point of the arc.
     * @returns {Integer} Status code.
     */
    static DrawArcI(graphics, pen, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipDrawArcI", "Ptr", graphics, "Ptr", pen, "Int", x, "Int", y, "Int", width, "Int", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Draws a Bézier spline.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Float} x1 - The x-coordinate of the starting point of the curve.
     * @param {Float} y1 - The y-coordinate of the starting point of the curve.
     * @param {Float} x2 - The x-coordinate of the first control point of the curve.
     * @param {Float} y2 - The y-coordinate of the first control point of the curve.
     * @param {Float} x3 - The x-coordinate of the second control point of the curve.
     * @param {Float} y3 - The y-coordinate of the second control point of the curve.
     * @param {Float} x4 - The x-coordinate of the ending point of the curve.
     * @param {Float} y4 - The y-coordinate of the ending point of the curve.
     * @returns {Integer} Status code.
     */
    static DrawBezier(graphics, pen, x1, y1, x2, y2, x3, y3, x4, y4) => DllCall("gdiplus\GdipDrawBezier", "Ptr", graphics, "Ptr", pen, "Float", x1, "Float", y1, "Float", x2, "Float", y2, "Float", x3, "Float", y3, "Float", x4, "Float", y4)

    /**
     * Draws a Bézier spline using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Integer} x1 - The x-coordinate of the starting point of the curve.
     * @param {Integer} y1 - The y-coordinate of the starting point of the curve.
     * @param {Integer} x2 - The x-coordinate of the first control point of the curve.
     * @param {Integer} y2 - The y-coordinate of the first control point of the curve.
     * @param {Integer} x3 - The x-coordinate of the second control point of the curve.
     * @param {Integer} y3 - The y-coordinate of the second control point of the curve.
     * @param {Integer} x4 - The x-coordinate of the ending point of the curve.
     * @param {Integer} y4 - The y-coordinate of the ending point of the curve.
     * @returns {Integer} Status code.
     */
    static DrawBezierI(graphics, pen, x1, y1, x2, y2, x3, y3, x4, y4) => DllCall("gdiplus\GdipDrawBezierI", "Ptr", graphics, "Ptr", pen, "Int", x1, "Int", y1, "Int", x2, "Int", y2, "Int", x3, "Int", y3, "Int", x4, "Int", y4)

    /**
     * Draws a series of Bézier splines from an array of points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of PointF structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static DrawBeziers(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawBeziers", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a series of Bézier splines from an array of points using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of Point structures.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static DrawBeziersI(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawBeziersI", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a rectangle.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the rectangle.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Float} width - The width of the rectangle.
     * @param {Float} height - The height of the rectangle.
     * @returns {Integer} Status code.
     */
    static DrawRectangle(graphics, pen, x, y, width, height) => DllCall("gdiplus\GdipDrawRectangle", "Ptr", graphics, "Ptr", pen, "Float", x, "Float", y, "Float", width, "Float", height)

    /**
     * Draws a rectangle using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the rectangle.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} width - The width of the rectangle.
     * @param {Integer} height - The height of the rectangle.
     * @returns {Integer} Status code.
     */
    static DrawRectangleI(graphics, pen, x, y, width, height) => DllCall("gdiplus\GdipDrawRectangleI", "Ptr", graphics, "Ptr", pen, "Int", x, "Int", y, "Int", width, "Int", height)

    /**
     * Draws a series of rectangles.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the rectangles.
     * @param {Pointer} rects - A pointer to an array of RectF structures.
     * @param {Integer} count - The number of rectangles to draw.
     * @returns {Integer} Status code.
     */
    static DrawRectangles(graphics, pen, rects, count) => DllCall("gdiplus\GdipDrawRectangles", "Ptr", graphics, "Ptr", pen, "Ptr", rects, "Int", count)

    /**
     * Draws a series of rectangles using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the rectangles.
     * @param {Pointer} rects - A pointer to an array of Rect structures.
     * @param {Integer} count - The number of rectangles to draw.
     * @returns {Integer} Status code.
     */
    static DrawRectanglesI(graphics, pen, rects, count) => DllCall("gdiplus\GdipDrawRectanglesI", "Ptr", graphics, "Ptr", pen, "Ptr", rects, "Int", count)

    /**
     * Draws an ellipse.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the ellipse.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @returns {Integer} Status code.
     */
    static DrawEllipse(graphics, pen, x, y, width, height) => DllCall("gdiplus\GdipDrawEllipse", "Ptr", graphics, "Ptr", pen, "Float", x, "Float", y, "Float", width, "Float", height)

    /**
     * Draws an ellipse using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the ellipse.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} width - The width of the rectangle that bounds the ellipse.
     * @param {Integer} height - The height of the rectangle that bounds the ellipse.
     * @returns {Integer} Status code.
     */
    static DrawEllipseI(graphics, pen, x, y, width, height) => DllCall("gdiplus\GdipDrawEllipseI", "Ptr", graphics, "Ptr", pen, "Int", x, "Int", y, "Int", width, "Int", height)

    /**
     * Draws a pie.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the pie.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @param {Float} startAngle - The starting angle measured in degrees clockwise from the x-axis to the starting point of the pie.
     * @param {Float} sweepAngle - The angle measured in degrees clockwise from the startAngle parameter to the ending point of the pie.
     * @returns {Integer} Status code.
     */
    static DrawPie(graphics, pen, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipDrawPie", "Ptr", graphics, "Ptr", pen, "Float", x, "Float", y, "Float", width, "Float", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Draws a pie using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the pie.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Integer} width - The width of the rectangle that bounds the ellipse.
     * @param {Integer} height - The height of the rectangle that bounds the ellipse.
     * @param {Integer} startAngle - The starting angle measured in degrees clockwise from the x-axis to the starting point of the pie.
     * @param {Integer} sweepAngle - The angle measured in degrees clockwise from the startAngle parameter to the ending point of the pie.
     * @returns {Integer} Status code.
     */
    static DrawPieI(graphics, pen, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipDrawPieI", "Ptr", graphics, "Ptr", pen, "Int", x, "Int", y, "Int", width, "Int", height, "Int", startAngle, "Int", sweepAngle)

    /**
     * Draws a polygon.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the polygon.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the polygon.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static DrawPolygon(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawPolygon", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a polygon using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the polygon.
     * @param {Pointer} points - A pointer to an array of Point structures that define the polygon.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static DrawPolygonI(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawPolygonI", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a GraphicsPath object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the path.
     * @param {Pointer} path - A pointer to the GraphicsPath object to be drawn.
     * @returns {Integer} Status code.
     */
    static DrawPath(graphics, pen, path) => DllCall("gdiplus\GdipDrawPath", "Ptr", graphics, "Ptr", pen, "Ptr", path)

    /**
     * Draws a cardinal spline.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static DrawCurve(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawCurve", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a cardinal spline using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of Point structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static DrawCurveI(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawCurveI", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a cardinal spline using a tension parameter.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static DrawCurve2(graphics, pen, points, count, tension) => DllCall("gdiplus\GdipDrawCurve2", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Draws a cardinal spline using a tension parameter and integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of Point structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static DrawCurve2I(graphics, pen, points, count, tension) => DllCall("gdiplus\GdipDrawCurve2I", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Draws a cardinal spline using a tension parameter, and specifying start and end points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @param {Integer} offset - The index of the first point in the array to use in drawing the spline.
     * @param {Integer} numberOfSegments - The number of segments to include in the curve.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static DrawCurve3(graphics, pen, points, count, offset, numberOfSegments, tension) => DllCall("gdiplus\GdipDrawCurve3", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count, "Int", offset, "Int", numberOfSegments, "Float", tension)

    /**
     * Draws a cardinal spline using a tension parameter, specifying start and end points, and using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of Point structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @param {Integer} offset - The index of the first point in the array to use in drawing the spline.
     * @param {Integer} numberOfSegments - The number of segments to include in the curve.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static DrawCurve3I(graphics, pen, points, count, offset, numberOfSegments, tension) => DllCall("gdiplus\GdipDrawCurve3I", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count, "Int", offset, "Int", numberOfSegments, "Float", tension)

    /**
     * Draws a closed cardinal spline.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static DrawClosedCurve(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawClosedCurve", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a closed cardinal spline using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of Point structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static DrawClosedCurveI(graphics, pen, points, count) => DllCall("gdiplus\GdipDrawClosedCurveI", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count)

    /**
     * Draws a closed cardinal spline using a tension parameter.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static DrawClosedCurve2(graphics, pen, points, count, tension) => DllCall("gdiplus\GdipDrawClosedCurve2", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Draws a closed cardinal spline using a tension parameter and integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} pen - A pointer to a Pen object that determines the color, width, and style of the curve.
     * @param {Pointer} points - A pointer to an array of Point structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @param {Float} tension - The tension of the curve.
     * @returns {Integer} Status code.
     */
    static DrawClosedCurve2I(graphics, pen, points, count, tension) => DllCall("gdiplus\GdipDrawClosedCurve2I", "Ptr", graphics, "Ptr", pen, "Ptr", points, "Int", count, "Float", tension)

    /**
     * Clears the entire drawing surface and fills it with the specified color.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Integer} color - The color to fill the surface with.
     * @returns {Integer} Status code.
     */
    static GraphicsClear(graphics, color) => DllCall("gdiplus\GdipGraphicsClear", "Ptr", graphics, "UInt", color)

    /**
     * Fills the interior of a rectangle.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Float} width - The width of the rectangle.
     * @param {Float} height - The height of the rectangle.
     * @returns {Integer} Status code.
     */
    static FillRectangle(graphics, brush, x, y, width, height) => DllCall("gdiplus\GdipFillRectangle", "Ptr", graphics, "Ptr", brush, "Float", x, "Float", y, "Float", width, "Float", height)

    /**
     * Fills the interior of a rectangle using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} width - The width of the rectangle.
     * @param {Integer} height - The height of the rectangle.
     * @returns {Integer} Status code.
     */
    static FillRectangleI(graphics, brush, x, y, width, height) => DllCall("gdiplus\GdipFillRectangleI", "Ptr", graphics, "Ptr", brush, "Int", x, "Int", y, "Int", width, "Int", height)

    /**
     * Fills the interior of an array of rectangles.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} rects - A pointer to an array of RectF structures that specify the rectangles to fill.
     * @param {Integer} count - The number of rectangles to fill.
     * @returns {Integer} Status code.
     */
    static FillRectangles(graphics, brush, rects, count) => DllCall("gdiplus\GdipFillRectangles", "Ptr", graphics, "Ptr", brush, "Ptr", rects, "Int", count)

    /**
     * Fills the interior of an array of rectangles using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} rects - A pointer to an array of Rect structures that specify the rectangles to fill.
     * @param {Integer} count - The number of rectangles to fill.
     * @returns {Integer} Status code.
     */
    static FillRectanglesI(graphics, brush, rects, count) => DllCall("gdiplus\GdipFillRectanglesI", "Ptr", graphics, "Ptr", brush, "Ptr", rects, "Int", count)

    /**
     * Fills the interior of a polygon.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the polygon.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static FillPolygon(graphics, brush, points, count) => DllCall("gdiplus\GdipFillPolygon", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count, "Int", 0)

    /**
     * Fills the interior of a polygon using integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} points - A pointer to an array of Point structures that define the polygon.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static FillPolygonI(graphics, brush, points, count) => DllCall("gdiplus\GdipFillPolygonI", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count, "Int", 0)

    /**
     * Fills the interior of a polygon using the specified fill mode.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the polygon.
     * @param {Integer} count - The number of points in the points array.
     * @param {Integer} fillMode - The fill mode to use.
     * @returns {Integer} Status code.
     */
    static FillPolygon2(graphics, brush, points, count, fillMode) => DllCall("gdiplus\GdipFillPolygon2", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count, "Int", fillMode)

    /**
     * Fills the interior of a polygon using the specified fill mode and integer coordinates.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} points - A pointer to an array of Point structures that define the polygon.
     * @param {Integer} count - The number of points in the points array.
     * @param {Integer} fillMode - The fill mode to use.
     * @returns {Integer} Status code.
     */
    static FillPolygon2I(graphics, brush, points, count, fillMode) => DllCall("gdiplus\GdipFillPolygon2I", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count, "Int", fillMode)

    /**
     * Fills the interior of an ellipse.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @returns {Integer} Status code.
     */
    static FillEllipse(graphics, brush, x, y, width, height) => DllCall("gdiplus\GdipFillEllipse", "Ptr", graphics, "Ptr", brush, "Float", x, "Float", y, "Float", width, "Float", height)

    /**
     * Fills the interior of a pie.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle that bounds the ellipse.
     * @param {Float} width - The width of the rectangle that bounds the ellipse.
     * @param {Float} height - The height of the rectangle that bounds the ellipse.
     * @param {Float} startAngle - The starting angle measured in degrees clockwise from the x-axis to the starting point of the pie.
     * @param {Float} sweepAngle - The angle measured in degrees clockwise from the startAngle parameter to the ending point of the pie.
     * @returns {Integer} Status code.
     */
    static FillPie(graphics, brush, x, y, width, height, startAngle, sweepAngle) => DllCall("gdiplus\GdipFillPie", "Ptr", graphics, "Ptr", brush, "Float", x, "Float", y, "Float", width, "Float", height, "Float", startAngle, "Float", sweepAngle)

    /**
     * Fills the interior of a GraphicsPath object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} path - A pointer to the GraphicsPath object to be filled.
     * @returns {Integer} Status code.
     */
    static FillPath(graphics, brush, path) => DllCall("gdiplus\GdipFillPath", "Ptr", graphics, "Ptr", brush, "Ptr", path)

    /**
     * Fills the interior of a closed cardinal spline curve.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @returns {Integer} Status code.
     */
    static FillClosedCurve(graphics, brush, points, count) => DllCall("gdiplus\GdipFillClosedCurve", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count)

    /**
     * Fills the interior of a closed cardinal spline curve using the specified fill mode and tension.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the spline.
     * @param {Integer} count - The number of points in the points array.
     * @param {Float} tension - The tension of the curve.
     * @param {Integer} fillMode - The fill mode to use.
     * @returns {Integer} Status code.
     */
    static FillClosedCurve2(graphics, brush, points, count, tension, fillMode) => DllCall("gdiplus\GdipFillClosedCurve2", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count, "Float", tension, "Int", fillMode)

    /**
     * Fills the interior of a Region object.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} brush - A pointer to a Brush object that determines the characteristics of the fill.
     * @param {Pointer} region - A pointer to the Region object to be filled.
     * @returns {Integer} Status code.
     */
    static FillRegion(graphics, brush, region) => DllCall("gdiplus\GdipFillRegion", "Ptr", graphics, "Ptr", brush, "Ptr", region)

    /**
     * Draws an Image object at a specified location.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} image - A pointer to the Image object to draw.
     * @param {Float} x - The x-coordinate of the upper-left corner of the drawn image.
     * @param {Float} y - The y-coordinate of the upper-left corner of the drawn image.
     * @returns {Integer} Status code.
     */
    static DrawImage(graphics, image, x, y) => DllCall("gdiplus\GdipDrawImage", "Ptr", graphics, "Ptr", image, "Float", x, "Float", y)

    /**
     * Draws an Image object in a specified rectangle.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} image - A pointer to the Image object to draw.
     * @param {Float} x - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Float} width - The width of the rectangle.
     * @param {Float} height - The height of the rectangle.
     * @returns {Integer} Status code.
     */
    static DrawImageRect(graphics, image, x, y, width, height) => DllCall("gdiplus\GdipDrawImageRect", "Ptr", graphics, "Ptr", image, "Float", x, "Float", y, "Float", width, "Float", height)

    /**
     * Draws an Image object at a specified set of points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} image - A pointer to the Image object to draw.
     * @param {Pointer} points - A pointer to an array of three PointF structures that define a parallelogram.
     * @returns {Integer} Status code.
     */
    static DrawImagePoints(graphics, image, points) => DllCall("gdiplus\GdipDrawImagePoints", "Ptr", graphics, "Ptr", image, "Ptr", points, "Int", 3)

    /**
     * Draws a portion of an Image object at a specified location and with a specified size.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} image - A pointer to the Image object to draw.
     * @param {Float} x - The x-coordinate of the upper-left corner of the drawn image.
     * @param {Float} y - The y-coordinate of the upper-left corner of the drawn image.
     * @param {Float} srcx - The x-coordinate of the upper-left corner of the portion of the source image to draw.
     * @param {Float} srcy - The y-coordinate of the upper-left corner of the portion of the source image to draw.
     * @param {Float} srcwidth - The width of the portion of the source image to draw.
     * @param {Float} srcheight - The height of the portion of the source image to draw.
     * @param {Integer} srcUnit - The unit of measure used for the source rectangle.
     * @returns {Integer} Status code.
     */
    static DrawImagePointRect(graphics, image, x, y, srcx, srcy, srcwidth, srcheight, srcUnit) => DllCall("gdiplus\GdipDrawImagePointRect", "Ptr", graphics, "Ptr", image, "Float", x, "Float", y, "Float", srcx, "Float", srcy, "Float", srcwidth, "Float", srcheight, "Int", srcUnit)

    /**
     * Draws a portion of an Image object in a specified rectangle.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} image - A pointer to the Image object to draw.
     * @param {Float} dstx - The x-coordinate of the upper-left corner of the destination rectangle.
     * @param {Float} dsty - The y-coordinate of the upper-left corner of the destination rectangle.
     * @param {Float} dstwidth - The width of the destination rectangle.
     * @param {Float} dstheight - The height of the destination rectangle.
     * @param {Float} srcx - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcy - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Float} srcwidth - The width of the source rectangle.
     * @param {Float} srcheight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure used for the source rectangle.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies recoloring and gamma information.
     * @param {Pointer} callback - A pointer to a callback function that specifies a color key.
     * @param {Pointer} callbackData - A pointer to a value that is passed to the callback function.
     * @returns {Integer} Status code.
     */
    static DrawImageRectRect(graphics, image, dstx, dsty, dstwidth, dstheight, srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes := 0, callback := 0, callbackData := 0) => DllCall("gdiplus\GdipDrawImageRectRect", "Ptr", graphics, "Ptr", image, "Float", dstx, "Float", dsty, "Float", dstwidth, "Float", dstheight, "Float", srcx, "Float", srcy, "Float", srcwidth, "Float", srcheight, "Int", srcUnit, "Ptr", imageAttributes, "Ptr", callback, "Ptr", callbackData)

    /**
     * Draws a portion of an Image object at a specified set of points.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} image - A pointer to the Image object to draw.
     * @param {Pointer} points - A pointer to an array of three PointF structures that define a parallelogram.
     * @param {Float} srcx - The x-coordinate of the upper-left corner of the portion of the source image to draw.
     * @param {Float} srcy - The y-coordinate of the upper-left corner of the portion of the source image to draw.
     * @param {Float} srcwidth - The width of the portion of the source image to draw.
     * @param {Float} srcheight - The height of the portion of the source image to draw.
     * @param {Integer} srcUnit - The unit of measure used for the source rectangle.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies recoloring and gamma information.
     * @param {Pointer} callback - A pointer to a callback function that specifies a color key.
     * @param {Pointer} callbackData - A pointer to a value that is passed to the callback function.
     * @returns {Integer} Status code.
     */
    static DrawImagePointsRect(graphics, image, points, srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes := 0, callback := 0, callbackData := 0) => DllCall("gdiplus\GdipDrawImagePointsRect", "Ptr", graphics, "Ptr", image, "Ptr", points, "Int", 3, "Float", srcx, "Float", srcy, "Float", srcwidth, "Float", srcheight, "Int", srcUnit, "Ptr", imageAttributes, "Ptr", callback, "Ptr", callbackData)

    /**
     * Draws an image using a specified effect.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} image - A pointer to the Image object to draw.
     * @param {Pointer} srcRect - A pointer to a RectF structure that specifies the portion of the image to draw.
     * @param {Pointer} xForm - A pointer to a matrix that specifies a geometric transform to apply to the image.
     * @param {Pointer} effect - A pointer to an effect object that specifies the effect to apply to the image.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object that specifies image attribute information.
     * @param {Integer} srcUnit - The unit of measure used for the source rectangle.
     * @returns {Integer} Status code.
     */
    static DrawImageFX(graphics, image, srcRect, xForm, effect, imageAttributes, srcUnit) => DllCall("gdiplus\GdipDrawImageFX", "Ptr", graphics, "Ptr", image, "Ptr", srcRect, "Ptr", xForm, "Ptr", effect, "Ptr", imageAttributes, "Int", srcUnit)

    /**
     * Draws a string.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {String} string - The string to draw.
     * @param {Integer} length - The length of the string.
     * @param {Pointer} font - A pointer to the Font object to use.
     * @param {Pointer} layoutRect - A pointer to a RectF structure that bounds the string.
     * @param {Pointer} stringFormat - A pointer to a StringFormat object that specifies formatting attributes.
     * @param {Pointer} brush - A pointer to the Brush object to use.
     * @returns {Integer} Status code.
     */
    static DrawString(graphics, string, length, font, layoutRect, stringFormat, brush) => DllCall("gdiplus\GdipDrawString", "Ptr", graphics, "WStr", string, "Int", length, "Ptr", font, "Ptr", layoutRect, "Ptr", stringFormat, "Ptr", brush)

    /**
     * Measures the extent of a string.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {String} string - The string to measure.
     * @param {Integer} length - The length of the string.
     * @param {Pointer} font - A pointer to the Font object to use.
     * @param {Pointer} layoutRect - A pointer to a RectF structure that bounds the string.
     * @param {Pointer} stringFormat - A pointer to a StringFormat object that specifies formatting attributes.
     * @param {Pointer} boundingBox - A pointer to a RectF structure that receives the bounding rectangle.
     * @param {Pointer} codepointsFitted - A pointer to an integer that receives the number of characters that fit in the layout rectangle.
     * @param {Pointer} linesFilled - A pointer to an integer that receives the number of lines that fit in the layout rectangle.
     * @returns {Integer} Status code.
     */
    static MeasureString(graphics, string, length, font, layoutRect, stringFormat, boundingBox, codepointsFitted, linesFilled) => DllCall("gdiplus\GdipMeasureString", "Ptr", graphics, "WStr", string, "Int", length, "Ptr", font, "Ptr", layoutRect, "Ptr", stringFormat, "Ptr", boundingBox, "Ptr", codepointsFitted, "Ptr", linesFilled)

    /**
     * Measures the extent of each of a series of character ranges.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {String} string - The string to measure.
     * @param {Integer} length - The length of the string.
     * @param {Pointer} font - A pointer to the Font object to use.
     * @param {Pointer} layoutRect - A pointer to a RectF structure that bounds the string.
     * @param {Pointer} stringFormat - A pointer to a StringFormat object that specifies formatting attributes.
     * @param {Integer} characterCount - The number of character ranges to measure.
     * @param {Pointer} regions - A pointer to an array of Region objects that receive the measurements.
     * @returns {Integer} Status code.
     */
    static MeasureCharacterRanges(graphics, string, length, font, layoutRect, stringFormat, characterCount, regions) => DllCall("gdiplus\GdipMeasureCharacterRanges", "Ptr", graphics, "WStr", string, "Int", length, "Ptr", font, "Ptr", layoutRect, "Ptr", stringFormat, "Int", characterCount, "Ptr", regions)

    /**
     * Draws a string using a specified driver string format.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} text - A pointer to an array of 16-bit Unicode characters.
     * @param {Integer} length - The number of characters in the array.
     * @param {Pointer} font - A pointer to the Font object to use.
     * @param {Pointer} brush - A pointer to the Brush object to use.
     * @param {Pointer} positions - A pointer to an array of PointF structures that specify the positions of the characters.
     * @param {Integer} flags - A value that specifies the string format.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transform to apply to the string.
     * @returns {Integer} Status code.
     */
    static DrawDriverString(graphics, text, length, font, brush, positions, flags, matrix) => DllCall("gdiplus\GdipDrawDriverString", "Ptr", graphics, "Ptr", text, "Int", length, "Ptr", font, "Ptr", brush, "Ptr", positions, "Int", flags, "Ptr", matrix)

    /**
     * Measures the extent of a string using a specified driver string format.
     * @param {Pointer} graphics - A pointer to the Graphics object.
     * @param {Pointer} text - A pointer to an array of 16-bit Unicode characters.
     * @param {Integer} length - The number of characters in the array.
     * @param {Pointer} font - A pointer to the Font object to use.
     * @param {Pointer} positions - A pointer to an array of PointF structures that specify the positions of the characters.
     * @param {Integer} flags - A value that specifies the string format.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies a transform to apply to the string.
     * @param {Pointer} boundingBox - A pointer to a RectF structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static MeasureDriverString(graphics, text, length, font, positions, flags, matrix, boundingBox) => DllCall("gdiplus\GdipMeasureDriverString", "Ptr", graphics, "Ptr", text, "Int", length, "Ptr", font, "Ptr", positions, "Int", flags, "Ptr", matrix, "Ptr", boundingBox)

    /**
     * Creates a Brush object based on a color.
     * @param {Integer} color - The color of the brush.
     * @param {Ptr*} brush - A pointer to a variable that receives the brush object.
     * @returns {Integer} Status code.
     */
    static CreateSolidFill(color, brush) => DllCall("gdiplus\GdipCreateSolidFill", "UInt", color, "Ptr*", brush)

    /**
     * Sets the color of a SolidBrush object.
     * @param {Pointer} brush - A pointer to the SolidBrush object.
     * @param {Integer} color - The color to set.
     * @returns {Integer} Status code.
     */
    static SetSolidFillColor(brush, color) => DllCall("gdiplus\GdipSetSolidFillColor", "Ptr", brush, "UInt", color)

    /**
     * Gets the color of a SolidBrush object.
     * @param {Pointer} brush - A pointer to the SolidBrush object.
     * @param {Ptr*} color - A pointer to a variable that receives the color.
     * @returns {Integer} Status code.
     */
    static GetSolidFillColor(brush, color) => DllCall("gdiplus\GdipGetSolidFillColor", "Ptr", brush, "Ptr*", color)

    /**
     * Creates a TextureBrush object based on an image.
     * @param {Pointer} image - A pointer to an Image object that specifies the texture.
     * @param {Integer} wrapMode - The wrap mode for the texture.
     * @param {Ptr*} texture - A pointer to a variable that receives the TextureBrush object.
     * @returns {Integer} Status code.
     */
    static CreateTexture(image, wrapMode, texture) => DllCall("gdiplus\GdipCreateTexture", "Ptr", image, "Int", wrapMode, "Ptr*", texture)

    /**
     * Creates a TextureBrush object based on an image and a bounding rectangle.
     * @param {Pointer} image - A pointer to an Image object that specifies the texture.
     * @param {Integer} wrapMode - The wrap mode for the texture.
     * @param {Float} x - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Float} width - The width of the bounding rectangle.
     * @param {Float} height - The height of the bounding rectangle.
     * @param {Ptr*} texture - A pointer to a variable that receives the TextureBrush object.
     * @returns {Integer} Status code.
     */
    static CreateTexture2(image, wrapMode, x, y, width, height, texture) => DllCall("gdiplus\GdipCreateTexture2", "Ptr", image, "Int", wrapMode, "Float", x, "Float", y, "Float", width, "Float", height, "Ptr*", texture)

    /**
     * Creates a TextureBrush object based on an image, a bounding rectangle, and an image attributes object.
     * @param {Pointer} image - A pointer to an Image object that specifies the texture.
     * @param {Pointer} imageAttributes - A pointer to an ImageAttributes object.
     * @param {Float} x - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Float} y - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Float} width - The width of the bounding rectangle.
     * @param {Float} height - The height of the bounding rectangle.
     * @param {Ptr*} texture - A pointer to a variable that receives the TextureBrush object.
     * @returns {Integer} Status code.
     */
    static CreateTextureIA(image, imageAttributes, x, y, width, height, texture) => DllCall("gdiplus\GdipCreateTextureIA", "Ptr", image, "Ptr", imageAttributes, "Float", x, "Float", y, "Float", width, "Float", height, "Ptr*", texture)

    /**
     * Creates a LinearGradientBrush object.
     * @param {Pointer} point1 - A pointer to a PointF structure that specifies the starting point of the linear gradient.
     * @param {Pointer} point2 - A pointer to a PointF structure that specifies the endpoint of the linear gradient.
     * @param {Integer} color1 - The starting color for the gradient.
     * @param {Integer} color2 - The ending color for the gradient.
     * @param {Ptr*} lineGradient - A pointer to a variable that receives the LinearGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreateLineBrush(point1, point2, color1, color2, lineGradient) => DllCall("gdiplus\GdipCreateLineBrush", "Ptr", point1, "Ptr", point2, "UInt", color1, "UInt", color2, "Ptr*", lineGradient)

    /**
     * Creates a LinearGradientBrush object based on a rectangle.
     * @param {Pointer} rect - A pointer to a RectF structure that specifies the boundary rectangle for the linear gradient.
     * @param {Integer} color1 - The starting color for the gradient.
     * @param {Integer} color2 - The ending color for the gradient.
     * @param {Integer} mode - The mode that specifies how to use color1 and color2 to create the gradient.
     * @param {Ptr*} lineGradient - A pointer to a variable that receives the LinearGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreateLineBrushFromRect(rect, color1, color2, mode, lineGradient) => DllCall("gdiplus\GdipCreateLineBrushFromRect", "Ptr", rect, "UInt", color1, "UInt", color2, "Int", mode, "Ptr*", lineGradient)

    /**
     * Creates a LinearGradientBrush object based on a rectangle and an angle of rotation.
     * @param {Pointer} rect - A pointer to a RectF structure that specifies the boundary rectangle for the linear gradient.
     * @param {Integer} color1 - The starting color for the gradient.
     * @param {Integer} color2 - The ending color for the gradient.
     * @param {Float} angle - The angle, in degrees, of rotation of the gradient.
     * @param {Integer} isAngleScalable - Specifies whether the angle is affected by the transform of the brush.
     * @param {Ptr*} lineGradient - A pointer to a variable that receives the LinearGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreateLineBrushFromRectWithAngle(rect, color1, color2, angle, isAngleScalable, lineGradient) => DllCall("gdiplus\GdipCreateLineBrushFromRectWithAngle", "Ptr", rect, "UInt", color1, "UInt", color2, "Float", angle, "Int", isAngleScalable, "Ptr*", lineGradient)

    /**
     * Sets the starting and ending colors of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Integer} color1 - The starting color for the gradient.
     * @param {Integer} color2 - The ending color for the gradient.
     * @returns {Integer} Status code.
     */
    static SetLineColors(brush, color1, color2) => DllCall("gdiplus\GdipSetLineColors", "Ptr", brush, "UInt", color1, "UInt", color2)

    /**
     * Gets the starting and ending colors of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr*} color1 - A pointer to a variable that receives the starting color.
     * @param {Ptr*} color2 - A pointer to a variable that receives the ending color.
     * @returns {Integer} Status code.
     */
    static GetLineColors(brush, color1, color2) => DllCall("gdiplus\GdipGetLineColors", "Ptr", brush, "Ptr", color1, "Ptr", color2)

    /**
     * Gets the bounding rectangle of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr} rect - A pointer to a RectF structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetLineRect(brush, rect) => DllCall("gdiplus\GdipGetLineRect", "Ptr", brush, "Ptr", rect)

    /**
     * Sets the gamma correction value for a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Integer} useGammaCorrection - Specifies whether gamma correction is enabled.
     * @returns {Integer} Status code.
     */
    static SetLineGammaCorrection(brush, useGammaCorrection) => DllCall("gdiplus\GdipSetLineGammaCorrection", "Ptr", brush, "Int", useGammaCorrection)

    /**
     * Gets the gamma correction value of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr*} useGammaCorrection - A pointer to a variable that receives the gamma correction state.
     * @returns {Integer} Status code.
     */
    static GetLineGammaCorrection(brush, useGammaCorrection) => DllCall("gdiplus\GdipGetLineGammaCorrection", "Ptr", brush, "Ptr", useGammaCorrection)

    /**
     * Gets the number of blend factors currently set for a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr*} count - A pointer to a variable that receives the blend count.
     * @returns {Integer} Status code.
     */
    static GetLineBlendCount(brush, count) => DllCall("gdiplus\GdipGetLineBlendCount", "Ptr", brush, "Ptr", count)

    /**
     * Gets the blend factors and their corresponding blend positions from a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr} blend - A pointer to an array that receives the blend factors.
     * @param {Ptr} positions - A pointer to an array that receives the blend positions.
     * @param {Integer} count - The number of elements in the blend and positions arrays.
     * @returns {Integer} Status code.
     */
    static GetLineBlend(brush, blend, positions, count) => DllCall("gdiplus\GdipGetLineBlend", "Ptr", brush, "Ptr", blend, "Ptr", positions, "Int", count)

    /**
     * Sets the blend factors and their corresponding blend positions for a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr} blend - A pointer to an array of blend factors.
     * @param {Ptr} positions - A pointer to an array of blend positions.
     * @param {Integer} count - The number of elements in the blend and positions arrays.
     * @returns {Integer} Status code.
     */
    static SetLineBlend(brush, blend, positions, count) => DllCall("gdiplus\GdipSetLineBlend", "Ptr", brush, "Ptr", blend, "Ptr", positions, "Int", count)

    /**
     * Gets the number of preset colors currently set for a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr*} count - A pointer to a variable that receives the preset color count.
     * @returns {Integer} Status code.
     */
    static GetLinePresetBlendCount(brush, count) => DllCall("gdiplus\GdipGetLinePresetBlendCount", "Ptr", brush, "Ptr", count)

    /**
     * Gets the preset colors and their corresponding blend positions from a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr} blend - A pointer to an array that receives the preset colors.
     * @param {Ptr} positions - A pointer to an array that receives the blend positions.
     * @param {Integer} count - The number of elements in the blend and positions arrays.
     * @returns {Integer} Status code.
     */
    static GetLinePresetBlend(brush, blend, positions, count) => DllCall("gdiplus\GdipGetLinePresetBlend", "Ptr", brush, "Ptr", blend, "Ptr", positions, "Int", count)

    /**
     * Sets the preset colors and their corresponding blend positions for a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr} blend - A pointer to an array of preset colors.
     * @param {Ptr} positions - A pointer to an array of blend positions.
     * @param {Integer} count - The number of elements in the blend and positions arrays.
     * @returns {Integer} Status code.
     */
    static SetLinePresetBlend(brush, blend, positions, count) => DllCall("gdiplus\GdipSetLinePresetBlend", "Ptr", brush, "Ptr", blend, "Ptr", positions, "Int", count)

    /**
     * Sets the blend shape of a LinearGradientBrush object to create a bell-shaped curve.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Float} focus - The focus value for the bell shape.
     * @param {Float} scale - The scale value for the bell shape.
     * @returns {Integer} Status code.
     */
    static SetLineSigmaBlend(brush, focus, scale) => DllCall("gdiplus\GdipSetLineSigmaBlend", "Ptr", brush, "Float", focus, "Float", scale)

    /**
     * Sets the blend shape of a LinearGradientBrush object to create a triangular shape.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Float} focus - The focus value for the triangular shape.
     * @param {Float} scale - The scale value for the triangular shape.
     * @returns {Integer} Status code.
     */
    static SetLineLinearBlend(brush, focus, scale) => DllCall("gdiplus\GdipSetLineLinearBlend", "Ptr", brush, "Float", focus, "Float", scale)

    /**
     * Sets the wrap mode of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Integer} wrapMode - The wrap mode to set.
     * @returns {Integer} Status code.
     */
    static SetLineWrapMode(brush, wrapMode) => DllCall("gdiplus\GdipSetLineWrapMode", "Ptr", brush, "Int", wrapMode)

    /**
     * Gets the wrap mode of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Ptr*} wrapMode - A pointer to a variable that receives the wrap mode.
     * @returns {Integer} Status code.
     */
    static GetLineWrapMode(brush, wrapMode) => DllCall("gdiplus\GdipGetLineWrapMode", "Ptr", brush, "Ptr", wrapMode)

    /**
     * Gets the transformation matrix of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Pointer} matrix - A pointer to a Matrix object that receives the transformation matrix.
     * @returns {Integer} Status code.
     */
    static GetLineTransform(brush, matrix) => DllCall("gdiplus\GdipGetLineTransform", "Ptr", brush, "Ptr", matrix)

    /**
     * Sets the transformation matrix of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @returns {Integer} Status code.
     */
    static SetLineTransform(brush, matrix) => DllCall("gdiplus\GdipSetLineTransform", "Ptr", brush, "Ptr", matrix)

    /**
     * Resets the transformation matrix of a LinearGradientBrush object to the identity matrix.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @returns {Integer} Status code.
     */
    static ResetLineTransform(brush) => DllCall("gdiplus\GdipResetLineTransform", "Ptr", brush)

    /**
     * Multiplies the transformation matrix of a LinearGradientBrush object by another matrix.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the matrix to multiply by.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static MultiplyLineTransform(brush, matrix, order) => DllCall("gdiplus\GdipMultiplyLineTransform", "Ptr", brush, "Ptr", matrix, "Int", order)

    /**
     * Translates the transformation matrix of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Float} dx - The amount to translate along the x-axis.
     * @param {Float} dy - The amount to translate along the y-axis.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static TranslateLineTransform(brush, dx, dy, order) => DllCall("gdiplus\GdipTranslateLineTransform", "Ptr", brush, "Float", dx, "Float", dy, "Int", order)

    /**
     * Scales the transformation matrix of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Float} sx - The amount to scale along the x-axis.
     * @param {Float} sy - The amount to scale along the y-axis.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static ScaleLineTransform(brush, sx, sy, order) => DllCall("gdiplus\GdipScaleLineTransform", "Ptr", brush, "Float", sx, "Float", sy, "Int", order)

    /**
     * Rotates the transformation matrix of a LinearGradientBrush object.
     * @param {Pointer} brush - A pointer to the LinearGradientBrush object.
     * @param {Float} angle - The rotation angle in degrees.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static RotateLineTransform(brush, angle, order) => DllCall("gdiplus\GdipRotateLineTransform", "Ptr", brush, "Float", angle, "Int", order)

    /**
     * Creates a HatchBrush object.
     * @param {Integer} hatchStyle - The hatch style.
     * @param {Integer} foreColor - The foreground color of the hatch pattern.
     * @param {Integer} backColor - The background color of the hatch pattern.
     * @param {Ptr*} brush - A pointer to a variable that receives the HatchBrush object.
     * @returns {Integer} Status code.
     */
    static CreateHatchBrush(hatchStyle, foreColor, backColor, brush) => DllCall("gdiplus\GdipCreateHatchBrush", "Int", hatchStyle, "UInt", foreColor, "UInt", backColor, "Ptr*", brush)

    /**
     * Gets the hatch style of a HatchBrush object.
     * @param {Pointer} brush - A pointer to the HatchBrush object.
     * @param {Ptr*} hatchStyle - A pointer to a variable that receives the hatch style.
     * @returns {Integer} Status code.
     */
    static GetHatchStyle(brush, hatchStyle) => DllCall("gdiplus\GdipGetHatchStyle", "Ptr", brush, "Ptr", hatchStyle)

    /**
     * Gets the foreground color of a HatchBrush object.
     * @param {Pointer} brush - A pointer to the HatchBrush object.
     * @param {Ptr*} foreColor - A pointer to a variable that receives the foreground color.
     * @returns {Integer} Status code.
     */
    static GetHatchForegroundColor(brush, foreColor) => DllCall("gdiplus\GdipGetHatchForegroundColor", "Ptr", brush, "Ptr", foreColor)

    /**
     * Gets the background color of a HatchBrush object.
     * @param {Pointer} brush - A pointer to the HatchBrush object.
     * @param {Ptr*} backColor - A pointer to a variable that receives the background color.
     * @returns {Integer} Status code.
     */
    static GetHatchBackgroundColor(brush, backColor) => DllCall("gdiplus\GdipGetHatchBackgroundColor", "Ptr", brush, "Ptr", backColor)

    /**
     * Creates a PathGradientBrush object based on an array of points.
     * @param {Pointer} points - A pointer to an array of PointF structures that define the brush's boundary path.
     * @param {Integer} count - The number of points in the points array.
     * @param {Integer} wrapMode - The wrap mode for the brush.
     * @param {Ptr*} brush - A pointer to a variable that receives the PathGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreatePathGradient(points, count, wrapMode, brush) => DllCall("gdiplus\GdipCreatePathGradient", "Ptr", points, "Int", count, "Int", wrapMode, "Ptr*", brush)

    /**
     * Creates a PathGradientBrush object based on a GraphicsPath object.
     * @param {Pointer} path - A pointer to a GraphicsPath object that defines the brush's boundary path.
     * @param {Ptr*} brush - A pointer to a variable that receives the PathGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreatePathGradientFromPath(path, brush) => DllCall("gdiplus\GdipCreatePathGradientFromPath", "Ptr", path, "Ptr*", brush)

    /**
     * Gets the center point of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} points - A pointer to a PointF structure that receives the center point.
     * @returns {Integer} Status code.
     */
    static GetPathGradientCenterPoint(brush, points) => DllCall("gdiplus\GdipGetPathGradientCenterPoint", "Ptr", brush, "Ptr", points)

    /**
     * Sets the center point of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} points - A pointer to a PointF structure that specifies the new center point.
     * @returns {Integer} Status code.
     */
    static SetPathGradientCenterPoint(brush, points) => DllCall("gdiplus\GdipSetPathGradientCenterPoint", "Ptr", brush, "Ptr", points)

    /**
     * Gets the bounding rectangle of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} rect - A pointer to a RectF structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetPathGradientRect(brush, rect) => DllCall("gdiplus\GdipGetPathGradientRect", "Ptr", brush, "Ptr", rect)

    /**
     * Gets the number of points in the boundary path of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Ptr*} count - A pointer to a variable that receives the point count.
     * @returns {Integer} Status code.
     */
    static GetPathGradientPointCount(brush, count) => DllCall("gdiplus\GdipGetPathGradientPointCount", "Ptr", brush, "Ptr", count)

    /**
     * Gets the number of colors specified for the surround color of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Ptr*} count - A pointer to a variable that receives the color count.
     * @returns {Integer} Status code.
     */
    static GetPathGradientSurroundColorCount(brush, count) => DllCall("gdiplus\GdipGetPathGradientSurroundColorCount", "Ptr", brush, "Ptr", count)

    /**
     * Sets the surround colors of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} color - A pointer to an array of colors to set as the surround colors.
     * @param {Ptr*} count - A pointer to the number of colors in the color array.
     * @returns {Integer} Status code.
     */
    static SetPathGradientSurroundColorsWithCount(brush, color, count) => DllCall("gdiplus\GdipSetPathGradientSurroundColorsWithCount", "Ptr", brush, "Ptr", color, "Ptr", count)

    /**
     * Gets the surround colors of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} color - A pointer to an array that receives the surround colors.
     * @param {Ptr*} count - A pointer to a variable that specifies the number of colors to retrieve and receives the actual number retrieved.
     * @returns {Integer} Status code.
     */
    static GetPathGradientSurroundColorsWithCount(brush, color, count) => DllCall("gdiplus\GdipGetPathGradientSurroundColorsWithCount", "Ptr", brush, "Ptr", color, "Ptr", count)

    /**
     * Sets the center color of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Integer} color - The color to set as the center color.
     * @returns {Integer} Status code.
     */
    static SetPathGradientCenterColor(brush, color) => DllCall("gdiplus\GdipSetPathGradientCenterColor", "Ptr", brush, "UInt", color)

    /**
     * Gets the center color of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Ptr*} color - A pointer to a variable that receives the center color.
     * @returns {Integer} Status code.
     */
    static GetPathGradientCenterColor(brush, color) => DllCall("gdiplus\GdipGetPathGradientCenterColor", "Ptr", brush, "Ptr", color)

    /**
     * Gets the focus scales of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Ptr*} xScale - A pointer to a variable that receives the x-axis focus scale.
     * @param {Ptr*} yScale - A pointer to a variable that receives the y-axis focus scale.
     * @returns {Integer} Status code.
     */
    static GetPathGradientFocusScales(brush, xScale, yScale) => DllCall("gdiplus\GdipGetPathGradientFocusScales", "Ptr", brush, "Ptr", xScale, "Ptr", yScale)

    /**
     * Sets the focus scales of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Float} xScale - The x-axis focus scale to set.
     * @param {Float} yScale - The y-axis focus scale to set.
     * @returns {Integer} Status code.
     */
    static SetPathGradientFocusScales(brush, xScale, yScale) => DllCall("gdiplus\GdipSetPathGradientFocusScales", "Ptr", brush, "Float", xScale, "Float", yScale)

    /**
     * Gets the number of preset colors in a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Ptr*} count - A pointer to a variable that receives the count of preset colors.
     * @returns {Integer} Status code.
     */
    static GetPathGradientPresetBlendCount(brush, count) => DllCall("gdiplus\GdipGetPathGradientPresetBlendCount", "Ptr", brush, "Ptr", count)

    /**
     * Gets the preset colors and blend positions of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} blend - A pointer to an array that receives the preset colors.
     * @param {Pointer} positions - A pointer to an array that receives the blend positions.
     * @param {Integer} count - The number of colors and positions to retrieve.
     * @returns {Integer} Status code.
     */
    static GetPathGradientPresetBlend(brush, blend, positions, count) => DllCall("gdiplus\GdipGetPathGradientPresetBlend", "Ptr", brush, "Ptr", blend, "Ptr", positions, "Int", count)

    /**
     * Sets the preset colors and blend positions of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} blend - A pointer to an array of colors to set.
     * @param {Pointer} positions - A pointer to an array of blend positions to set.
     * @param {Integer} count - The number of colors and positions to set.
     * @returns {Integer} Status code.
     */
    static SetPathGradientPresetBlend(brush, blend, positions, count) => DllCall("gdiplus\GdipSetPathGradientPresetBlend", "Ptr", brush, "Ptr", blend, "Ptr", positions, "Int", count)

    /**
     * Sets a PathGradientBrush object's blend to create a bell-shaped curve.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Float} focus - The focus value for the bell shape.
     * @param {Float} scale - The scale value for the bell shape.
     * @returns {Integer} Status code.
     */
    static SetPathGradientSigmaBlend(brush, focus, scale) => DllCall("gdiplus\GdipSetPathGradientSigmaBlend", "Ptr", brush, "Float", focus, "Float", scale)

    /**
     * Sets a PathGradientBrush object's blend to create a triangular shape.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Float} focus - The focus value for the triangular shape.
     * @param {Float} scale - The scale value for the triangular shape.
     * @returns {Integer} Status code.
     */
    static SetPathGradientLinearBlend(brush, focus, scale) => DllCall("gdiplus\GdipSetPathGradientLinearBlend", "Ptr", brush, "Float", focus, "Float", scale)

    /**
     * Gets the wrap mode of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Ptr*} wrapMode - A pointer to a variable that receives the wrap mode.
     * @returns {Integer} Status code.
     */
    static GetPathGradientWrapMode(brush, wrapMode) => DllCall("gdiplus\GdipGetPathGradientWrapMode", "Ptr", brush, "Ptr", wrapMode)

    /**
     * Sets the wrap mode of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Integer} wrapMode - The wrap mode to set.
     * @returns {Integer} Status code.
     */
    static SetPathGradientWrapMode(brush, wrapMode) => DllCall("gdiplus\GdipSetPathGradientWrapMode", "Ptr", brush, "Int", wrapMode)

    /**
     * Gets the transformation matrix of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} matrix - A pointer to a Matrix object that receives the transformation matrix.
     * @returns {Integer} Status code.
     */
    static GetPathGradientTransform(brush, matrix) => DllCall("gdiplus\GdipGetPathGradientTransform", "Ptr", brush, "Ptr", matrix)

    /**
     * Sets the transformation matrix of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @returns {Integer} Status code.
     */
    static SetPathGradientTransform(brush, matrix) => DllCall("gdiplus\GdipSetPathGradientTransform", "Ptr", brush, "Ptr", matrix)

    /**
     * Resets the transformation matrix of a PathGradientBrush object to the identity matrix.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @returns {Integer} Status code.
     */
    static ResetPathGradientTransform(brush) => DllCall("gdiplus\GdipResetPathGradientTransform", "Ptr", brush)

    /**
     * Multiplies the transformation matrix of a PathGradientBrush object by another matrix.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the matrix to multiply by.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static MultiplyPathGradientTransform(brush, matrix, order) => DllCall("gdiplus\GdipMultiplyPathGradientTransform", "Ptr", brush, "Ptr", matrix, "Int", order)

    /**
     * Translates the transformation matrix of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Float} dx - The amount to translate along the x-axis.
     * @param {Float} dy - The amount to translate along the y-axis.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static TranslatePathGradientTransform(brush, dx, dy, order) => DllCall("gdiplus\GdipTranslatePathGradientTransform", "Ptr", brush, "Float", dx, "Float", dy, "Int", order)

    /**
     * Scales the transformation matrix of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Float} sx - The amount to scale along the x-axis.
     * @param {Float} sy - The amount to scale along the y-axis.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static ScalePathGradientTransform(brush, sx, sy, order) => DllCall("gdiplus\GdipScalePathGradientTransform", "Ptr", brush, "Float", sx, "Float", sy, "Int", order)

    /**
     * Rotates the transformation matrix of a PathGradientBrush object.
     * @param {Pointer} brush - A pointer to the PathGradientBrush object.
     * @param {Float} angle - The rotation angle in degrees.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static RotatePathGradientTransform(brush, angle, order) => DllCall("gdiplus\GdipRotatePathGradientTransform", "Ptr", brush, "Float", angle, "Int", order)

    /**
     * Creates a Pen object that uses a specified color and width.
     * @param {Integer} color - The color of the pen.
     * @param {Float} width - The width of the pen.
     * @param {Integer} unit - The unit of measure for the pen width.
     * @param {Ptr*} pen - A pointer to a variable that receives the Pen object.
     * @returns {Integer} Status code.
     */
    static CreatePen1(color, width, unit, pen) => DllCall("gdiplus\GdipCreatePen1", "UInt", color, "Float", width, "Int", unit, "Ptr*", pen)

    /**
     * Creates a Pen object that uses a specified brush and width.
     * @param {Pointer} brush - A pointer to the Brush object to use.
     * @param {Float} width - The width of the pen.
     * @param {Integer} unit - The unit of measure for the pen width.
     * @param {Ptr*} pen - A pointer to a variable that receives the Pen object.
     * @returns {Integer} Status code.
     */
    static CreatePen2(brush, width, unit, pen) => DllCall("gdiplus\GdipCreatePen2", "Ptr", brush, "Float", width, "Int", unit, "Ptr*", pen)

    /**
     * Creates a copy of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object to clone.
     * @param {Ptr*} clonepen - A pointer to a variable that receives the cloned Pen object.
     * @returns {Integer} Status code.
     */
    static ClonePen(pen, clonepen) => DllCall("gdiplus\GdipClonePen", "Ptr", pen, "Ptr*", clonepen)

    /**
     * Deletes a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object to delete.
     * @returns {Integer} Status code.
     */
    static DeletePen(pen) => DllCall("gdiplus\GdipDeletePen", "Ptr", pen)

    /**
     * Sets the width of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Float} width - The width to set.
     * @returns {Integer} Status code.
     */
    static SetPenWidth(pen, width) => DllCall("gdiplus\GdipSetPenWidth", "Ptr", pen, "Float", width)

    /**
     * Gets the width of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} width - A pointer to a variable that receives the width.
     * @returns {Integer} Status code.
     */
    static GetPenWidth(pen, &width) => DllCall("gdiplus\GdipGetPenWidth", "Ptr", pen, "float*", &width)

    /**
     * Sets the unit of measure for a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} unit - The unit of measure to set.
     * @returns {Integer} Status code.
     */
    static SetPenUnit(pen, unit) => DllCall("gdiplus\GdipSetPenUnit", "Ptr", pen, "Int", unit)

    /**
     * Gets the unit of measure for a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} unit - A pointer to a variable that receives the unit of measure.
     * @returns {Integer} Status code.
     */
    static GetPenUnit(pen, unit) => DllCall("gdiplus\GdipGetPenUnit", "Ptr", pen, "Ptr", unit)

    /**
     * Sets the line cap style for the start, end, and dash of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} startCap - The line cap style for the start of a line.
     * @param {Integer} endCap - The line cap style for the end of a line.
     * @param {Integer} dashCap - The line cap style for a dash in a dashed line.
     * @returns {Integer} Status code.
     */
    static SetPenLineCap197819(pen, startCap, endCap, dashCap) => DllCall("gdiplus\GdipSetPenLineCap197819", "Ptr", pen, "Int", startCap, "Int", endCap, "Int", dashCap)

    /**
     * Sets the line cap style for the start of a line drawn with a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} startCap - The line cap style to set.
     * @returns {Integer} Status code.
     */
    static SetPenStartCap(pen, startCap) => DllCall("gdiplus\GdipSetPenStartCap", "Ptr", pen, "Int", startCap)

    /**
     * Sets the line cap style for the end of a line drawn with a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} endCap - The line cap style to set.
     * @returns {Integer} Status code.
     */
    static SetPenEndCap(pen, endCap) => DllCall("gdiplus\GdipSetPenEndCap", "Ptr", pen, "Int", endCap)

    /**
     * Sets the line cap style for a dash in a dashed line drawn with a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} dashCap - The line cap style to set.
     * @returns {Integer} Status code.
     */
    static SetPenDashCap197819(pen, dashCap) => DllCall("gdiplus\GdipSetPenDashCap197819", "Ptr", pen, "Int", dashCap)

    /**
     * Gets the line cap style for the start of a line drawn with a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} startCap - A pointer to a variable that receives the line cap style.
     * @returns {Integer} Status code.
     */
    static GetPenStartCap(pen, startCap) => DllCall("gdiplus\GdipGetPenStartCap", "Ptr", pen, "Ptr", startCap)

    /**
     * Gets the line cap style for the end of a line drawn with a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} endCap - A pointer to a variable that receives the line cap style.
     * @returns {Integer} Status code.
     */
    static GetPenEndCap(pen, endCap) => DllCall("gdiplus\GdipGetPenEndCap", "Ptr", pen, "Ptr", endCap)

    /**
     * Gets the line cap style for a dash in a dashed line drawn with a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} dashCap - A pointer to a variable that receives the line cap style.
     * @returns {Integer} Status code.
     */
    static GetPenDashCap197819(pen, dashCap) => DllCall("gdiplus\GdipGetPenDashCap197819", "Ptr", pen, "Ptr", dashCap)

    /**
     * Sets the line join style for a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} lineJoin - The line join style to set.
     * @returns {Integer} Status code.
     */
    static SetPenLineJoin(pen, lineJoin) => DllCall("gdiplus\GdipSetPenLineJoin", "Ptr", pen, "Int", lineJoin)

    /**
     * Gets the line join style of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} lineJoin - A pointer to a variable that receives the line join style.
     * @returns {Integer} Status code.
     */
    static GetPenLineJoin(pen, lineJoin) => DllCall("gdiplus\GdipGetPenLineJoin", "Ptr", pen, "Ptr", lineJoin)

    /**
     * Sets the custom start cap of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} customCap - A pointer to a CustomLineCap object that specifies the custom start cap.
     * @returns {Integer} Status code.
     */
    static SetPenCustomStartCap(pen, customCap) => DllCall("gdiplus\GdipSetPenCustomStartCap", "Ptr", pen, "Ptr", customCap)

    /**
     * Gets the custom start cap of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} customCap - A pointer to a variable that receives the CustomLineCap object.
     * @returns {Integer} Status code.
     */
    static GetPenCustomStartCap(pen, customCap) => DllCall("gdiplus\GdipGetPenCustomStartCap", "Ptr", pen, "Ptr", customCap)

    /**
     * Sets the custom end cap of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} customCap - A pointer to a CustomLineCap object that specifies the custom end cap.
     * @returns {Integer} Status code.
     */
    static SetPenCustomEndCap(pen, customCap) => DllCall("gdiplus\GdipSetPenCustomEndCap", "Ptr", pen, "Ptr", customCap)

    /**
     * Gets the custom end cap of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} customCap - A pointer to a variable that receives the CustomLineCap object.
     * @returns {Integer} Status code.
     */
    static GetPenCustomEndCap(pen, customCap) => DllCall("gdiplus\GdipGetPenCustomEndCap", "Ptr", pen, "Ptr", customCap)

    /**
     * Sets the miter limit of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Float} miterLimit - The miter limit to set.
     * @returns {Integer} Status code.
     */
    static SetPenMiterLimit(pen, miterLimit) => DllCall("gdiplus\GdipSetPenMiterLimit", "Ptr", pen, "Float", miterLimit)

    /**
     * Gets the miter limit of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} miterLimit - A pointer to a variable that receives the miter limit.
     * @returns {Integer} Status code.
     */
    static GetPenMiterLimit(pen, miterLimit) => DllCall("gdiplus\GdipGetPenMiterLimit", "Ptr", pen, "Ptr", miterLimit)

    /**
     * Sets the modification mode of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} penMode - The pen modification mode to set.
     * @returns {Integer} Status code.
     */
    static SetPenMode(pen, penMode) => DllCall("gdiplus\GdipSetPenMode", "Ptr", pen, "Int", penMode)

    /**
     * Gets the modification mode of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} penMode - A pointer to a variable that receives the pen modification mode.
     * @returns {Integer} Status code.
     */
    static GetPenMode(pen, penMode) => DllCall("gdiplus\GdipGetPenMode", "Ptr", pen, "Ptr", penMode)

    /**
     * Sets the transformation matrix of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the transformation.
     * @returns {Integer} Status code.
     */
    static SetPenTransform(pen, matrix) => DllCall("gdiplus\GdipSetPenTransform", "Ptr", pen, "Ptr", matrix)

    /**
     * Gets the transformation matrix of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} matrix - A pointer to a Matrix object that receives the transformation.
     * @returns {Integer} Status code.
     */
    static GetPenTransform(pen, matrix) => DllCall("gdiplus\GdipGetPenTransform", "Ptr", pen, "Ptr", matrix)

    /**
     * Resets the transformation matrix of a Pen object to the identity matrix.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @returns {Integer} Status code.
     */
    static ResetPenTransform(pen) => DllCall("gdiplus\GdipResetPenTransform", "Ptr", pen)

    /**
     * Multiplies the transformation matrix of a Pen object by another matrix.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} matrix - A pointer to a Matrix object that specifies the matrix to multiply by.
     * @param {Integer} order - The order of multiplication.
     * @returns {Integer} Status code.
     */
    static MultiplyPenTransform(pen, matrix, order) => DllCall("gdiplus\GdipMultiplyPenTransform", "Ptr", pen, "Ptr", matrix, "Int", order)

    /**
     * Translates the transformation matrix of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Float} dx - The amount to translate along the x-axis.
     * @param {Float} dy - The amount to translate along the y-axis.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static TranslatePenTransform(pen, dx, dy, order) => DllCall("gdiplus\GdipTranslatePenTransform", "Ptr", pen, "Float", dx, "Float", dy, "Int", order)

    /**
     * Scales the transformation matrix of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Float} sx - The amount to scale along the x-axis.
     * @param {Float} sy - The amount to scale along the y-axis.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static ScalePenTransform(pen, sx, sy, order) => DllCall("gdiplus\GdipScalePenTransform", "Ptr", pen, "Float", sx, "Float", sy, "Int", order)

    /**
     * Rotates the transformation matrix of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Float} angle - The rotation angle in degrees.
     * @param {Integer} order - The order of transformation.
     * @returns {Integer} Status code.
     */
    static RotatePenTransform(pen, angle, order) => DllCall("gdiplus\GdipRotatePenTransform", "Ptr", pen, "Float", angle, "Int", order)

    /**
     * Sets the color of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} argb - The color to set.
     * @returns {Integer} Status code.
     */
    static SetPenColor(pen, argb) => DllCall("gdiplus\GdipSetPenColor", "Ptr", pen, "UInt", argb)

    /**
     * Gets the color of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} argb - A pointer to a variable that receives the color.
     * @returns {Integer} Status code.
     */
    static GetPenColor(pen, argb) => DllCall("gdiplus\GdipGetPenColor", "Ptr", pen, "Ptr", argb)

    /**
     * Sets the Brush object that a Pen object uses to fill lines.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} brush - A pointer to the Brush object to use.
     * @returns {Integer} Status code.
     */
    static SetPenBrushFill(pen, brush) => DllCall("gdiplus\GdipSetPenBrushFill", "Ptr", pen, "Ptr", brush)

    /**
     * Gets a Brush object that is used by a Pen object to fill lines.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} brush - A pointer to a variable that receives the Brush object.
     * @returns {Integer} Status code.
     */
    static GetPenBrushFill(pen, brush) => DllCall("gdiplus\GdipGetPenBrushFill", "Ptr", pen, "Ptr", brush)

    /**
     * Gets the fill type of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} type - A pointer to a variable that receives the fill type.
     * @returns {Integer} Status code.
     */
    static GetPenFillType(pen, type) => DllCall("gdiplus\GdipGetPenFillType", "Ptr", pen, "Ptr", type)

    /**
     * Gets the dash style of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} dashStyle - A pointer to a variable that receives the dash style.
     * @returns {Integer} Status code.
     */
    static GetPenDashStyle(pen, dashStyle) => DllCall("gdiplus\GdipGetPenDashStyle", "Ptr", pen, "Ptr", dashStyle)

    /**
     * Sets the dash style of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Integer} dashStyle - The dash style to set.
     * @returns {Integer} Status code.
     */
    static SetPenDashStyle(pen, dashStyle) => DllCall("gdiplus\GdipSetPenDashStyle", "Ptr", pen, "Int", dashStyle)

    /**
     * Gets the distance from the start of the line to the start of the first dash in a dashed line.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} offset - A pointer to a variable that receives the dash offset.
     * @returns {Integer} Status code.
     */
    static GetPenDashOffset(pen, offset) => DllCall("gdiplus\GdipGetPenDashOffset", "Ptr", pen, "Ptr", offset)

    /**
     * Sets the distance from the start of the line to the start of the first dash in a dashed line.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Float} offset - The dash offset to set.
     * @returns {Integer} Status code.
     */
    static SetPenDashOffset(pen, offset) => DllCall("gdiplus\GdipSetPenDashOffset", "Ptr", pen, "Float", offset)

    /**
     * Gets the number of elements in a Pen object's dash pattern array.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} count - A pointer to a variable that receives the count.
     * @returns {Integer} Status code.
     */
    static GetPenDashCount(pen, count) => DllCall("gdiplus\GdipGetPenDashCount", "Ptr", pen, "Ptr", count)

    /**
     * Sets the dash pattern of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} dash - A pointer to an array of dash lengths.
     * @param {Integer} count - The number of elements in the dash array.
     * @returns {Integer} Status code.
     */
    static SetPenDashArray(pen, dash, count) => DllCall("gdiplus\GdipSetPenDashArray", "Ptr", pen, "Ptr", dash, "Int", count)

    /**
     * Gets the dash pattern of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} dash - A pointer to an array that receives the dash pattern.
     * @param {Integer} count - The number of elements in the dash array.
     * @returns {Integer} Status code.
     */
    static GetPenDashArray(pen, dash, count) => DllCall("gdiplus\GdipGetPenDashArray", "Ptr", pen, "Ptr", dash, "Int", count)

    /**
     * Gets the number of compound array elements in a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Ptr*} count - A pointer to a variable that receives the count.
     * @returns {Integer} Status code.
     */
    static GetPenCompoundCount(pen, count) => DllCall("gdiplus\GdipGetPenCompoundCount", "Ptr", pen, "Ptr", count)

    /**
     * Sets the compound array of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} dash - A pointer to an array that specifies the compound pen.
     * @param {Integer} count - The number of elements in the compound array.
     * @returns {Integer} Status code.
     */
    static SetPenCompoundArray(pen, dash, count) => DllCall("gdiplus\GdipSetPenCompoundArray", "Ptr", pen, "Ptr", dash, "Int", count)

    /**
     * Gets the compound array of a Pen object.
     * @param {Pointer} pen - A pointer to the Pen object.
     * @param {Pointer} dash - A pointer to an array that receives the compound pen.
     * @param {Integer} count - The number of elements in the compound array.
     * @returns {Integer} Status code.
     */
    static GetPenCompoundArray(pen, dash, count) => DllCall("gdiplus\GdipGetPenCompoundArray", "Ptr", pen, "Ptr", dash, "Int", count)

    /**
     * Creates a CustomLineCap object.
     * @param {Pointer} fillPath - A pointer to a GraphicsPath object that defines the fill of the custom cap.
     * @param {Pointer} strokePath - A pointer to a GraphicsPath object that defines the outline of the custom cap.
     * @param {Integer} baseCap - The base cap on which this custom cap is based.
     * @param {Float} baseInset - The distance between the base cap and the start of the line.
     * @param {Ptr*} customCap - A pointer to a variable that receives the CustomLineCap object.
     * @returns {Integer} Status code.
     */
    static CreateCustomLineCap(fillPath, strokePath, baseCap, baseInset, customCap) => DllCall("gdiplus\GdipCreateCustomLineCap", "Ptr", fillPath, "Ptr", strokePath, "Int", baseCap, "Float", baseInset, "Ptr*", customCap)

    /**
     * Deletes a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object to delete.
     * @returns {Integer} Status code.
     */
    static DeleteCustomLineCap(customCap) => DllCall("gdiplus\GdipDeleteCustomLineCap", "Ptr", customCap)

    /**
     * Creates a copy of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object to clone.
     * @param {Ptr*} clonedCap - A pointer to a variable that receives the cloned CustomLineCap object.
     * @returns {Integer} Status code.
     */
    static CloneCustomLineCap(customCap, clonedCap) => DllCall("gdiplus\GdipCloneCustomLineCap", "Ptr", customCap, "Ptr*", clonedCap)

    /**
     * Gets the type of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Ptr*} capType - A pointer to a variable that receives the cap type.
     * @returns {Integer} Status code.
     */
    static GetCustomLineCapType(customCap, capType) => DllCall("gdiplus\GdipGetCustomLineCapType", "Ptr", customCap, "Ptr", capType)

    /**
     * Sets the start and end caps for the stroke of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Integer} startCap - The line cap for the start of the custom cap.
     * @param {Integer} endCap - The line cap for the end of the custom cap.
     * @returns {Integer} Status code.
     */
    static SetCustomLineCapStrokeCaps(customCap, startCap, endCap) => DllCall("gdiplus\GdipSetCustomLineCapStrokeCaps", "Ptr", customCap, "Int", startCap, "Int", endCap)

    /**
     * Gets the start and end caps for the stroke of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Ptr*} startCap - A pointer to a variable that receives the start cap.
     * @param {Ptr*} endCap - A pointer to a variable that receives the end cap.
     * @returns {Integer} Status code.
     */
    static GetCustomLineCapStrokeCaps(customCap, startCap, endCap) => DllCall("gdiplus\GdipGetCustomLineCapStrokeCaps", "Ptr", customCap, "Ptr", startCap, "Ptr", endCap)

    /**
     * Sets the line join for the stroke of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Integer} lineJoin - The line join to set.
     * @returns {Integer} Status code.
     */
    static SetCustomLineCapStrokeJoin(customCap, lineJoin) => DllCall("gdiplus\GdipSetCustomLineCapStrokeJoin", "Ptr", customCap, "Int", lineJoin)

    /**
     * Gets the line join for the stroke of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Ptr*} lineJoin - A pointer to a variable that receives the line join.
     * @returns {Integer} Status code.
     */
    static GetCustomLineCapStrokeJoin(customCap, lineJoin) => DllCall("gdiplus\GdipGetCustomLineCapStrokeJoin", "Ptr", customCap, "Ptr", lineJoin)

    /**
     * Sets the base cap for a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Integer} baseCap - The base cap to set.
     * @returns {Integer} Status code.
     */
    static SetCustomLineCapBaseCap(customCap, baseCap) => DllCall("gdiplus\GdipSetCustomLineCapBaseCap", "Ptr", customCap, "Int", baseCap)

    /**
     * Gets the base cap of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Ptr*} baseCap - A pointer to a variable that receives the base cap.
     * @returns {Integer} Status code.
     */
    static GetCustomLineCapBaseCap(customCap, baseCap) => DllCall("gdiplus\GdipGetCustomLineCapBaseCap", "Ptr", customCap, "Ptr", baseCap)

    /**
     * Sets the base inset for a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Float} inset - The base inset to set.
     * @returns {Integer} Status code.
     */
    static SetCustomLineCapBaseInset(customCap, inset) => DllCall("gdiplus\GdipSetCustomLineCapBaseInset", "Ptr", customCap, "Float", inset)

    /**
     * Gets the base inset of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Ptr*} inset - A pointer to a variable that receives the base inset.
     * @returns {Integer} Status code.
     */
    static GetCustomLineCapBaseInset(customCap, inset) => DllCall("gdiplus\GdipGetCustomLineCapBaseInset", "Ptr", customCap, "Ptr", inset)

    /**
     * Sets the width scale of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Float} widthScale - The width scale to set.
     * @returns {Integer} Status code.
     */
    static SetCustomLineCapWidthScale(customCap, widthScale) => DllCall("gdiplus\GdipSetCustomLineCapWidthScale", "Ptr", customCap, "Float", widthScale)

    /**
     * Gets the width scale of a CustomLineCap object.
     * @param {Pointer} customCap - A pointer to the CustomLineCap object.
     * @param {Ptr*} widthScale - A pointer to a variable that receives the width scale.
     * @returns {Integer} Status code.
     */
    static GetCustomLineCapWidthScale(customCap, widthScale) => DllCall("gdiplus\GdipGetCustomLineCapWidthScale", "Ptr", customCap, "Ptr", widthScale)

    /**
     * Creates an adjustable arrow line cap.
     * @param {Float} height - The height of the arrow cap.
     * @param {Float} width - The width of the arrow cap.
     * @param {Integer} isFilled - Specifies whether the arrow cap is filled.
     * @param {Ptr*} cap - A pointer to a variable that receives the AdjustableArrowCap object.
     * @returns {Integer} Status code.
     */
    static CreateAdjustableArrowCap(height, width, isFilled, cap) => DllCall("gdiplus\GdipCreateAdjustableArrowCap", "Float", height, "Float", width, "Int", isFilled, "Ptr*", cap)

    /**
     * Sets the height of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Float} height - The height to set.
     * @returns {Integer} Status code.
     */
    static SetAdjustableArrowCapHeight(cap, height) => DllCall("gdiplus\GdipSetAdjustableArrowCapHeight", "Ptr", cap, "Float", height)

    /**
     * Gets the height of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Ptr*} height - A pointer to a variable that receives the height.
     * @returns {Integer} Status code.
     */
    static GetAdjustableArrowCapHeight(cap, height) => DllCall("gdiplus\GdipGetAdjustableArrowCapHeight", "Ptr", cap, "Ptr", height)

    /**
     * Sets the width of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Float} width - The width to set.
     * @returns {Integer} Status code.
     */
    static SetAdjustableArrowCapWidth(cap, width) => DllCall("gdiplus\GdipSetAdjustableArrowCapWidth", "Ptr", cap, "Float", width)

    /**
     * Gets the width of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Ptr*} width - A pointer to a variable that receives the width.
     * @returns {Integer} Status code.
     */
    static GetAdjustableArrowCapWidth(cap, width) => DllCall("gdiplus\GdipGetAdjustableArrowCapWidth", "Ptr", cap, "Ptr", width)

    /**
     * Sets the middle inset of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Float} middleInset - The middle inset to set.
     * @returns {Integer} Status code.
     */
    static SetAdjustableArrowCapMiddleInset(cap, middleInset) => DllCall("gdiplus\GdipSetAdjustableArrowCapMiddleInset", "Ptr", cap, "Float", middleInset)

    /**
     * Gets the middle inset of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Ptr*} middleInset - A pointer to a variable that receives the middle inset.
     * @returns {Integer} Status code.
     */
    static GetAdjustableArrowCapMiddleInset(cap, middleInset) => DllCall("gdiplus\GdipGetAdjustableArrowCapMiddleInset", "Ptr", cap, "Ptr", middleInset)

    /**
     * Sets the fill state of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Integer} fillState - The fill state to set.
     * @returns {Integer} Status code.
     */
    static SetAdjustableArrowCapFillState(cap, fillState) => DllCall("gdiplus\GdipSetAdjustableArrowCapFillState", "Ptr", cap, "Int", fillState)

    /**
     * Gets the fill state of an adjustable arrow line cap.
     * @param {Pointer} cap - A pointer to the AdjustableArrowCap object.
     * @param {Ptr*} fillState - A pointer to a variable that receives the fill state.
     * @returns {Integer} Status code.
     */
    static GetAdjustableArrowCapFillState(cap, fillState) => DllCall("gdiplus\GdipGetAdjustableArrowCapFillState", "Ptr", cap, "Ptr", fillState)

    /**
     * Creates a FontFamily object based on a specified font family name.
     * @param {String} name - The name of the font family.
     * @param {Pointer} fontCollection - A pointer to a FontCollection object, or NULL.
     * @param {Ptr*} fontFamily - A pointer to a variable that receives the FontFamily object.
     * @returns {Integer} Status code.
     */
    static CreateFontFamilyFromName(name, fontCollection, fontFamily) => DllCall("gdiplus\GdipCreateFontFamilyFromName", "WStr", name, "Ptr", fontCollection, "Ptr*", fontFamily)

    /**
     * Deletes a FontFamily object.
     * @param {Pointer} fontFamily - A pointer to the FontFamily object to delete.
     * @returns {Integer} Status code.
     */
    static DeleteFontFamily(fontFamily) => DllCall("gdiplus\GdipDeleteFontFamily", "Ptr", fontFamily)

    /**
     * Creates a copy of a FontFamily object.
     * @param {Pointer} fontFamily - A pointer to the FontFamily object to clone.
     * @param {Ptr*} clonedFontFamily - A pointer to a variable that receives the cloned FontFamily object.
     * @returns {Integer} Status code.
     */
    static CloneFontFamily(fontFamily, clonedFontFamily) => DllCall("gdiplus\GdipCloneFontFamily", "Ptr", fontFamily, "Ptr*", clonedFontFamily)

    /**
     * Gets a FontFamily object that represents a generic sans serif font family.
     * @param {Ptr*} nativeFamily - A pointer to a variable that receives the FontFamily object.
     * @returns {Integer} Status code.
     */
    static GetGenericFontFamilySansSerif(nativeFamily) => DllCall("gdiplus\GdipGetGenericFontFamilySansSerif", "Ptr*", nativeFamily)

    /**
     * Gets a FontFamily object that represents a generic serif font family.
     * @param {Ptr*} nativeFamily - A pointer to a variable that receives the FontFamily object.
     * @returns {Integer} Status code.
     */
    static GetGenericFontFamilySerif(nativeFamily) => DllCall("gdiplus\GdipGetGenericFontFamilySerif", "Ptr*", nativeFamily)

    /**
     * Gets a FontFamily object that represents a generic monospace font family.
     * @param {Ptr*} nativeFamily - A pointer to a variable that receives the FontFamily object.
     * @returns {Integer} Status code.
     */
    static GetGenericFontFamilyMonospace(nativeFamily) => DllCall("gdiplus\GdipGetGenericFontFamilyMonospace", "Ptr*", nativeFamily)

    /**
     * Gets the name of a font family.
     * @param {Pointer} family - A pointer to the FontFamily object.
     * @param {WStr} name - A pointer to a buffer that receives the family name.
     * @param {Integer} language - The language of the name.
     * @returns {Integer} Status code.
     */
    static GetFamilyName(family, name, language) => DllCall("gdiplus\GdipGetFamilyName", "Ptr", family, "WStr", name, "Int", language)

    /**
     * Determines whether the specified style is available for this font family.
     * @param {Pointer} family - A pointer to the FontFamily object.
     * @param {Integer} style - The font style to check.
     * @param {Ptr*} isStyleAvailable - A pointer to a variable that receives the result.
     * @returns {Integer} Status code.
     */
    static IsStyleAvailable(family, style, isStyleAvailable) => DllCall("gdiplus\GdipIsStyleAvailable", "Ptr", family, "Int", style, "Ptr*", isStyleAvailable)

    /**
     * Enumerates the font families in a font collection.
     * @param {Pointer} fontCollection - A pointer to the FontCollection object.
     * @param {Integer} numFound - The number of font families found.
     * @param {Pointer} gpfamilies - A pointer to an array of FontFamily objects.
     * @param {Integer} numFamilies - The number of font families to enumerate.
     * @returns {Integer} Status code.
     */
    static FontCollectionEnumerable(fontCollection, numFound, gpfamilies, numFamilies) => DllCall("gdiplus\GdipFontCollectionEnumerable", "Ptr", fontCollection, "Int", numFound, "Ptr", gpfamilies, "Int", numFamilies)

    /**
     * Enumerates the font families in a font collection.
     * @param {Pointer} fontCollection - A pointer to the FontCollection object.
     * @param {Integer} numSought - The number of font families to enumerate.
     * @param {Pointer} gpfamilies - A pointer to an array of FontFamily objects.
     * @param {Ptr*} numFound - A pointer to a variable that receives the number of font families found.
     * @returns {Integer} Status code.
     */
    static FontCollectionEnumerate(fontCollection, numSought, gpfamilies, numFound) => DllCall("gdiplus\GdipFontCollectionEnumerate", "Ptr", fontCollection, "Int", numSought, "Ptr", gpfamilies, "Ptr", numFound, "Ptr", 0)

    /**
     * Gets the em height of a font family in the specified style.
     * @param {Pointer} family - A pointer to the FontFamily object.
     * @param {Integer} style - The font style.
     * @param {Ptr*} EmHeight - A pointer to a variable that receives the em height.
     * @returns {Integer} Status code.
     */
    static GetEmHeight(family, style, EmHeight) => DllCall("gdiplus\GdipGetEmHeight", "Ptr", family, "Int", style, "Ptr", EmHeight)

    /**
     * Gets the cell ascent of a font family in the specified style.
     * @param {Pointer} family - A pointer to the FontFamily object.
     * @param {Integer} style - The font style.
     * @param {Ptr*} CellAscent - A pointer to a variable that receives the cell ascent.
     * @returns {Integer} Status code.
     */
    static GetCellAscent(family, style, CellAscent) => DllCall("gdiplus\GdipGetCellAscent", "Ptr", family, "Int", style, "Ptr", CellAscent)

    /**
     * Gets the cell descent of a font family in the specified style.
     * @param {Pointer} family - A pointer to the FontFamily object.
     * @param {Integer} style - The font style.
     * @param {Ptr*} CellDescent - A pointer to a variable that receives the cell descent.
     * @returns {Integer} Status code.
     */
    static GetCellDescent(family, style, CellDescent) => DllCall("gdiplus\GdipGetCellDescent", "Ptr", family, "Int", style, "Ptr", CellDescent)

    /**
     * Gets the line spacing of a font family in the specified style.
     * @param {Pointer} family - A pointer to the FontFamily object.
     * @param {Integer} style - The font style.
     * @param {Ptr*} LineSpacing - A pointer to a variable that receives the line spacing.
     * @returns {Integer} Status code.
     */
    static GetLineSpacing(family, style, LineSpacing) => DllCall("gdiplus\GdipGetLineSpacing", "Ptr", family, "Int", style, "Ptr", LineSpacing)

    /**
     * Creates a Font object based on a device context.
     * @param {Pointer} hdc - A handle to a device context.
     * @param {Ptr*} font - A pointer to a variable that receives the Font object.
     * @returns {Integer} Status code.
     */
    static CreateFontFromDC(hdc, font) => DllCall("gdiplus\GdipCreateFontFromDC", "Ptr", hdc, "Ptr*", font)

    /**
     * Creates a Font object based on a LOGFONTA structure.
     * @param {Pointer} hdc - A handle to a device context.
     * @param {Pointer} logfont - A pointer to a LOGFONTA structure.
     * @param {Ptr*} font - A pointer to a variable that receives the Font object.
     * @returns {Integer} Status code.
     */
    static CreateFontFromLogfontA(hdc, logfont, font) => DllCall("gdiplus\GdipCreateFontFromLogfontA", "Ptr", hdc, "Ptr", logfont, "Ptr*", font)

    /**
     * Creates a Font object based on a LOGFONTW structure.
     * @param {Pointer} hdc - A handle to a device context.
     * @param {Pointer} logfont - A pointer to a LOGFONTW structure.
     * @param {Ptr*} font - A pointer to a variable that receives the Font object.
     * @returns {Integer} Status code.
     */
    static CreateFontFromLogfontW(hdc, logfont, font) => DllCall("gdiplus\GdipCreateFontFromLogfontW", "Ptr", hdc, "Ptr", logfont, "Ptr*", font)

    /**
     * Creates a Font object based on a FontFamily object, size, style, and unit.
     * @param {Pointer} fontFamily - A pointer to a FontFamily object.
     * @param {Float} emSize - The em size of the font.
     * @param {Integer} style - The font style.
     * @param {Integer} unit - The unit of measure for the font size.
     * @param {Ptr*} font - A pointer to a variable that receives the Font object.
     * @returns {Integer} Status code.
     */
    static CreateFont(fontFamily, emSize, style, unit, font) => DllCall("gdiplus\GdipCreateFont", "Ptr", fontFamily, "Float", emSize, "Int", style, "Int", unit, "Ptr*", font)

    /**
     * Creates a copy of a Font object.
     * @param {Pointer} font - A pointer to the Font object to clone.
     * @param {Ptr*} cloneFont - A pointer to a variable that receives the cloned Font object.
     * @returns {Integer} Status code.
     */
    static CloneFont(font, cloneFont) => DllCall("gdiplus\GdipCloneFont", "Ptr", font, "Ptr*", cloneFont)

    /**
     * Deletes a Font object.
     * @param {Pointer} font - A pointer to the Font object to delete.
     * @returns {Integer} Status code.
     */
    static DeleteFont(font) => DllCall("gdiplus\GdipDeleteFont", "Ptr", font)

    /**
     * Gets the FontFamily object associated with a Font object.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Ptr*} family - A pointer to a variable that receives the FontFamily object.
     * @returns {Integer} Status code.
     */
    static GetFamily(font, family) => DllCall("gdiplus\GdipGetFamily", "Ptr", font, "Ptr*", family)

    /**
     * Gets the style of a Font object.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Ptr*} style - A pointer to a variable that receives the font style.
     * @returns {Integer} Status code.
     */
    static GetFontStyle(font, style) => DllCall("gdiplus\GdipGetFontStyle", "Ptr", font, "Ptr", style)

    /**
     * Gets the size of a Font object.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Ptr*} size - A pointer to a variable that receives the font size.
     * @returns {Integer} Status code.
     */
    static GetFontSize(font, size) => DllCall("gdiplus\GdipGetFontSize", "Ptr", font, "Ptr", size)

    /**
     * Gets the unit of measure of a Font object.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Ptr*} unit - A pointer to a variable that receives the font unit.
     * @returns {Integer} Status code.
     */
    static GetFontUnit(font, unit) => DllCall("gdiplus\GdipGetFontUnit", "Ptr", font, "Ptr", unit)

    /**
     * Gets the height of a Font object in the current unit of a specified Graphics object.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Ptr*} height - A pointer to a variable that receives the font height.
     * @returns {Integer} Status code.
     */
    static GetFontHeight(font, graphics, height) => DllCall("gdiplus\GdipGetFontHeight", "Ptr", font, "Ptr", graphics, "Ptr", height)

    /**
     * Gets the height of a Font object in pixels for a specified DPI.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Float} dpi - The DPI value.
     * @param {Ptr*} height - A pointer to a variable that receives the font height.
     * @returns {Integer} Status code.
     */
    static GetFontHeightGivenDPI(font, dpi, height) => DllCall("gdiplus\GdipGetFontHeightGivenDPI", "Ptr", font, "Float", dpi, "Ptr", height)

    /**
     * Gets a Windows LOGFONTA structure based on a Font object.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} logfontA - A pointer to a LOGFONTA structure that receives the font information.
     * @returns {Integer} Status code.
     */
    static GetLogFontA(font, graphics, logfontA) => DllCall("gdiplus\GdipGetLogFontA", "Ptr", font, "Ptr", graphics, "Ptr", logfontA)

    /**
     * Gets a Windows LOGFONTW structure based on a Font object.
     * @param {Pointer} font - A pointer to the Font object.
     * @param {Pointer} graphics - A pointer to a Graphics object.
     * @param {Pointer} logfontW - A pointer to a LOGFONTW structure that receives the font information.
     * @returns {Integer} Status code.
     */
    static GetLogFontW(font, graphics, logfontW) => DllCall("gdiplus\GdipGetLogFontW", "Ptr", font, "Ptr", graphics, "Ptr", logfontW)

    /**
     * Creates a new InstalledFontCollection object.
     * @param {Ptr*} fontCollection - A pointer to a variable that receives the InstalledFontCollection object.
     * @returns {Integer} Status code.
     */
    static NewInstalledFontCollection(fontCollection) => DllCall("gdiplus\GdipNewInstalledFontCollection", "Ptr*", fontCollection)

    /**
     * Creates a new PrivateFontCollection object.
     * @param {Ptr*} fontCollection - A pointer to a variable that receives the PrivateFontCollection object.
     * @returns {Integer} Status code.
     */
    static NewPrivateFontCollection(fontCollection) => DllCall("gdiplus\GdipNewPrivateFontCollection", "Ptr*", fontCollection)

    /**
     * Deletes a PrivateFontCollection object.
     * @param {Pointer} fontCollection - A pointer to the PrivateFontCollection object to delete.
     * @returns {Integer} Status code.
     */
    static DeletePrivateFontCollection(fontCollection) => DllCall("gdiplus\GdipDeletePrivateFontCollection", "Ptr", fontCollection)

    /**
     * Gets the number of font families in a font collection.
     * @param {Pointer} fontCollection - A pointer to the FontCollection object.
     * @param {Ptr*} numFound - A pointer to a variable that receives the number of font families.
     * @returns {Integer} Status code.
     */
    static GetFontCollectionFamilyCount(fontCollection, numFound) => DllCall("gdiplus\GdipGetFontCollectionFamilyCount", "Ptr", fontCollection, "Ptr", numFound)

    /**
     * Gets a list of the font families contained in a font collection.
     * @param {Pointer} fontCollection - A pointer to the FontCollection object.
     * @param {Integer} numSought - The number of font families to retrieve.
     * @param {Pointer} gpfamilies - A pointer to an array that receives the FontFamily objects.
     * @param {Ptr*} numFound - A pointer to a variable that receives the number of font families found.
     * @returns {Integer} Status code.
     */
    static GetFontCollectionFamilyList(fontCollection, numSought, gpfamilies, numFound) => DllCall("gdiplus\GdipGetFontCollectionFamilyList", "Ptr", fontCollection, "Int", numSought, "Ptr", gpfamilies, "Ptr", numFound)

    /**
     * Adds a font file to a private font collection.
     * @param {Pointer} fontCollection - A pointer to the PrivateFontCollection object.
     * @param {String} filename - The name of the font file to add.
     * @returns {Integer} Status code.
     */
    static PrivateAddFontFile(fontCollection, filename) => DllCall("gdiplus\GdipPrivateAddFontFile", "Ptr", fontCollection, "WStr", filename)

    /**
     * Adds a font from memory to a private font collection.
     * @param {Pointer} fontCollection - A pointer to the PrivateFontCollection object.
     * @param {Pointer} memory - A pointer to the font data in memory.
     * @param {Integer} length - The length of the font data.
     * @returns {Integer} Status code.
     */
    static PrivateAddMemoryFont(fontCollection, memory, length) => DllCall("gdiplus\GdipPrivateAddMemoryFont", "Ptr", fontCollection, "Ptr", memory, "Int", length)

    /**
     * Creates a StringFormat object.
     * @param {Integer} formatFlags - The format flags to use.
     * @param {Integer} language - The language to use.
     * @param {Ptr*} format - A pointer to a variable that receives the StringFormat object.
     * @returns {Integer} Status code.
     */
    static CreateStringFormat(formatFlags, language, format) => DllCall("gdiplus\GdipCreateStringFormat", "Int", formatFlags, "Int", language, "Ptr*", format)

    /**
     * Gets a generic default StringFormat object.
     * @param {Ptr*} format - A pointer to a variable that receives the StringFormat object.
     * @returns {Integer} Status code.
     */
    static StringFormatGetGenericDefault(format) => DllCall("gdiplus\GdipStringFormatGetGenericDefault", "Ptr*", format)

    /**
     * Gets a generic typographic StringFormat object.
     * @param {Ptr*} format - A pointer to a variable that receives the StringFormat object.
     * @returns {Integer} Status code.
     */
    static StringFormatGetGenericTypographic(format) => DllCall("gdiplus\GdipStringFormatGetGenericTypographic", "Ptr*", format)

    /**
     * Deletes a StringFormat object.
     * @param {Pointer} format - A pointer to the StringFormat object to delete.
     * @returns {Integer} Status code.
     */
    static DeleteStringFormat(format) => DllCall("gdiplus\GdipDeleteStringFormat", "Ptr", format)

    /**
     * Creates a copy of a StringFormat object.
     * @param {Pointer} format - A pointer to the StringFormat object to clone.
     * @param {Ptr*} newFormat - A pointer to a variable that receives the cloned StringFormat object.
     * @returns {Integer} Status code.
     */
    static CloneStringFormat(format, newFormat) => DllCall("gdiplus\GdipCloneStringFormat", "Ptr", format, "Ptr*", newFormat)

    /**
     * Sets the format flags for a StringFormat object.
     * @param {Pointer} format - A pointer to the StringFormat object.
     * @param {Integer} flags - The format flags to set.
     * @returns {Integer} Status code.
     */
    static SetStringFormatFlags(format, flags) => DllCall("gdiplus\GdipSetStringFormatFlags", "Ptr", format, "Int", flags)

    /**
     * Gets the format flags for a StringFormat object.
     * @param {Pointer} format - A pointer to the StringFormat object.
     * @param {Ptr*} flags - A pointer to a variable that receives the format flags.
     * @returns {Integer} Status code.
     */
    static GetStringFormatFlags(format, flags) => DllCall("gdiplus\GdipGetStringFormatFlags", "Ptr", format, "Ptr", flags)

    /**
     * Sets the alignment for a StringFormat object.
     * @param {Pointer} format - A pointer to the StringFormat object.
     * @param {Integer} align - The alignment to set.
     * @returns {Integer} Status code.
     */
    static SetStringFormatAlign(format, align) => DllCall("gdiplus\GdipSetStringFormatAlign", "Ptr", format, "Int", align)

    /**
     * Gets the alignment for a StringFormat object.
     * @param {Pointer} format - A pointer to the StringFormat object.
     * @param {Ptr*} align - A pointer to a variable that receives the alignment.
     * @returns {Integer} Status code.
     */
    static GetStringFormatAlign(format, align) => DllCall("gdiplus\GdipGetStringFormatAlign", "Ptr", format, "Ptr", align)

    /**
     * Provides a hook for GDI+ to send notifications to the application.
     * @param {Ptr*} token - A pointer to a variable that receives a token to be used with GdiplusNotificationUnhook.
     * @param {Pointer} hook - A pointer to a function that will receive notifications.
     * @returns {Integer} Status code.
     */
    static NotificationHook(token, hook) => DllCall("gdiplus\GdiplusNotificationHook", "Ptr*", token, "Ptr", hook)

    /**
     * Removes a previously set notification hook.
     * @param {Pointer} token - The token received from GdiplusNotificationHook.
     * @returns {Integer} Status code.
     */
    static NotificationUnhook(token) => DllCall("gdiplus\GdiplusNotificationUnhook", "Ptr", token)

    /**
     * Fills the interior of an ellipse defined by a bounding rectangle.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} brush - Pointer to the Brush object used for filling.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} width - The width of the bounding rectangle.
     * @param {Integer} height - The height of the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static FillEllipseI(graphics, brush, x, y, width, height) => DllCall("gdiplus\GdipFillEllipseI", "Ptr", graphics, "Ptr", brush, "Int", x, "Int", y, "Int", width, "Int", height)

    /**
     * Fills the interior of a closed cardinal spline curve defined by an array of points.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} brush - Pointer to the Brush object used for filling.
     * @param {Pointer} points - Pointer to an array of Point structures that define the spline.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static FillClosedCurveI(graphics, brush, points, count) => DllCall("gdiplus\GdipFillClosedCurveI", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count)

    /**
     * Fills the interior of a closed cardinal spline curve defined by an array of points.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} brush - Pointer to the Brush object used for filling.
     * @param {Pointer} points - Pointer to an array of Point structures that define the spline.
     * @param {Integer} count - The number of points in the array.
     * @param {Float} tension - The tension of the curve.
     * @param {Integer} fillMode - The fill mode (alternate or winding).
     * @returns {Integer} Status code.
     */
    static FillClosedCurve2I(graphics, brush, points, count, tension, fillMode) => DllCall("gdiplus\GdipFillClosedCurve2I", "Ptr", graphics, "Ptr", brush, "Ptr", points, "Int", count, "Float", tension, "Int", fillMode)

    /**
     * Draws an image at a specified position.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} image - Pointer to the Image object to draw.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the drawn image.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the drawn image.
     * @returns {Integer} Status code.
     */
    static DrawImageI(graphics, image, x, y) => DllCall("gdiplus\GdipDrawImageI", "Ptr", graphics, "Ptr", image, "Int", x, "Int", y)

    /**
     * Draws an image at a specified position and with a specified size.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} image - Pointer to the Image object to draw.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the drawn image.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the drawn image.
     * @param {Integer} width - The width of the drawn image.
     * @param {Integer} height - The height of the drawn image.
     * @returns {Integer} Status code.
     */
    static DrawImageRectI(graphics, image, x, y, width, height) => DllCall("gdiplus\GdipDrawImageRectI", "Ptr", graphics, "Ptr", image, "Int", x, "Int", y, "Int", width, "Int", height)

    /**
     * Draws an image at a specified position defined by an array of points.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} image - Pointer to the Image object to draw.
     * @param {Pointer} points - Pointer to an array of Point structures that define the destination parallelogram.
     * @param {Integer} count - The number of points in the array.
     * @returns {Integer} Status code.
     */
    static DrawImagePointsI(graphics, image, points, count) => DllCall("gdiplus\GdipDrawImagePointsI", "Ptr", graphics, "Ptr", image, "Ptr", points, "Int", count)

    /**
     * Draws a portion of an image at a specified location and with a specified size.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} image - Pointer to the Image object to draw.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the drawn image.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the drawn image.
     * @param {Integer} srcx - The x-coordinate of the upper-left corner of the portion of the source image to draw.
     * @param {Integer} srcy - The y-coordinate of the upper-left corner of the portion of the source image to draw.
     * @param {Integer} srcwidth - The width of the portion of the source image to draw.
     * @param {Integer} srcheight - The height of the portion of the source image to draw.
     * @param {Integer} srcUnit - The unit of measure used for the source rectangle.
     * @returns {Integer} Status code.
     */
    static DrawImagePointRectI(graphics, image, x, y, srcx, srcy, srcwidth, srcheight, srcUnit) => DllCall("gdiplus\GdipDrawImagePointRectI", "Ptr", graphics, "Ptr", image, "Int", x, "Int", y, "Int", srcx, "Int", srcy, "Int", srcwidth, "Int", srcheight, "Int", srcUnit)

    /**
     * Draws a portion of an image at a specified location and with a specified size.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} image - Pointer to the Image object to draw.
     * @param {Integer} dstx - The x-coordinate of the upper-left corner of the destination rectangle.
     * @param {Integer} dsty - The y-coordinate of the upper-left corner of the destination rectangle.
     * @param {Integer} dstwidth - The width of the destination rectangle.
     * @param {Integer} dstheight - The height of the destination rectangle.
     * @param {Integer} srcx - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcy - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcwidth - The width of the source rectangle.
     * @param {Integer} srcheight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure used for the source rectangle.
     * @param {Pointer} imageAttributes - Pointer to an ImageAttributes object that specifies recoloring and gamma information.
     * @param {Pointer} callback - Pointer to a callback function that specifies a color key.
     * @param {Pointer} callbackData - Pointer to a value that is passed to the callback function.
     * @returns {Integer} Status code.
     */
    static DrawImageRectRectI(graphics, image, dstx, dsty, dstwidth, dstheight, srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes, callback, callbackData) => DllCall("gdiplus\GdipDrawImageRectRectI", "Ptr", graphics, "Ptr", image, "Int", dstx, "Int", dsty, "Int", dstwidth, "Int", dstheight, "Int", srcx, "Int", srcy, "Int", srcwidth, "Int", srcheight, "Int", srcUnit, "Ptr", imageAttributes, "Ptr", callback, "Ptr", callbackData)

    /**
     * Draws a portion of an image at a specified location and with a specified size.
     * @param {Pointer} graphics - Pointer to the Graphics object.
     * @param {Pointer} image - Pointer to the Image object to draw.
     * @param {Pointer} destPoints - Pointer to an array of Point structures that define the destination parallelogram.
     * @param {Integer} count - The number of points in the destPoints array.
     * @param {Integer} srcx - The x-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcy - The y-coordinate of the upper-left corner of the source rectangle.
     * @param {Integer} srcwidth - The width of the source rectangle.
     * @param {Integer} srcheight - The height of the source rectangle.
     * @param {Integer} srcUnit - The unit of measure used for the source rectangle.
     * @param {Pointer} imageAttributes - Pointer to an ImageAttributes object that specifies recoloring and gamma information.
     * @param {Pointer} callback - Pointer to a callback function that specifies a color key.
     * @param {Pointer} callbackData - Pointer to a value that is passed to the callback function.
     * @returns {Integer} Status code.
     */
    static DrawImagePointsRectI(graphics, image, destPoints, count, srcx, srcy, srcwidth, srcheight, srcUnit, imageAttributes, callback, callbackData) => DllCall("gdiplus\GdipDrawImagePointsRectI", "Ptr", graphics, "Ptr", image, "Ptr", destPoints, "Int", count, "Int", srcx, "Int", srcy, "Int", srcwidth, "Int", srcheight, "Int", srcUnit, "Ptr", imageAttributes, "Ptr", callback, "Ptr", callbackData)

    /**
     * Creates a texture brush based on an image.
     * @param {Pointer} image - Pointer to the Image object to use for the texture.
     * @param {Integer} wrapMode - The wrap mode for the texture.
     * @param {Integer} x - The x-coordinate of the upper-left corner of the image rectangle.
     * @param {Integer} y - The y-coordinate of the upper-left corner of the image rectangle.
     * @param {Integer} width - The width of the image rectangle.
     * @param {Integer} height - The height of the image rectangle.
     * @param {Ptr*} texture - Pointer to a variable that receives the TextureBrush object.
     * @returns {Integer} Status code.
     */
    static CreateTexture2I(image, wrapMode, x, y, width, height, texture) => DllCall("gdiplus\GdipCreateTexture2I", "Ptr", image, "Int", wrapMode, "Int", x, "Int", y, "Int", width, "Int", height, "Ptr*", texture)

    /**
     * Creates a LinearGradientBrush object based on a line defined by two points.
     * @param {Integer} x1 - The x-coordinate of the starting point of the line.
     * @param {Integer} y1 - The y-coordinate of the starting point of the line.
     * @param {Integer} x2 - The x-coordinate of the ending point of the line.
     * @param {Integer} y2 - The y-coordinate of the ending point of the line.
     * @param {Integer} color1 - The starting color for the gradient.
     * @param {Integer} color2 - The ending color for the gradient.
     * @param {Ptr*} lineGradient - Pointer to a variable that receives the LinearGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreateLineBrushI(x1, y1, x2, y2, color1, color2, lineGradient) => DllCall("gdiplus\GdipCreateLineBrushI", "Int", x1, "Int", y1, "Int", x2, "Int", y2, "Int", color1, "Int", color2, "Ptr*", lineGradient)

    /**
     * Creates a LinearGradientBrush object based on a rectangle.
     * @param {Pointer} rect - Pointer to a Rect structure that defines the boundary rectangle for the linear gradient.
     * @param {Integer} color1 - The starting color for the gradient.
     * @param {Integer} color2 - The ending color for the gradient.
     * @param {Integer} mode - The mode that specifies how the gradient is oriented.
     * @param {Ptr*} lineGradient - Pointer to a variable that receives the LinearGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreateLineBrushFromRectI(rect, color1, color2, mode, lineGradient) => DllCall("gdiplus\GdipCreateLineBrushFromRectI", "Ptr", rect, "Int", color1, "Int", color2, "Int", mode, "Ptr*", lineGradient)

    /**
     * Creates a LinearGradientBrush object based on a rectangle and a rotation angle.
     * @param {Pointer} rect - Pointer to a Rect structure that defines the boundary rectangle for the linear gradient.
     * @param {Integer} color1 - The starting color for the gradient.
     * @param {Integer} color2 - The ending color for the gradient.
     * @param {Float} angle - The rotation angle of the gradient.
     * @param {Integer} isAngleScalable - Specifies whether the angle is scalable.
     * @param {Ptr*} lineGradient - Pointer to a variable that receives the LinearGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreateLineBrushFromRectWithAngleI(rect, color1, color2, angle, isAngleScalable, lineGradient) => DllCall("gdiplus\GdipCreateLineBrushFromRectWithAngleI", "Ptr", rect, "Int", color1, "Int", color2, "Float", angle, "Int", isAngleScalable, "Ptr*", lineGradient)

    /**
     * Gets the rectangle that defines the boundaries of a LinearGradientBrush object.
     * @param {Pointer} brush - Pointer to the LinearGradientBrush object.
     * @param {Ptr*} rect - Pointer to a Rect structure that receives the boundary rectangle.
     * @returns {Integer} Status code.
     */
    static GetLineRectI(brush, rect) => DllCall("gdiplus\GdipGetLineRectI", "Ptr", brush, "Ptr", rect)

    /**
     * Creates a PathGradientBrush object based on an array of points.
     * @param {Pointer} points - Pointer to an array of Point structures that define the brush's boundary path.
     * @param {Integer} count - The number of points in the array.
     * @param {Integer} wrapMode - The wrap mode for the brush.
     * @param {Ptr*} polyGradient - Pointer to a variable that receives the PathGradientBrush object.
     * @returns {Integer} Status code.
     */
    static CreatePathGradientI(points, count, wrapMode, polyGradient) => DllCall("gdiplus\GdipCreatePathGradientI", "Ptr", points, "Int", count, "Int", wrapMode, "Ptr*", polyGradient)

    /**
     * Gets the center point of a PathGradientBrush object.
     * @param {Pointer} brush - Pointer to the PathGradientBrush object.
     * @param {Ptr*} points - Pointer to a Point structure that receives the center point.
     * @returns {Integer} Status code.
     */
    static GetPathGradientCenterPointI(brush, points) => DllCall("gdiplus\GdipGetPathGradientCenterPointI", "Ptr", brush, "Ptr", points)

    /**
     * Sets the center point of a PathGradientBrush object.
     * @param {Pointer} brush - Pointer to the PathGradientBrush object.
     * @param {Pointer} points - Pointer to a Point structure that specifies the new center point.
     * @returns {Integer} Status code.
     */
    static SetPathGradientCenterPointI(brush, points) => DllCall("gdiplus\GdipSetPathGradientCenterPointI", "Ptr", brush, "Ptr", points)

    /**
     * Gets the bounding rectangle of a PathGradientBrush object.
     * @param {Pointer} brush - Pointer to the PathGradientBrush object.
     * @param {Ptr*} rect - Pointer to a Rect structure that receives the bounding rectangle.
     * @returns {Integer} Status code.
     */
    static GetPathGradientRectI(brush, rect) => DllCall("gdiplus\GdipGetPathGradientRectI", "Ptr", brush, "Ptr", rect)

    /**
     * Defines composition modes for drawing operations.
     */
    class CMode
    {
        /** Blended composition mode. */
        static Blended   => 0

        /** Overwrite composition mode. */
        static Overwrite => 1
    }

    /**
     * Defines smoothing modes for drawing operations.
     */
    class SMode
    {
        /** No smoothing. */
        static None        => 0

        /** Optimized for speed. */
        static HighSpeed   => 1

        /** Optimized for quality. */
        static HighQuality => 2

        /** Default smoothing mode. */
        static Default     => 3

        /** Anti-aliasing smoothing mode. */
        static AntiAlias   => 4
    }

    /**
     * Defines interpolation modes for image scaling.
     */
    class IMode
    {
        /** Default interpolation mode. */
        static Default             => 0

        /** Low quality interpolation. */
        static LowQuality          => 1

        /** High quality interpolation. */
        static HighQuality         => 2

        /** Bilinear interpolation. */
        static Bilinear            => 3

        /** Bicubic interpolation. */
        static Bicubic             => 4

        /** Nearest-neighbor interpolation. */
        static NearestNeighbor     => 5

        /** High quality bilinear interpolation. */
        static HighQualityBilinear => 6

        /** High quality bicubic interpolation. */
        static HighQualityBicubic  => 7
    }

    /**
     * Represents an encoder parameter for image encoding.
     */
    class EncoderParameter
    {
        /**  The GUID of the parameter. */
        Guid := 0

        /**  The number of values for the parameter. */
        NumberOfValues := 0

        /**  The type of the parameter. */
        Type := 0

        /**  The value of the parameter. */
        Value := 0
    }

    /**
     * Represents a color palette for indexed-color images.
     */
    class ColorPalette
    {
        /** Palette flags. */
        Flags := 0

        /** Number of colors in the palette. */
        Count := 0

        /** Array of color entries. */
        Entries := []
    }

    /**
     * Stores the pixel data for a Bitmap object.
     */
    class BitmapData
    {
        /**  The width of the bitmap. */
        Width := 0

        /**  The height of the bitmap. */
        Height := 0

        /**  The stride of the bitmap. */
        Stride := 0

        /**  The pixel format of the bitmap. */
        PixelFormat := 0

        /**  A pointer to the first scan line of the bitmap. */
        Scan0 := 0

        /**  Reserved for future use. */
        Reserved := 0
    }

    /**
     * Represents a size with integer values.
     */
    class Size
    {
        /** The width component of the size. */
        Width := 0
        /** The height component of the size. */
        Height := 0
    }

    /**
     * Represents the data points that make up a graphics path.
     */
    class PathData
    {
        /** The number of points in the path. */
        Count := 0

        /** Array of points in the path. */
        Points := []

        /** Array of point types in the path. */
        Types := []
    }

    /**
     * Represents a 5x5 matrix used for color transformations.
     */
    class ColorMatrix
    {
        /** The 5x5 matrix of color transformation values. */
        Matrix := [
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 0.0, 0.0]
        ]
    }

    /**
     * Represents the StartupInput structure.
     */
    class StartupInput
    {
        /** The GDI+ version. Should be 1. */
        Version := 1
        /** Pointer to a DebugEventProc callback function. */
        DebugEventCallback := 0
        /** Indicates whether to suppress the background thread. */
        SuppressBackgroundThread := false
        /** Indicates whether to suppress external codecs. */
        SuppressExternalCodecs := false
    }

    /**
     * Represents the StartupOutput structure.
     */
    class StartupOutput
    {
        /** Pointer to the notification hook function. */
        NotificationHook := 0
        /** Pointer to the notification unhook function. */
        NotificationUnhook := 0
    }

    /**
     * Represents the ColorMap structure.
     */
    class ColorMap
    {
        /** The old color to be replaced. */
        OldColor := 0
        /** The new color to replace the old color. */
        NewColor := 0
    }

    /**
     * Represents the EncoderParameters structure.
     */
    class EncoderParameters
    {
        /** The number of EncoderParameter structures in the array. */
        Count := 0
        /** An array of EncoderParameter structures. */
        Parameter := []
    }

    /**
     * Represents the ImageCodecInfo structure.
     */
    class ImageCodecInfo
    {
        /** The GUID of the codec. */
        Clsid := ""
        /** The format of the image. */
        FormatID := ""
        /** A pointer to a wide-character string that contains the codec name. */
        CodecName := ""
        /** A pointer to a wide-character string that contains the format description. */
        DllName := ""
        /** A pointer to a wide-character string that contains the format description. */
        FormatDescription := ""
        /** A pointer to a wide-character string that contains the file name extension(s). */
        FilenameExtension := ""
        /** A pointer to a wide-character string that contains the mime type. */
        MimeType := ""
        /** A combination of flags from the ImageCodecFlags enumeration. */
        Flags := 0
        /** The version of the codec. */
        Version := 0
        /** The number of signatures used by the file format. */
        SigCount := 0
        /** The number of bytes in each signature. */
        SigSize := 0
        /** A pointer to an array of bytes that contains the signature. */
        SigPattern := 0
        /** A pointer to an array of bytes that contains the mask. */
        SigMask := 0
    }

    /**
     * Represents the PropertyItem structure.
     */
    class PropertyItem
    {
        /** The ID of the property. */
        ID := 0
        /** The length, in bytes, of the value. */
        Length := 0
        /** The type of the value. */
        Type := 0
        /** A pointer to the property value. */
        Value := 0
    }

    /**
     * Represents a range of character positions.
     */
    class CharacterRange
    {
        /** The first position in the range. */
        First := 0
        /** The number of positions in the range. */
        Length := 0
    }

    /**
     * Contains information about a metafile.
     */
    class MetafileHeader
    {
        /** Type of the metafile. */
        Type := 0
        /** Size of the metafile, in bytes. */
        Size := 0
        /** Version of the metafile. */
        Version := 0
        /** Flags to indicate the nature of the metafile. */
        EmfPlusFlags := 0
        /** DPI in the x direction. */
        DpiX := 0.0
        /** DPI in the y direction. */
        DpiY := 0.0
        /** Bounding rectangle for the metafile. */
        X := 0
        /** Bounding rectangle for the metafile. */
        Y := 0
        /** Bounding rectangle for the metafile. */
        Width := 0
        /** Bounding rectangle for the metafile. */
        Height := 0
        /** Union of header structures. */
        Header := {EmfHeader: 0, WmfHeader: 0}
        /** Number of metafile records. */
        EmfPlusHeaderSize := 0
        /** Logical DPI in the x direction. */
        LogicalDpiX := 0
        /** Logical DPI in the y direction. */
        LogicalDpiY := 0
    }

    /**
     * Represents image item data.
     */
    class ImageItemData
    {
        /** Size of the structure. */
        Size := 0
        /** Position of the item. */
        Position := 0
        /** Pointer to the item data. */
        Desc := 0
        /** Type of the data. */
        DescSize := 0
        /** Pointer to the item data. */
        Data := 0
        /** Size of the data. */
        DataSize := 0
        /** Type of the image item. */
        Cookie := 0
    }

    /**
     * Represents GDI+ abort structure.
     */
    class Abort
    {
        /** Pointer to the abort callback function. */
        Callback := 0
        /** Pointer to user-defined data. */
        Context := 0
    }

    /**
     * Represents GDI+ drawing text structure.
     */
    class DrawingText
    {
        /** Pointer to the text string. */
        Text := 0
        /** Length of the text string. */
        Length := 0
        /** Pointer to the font object. */
        Font := 0
        /** Layout rectangle for the text. */
        LayoutRect := {X: 0, Y: 0, Width: 0, Height: 0}
        /** Pointer to the string format object. */
        StringFormat := 0
    }

    /**
     * Represents GDI+ effect parameters structure.

     */
    class EffectParams
    {
        /** GUID of the effect. */
        Guid := ""
        /** Size of the parameter data. */
        Size := 0
        /** Pointer to the parameter data. */
        Data := 0
    }

    /**
     * Represents the elements of a GDI+ matrix.

     */
    class MatrixElements
    {
        /** The value in the first row and first column. */
        M11 := 0.0
        /** The value in the first row and second column. */
        M12 := 0.0
        /** The value in the second row and first column. */
        M21 := 0.0
        /** The value in the second row and second column. */
        M22 := 0.0
        /** The value in the third row and first column. */
        Dx := 0.0
        /** The value in the third row and second column. */
        Dy := 0.0
    }

    /**
     * Represents GDI+ brush data.

     */
    class BrushData
    {
        /** The type of the brush. */
        Type := 0
        /** Pointer to the brush object. */
        Brush := 0
    }

    /**
     * Represents GDI+ pen data.

     */
    class PenData
    {
        /** The type of the pen. */
        Type := 0
        /** Pointer to the pen object. */
        Pen := 0
    }

    /**
     * Represents GDI+ path point types.

     */
    class PathPointType
    {
        /** Start point of a subpath. */
        static Start => 0
        /** Line point. */
        static Line => 1
        /** Bezier control point. */
        static Bezier => 3
        /** Close figure flag. */
        static CloseSubpath => 0x80
    }

    /**
     * Represents a GDI+ path point with integer coordinates.

     */
    class PathPoint
    {
        /** The x-coordinate of the point. */
        X := 0
        /** The y-coordinate of the point. */
        Y := 0
        /** The type of the point. */
        Type := 0
    }

    /**
     * Represents a GDI+ region node.

     */
    class RegionNode
    {
        /** The type of the region node. */
        Type := 0
        /** Pointer to the region node data. */
        Data := 0
    }

    /**
     * Represents a list of GDI+ image decoders.

     */
    class ImageDecoderList
    {
        /** The number of decoders in the list. */
        Count := 0
        /** Pointer to an array of ImageCodecInfo structures. */
        Decoders := 0
    }

    /**
     * Represents a list of GDI+ image encoders.

     */
    class ImageEncoderList
    {
        /** The number of encoders in the list. */
        Count := 0
        /** Pointer to an array of ImageCodecInfo structures. */
        Encoders := 0
    }

    /**
     * Represents GDI+ image load flags.

     */
    class ImageLoadFlags
    {
        /** Load the image as read-only. */
        static ReadOnly => 0x0001
        /** Cache the image for faster rendering. */
        static Cached => 0x0002
    }

    /**
     * Represents GDI+ image save flags.
     */
    class ImageSaveFlags
    {
        /** Save the image with multi-frame support. */
        static MultiFrame => 0x0001
        /** Save the image with color space information. */
        static ColorSpaceInfo => 0x0002
        /** Save the image with transformation information. */
        static Transform => 0x0004
    }

    /**
     * Represents GDI+ pixel format.
     */
    class PixelFormat
    {
        /** 32-bit ARGB pixel format. */
        static Format32bppARGB => 0x26200A
        /** 32-bit RGB pixel format. */
        static Format32bppRGB => 0x22009
        /** 24-bit RGB pixel format. */
        static Format24bppRGB => 0x21808
        /** 16-bit RGB pixel format. */
        static Format16bppRGB565 => 0x21005
        /** 16-bit RGB pixel format with alpha. */
        static Format16bppARGB1555 => 0x21007
        /** 8-bit indexed pixel format. */
        static Format8bppIndexed => 0x30803
    }
}