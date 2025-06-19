package kernel

VGA_MEM_BASE :: uintptr(0xb8000)
INDEX : int = 0
INDEX_Y : int = 0
INDEX_X : int = 0
COL :: int(80)
ROW :: int(25)
M_FG := Color.White
M_BG := Color.Black

Color :: enum u8 {
    Black       = 0,
    Blue        = 1,
    Green       = 2,
    Cyan        = 3,
    Red         = 4,
    Magenta     = 5,
    Brown       = 6,
    LightGray   = 7,
    DarkGray    = 8,
    LightBlue   = 9,
    LightGreen  = 10,
    LightCyan   = 11,
    LightRed    = 12,
    LightMagenta= 13,
    Yellow      = 14,
    White       = 15,
}
