package kernel




print_char :: proc( fg:Color, bg:Color, c: u8 ){
	
	color_all := (u8(bg) << 4 | u8(fg))
	out := u16(color_all) << 8 | u16(c)
	
	buff := cast(^u16)(VGA_MEM_BASE + uintptr(INDEX * 2))
	buff^ = out

}

set_color :: proc(fg:Color, bg:Color){
	M_FG = fg
	M_BG = bg
}

set_index :: proc(x:int, y:int){
	INDEX = y * 80 + x
}

print :: proc(str:string){
	for i in 0 ..< len(str){
		if str[i] == '\n' { 
			INDEX = INDEX - (INDEX%COL) + (COL-1)
		}
		else if str[i] == '\t'{
			INDEX += 4
		}else {
			print_char(M_FG, M_BG, str[i])
		}
		INDEX += 1
	}
}

clear_screen :: proc(){
	for i in 0 ..< ROW{
		for j := 0; j < COL; j+= 1{
			print_char(Color.Black, Color.Black, ' ')
			INDEX += 1
		}
	}
	INDEX = 0
}
