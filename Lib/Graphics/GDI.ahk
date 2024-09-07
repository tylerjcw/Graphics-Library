#Requires AutoHotkey v2.0

class GDI
{
    /**
     * Creates a memory device context (DC) compatible with the specified device.
     * @param {Ptr} hdc - A handle to an existing DC. If this handle is NULL, the function creates a memory DC compatible with the application's current screen.
     * @returns {Ptr} A handle to the new memory DC if the function succeeds, NULL otherwise.
     */
    static CreateCompatibleDC(hdc := 0) => DllCall("Gdi32.dll\CreateCompatibleDC", "Ptr", hdc, "Ptr")

    /**
     * Creates a bitmap compatible with the device associated with the specified device context.
     * @param {Ptr} hdc - A handle to a device context.
     * @param {Integer} width - The bitmap width, in pixels.
     * @param {Integer} height - The bitmap height, in pixels.
     * @returns {Ptr} A handle to the compatible bitmap if successful, or NULL otherwise.
     */
    static CreateCompatibleBitmap(hdc, width, height) => DllCall("Gdi32.dll\CreateCompatibleBitmap", "Ptr", hdc, "Int", width, "Int", height, "Ptr")

    /**
     * Retrieves a handle to a device context (DC) for the client area of a specified window or for the entire screen.
     * @param {Ptr} hwnd - A handle to the window whose DC is to be retrieved. If this value is NULL, GetDC retrieves the DC for the entire screen.
     * @returns {Ptr} A handle to the DC for the specified window's client area if successful, or NULL otherwise.
     */
    static GetDC(hwnd := 0) => DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    /**
     * Releases a device context (DC), freeing it for use by other applications.
     * @param {Ptr} hwnd - A handle to the window whose DC is to be released.
     * @param {Ptr} hdc - A handle to the DC to be released.
     * @returns {Integer} 1 if the DC was released or 0 if the DC was not released.
     */
    static ReleaseDC(hwnd, hdc) => DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc)

    /**
     * Deletes the specified device context (DC).
     * @param {Ptr} hdc - A handle to the device context.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static DeleteDC(hdc) => DllCall("Gdi32.dll\DeleteDC", "Ptr", hdc)

    /**
     * Saves the current state of the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @returns {Integer} A value that can be used to restore the device context.
     */
    static SaveDC(hdc) => DllCall("Gdi32.dll\SaveDC", "Ptr", hdc)

    /**
     * Restores a device context to the specified state.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} nSavedDC - The saved state to be restored.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static RestoreDC(hdc, nSavedDC) => DllCall("Gdi32.dll\RestoreDC", "Ptr", hdc, "Int", nSavedDC)

    /**
     * Retrieves device-specific information for the specified device.
     * @param {Ptr} hdc - A handle to the DC.
     * @param {Integer} index - The item to be returned.
     * @returns {Integer} The value of the desired item.
     */
    static GetDeviceCaps(hdc, index) => DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", hdc, "Int", index)

    /**
     * Sets the current foreground mix mode. GDI uses the foreground mix mode to combine pens and interiors of filled objects with the colors already on the screen.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} rop2 - The mix mode.
     * @returns {Integer} The previous mix mode if successful, or 0 otherwise.
     */
    static SetROP2(hdc, rop2) => DllCall("Gdi32.dll\SetROP2", "Ptr", hdc, "Int", rop2)

    /**
     * Sets the mapping mode of the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} mode - The new mapping mode.
     * @returns {Integer} The previous mapping mode.
     */
    static SetMapMode(hdc, mode) => DllCall("Gdi32.dll\SetMapMode", "Ptr", hdc, "Int", mode)

    /**
     * Sets the horizontal and vertical extents of the window for a device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The horizontal extent.
     * @param {Integer} y - The vertical extent.
     * @param {VarRef} [prevX] - Optional variable to store the previous horizontal extent.
     * @param {VarRef} [prevY] - Optional variable to store the previous vertical extent.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static SetWindowExtEx(hdc, x, y, &prevX := 0, &prevY := 0)
    {
        point := Buffer(8, 0)
        result := DllCall("Gdi32.dll\SetWindowExtEx", "Ptr", hdc, "Int", x, "Int", y, "Ptr", point)
        if (result)
        {
            prevX := NumGet(point, 0, "Int")
            prevY := NumGet(point, 4, "Int")
        }
        return result
    }

    /**
     * Sets the horizontal and vertical extents of the viewport for a device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The horizontal extent.
     * @param {Integer} y - The vertical extent.
     * @param {VarRef} [prevX] - Optional variable to store the previous horizontal extent.
     * @param {VarRef} [prevY] - Optional variable to store the previous vertical extent.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static SetViewportExtEx(hdc, x, y, &prevX := 0, &prevY := 0)
    {
        point := Buffer(8, 0)
        result := DllCall("Gdi32.dll\SetViewportExtEx", "Ptr", hdc, "Int", x, "Int", y, "Ptr", point)
        if (result)
        {
            prevX := NumGet(point, 0, "Int")
            prevY := NumGet(point, 4, "Int")
        }
        return result
    }

    /**
     * Creates a logical pen.
     * @param {Integer} style - The pen style.
     * @param {Integer} width - The width of the pen.
     * @param {Integer} color - The color of the pen.
     * @returns {Ptr} A handle to the newly created pen.
     */
    static CreatePen(style, width, color) => DllCall("Gdi32.dll\CreatePen", "Int", style, "Int", width, "UInt", color, "Ptr")

    /**
     * Creates a logical brush with a specified solid color.
     * @param {Integer} color - The color of the brush.
     * @returns {Ptr} A handle to the newly created brush.
     */
    static CreateSolidBrush(color) => DllCall("Gdi32.dll\CreateSolidBrush", "UInt", color, "Ptr")

    /**
     * Selects an object into the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} hgdiobj - A handle to the object to be selected.
     * @returns {Ptr} A handle to the object being replaced.
     */
    static SelectObject(hdc, hgdiobj) => DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", hgdiobj, "Ptr")

    /**
     * Deletes a logical pen, brush, font, bitmap, region, or palette.
     * @param {Ptr} hObject - A handle to the object to be deleted.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static DeleteObject(hObject) => DllCall("Gdi32.dll\DeleteObject", "Ptr", hObject)

    /**
     * Creates a rectangular region.
     * @param {Integer} left - x-coordinate of upper-left corner of region.
     * @param {Integer} top - y-coordinate of upper-left corner of region.
     * @param {Integer} right - x-coordinate of lower-right corner of region.
     * @param {Integer} bottom - y-coordinate of lower-right corner of region.
     * @returns {Ptr} Handle to the region if successful, NULL otherwise.
     */
    static CreateRectRgn(left, top, right, bottom) => DllCall("Gdi32.dll\CreateRectRgn", "Int", left, "Int", top, "Int", right, "Int", bottom, "Ptr")

    /**
     * Sets the clipping region of a device context.
     * @param {Ptr} hdc - Handle to the device context.
     * @param {Ptr} hrgn - Handle to the region.
     * @returns {Integer} The region's type.
     */
    static SelectClipRgn(hdc, hrgn) => DllCall("Gdi32.dll\SelectClipRgn", "Ptr", hdc, "Ptr", hrgn)

    /**
     * Draws a line from the current position up to, but not including, the specified point.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The x-coordinate of the line's ending point.
     * @param {Integer} y - The y-coordinate of the line's ending point.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static LineTo(hdc, x, y) => DllCall("Gdi32.dll\LineTo", "Ptr", hdc, "Int", x, "Int", y)

    /**
     * Updates the current position to the specified point and optionally returns the previous position.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The x-coordinate of the new position, in logical units.
     * @param {Integer} y - The y-coordinate of the new position, in logical units.
     * @param {Ptr} lpPoint - A pointer to a POINT structure that receives the previous current position. This parameter can be NULL.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static MoveToEx(hdc, x, y, lpPoint := 0) => DllCall("Gdi32.dll\MoveToEx", "Ptr", hdc, "Int", x, "Int", y, "Ptr", lpPoint)

    /**
     * Draws a rectangle.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} top - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} right - The x-coordinate of the lower-right corner of the rectangle.
     * @param {Integer} bottom - The y-coordinate of the lower-right corner of the rectangle.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static Rectangle(hdc, left, top, right, bottom) => DllCall("Gdi32.dll\Rectangle", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom)

    /**
     * Fills a rectangle by using the specified brush.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Object} rect - An object with left, top, right, and bottom properties defining the rectangle.
     * @param {Ptr} hbr - A handle to the brush used to fill the rectangle.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static FillRect(hdc, rect, hbr)
    {
        rectBuffer := Buffer(16)
        NumPut("Int", rect.left, rectBuffer, 0)
        NumPut("Int", rect.top, rectBuffer, 4)
        NumPut("Int", rect.right, rectBuffer, 8)
        NumPut("Int", rect.bottom, rectBuffer, 12)
        return DllCall("User32.dll\FillRect", "Ptr", hdc, "Ptr", rectBuffer, "Ptr", hbr)
    }

    /**
     * Draws an ellipse using the current pen. The ellipse is outlined by using the current pen and filled by using the current brush.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} top - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} right - The x-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} bottom - The y-coordinate of the lower-right corner of the bounding rectangle.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static Ellipse(hdc, left, top, right, bottom) => DllCall("Gdi32.dll\Ellipse", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom)

    /**
     * Sets the background mode for text and hatched brushes.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} mode - The background mode.
     * @returns {Integer} The previous background mode if the function succeeds, zero if it fails.
     */
    static SetBkMode(hdc, mode) => DllCall("Gdi32.dll\SetBkMode", "Ptr", hdc, "Int", mode)

    /**
     * Sets the text color for the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} color - The color of the text.
     * @returns {Integer} The previous text color if the function succeeds, CLR_INVALID if it fails.
     */
    static SetTextColor(hdc, color) => DllCall("Gdi32.dll\SetTextColor", "Ptr", hdc, "UInt", color)

    /**
     * Writes a string at the specified location.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The x-coordinate of the starting position of the text.
     * @param {Integer} y - The y-coordinate of the starting position of the text.
     * @param {String} text - The text string to be drawn.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static TextOut(hdc, x, y, text) => DllCall("Gdi32.dll\TextOutW", "Ptr", hdc, "Int", x, "Int", y, "Str", text, "Int", StrLen(text))

    /**
     * Draws formatted text in the specified rectangle.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {String} text - The string to be drawn.
     * @param {Object} rect - An object with left, top, right, and bottom properties defining the rectangle.
     * @param {Integer} format - The method of formatting the text.
     * @returns {Integer} The height of the text if the function succeeds, zero if it fails.
     */
    static DrawText(hdc, text, rect, format)
    {
        rectBuffer := Buffer(16)
        NumPut("Int", rect.left, rectBuffer, 0)
        NumPut("Int", rect.top, rectBuffer, 4)
        NumPut("Int", rect.right, rectBuffer, 8)
        NumPut("Int", rect.bottom, rectBuffer, 12)
        return DllCall("User32.dll\DrawText", "Ptr", hdc, "Str", text, "Int", -1, "Ptr", rectBuffer, "UInt", format)
    }

    /**
     * Creates a logical font with the specified characteristics.
     * @param {Integer} height - The height of the font.
     * @param {Integer} width - The width of the font.
     * @param {Integer} escapement - The angle, in tenths of degrees, between the escapement vector and the x-axis of the device.
     * @param {Integer} orientation - The angle, in tenths of degrees, between each character's base line and the x-axis of the device.
     * @param {Integer} weight - The weight of the font in the range 0 through 1000.
     * @param {Integer} italic - Specifies an italic font if set to TRUE.
     * @param {Integer} underline - Specifies an underlined font if set to TRUE.
     * @param {Integer} strikeOut - Specifies a strikeout font if set to TRUE.
     * @param {Integer} charSet - The character set.
     * @param {Integer} outputPrecision - The output precision.
     * @param {Integer} clipPrecision - The clipping precision.
     * @param {Integer} quality - The output quality.
     * @param {Integer} pitchAndFamily - The pitch and family of the font.
     * @param {String} faceName - The typeface name of the font.
     * @returns {Ptr} A handle to the font if successful, or NULL otherwise.
     */
    static CreateFont(height, width, escapement, orientation, weight, italic, underline, strikeOut, charSet, outputPrecision, clipPrecision, quality, pitchAndFamily, faceName) => DllCall("Gdi32.dll\CreateFont", "Int", height, "Int", width, "Int", escapement, "Int", orientation, "Int", weight, "UInt", italic, "UInt", underline, "UInt", strikeOut, "UInt", charSet, "UInt", outputPrecision, "UInt", clipPrecision, "UInt", quality, "UInt", pitchAndFamily, "Str", faceName, "Ptr")

    /**
     * Computes the width and height of the specified string of text.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {String} text - The string to be measured.
     * @returns {Object} An object with width and height properties.
     */
    static GetTextExtentPoint32(hdc, text)
    {
        size := Buffer(8)
        DllCall("Gdi32.dll\GetTextExtentPoint32", "Ptr", hdc, "Str", text, "Int", StrLen(text), "Ptr", size)
        return {width: NumGet(size, 0, "Int"), height: NumGet(size, 4, "Int")}
    }

    /**
     * Paints the specified rectangle using the brush that is currently selected into the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The x-coordinate, in logical units, of the upper-left corner of the rectangle to be filled.
     * @param {Integer} y - The y-coordinate, in logical units, of the upper-left corner of the rectangle to be filled.
     * @param {Integer} w - The width, in logical units, of the rectangle.
     * @param {Integer} h - The height, in logical units, of the rectangle.
     * @param {Integer} rop - The raster operation code.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static PatBlt(hdc, x, y, w, h, rop) => DllCall("Gdi32.dll\PatBlt", "Ptr", hdc, "Int", x, "Int", y, "Int", w, "Int", h, "UInt", rop)

    /**
     * Performs a bit-block transfer of color data from a source rectangle to a destination rectangle.
     * @param {Ptr} hdc - A handle to the destination device context.
     * @param {Integer} x - The x-coordinate, in logical units, of the upper-left corner of the destination rectangle.
     * @param {Integer} y - The y-coordinate, in logical units, of the upper-left corner of the destination rectangle.
     * @param {Integer} w - The width, in logical units, of the destination rectangle and source rectangle.
     * @param {Integer} h - The height, in logical units, of the destination rectangle and source rectangle.
     * @param {Ptr} hdcSrc - A handle to the source device context.
     * @param {Integer} xSrc - The x-coordinate, in logical units, of the upper-left corner of the source rectangle.
     * @param {Integer} ySrc - The y-coordinate, in logical units, of the upper-left corner of the source rectangle.
     * @param {Integer} rop - A raster-operation code that specifies how the color data for the source rectangle is to be combined with the color data for the destination rectangle.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static BitBlt(hdc, x, y, w, h, hdcSrc, xSrc, ySrc, rop) => DllCall("Gdi32.dll\BitBlt", "Ptr", hdc, "Int", x, "Int", y, "Int", w, "Int", h, "Ptr", hdcSrc, "Int", xSrc, "Int", ySrc, "UInt", rop)

    /**
     * Copies a bitmap from a source rectangle into a destination rectangle, stretching or compressing the bitmap to fit the dimensions of the destination rectangle, if necessary.
     * @param {Ptr} hdcDest - A handle to the destination device context.
     * @param {Integer} xDest - The x-coordinate, in logical units, of the upper-left corner of the destination rectangle.
     * @param {Integer} yDest - The y-coordinate, in logical units, of the upper-left corner of the destination rectangle.
     * @param {Integer} wDest - The width, in logical units, of the destination rectangle.
     * @param {Integer} hDest - The height, in logical units, of the destination rectangle.
     * @param {Ptr} hdcSrc - A handle to the source device context.
     * @param {Integer} xSrc - The x-coordinate, in logical units, of the upper-left corner of the source rectangle.
     * @param {Integer} ySrc - The y-coordinate, in logical units, of the upper-left corner of the source rectangle.
     * @param {Integer} wSrc - The width, in logical units, of the source rectangle.
     * @param {Integer} hSrc - The height, in logical units, of the source rectangle.
     * @param {Integer} rop - The raster operation to be performed.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static StretchBlt(hdcDest, xDest, yDest, wDest, hDest, hdcSrc, xSrc, ySrc, wSrc, hSrc, rop) => DllCall("Gdi32.dll\StretchBlt", "Ptr", hdcDest, "Int", xDest, "Int", yDest, "Int", wDest, "Int", hDest, "Ptr", hdcSrc, "Int", xSrc, "Int", ySrc, "Int", wSrc, "Int", hSrc, "UInt", rop)

    /**
     * Sets the bitmap stretching mode in the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} mode - The stretching mode.
     * @returns {Integer} The previous stretching mode if successful, 0 otherwise.
     */
    static SetStretchBltMode(hdc, mode) => DllCall("Gdi32.dll\SetStretchBltMode", "Ptr", hdc, "Int", mode)

    /**
     * Draws a polygon consisting of two or more vertices connected by straight lines.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Array} points - An array of Point objects, where each Point has x and y properties.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static Polygon(hdc, points)
    {
        pointCount := points.Length
        pPoints := Buffer(8 * pointCount, 0)
        for i, point in points
        {
            NumPut("Int", point.x, pPoints, (i-1)*8)
            NumPut("Int", point.y, pPoints, (i-1)*8+4)
        }
        return DllCall("Gdi32.dll\Polygon", "Ptr", hdc, "Ptr", pPoints, "Int", pointCount)
    }

    /**
     * Draws a series of line segments by connecting the points in the specified array.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Array} points - An array of Point objects, where each Point has x and y properties.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static PolyLine(hdc, points)
    {
        pointCount := points.Length
        pPoints := Buffer(8 * pointCount, 0)
        for i, point in points {
            NumPut("Int", point.x, pPoints, (i-1)*8)
            NumPut("Int", point.y, pPoints, (i-1)*8+4)
        }
        return DllCall("Gdi32.dll\Polyline", "Ptr", hdc, "Ptr", pPoints, "Int", pointCount)
    }

    /**
     * Sets the polygon fill mode for functions that fill polygons.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} mode - The fill mode. Use values from GDI.FillMode.
     * @returns {Integer} The previous fill mode if successful, 0 otherwise.
     */
    static SetPolyFillMode(hdc, mode) => DllCall("Gdi32.dll\SetPolyFillMode", "Ptr", hdc, "Int", mode)

    /**
     * Retrieves a handle to one of the stock pens, brushes, fonts, or palettes.
     * @param {Integer} object - The type of stock object.
     * @returns {Ptr} A handle to the requested stock object if successful, 0 otherwise.
     */
    static GetStockObject(object) => DllCall("Gdi32.dll\GetStockObject", "Int", object, "Ptr")

    /**
     * Loads an image (icon, cursor, or bitmap) from a file or resource.
     * @param {Integer} hInst - Handle to the instance of the module that contains the image. For files, set to 0.
     * @param {String} name - Name of the file or resource containing the image.
     * @param {Integer} type - Type of image to load.
     * @param {Integer} cx - Desired width of the image.
     * @param {Integer} cy - Desired height of the image.
     * @param {Integer} fuLoad - Load flags.
     * @returns {Ptr} Handle to the newly loaded image if successful, 0 otherwise.
     */
    static LoadImage(hInst, name, type, cx, cy, fuLoad) => DllCall("User32.dll\LoadImage", "Ptr", hInst, "Str", name, "UInt", type, "Int", cx, "Int", cy, "UInt", fuLoad, "Ptr")

    /**
     * Draws an elliptical arc.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x1 - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} y1 - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} x2 - The x-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} y2 - The y-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} x3 - The x-coordinate of the arc's starting point.
     * @param {Integer} y3 - The y-coordinate of the arc's starting point.
     * @param {Integer} x4 - The x-coordinate of the arc's ending point.
     * @param {Integer} y4 - The y-coordinate of the arc's ending point.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static Arc(hdc, x1, y1, x2, y2, x3, y3, x4, y4) => DllCall("Gdi32.dll\Arc", "Ptr", hdc, "Int", x1, "Int", y1, "Int", x2, "Int", y2, "Int", x3, "Int", y3, "Int", x4, "Int", y4)

    /**
     * Draws an arc.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} top - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} right - The x-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} bottom - The y-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} startAngle - The starting angle of the arc in degrees.
     * @param {Integer} sweepAngle - The sweep angle of the arc in degrees.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static AngleArc(hdc, left, top, right, bottom, startAngle, sweepAngle) => DllCall("Gdi32.dll\Arc", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom, "Int", startAngle, "Int", sweepAngle)

    /**
     * Draws one or more Bézier curves.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Array} points - An array of Point objects, where each Point has x and y properties.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static PolyBezier(hdc, points)
    {
        pointCount := points.Length
        pPoints := Buffer(8 * pointCount, 0)
        for i, point in points
        {
            NumPut("Int", point.x, pPoints, (i-1)*8)
            NumPut("Int", point.y, pPoints, (i-1)*8+4)
        }
        return DllCall("Gdi32.dll\PolyBezier", "Ptr", hdc, "Ptr", pPoints, "UInt", pointCount)
    }

    /**
     * Closes an open figure in a path.
     * @param {Ptr} hdc - A handle to the device context.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static CloseFigure(hdc) => DllCall("Gdi32.dll\CloseFigure", "Ptr", hdc)

    /**
     * Opens a path bracket in the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static BeginPath(hdc) => DllCall("Gdi32.dll\BeginPath", "Ptr", hdc)

    /**
     * Closes a path bracket and selects the path defined by the bracket into the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static EndPath(hdc) => DllCall("Gdi32.dll\EndPath", "Ptr", hdc)

    /**
     * Closes any open figures in the current path and fills the path's interior by using the current brush and polygon-filling mode.
     * @param {Ptr} hdc - A handle to the device context.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static FillPath(hdc) => DllCall("Gdi32.dll\FillPath", "Ptr", hdc)

    /**
     * Renders the specified path by using the current pen.
     * @param {Ptr} hdc - A handle to the device context.
     * @returns {Integer} Nonzero if the function succeeds, zero if it fails.
     */
    static StrokePath(hdc) => DllCall("Gdi32.dll\StrokePath", "Ptr", hdc)

    /**
     * Sets the pixel at the specified coordinates to the specified color.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The x-coordinate of the pixel.
     * @param {Integer} y - The y-coordinate of the pixel.
     * @param {Integer} color - The color to be used to paint the pixel.
     * @returns {Integer} The previous color of the pixel if successful, -1 otherwise.
     */
    static SetPixel(hdc, x, y, color) => DllCall("Gdi32.dll\SetPixel", "Ptr", hdc, "Int", x, "Int", y, "UInt", color)

    /**
     * Retrieves the color value of the pixel at the specified coordinates.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The x-coordinate of the pixel.
     * @param {Integer} y - The y-coordinate of the pixel.
     * @returns {Integer} The color of the pixel as a COLORREF value.
     */
    static GetPixel(hdc, x, y) => DllCall("Gdi32.dll\GetPixel", "Ptr", hdc, "Int", x, "Int", y)

    /**
     * Retrieves the current world-space to page-space transformation.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} lpXform - A pointer to a XFORM structure that receives the transformation.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static GetWorldTransform(hdc, lpXform)
    {
        return DllCall("Gdi32.dll\GetWorldTransform", "Ptr", hdc, "Ptr", lpXform)
    }

    /**
     * Sets a two-dimensional linear transformation between world space and page space for the specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} lpXform - A pointer to a XFORM structure that specifies the transformation.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static SetWorldTransform(hdc, lpXform)
    {
        return DllCall("Gdi32.dll\SetWorldTransform", "Ptr", hdc, "Ptr", lpXform)
    }

    /**
     * Creates a DIB that applications can write to directly.
     * @param {Ptr} hdc - A handle to a device context.
     * @param {Ptr} pbmi - A pointer to a BITMAPINFO structure.
     * @param {UInt} usage - The usage for the DIB.
     * @param {Ptr&} ppvBits - A pointer to a variable that receives a pointer to the location of the DIB bit values.
     * @param {Ptr} hSection - A handle to a file-mapping object, or NULL.
     * @param {UInt} offset - The offset from the beginning of the file-mapping object where the bitmap bit values start.
     * @returns {Ptr} A handle to the newly created DIB, or NULL if the function fails.
     */
    static CreateDIBSection(hdc, pbmi, usage, &ppvBits, hSection := 0, offset := 0)
    {
        return DllCall("Gdi32.dll\CreateDIBSection", "Ptr", hdc, "Ptr", pbmi, "UInt", usage, "Ptr*", &ppvBits, "Ptr", hSection, "UInt", offset, "Ptr")
    }

    /**
     * Retrieves the bits of the specified compatible bitmap and copies them into a buffer as a DIB.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} hbm - A handle to the bitmap.
     * @param {UInt} start - The first scan line to retrieve.
     * @param {UInt} cLines - The number of scan lines to retrieve.
     * @param {Ptr} lpvBits - A pointer to a buffer to receive the bitmap data.
     * @param {Ptr} lpbi - A pointer to a BITMAPINFO structure.
     * @param {UInt} usage - The format of the bmiColors member of the BITMAPINFO structure.
     * @returns {Integer} The number of scan lines copied if successful, or zero if the function fails.
     */
    static GetDIBits(hdc, hbm, start, cLines, lpvBits, lpbi, usage)
    {
        return DllCall("Gdi32.dll\GetDIBits", "Ptr", hdc, "Ptr", hbm, "UInt", start, "UInt", cLines, "Ptr", lpvBits, "Ptr", lpbi, "UInt", usage)
    }

    /**
     * Sets the pixels in a compatible bitmap using the color data found in the specified DIB.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} hbm - A handle to the bitmap.
     * @param {UInt} start - The starting scan line.
     * @param {UInt} cLines - The number of scan lines.
     * @param {Ptr} lpvBits - A pointer to the DIB color data.
     * @param {Ptr} lpbi - A pointer to a BITMAPINFO structure.
     * @param {UInt} usage - The format of the bmiColors member of the BITMAPINFO structure.
     * @returns {Integer} The number of scan lines set if successful, or zero if the function fails.
     */
    static SetDIBits(hdc, hbm, start, cLines, lpvBits, lpbi, usage)
    {
        return DllCall("Gdi32.dll\SetDIBits", "Ptr", hdc, "Ptr", hbm, "UInt", start, "UInt", cLines, "Ptr", lpvBits, "Ptr", lpbi, "UInt", usage)
    }

    /**
     * Creates a rectangular region with rounded corners.
     * @param {Integer} left - x-coordinate of upper-left corner.
     * @param {Integer} top - y-coordinate of upper-left corner.
     * @param {Integer} right - x-coordinate of lower-right corner.
     * @param {Integer} bottom - y-coordinate of lower-right corner.
     * @param {Integer} width - Width of the ellipse used to create the rounded corners.
     * @param {Integer} height - Height of the ellipse used to create the rounded corners.
     * @returns {Ptr} A handle to the region if successful, NULL otherwise.
     */
    static CreateRoundRectRgn(left, top, right, bottom, width, height)
    {
        return DllCall("Gdi32.dll\CreateRoundRectRgn", "Int", left, "Int", top, "Int", right, "Int", bottom, "Int", width, "Int", height, "Ptr")
    }

    /**
     * Creates a region from the specified region data and transformation data.
     * @param {Ptr} lpXform - A pointer to an XFORM structure that defines a transformation to be applied to the region.
     * @param {Ptr} lpRgnData - A pointer to a RGNDATA structure that contains the region data.
     * @param {UInt} cbRgnData - The size, in bytes, of the RGNDATA structure.
     * @returns {Ptr} A handle to the new region if successful, NULL otherwise.
     */
    static ExtCreateRegion(lpXform, lpRgnData, cbRgnData)
    {
        return DllCall("Gdi32.dll\ExtCreateRegion", "Ptr", lpXform, "UInt", cbRgnData, "Ptr", lpRgnData, "Ptr")
    }

    /**
     * Combines two regions and stores the result in a third region.
     * @param {Ptr} hrgnDest - A handle to the new region.
     * @param {Ptr} hrgnSrc1 - A handle to the first region.
     * @param {Ptr} hrgnSrc2 - A handle to the second region.
     * @param {Integer} iMode - The combining mode.
     * @returns {Integer} The type of the resulting region if successful, zero if an error occurs.
     */
    static CombineRgn(hrgnDest, hrgnSrc1, hrgnSrc2, iMode)
    {
        return DllCall("Gdi32.dll\CombineRgn", "Ptr", hrgnDest, "Ptr", hrgnSrc1, "Ptr", hrgnSrc2, "Int", iMode)
    }

    /**
     * Retrieves the dimensions of the tightest bounding rectangle for the current clipping region.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} lprc - A pointer to a RECT structure that receives the bounding rectangle.
     * @returns {Integer} The type of the clipping region.
     */
    static GetClipBox(hdc, lprc)
    {
        return DllCall("Gdi32.dll\GetClipBox", "Ptr", hdc, "Ptr", lprc)
    }

    /**
     * Creates a new clipping region that consists of the existing clipping region minus the specified rectangle.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - x-coordinate of upper-left corner of rectangle.
     * @param {Integer} top - y-coordinate of upper-left corner of rectangle.
     * @param {Integer} right - x-coordinate of lower-right corner of rectangle.
     * @param {Integer} bottom - y-coordinate of lower-right corner of rectangle.
     * @returns {Integer} The type of the new clipping region.
     */
    static ExcludeClipRect(hdc, left, top, right, bottom)
    {
        return DllCall("Gdi32.dll\ExcludeClipRect", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom)
    }

    /**
     * Creates a new clipping region from the intersection of the current clipping region and the specified rectangle.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - x-coordinate of upper-left corner of rectangle.
     * @param {Integer} top - y-coordinate of upper-left corner of rectangle.
     * @param {Integer} right - x-coordinate of lower-right corner of rectangle.
     * @param {Integer} bottom - y-coordinate of lower-right corner of rectangle.
     * @returns {Integer} The type of the new clipping region.
     */
    static IntersectClipRect(hdc, left, top, right, bottom)
    {
        return DllCall("Gdi32.dll\IntersectClipRect", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom)
    }

    /**
     * Retrieves the text metrics for the currently selected font in a specified device context.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} lptm - A pointer to a TEXTMETRIC structure that receives the text metrics.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static GetTextMetrics(hdc, lptm)
    {
        return DllCall("Gdi32.dll\GetTextMetrics", "Ptr", hdc, "Ptr", lptm)
    }

    /**
     * Creates a logical brush that has the specified hatch pattern and color.
     * @param {Integer} iHatch - The hatch style of the brush.
     * @param {Integer} color - The color of the brush.
     * @returns {Ptr} A handle to the logical brush if successful, NULL otherwise.
     */
    static CreateHatchBrush(iHatch, color)
    {
        return DllCall("Gdi32.dll\CreateHatchBrush", "Int", iHatch, "UInt", color, "Ptr")
    }

    /**
     * Adds a closed curve to the current path.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Ptr} apt - A pointer to an array of POINT structures that define the curve.
     * @param {Integer} cpt - The number of points in the array.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static AddClosedFigure(hdc, apt, cpt)
    {
        return DllCall("Gdi32.dll\AddClosedFigure", "Ptr", hdc, "Ptr", apt, "Int", cpt)
    }

    /**
     * Adds a line to the current path.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} x - The x-coordinate of the line's ending point.
     * @param {Integer} y - The y-coordinate of the line's ending point.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static AddLine(hdc, x, y)
    {
        return DllCall("Gdi32.dll\AddLine", "Ptr", hdc, "Int", x, "Int", y)
    }

    /**
     * Adds a rectangle to the current path.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} top - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} right - The x-coordinate of the lower-right corner of the rectangle.
     * @param {Integer} bottom - The y-coordinate of the lower-right corner of the rectangle.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static AddRectangle(hdc, left, top, right, bottom)
    {
        return DllCall("Gdi32.dll\AddRectangle", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom)
    }

    /**
     * Animates a palette entry.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} iStartIndex - The first palette entry to animate.
     * @param {Integer} cEntries - The number of palette entries to animate.
     * @param {Ptr} ppe - A pointer to an array of PALETTEENTRY structures.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static AnimatePalette(hdc, iStartIndex, cEntries, ppe)
    {
        return DllCall("Gdi32.dll\AnimatePalette", "Ptr", hdc, "Int", iStartIndex, "Int", cEntries, "Ptr", ppe)
    }

    /**
     * Draws an arc and connects the endpoints with a line.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} top - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} right - The x-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} bottom - The y-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} xStart - The x-coordinate of the arc's starting point.
     * @param {Integer} yStart - The y-coordinate of the arc's starting point.
     * @param {Integer} xEnd - The x-coordinate of the arc's ending point.
     * @param {Integer} yEnd - The y-coordinate of the arc's ending point.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static ArcTo(hdc, left, top, right, bottom, xStart, yStart, xEnd, yEnd) => DllCall("Gdi32.dll\ArcTo", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom, "Int", xStart, "Int", yStart, "Int", xEnd, "Int", yEnd)

    /**
     * Draws a rectangle with rounded corners.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - The x-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} top - The y-coordinate of the upper-left corner of the rectangle.
     * @param {Integer} right - The x-coordinate of the lower-right corner of the rectangle.
     * @param {Integer} bottom - The y-coordinate of the lower-right corner of the rectangle.
     * @param {Integer} width - The width of the ellipse used to draw the rounded corners.
     * @param {Integer} height - The height of the ellipse used to draw the rounded corners.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static RoundRect(hdc, left, top, right, bottom, width, height) => DllCall("Gdi32.dll\RoundRect", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom, "Int", width, "Int", height)

    /**
     * Draws a chord (a region bounded by the intersection of an ellipse and a line segment).
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} left - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} top - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} right - The x-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} bottom - The y-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} xStart - The x-coordinate of the chord's starting point.
     * @param {Integer} yStart - The y-coordinate of the chord's starting point.
     * @param {Integer} xEnd - The x-coordinate of the chord's ending point.
     * @param {Integer} yEnd - The y-coordinate of the chord's ending point.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static Chord(hdc, left, top, right, bottom, xStart, yStart, xEnd, yEnd) => DllCall("Gdi32.dll\Chord", "Ptr", hdc, "Int", left, "Int", top, "Int", right, "Int", bottom, "Int", xStart, "Int", yStart, "Int", xEnd, "Int", yEnd)

    /**
     * Sets the pixel format of a device context to the format specified by the index.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} iPixelFormat - Index of the pixel format.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static ChoosePixelFormat(hdc, iPixelFormat) => DllCall("Gdi32.dll\ChoosePixelFormat", "Ptr", hdc, "Int", iPixelFormat)

    /**
     * Closes an enhanced-format metafile.
     * @param {Ptr} hdc - A handle to the device context for the enhanced metafile.
     * @returns {Ptr} A handle to the enhanced metafile if successful, NULL otherwise.
     */
    static CloseEnhMetaFile(hdc) => DllCall("Gdi32.dll\CloseEnhMetaFile", "Ptr", hdc, "Ptr")

    /**
     * Creates a copy of the specified enhanced metafile.
     * @param {Ptr} hemfSrc - A handle to the enhanced metafile to be copied.
     * @param {Str} lpszFile - The name of the file to which the copy will be written.
     * @returns {Ptr} A handle to the copy of the enhanced metafile if successful, NULL otherwise.
     */
    static CopyEnhMetaFile(hemfSrc, lpszFile) => DllCall("Gdi32.dll\CopyEnhMetaFile", "Ptr", hemfSrc, "Str", lpszFile, "Ptr")

    /**
     * Creates a bitmap with the specified width, height, and color format.
     * @param {Integer} width - The bitmap width, in pixels.
     * @param {Integer} height - The bitmap height, in pixels.
     * @param {Integer} cPlanes - The number of color planes.
     * @param {Integer} cBitsPerPel - The number of bits required to identify the color of a pixel.
     * @param {Ptr} lpvBits - A pointer to an array of color data.
     * @returns {Ptr} A handle to the bitmap if successful, NULL otherwise.
     */
    static CreateBitmap(width, height, cPlanes, cBitsPerPel, lpvBits) => DllCall("Gdi32.dll\CreateBitmap", "Int", width, "Int", height, "UInt", cPlanes, "UInt", cBitsPerPel, "Ptr", lpvBits, "Ptr")

    /**
     * Creates a bitmap with the specified width, height, and color format.
     * @param {Ptr} lpbm - A pointer to a BITMAP structure that contains information about the bitmap.
     * @returns {Ptr} A handle to the bitmap if successful, NULL otherwise.
     */
    static CreateBitmapIndirect(lpbm) => DllCall("Gdi32.dll\CreateBitmapIndirect", "Ptr", lpbm, "Ptr")

    /**
     * Creates a device-independent bitmap (DIB) from the specified data.
     * @param {Ptr} hdc - A handle to a device context.
     * @param {Ptr} lpbmi - A pointer to a BITMAPINFO structure that describes the dimensions and color format of the array of pixels.
     * @param {UInt} fdwInit - Specifies how the system initializes the bitmap bits.
     * @param {Ptr} lpvBits - A pointer to an array of bytes containing the initial bitmap data.
     * @param {Ptr} lpbmi - A pointer to a BITMAPINFO structure that describes the dimensions and color format of the array of pixels.
     * @param {UInt} fuUsage - Specifies whether the bmiColors member of the BITMAPINFO structure contains explicit RGB values or indexes into a palette.
     * @returns {Ptr} A handle to the newly created DIB if successful, NULL otherwise.
     */
    static CreateDIBitmap(hdc, lpbmih, fdwInit, lpvBits, lpbmi, fuUsage) => DllCall("Gdi32.dll\CreateDIBitmap", "Ptr", hdc, "Ptr", lpbmih, "UInt", fdwInit, "Ptr", lpvBits, "Ptr", lpbmi, "UInt", fuUsage, "Ptr")

    /**
     * Creates an elliptical region.
     * @param {Integer} nLeftRect - The x-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} nTopRect - The y-coordinate of the upper-left corner of the bounding rectangle.
     * @param {Integer} nRightRect - The x-coordinate of the lower-right corner of the bounding rectangle.
     * @param {Integer} nBottomRect - The y-coordinate of the lower-right corner of the bounding rectangle.
     * @returns {Ptr} A handle to the region if successful, NULL otherwise.
     */
    static CreateEllipticRgn(nLeftRect, nTopRect, nRightRect, nBottomRect) => DllCall("Gdi32.dll\CreateEllipticRgn", "Int", nLeftRect, "Int", nTopRect, "Int", nRightRect, "Int", nBottomRect, "Ptr")

    /**
     * Creates a device context (DC) for an enhanced-format metafile.
     * @param {Str} lpFilename - The name of the enhanced metafile.
     * @param {Ptr} lprc - A pointer to a RECT structure that specifies the dimensions of the picture.
     * @param {Ptr} lpDescription - A pointer to a METAFILEPICT structure that contains a description of the metafile.
     * @returns {Ptr} A handle to the device context for the enhanced metafile if successful, NULL otherwise.
     */
    static CreateEnhMetaFile(lpFilename, lprc, lpDescription) => DllCall("Gdi32.dll\CreateEnhMetaFile", "Str", lpFilename, "Ptr", lprc, "Ptr", lpDescription, "Ptr")

    /**
     * Creates a logical font with the specified characteristics.
     * @param {Ptr} lplf - A pointer to a LOGFONT structure that defines the characteristics of the logical font.
     * @returns {Ptr} A handle to the logical font if successful, NULL otherwise.
     */
    static CreateFontIndirect(lplf) => DllCall("Gdi32.dll\CreateFontIndirect", "Ptr", lplf, "Ptr")

    /**
     * Creates a logical palette.
     * @param {Ptr} plpal - A pointer to a LOGPALETTE structure that contains information about the colors in the logical palette.
     * @returns {Ptr} A handle to the logical palette if successful, NULL otherwise.
     */
    static CreatePalette(plpal) => DllCall("Gdi32.dll\CreatePalette", "Ptr", plpal, "Ptr")

    /**
     * Creates a logical brush with a specified bitmap pattern.
     * @param {Ptr} hbm - A handle to the bitmap to be used to create the brush.
     * @returns {Ptr} A handle to the logical brush if successful, NULL otherwise.
     */
    static CreatePatternBrush(hbm) => DllCall("Gdi32.dll\CreatePatternBrush", "Ptr", hbm, "Ptr")

    /**
     * Creates a polygonal region.
     * @param {Ptr} lppt - A pointer to an array of POINT structures that define the vertices of the region in logical units.
     * @param {Integer} cPoints - The number of points in the array.
     * @param {Integer} fnPolyFillMode - The fill mode used to determine which pixels are in the region.
     * @returns {Ptr} A handle to the region if successful, NULL otherwise.
     */
    static CreatePolygonRgn(lppt, cPoints, fnPolyFillMode) => DllCall("Gdi32.dll\CreatePolygonRgn", "Ptr", lppt, "Int", cPoints, "Int", fnPolyFillMode, "Ptr")

    /**
     * Deletes the specified enhanced metafile.
     * @param {Ptr} hemf - A handle to the enhanced metafile to be deleted.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static DeleteEnhMetaFile(hemf) => DllCall("Gdi32.dll\DeleteEnhMetaFile", "Ptr", hemf)

    /**
     * Passes arbitrary information to a specified device driver.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} nEscape - The escape function to be performed.
     * @param {Integer} cbInput - The number of bytes of data pointed to by lpvInData.
     * @param {Ptr} lpvInData - A pointer to the input structure required for the specified escape.
     * @param {Ptr} lpvOutData - A pointer to the structure that receives output from the specified escape.
     * @returns {Integer} The value returned depends on the escape function.
     */
    static DrawEscape(hdc, nEscape, cbInput, lpvInData, lpvOutData) => DllCall("Gdi32.dll\DrawEscape", "Ptr", hdc, "Int", nEscape, "Int", cbInput, "Ptr", lpvInData, "Ptr", lpvOutData)

    /**
     * Enumerates the fonts available on a system.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Str} lpLogfont - A pointer to a LOGFONT structure that contains information about the fonts to enumerate.
     * @param {Ptr} lpProc - A pointer to the application-defined callback function.
     * @param {Ptr} lParam - An application-defined value passed to the callback function.
     * @returns {Integer} The last value returned by the callback function.
     */
    static EnumFontFamilies(hdc, lpLogfont, lpProc, lParam) => DllCall("Gdi32.dll\EnumFontFamilies", "Ptr", hdc, "Str", lpLogfont, "Ptr", lpProc, "Ptr", lParam)

    /**
     * Creates a logical cosmetic or geometric pen that has the specified style, width, and brush attributes.
     * @param {Integer} dwPenStyle - The pen style.
     * @param {Integer} dwWidth - The width of the pen, in logical units.
     * @param {Ptr} lplb - A pointer to a LOGBRUSH structure that defines the brush attributes of the pen.
     * @param {Integer} dwStyleCount - The number of entries in the lpStyle array.
     * @param {Ptr} lpStyle - A pointer to an array of values that specify a user-defined dash pattern.
     * @returns {Ptr} A handle to the logical pen if successful, NULL otherwise.
     */
    static ExtCreatePen(dwPenStyle, dwWidth, lplb, dwStyleCount, lpStyle) => DllCall("Gdi32.dll\ExtCreatePen", "UInt", dwPenStyle, "UInt", dwWidth, "Ptr", lplb, "UInt", dwStyleCount, "Ptr", lpStyle, "Ptr")

    /**
     * Fills an area of the display surface with the current brush.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} nXStart - The x-coordinate of the starting point of the area to be filled.
     * @param {Integer} nYStart - The y-coordinate of the starting point of the area to be filled.
     * @param {Integer} crColor - The color of the boundary or the starting point.
     * @param {Integer} fuFillType - The type of flood fill to be performed.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static ExtFloodFill(hdc, nXStart, nYStart, crColor, fuFillType) => DllCall("Gdi32.dll\ExtFloodFill", "Ptr", hdc, "Int", nXStart, "Int", nYStart, "UInt", crColor, "UInt", fuFillType)

    /**
     * Draws text using the currently selected font, background color, and text color.
     * @param {Ptr} hdc - A handle to the device context.
     * @param {Integer} X - The x-coordinate of the reference point used to position the string.
     * @param {Integer} Y - The y-coordinate of the reference point used to position the string.
     * @param {Integer} fuOptions - A set of bit flags that specify how to draw the text.
     * @param {Ptr} lprc - A pointer to a RECT structure that specifies the dimensions of the bounding rectangle.
     * @param {Str} lpString - A pointer to the string to be drawn.
     * @param {Integer} cbCount - The length of the string pointed to by lpString.
     * @param {Ptr} lpDx - A pointer to an array of values that indicate the distance between each character.
     * @returns {Integer} Nonzero if successful, zero otherwise.
     */
    static ExtTextOut(hdc, X, Y, fuOptions, lprc, lpString, cbCount, lpDx) => DllCall("Gdi32.dll\ExtTextOut", "Ptr", hdc, "Int", X, "Int", Y, "UInt", fuOptions, "Ptr", lprc, "Str", lpString, "UInt", cbCount, "Ptr", lpDx)
}

