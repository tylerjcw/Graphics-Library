#Requires AutoHotkey v2.0

class LayeredWindow
{
    /**
     * Updates the position, size, shape, content, and translucency of a layered window.
     * @param {Ptr} hwnd - A handle to the layered window.
     * @param {Ptr} hdcSrc - A handle to a DC for the surface that defines the layered window.
     * @param {Ptr} pptSrc - A pointer to a POINT structure that specifies the location of the layer in the device context.
     * @param {Ptr} psize - A pointer to a SIZE structure that specifies the size of the layer.
     * @param {Ptr} hdcDst - A handle to a DC for the screen.
     * @param {Ptr} pptDst - A pointer to a POINT structure that specifies the new screen position of the layered window.
     * @param {UInt} crKey - A COLORREF value that specifies the color key to be used when composing the layered window.
     * @param {Ptr} pblend - A pointer to a BLENDFUNCTION structure that specifies the transparency value to be used when composing the layered window.
     * @param {UInt} dwFlags - Specifies an action to take when composing the layered window.
     * @returns {UInt} If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
     */
    static UpdateLayeredWindow(hwnd, hdcSrc, pptSrc, psize, hdcDst, pptDst, crKey, pblend, dwFlags) => DllCall("User32.dll\UpdateLayeredWindow", "Ptr", hwnd, "Ptr", hdcDst, "Ptr", pptDst, "Ptr", psize, "Ptr", hdcSrc, "Ptr", pptSrc, "UInt", crKey, "Ptr", pblend, "UInt", dwFlags, "UInt")

    /**
     * Retrieves the opacity and color key of a layered window.
     * @param {Ptr} hwnd - A handle to the layered window.
     * @param {UInt&} pcrKey - A pointer to a COLORREF value that receives the layered window's color key.
     * @param {UChar&} pbAlpha - A pointer to a BYTE that receives the layered window's Alpha value.
     * @param {UInt&} pdwFlags - A pointer to a DWORD that receives a combination of layered window flags.
     * @returns {UInt} If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
     */
    static GetLayeredWindowAttributes(hwnd, &pcrKey, &pbAlpha, &pdwFlags) => DllCall("User32.dll\GetLayeredWindowAttributes", "Ptr", hwnd, "Ptr", &pcrKey, "Ptr", &pbAlpha, "Ptr", &pdwFlags, "UInt")

    /**
     * Sets the opacity and transparency color key of a layered window.
     * @param {Ptr} hwnd - A handle to the layered window.
     * @param {UInt} crKey - A COLORREF value that specifies the transparency color key to be used when composing the layered window.
     * @param {UChar} bAlpha - The alpha value used to describe the opacity of the layered window.
     * @param {UInt} dwFlags - Specifies an action to take when setting the layered window attributes.
     * @returns {UInt} If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
     */
    static SetLayeredWindowAttributes(hwnd, crKey, bAlpha, dwFlags) => DllCall("User32.dll\SetLayeredWindowAttributes", "Ptr", hwnd, "UInt", crKey, "UChar", bAlpha, "UInt", dwFlags, "UInt")

    /**
     * Creates a layered window with extended styles.
     * @param {UInt} dwExStyle - The extended window style.
     * @param {String} lpClassName - The window class name.
     * @param {String} lpWindowName - The window name.
     * @param {UInt} dwStyle - The window style.
     * @param {Int} x - The initial horizontal position of the window.
     * @param {Int} y - The initial vertical position of the window.
     * @param {Int} nWidth - The width of the window.
     * @param {Int} nHeight - The height of the window.
     * @param {Ptr} hWndParent - A handle to the parent or owner window.
     * @param {Ptr} hMenu - A handle to a menu, or NULL for no menu.
     * @param {Ptr} hInstance - A handle to the instance of the module to be associated with the window.
     * @param {Ptr} lpParam - Pointer to a value to be passed to the window through the CREATESTRUCT structure.
     * @returns {Ptr} The handle to the new window if successful, or NULL if not.
     */
    static CreateWindowEx(dwExStyle, lpClassName, lpWindowName, dwStyle, x, y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam) => DllCall("User32.dll\CreateWindowEx", "UInt", dwExStyle, "Str", lpClassName, "Str", lpWindowName, "UInt", dwStyle, "Int", x, "Int", y, "Int", nWidth, "Int", nHeight, "Ptr", hWndParent, "Ptr", hMenu, "Ptr", hInstance, "Ptr", lpParam, "Ptr")

