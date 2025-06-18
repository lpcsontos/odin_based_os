package kernel

VGA_MEM_BASE :: uintptr(0xb8000)
INDEX : int = 0
COL :: int(80)
ROW :: int(25)

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

print_char :: proc( fg:Color, bg:Color, c: u8 ){
	color_all := (u8(bg) << 4 | u8(fg))
	out := u16(color_all) << 8 | u16(c)
	
	buff := cast(^u16)(VGA_MEM_BASE + uintptr(INDEX * 2))
	buff^ = out

}

print :: proc(fg:Color, bg:Color, str:string){
	for i in 0 ..< len(str){
		print_char(fg, bg, str[i])
		INDEX += 1
	}
}

clear_screen :: proc(){
	for i := 0; i < ROW; i += 1{
		for j := 0; j < COL; j+= 1{
			print_char(Color.Black, Color.Black, ' ')
			INDEX += 1
		}
	}
	INDEX = 0
}

@export
kernel_odin :: proc(){
	clear_screen()
	print(Color.White, Color.Black, "Hello World!")
}


