/**
 * Defines mix modes for drawing operations.
 */
class MixMode
{
    /** Pixel is always 0. */
    static BLACK := 1
    /** Pixel is the inverse of the R2_MERGEPEN color. */
    static NOTMERGEPEN := 2
    /** Pixel is a combination of the colors common to both the screen and the inverse of the pen. */
    static MASKNOTPEN := 3
    /** Pixel is the inverse of the pen color. */
    static NOTCOPYPEN := 4
    /** Pixel is a combination of the colors common to both the pen and the inverse of the screen. */
    static MASKPENNOT := 5
    /** Pixel is the inverse of the screen color. */
    static NOT := 6
    /** Pixel is a combination of the colors in the pen and in the screen, but not in both. */
    static XORPEN := 7
    /** Pixel is the inverse of the R2_MASKPEN color. */
    static NOTMASKPEN := 8
    /** Pixel is a combination of the colors common to both the pen and the screen. */
    static MASKPEN := 9
    /** Pixel is the inverse of the R2_XORPEN color. */
    static NOTXORPEN := 10
    /** Pixel remains unchanged. */
    static NOP := 11
    /** Pixel is a combination of the screen color and the inverse of the pen color. */
    static MERGENOTPEN := 12
    /** Pixel is the pen color. */
    static COPYPEN := 13
    /** Pixel is a combination of the pen color and the inverse of the screen color. */
    static MERGEPENNOT := 14
    /** Pixel is a combination of the pen color and the screen color. */
    static MERGEPEN := 15
    /** Pixel is always 1. */
    static WHITE := 16
}