    /**
     * Changes an attribute of the specified window.
     * @param {Ptr} hWnd - A handle to the window.
     * @param {Int} nIndex - The zero-based offset to the value to be set.
     * @param {Ptr} dwNewLong - The replacement value.
     * @returns {Ptr} The previous value of the specified offset if successful, or zero if not.
     */
    static SetWindowLong(hWnd, nIndex, dwNewLong) => DllCall("User32.dll\SetWindowLong" (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", hWnd, "Int", nIndex, "Ptr", dwNewLong, "Ptr")

    /**
     * Retrieves information about the specified window.
     * @param {Ptr} hWnd - A handle to the window.
     * @param {Int} nIndex - The zero-based offset to the value to be retrieved.
     * @returns {Ptr} The requested value if successful, or zero if not.
     */
    static GetWindowLong(hWnd, nIndex) => DllCall("User32.dll\GetWindowLong" (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", hWnd, "Int", nIndex, "Ptr")

    /**
     * Sets the specified window's show state.
     * @param {Ptr} hWnd - A handle to the window.
     * @param {Int} nCmdShow - Controls how the window is to be shown.
     * @returns {Int} Nonzero if successful, zero if not.
     */
    static ShowWindow(hWnd, nCmdShow) => DllCall("User32.dll\ShowWindow", "Ptr", hWnd, "Int", nCmdShow, "Int")

    /**
     * Changes the size, position, and Z order of a child, pop-up, or top-level window.
     * @param {Ptr} hWnd - A handle to the window.
     * @param {Ptr} hWndInsertAfter - A handle to the window to precede the positioned window in the Z order.
     * @param {Int} X - The new position of the left side of the window.
     * @param {Int} Y - The new position of the top of the window.
     * @param {Int} cx - The new width of the window.
     * @param {Int} cy - The new height of the window.
     * @param {UInt} uFlags - The window sizing and positioning flags.
     * @returns {Int} Nonzero if successful, zero if not.
     */
    static SetWindowPos(hWnd, hWndInsertAfter, X, Y, cx, cy, uFlags) => DllCall("User32.dll\SetWindowPos", "Ptr", hWnd, "Ptr", hWndInsertAfter, "Int", X, "Int", Y, "Int", cx, "Int", cy, "UInt", uFlags, "Int")

    /**
     * Updates the specified rectangle or region in a window's client area.
     * @param {Ptr} hWnd - A handle to the window to be redrawn.
     * @param {Ptr} lprcUpdate - A pointer to a RECT structure containing the update rectangle.
     * @param {Ptr} hrgnUpdate - A handle to the update region.
     * @param {UInt} flags - The redraw flags.
     * @returns {Int} Nonzero if successful, zero if not.
     */
    static RedrawWindow(hWnd, lprcUpdate, hrgnUpdate, flags) => DllCall("User32.dll\RedrawWindow", "Ptr", hWnd, "Ptr", lprcUpdate, "Ptr", hrgnUpdate, "UInt", flags, "Int")

    /**
     * Adds a rectangle to the specified window's update region.
     * @param {Ptr} hWnd - A handle to the window whose update region has changed.
     * @param {Ptr} lpRect - A pointer to a RECT structure containing the client coordinates of the rectangle to be added to the update region.
     * @param {Int} bErase - Specifies whether the background within the update region is to be erased.
     * @returns {Int} Nonzero if successful, zero if not.
     */
    static InvalidateRect(hWnd, lpRect, bErase) => DllCall("User32.dll\InvalidateRect", "Ptr", hWnd, "Ptr", lpRect, "Int", bErase, "Int")
}