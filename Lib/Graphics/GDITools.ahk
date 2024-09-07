#Requires AutoHotkey v2.0

class GDIPTools
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
}

Class GDITools
{

}

class CMode
{
    static Blended   => 0
    static Overwrite => 1
}

class SMode
{
    static None        => 0
    static HighSpeed   => 1
    static HighQuality => 2
    static Default     => 3
    static AntiAlias   => 4
}

class IMode
{
    static Default             => 0
    static LowQuality          => 1
    static HighQuality         => 2
    static Bilinear            => 3
    static Bicubic             => 4
    static NearestNeighbor     => 5
    static HighQualityBilinear => 6
    static HighQualityBicubic  => 7
}