/**
 * Defines stretch modes for the StretchBlt function.
 */
class StretchMode
{
    /** Performs a Boolean AND operation using the color values for the eliminated and existing pixels. */
    static BLACKONWHITE := 1
    /** Performs a Boolean OR operation using the color values for the eliminated and existing pixels. */
    static WHITEONBLACK := 2
    /** Deletes the pixels. This mode deletes all eliminated lines of pixels without trying to preserve their information. */
    static COLORONCOLOR := 3
    /** Maps pixels from the source rectangle into blocks of pixels in the destination rectangle. */
    static HALFTONE := 4
}

/**
 * Defines modes for combining two regions.
 */
class CombineMode
{
    /** Creates the intersection of the two combined regions. */
    static AND := 1
    /** Creates the union of two combined regions. */
    static OR := 2
    /** Creates the union of two combined regions except for any overlapping areas. */
    static XOR := 3
    /** Combines the parts of hrgnSrc1 that are not part of hrgnSrc2. */
    static DIFF := 4
    /** Copies the hrgnSrc1 region. */
    static COPY := 5
}

/**
 * Defines types of clip regions.
 */
class ClipRegionType
{
    /** An error occurred. */
    static ERROR := 0
    /** Region is empty. */
    static NULLREGION := 1
    /** Region is a single rectangle. */
    static SIMPLEREGION := 2
    /** Region is more than one rectangle. */
    static COMPLEXREGION := 3
}

/**
 * Defines hatch styles for brushes.
 */
class HatchStyle
{
    /** Horizontal hatch */
    static HORIZONTAL := 0
    /** Vertical hatch */
    static VERTICAL := 1
    /** 45-degree downward left-to-right hatch */
    static FDIAGONAL := 2
    /** 45-degree upward left-to-right hatch */
    static BDIAGONAL := 3
    /** Horizontal and vertical crosshatch */
    static CROSS := 4
    /** 45-degree crosshatch */
    static DIAGCROSS := 5
}

/**
 * Defines color table usage for DIB functions.
 */
class DIBColors
{
    /** The color table contains literal RGB values. */
    static RGB_COLORS := 0
    /** The color table consists of an array of 16-bit indexes into the current logical palette. */
    static PAL_COLORS := 1
}

/**
 * Defines mapping modes for device contexts.
 */
class MapMode
{
    /** Each logical unit is mapped to one device pixel. */
    static TEXT := 1
    /** Each logical unit is mapped to 0.1 millimeter. */
    static LOMETRIC := 2
    /** Each logical unit is mapped to 0.01 millimeter. */
    static HIMETRIC := 3
    /** Each logical unit is mapped to 0.01 inch. */
    static LOENGLISH := 4
    /** Each logical unit is mapped to 0.001 inch. */
    static HIENGLISH := 5
    /** Each logical unit is mapped to one twentieth of a printer's point (1/1440 inch). */
    static TWIPS := 6
    /** Logical units are mapped to arbitrary units with equally scaled axes. */
    static ISOTROPIC := 7
    /** Logical units are mapped to arbitrary units with arbitrarily scaled axes. */
    static ANISOTROPIC := 8
}

/**
 * Defines stock objects.
 */
class StockObject
{
    /** White brush. */
    static WHITE_BRUSH := 0
    /** Light gray brush. */
    static LTGRAY_BRUSH := 1
    /** Gray brush. */
    static GRAY_BRUSH := 2
    /** Dark gray brush. */
    static DKGRAY_BRUSH := 3
    /** Black brush. */
    static BLACK_BRUSH := 4
    /** Null brush (equivalent to HOLLOW_BRUSH). */
    static NULL_BRUSH := 5
    /** White pen. */
    static WHITE_PEN := 6
    /** Black pen. */
    static BLACK_PEN := 7
    /** Null pen. */
    static NULL_PEN := 8
    /** OEM-dependent fixed-width font. */
    static OEM_FIXED_FONT := 10
    /** Windows fixed-width font. */
    static ANSI_FIXED_FONT := 11
    /** Windows variable-width font. */
    static ANSI_VAR_FONT := 12
    /** System font. */
    static SYSTEM_FONT := 13
    /** Device-dependent font. */
    static DEVICE_DEFAULT_FONT := 14
    /** Default palette. */
    static DEFAULT_PALETTE := 15
    /** System fixed-width font. */
    static SYSTEM_FIXED_FONT := 16
    /** Default font for user interface objects such as menus and dialog boxes. */
    static DEFAULT_GUI_FONT := 17
}

/**
 * Defines device capability constants.
 */
class DeviceCap
{
    /** Device driver version */
    static DRIVERVERSION := 0
    /** Device classification */
    static TECHNOLOGY := 2
    /** Horizontal size in millimeters */
    static HORZSIZE := 4
    /** Vertical size in millimeters */
    static VERTSIZE := 6
    /** Horizontal width in pixels */
    static HORZRES := 8
    /** Vertical height in pixels */
    static VERTRES := 10
    /** Number of bits per pixel */
    static BITSPIXEL := 12
    /** Number of planes */
    static PLANES := 14
    /** Number of brushes the device has */
    static NUMBRUSHES := 16
    /** Number of pens the device has */
    static NUMPENS := 18
    /** Number of markers the device has */
    static NUMMARKERS := 20
    /** Number of fonts the device has */
    static NUMFONTS := 22
    /** Number of colors the device supports */
    static NUMCOLORS := 24
    /** Size required for device descriptor */
    static PDEVICESIZE := 26
    /** Curve capabilities */
    static CURVECAPS := 28
    /** Line capabilities */
    static LINECAPS := 30
    /** Polygonal capabilities */
    static POLYGONALCAPS := 32
    /** Text capabilities */
    static TEXTCAPS := 34
    /** Clipping capabilities */
    static CLIPCAPS := 36
    /** Bitblt capabilities */
    static RASTERCAPS := 38
    /** Relative width of a device pixel used for line drawing */
    static ASPECTX := 40
    /** Relative height of a device pixel used for line drawing */
    static ASPECTY := 42
    /** Relative width of a device pixel used for line drawing */
    static ASPECTXY := 44
    /** Number of pixels per logical inch along the screen width */
    static LOGPIXELSX := 88
    /** Number of pixels per logical inch along the screen height */
    static LOGPIXELSY := 90
}

/**
 * Constants for pixel format options.
 */
class PixelFormat
{
    /** RGBA color format */
    static TYPE_RGBA := 0
    /** Color-index format */
    static TYPE_COLORINDEX := 1
    /** Main plane */
    static MAIN_PLANE := 0
    /** Overlay plane */
    static OVERLAY_PLANE := 1
    /** Underlay plane */
    static UNDERLAY_PLANE := -1
    /** Double buffering supported */
    static DOUBLEBUFFER := 0x00000001
    /** Stereo buffering supported */
    static STEREO := 0x00000002
    /** Draw to window supported */
    static DRAW_TO_WINDOW := 0x00000004
    /** Draw to bitmap supported */
    static DRAW_TO_BITMAP := 0x00000008
    /** GDI support */
    static SUPPORT_GDI := 0x00000010
    /** OpenGL support */
    static SUPPORT_OPENGL := 0x00000020
    /** Generic format */
    static GENERIC_FORMAT := 0x00000040
    /** Palette support needed */
    static NEED_PALETTE := 0x00000080
    /** System palette support needed */
    static NEED_SYSTEM_PALETTE := 0x00000100
    /** Swap by exchanging */
    static SWAP_EXCHANGE := 0x00000200
    /** Swap by copying */
    static SWAP_COPY := 0x00000400
    /** Swap individual layer buffers */
    static SWAP_LAYER_BUFFERS := 0x00000800
    /** Generic hardware acceleration */
    static GENERIC_ACCELERATED := 0x00001000
    /** DirectDraw support */
    static SUPPORT_DIRECTDRAW := 0x00002000
}

/**
 * Constants for metafile types.
 */
class MetafileType
{
    /** Metafile header record */
    static HEADER := 1
    /** PolyBezier record */
    static POLYBEZIER := 2
    /** Polygon record */
    static POLYGON := 3
    /** Polyline record */
    static POLYLINE := 4
    /** PolyBezierTo record */
    static POLYBEZIERTO := 5
    /** PolyLineTo record */
    static POLYLINETO := 6
    /** PolyPolyline record */
    static POLYPOLYLINE := 7
    /** PolyPolygon record */
    static POLYPOLYGON := 8
    /** SetWindowExtEx record */
    static SETWINDOWEXTEX := 9
    /** SetWindowOrgEx record */
    static SETWINDOWORGEX := 10
    /** SetViewportExtEx record */
    static SETVIEWPORTEXTEX := 11
    /** SetViewportOrgEx record */
    static SETVIEWPORTORGEX := 12
    /** SetBrushOrgEx record */
    static SETBRUSHORGEX := 13
    /** End of file record */
    static EOF := 14
    /** SetPixelV record */
    static SETPIXELV := 15
    /** SetMapperFlags record */
    static SETMAPPERFLAGS := 16
    /** SetMapMode record */
    static SETMAPMODE := 17
    /** SetBkMode record */
    static SETBKMODE := 18
    /** SetPolyFillMode record */
    static SETPOLYFILLMODE := 19
    /** SetROP2 record */
    static SETROP2 := 20
    /** SetStretchBltMode record */
    static SETSTRETCHBLTMODE := 21
    /** SetTextAlign record */
    static SETTEXTALIGN := 22
    /** SetColorAdjustment record */
    static SETCOLORADJUSTMENT := 23
    /** SetTextColor record */
    static SETTEXTCOLOR := 24
    /** SetBkColor record */
    static SETBKCOLOR := 25
    /** OffsetClipRgn record */
    static OFFSETCLIPRGN := 26
    /** MoveToEx record */
    static MOVETOEX := 27
    /** SetMetaRgn record */
    static SETMETARGN := 28
    /** ExcludeClipRect record */
    static EXCLUDECLIPRECT := 29
    /** IntersectClipRect record */
    static INTERSECTCLIPRECT := 30
}

/**
 * Constants for font quality options.
 */
class FontQuality
{
    /** Default quality */
    static DEFAULT_QUALITY := 0
    /** Draft quality */
    static DRAFT_QUALITY := 1
    /** Proof quality */
    static PROOF_QUALITY := 2
    /** Non-antialiased quality */
    static NONANTIALIASED_QUALITY := 3
    /** Antialiased quality */
    static ANTIALIASED_QUALITY := 4
    /** ClearType quality */
    static CLEARTYPE_QUALITY := 5
    /** ClearType natural quality */
    static CLEARTYPE_NATURAL_QUALITY := 6
}

/**
 * Constants for brush styles.
 */
class BrushStyle
{
    /** Solid brush */
    static SOLID := 0
    /** Null brush */
    static NULL := 1
    /** Hollow brush (same as NULL) */
    static HOLLOW := BrushStyle.NULL
    /** Hatched brush */
    static HATCHED := 2
    /** Pattern brush */
    static PATTERN := 3
    /** Indexed brush */
    static INDEXED := 4
    /** DIB pattern brush */
    static DIBPATTERN := 5
    /** DIB pattern brush (PT) */
    static DIBPATTERNPT := 6
    /** 8x8 pattern brush */
    static PATTERN8X8 := 7
    /** 8x8 DIB pattern brush */
    static DIBPATTERN8X8 := 8
    /** Monochrome pattern brush */
    static MONOPATTERN := 9
}

/**
 * Constants for pen styles.
 */
class PenStyle
{
    /** Solid pen */
    static SOLID := 0
    /** Dashed pen */
    static DASH := 1
    /** Dotted pen */
    static DOT := 2
    /** Dash-dot pen */
    static DASHDOT := 3
    /** Dash-dot-dot pen */
    static DASHDOTDOT := 4
    /** Null pen */
    static NULL := 5
    /** Inside frame pen */
    static INSIDEFRAME := 6
    /** User-defined style pen */
    static USERSTYLE := 7
    /** Alternate pen */
    static ALTERNATE := 8
    /** Style mask */
    static STYLE_MASK := 0x0000000F
    /** Round end cap */
    static ENDCAP_ROUND := 0x00000000
    /** Square end cap */
    static ENDCAP_SQUARE := 0x00000100
    /** Flat end cap */
    static ENDCAP_FLAT := 0x00000200
    /** End cap mask */
    static ENDCAP_MASK := 0x00000F00
    /** Round join */
    static JOIN_ROUND := 0x00000000
    /** Bevel join */
    static JOIN_BEVEL := 0x00001000
    /** Miter join */
    static JOIN_MITER := 0x00002000
    /** Join mask */
    static JOIN_MASK := 0x0000F000
    /** Cosmetic pen */
    static COSMETIC := 0x00000000
    /** Geometric pen */
    static GEOMETRIC := 0x00010000
    /** Type mask */
    static TYPE_MASK := 0x000F0000
}

/**
 * Constants for polygon fill modes.
 */
class FillMode
{
    /** Alternate fill mode */
    static ALTERNATE := 1
    /** Winding fill mode */
    static WINDING := 2
}

/**
 * Constants for flood fill types.
 */
class FloodFill
{
    /** Fill to border color */
    static BORDER := 0
    /** Fill to surface color */
    static SURFACE := 1
}

/**
 * Constants for text output options.
 */
class TextOutOptions
{
    /** Fill background */
    static OPAQUE := 0x0002
    /** Clip text to rectangle */
    static CLIPPED := 0x0004
    /** Use glyph indices */
    static GLYPH_INDEX := 0x0010
    /** Right-to-left reading order */
    static RTLREADING := 0x0080
    /** Use locale-specific numerals */
    static NUMERICSLOCAL := 0x0400
    /** Use Latin numerals */
    static NUMERICSLATIN := 0x0800
    /** Ignore language option */
    static IGNORELANGUAGE := 0x1000
    /** Use PDY for inter-row spacing */
    static PDY := 0x2000
    /** Reverse glyph index to character index mapping */
    static REVERSE_INDEX_MAP := 0x10000
}

/**
 * Constants for binary raster operations used in BitBlt and StretchBlt functions.
 */
class BinaryRaster
{
    /** Destination = Source */
    static SRCCOPY := 0x00CC0020
    /** Destination = Source OR Destination */
    static SRCPAINT := 0x00EE0086
    /** Destination = Source AND Destination */
    static SRCAND := 0x008800C6
    /** Destination = Source XOR Destination */
    static SRCINVERT := 0x00660046
    /** Destination = Source AND (NOT Destination) */
    static SRCERASE := 0x00440328
    /** Destination = (NOT Source) */
    static NOTSRCCOPY := 0x00330008
    /** Destination = (NOT Source) OR Destination */
    static NOTSRCERASE := 0x001100A6
    /** Destination = (Source AND Pattern) */
    static MERGECOPY := 0x00C000CA
    /** Destination = (NOT Source) AND Destination */
    static MERGEPAINT := 0x00BB0226
    /** Destination = Pattern */
    static PATCOPY := 0x00F00021
    /** Destination = DPSnoo */
    static PATPAINT := 0x00FB0A09
    /** Destination = Pattern XOR Destination */
    static PATINVERT := 0x005A0049
    /** Destination = (NOT Destination) */
    static DSTINVERT := 0x00550009
    /** Destination = BLACK */
    static BLACKNESS := 0x00000042
    /** Destination = WHITE */
    static WHITENESS := 0x00FF0062
}

/**
 * Constants for background modes used in SetBkMode function.
 */
class BackgroundModes
{
    /** Background is transparent */
    static TRANSPARENT := 1
    /** Background is opaque */
    static OPAQUE := 2
}

/**
 * Constants for specifying arc direction in various drawing functions.
 */
class ArcDirection
{
    /** Arc is drawn counterclockwise */
    static COUNTERCLOCKWISE := 1
    /** Arc is drawn clockwise */
    static CLOCKWISE := 2
}

/**
 * Constants for text alignment options used in SetTextAlign function.
 */
class TextAlignment
{
    /** Left-align text */
    static LEFT := 0
    /** Right-align text */
    static RIGHT := 2
    /** Center-align text horizontally */
    static CENTER := 6
    /** Top-align text */
    static TOP := 0
    /** Bottom-align text */
    static BOTTOM := 8
    /** Vertically center text */
    static BASELINE := 24
    /** Update current position after each text output call */
    static UPDATECP := 1
    /** Do not update current position after each text output call */
    static NOUPDATECP := 0
}