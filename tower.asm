;Name: Justin Prez
;Date: December 9th, 2018

%include "asm_io.inc"
global asm_main
extern rconf

section .data
con1 db   "Initial configuration",10,0
con2 db   "Final configuration", 10, 0
error1 db "Error commandline argument is not 1",10,0
error2 db "Error the input should be an unsigned integer between from 2 to 9!",10,0  
peg2: dd 0,0,0,0,0,0,0,0,0  
p1: db  "          o|o          ",0  
p2: db  "         oo|oo         ",0
p3: db  "        ooo|ooo        ",0
p4: db  "       oooo|oooo       ",0
p5: db  "      ooooo|ooooo      ",0
p6: db  "     oooooo|oooooo     ",0
p7: db  "    ooooooo|ooooooo    ",0
p8: db  "   oooooooo|oooooooo   ",0
p9: db  "  ooooooooo|ooooooooo  ",0
base: db"XXXXXXXXXXXXXXXXXXXXXXX",0


section .bss
num_peg: resd 1

section .text
  global asm_main

asm_main:
  enter 0, 0
  pusha                  

  mov edx, dword 0       
  mov eax, dword [ebp+8] 
  cmp eax, dword 2       
  jne Error1             

  mov ebx, [ebp+12]      
  mov ecx, [ebx+4]      
  mov al, byte [ecx]     

  cmp al, 32h           
  jb Error2              
  cmp al, 39h            
  ja Error2             

  mov [num_peg], al     
  sub dword [num_peg], 48
  mov eax, dword[num_peg] 

  push eax               
  mov ebx, peg2          
  push ebx               

  call rconf             
  add esp, 8             
  mov eax, con1
  call print_string
  mov eax, dword[num_peg] 
  push ebx                
  push eax                

  call showp              
  pop eax                 
  pop eax

  call read_char          
  mov eax, dword[num_peg] 
  mov ebx, peg2           

  push ebx                
  push eax                

  call tower            
  pop eax                 
  pop eax                 

  mov ecx, peg2           
  mov ebx, dword[num_peg] 

  swapfirst:              
  cmp ebx, 1              
  je finish_loop          
  dec ebx
  mov eax, [ecx + 4]      
  mov edx, [ecx]          

  cmp edx, eax            
  ja end_swap_loop       

  mov [ecx + 4], edx   
  mov [ecx], eax  

;  mov eax, peg2 
;  push eax  
;  mov eax, dword [num_peg]
;  push eax            
;  call showp 
;  pop eax
;  pop eax
;  call read_char

  end_swap_loop:
  add ecx, 4  
  jmp swapfirst  

  finish_loop:
  mov eax, peg2
  push eax
  mov eax, dword[num_peg]
  push eax
  call showp
  call read_char
  pop eax
  pop eax
  mov eax, con2
  call print_string
  mov eax, peg2
  push eax
  mov eax, dword [num_peg]
  push eax
  call showp
  pop eax
  pop eax
  call read_char                 
  jmp asm_main_end     

tower:
  enter 0,0

  mov ebx, [ebp + 8 ]   
  mov ecx, [ebp + 12]    

  cmp ebx, 1
  je base_condition
    dec ebx
  add ecx, 4
  push ecx
  push ebx
  call tower         
  pop ebx
  pop ecx

;  mov eax, peg2
;  push eax
;  mov eax, dword [num_peg]
;  push eax
;  call showp
;  pop eax
;  pop eax
;  call read_char

  swaploop:       
  cmp ebx, 1
  je endloop
  dec ebx
  mov eax, [ecx + 4]
  mov edx, [ecx]

  cmp edx, eax
  ja endswap

  mov [ecx + 4], edx  
  mov [ecx], eax

;  mov eax, peg2
  endloop:

  mov eax, peg2
  push eax
  mov eax, dword [num_peg]
  push eax
  call showp
  pop eax
  pop eax
  call read_char
  leave
  ret

showp:
  enter 0,0     
  pusha

  mov edx, [ebp + 12]
  mov ecx, [ebp + 8]
  mov ebx, edx
  mov eax, 4
  mul ecx
  sub eax, 4
  add ebx, eax

  printloop: 

     cmp dword [ebx], 1
     jne eq1
     mov eax, p1
     call print_string
     jmp endlo

     eq1:
     cmp dword [ebx], 2
     jne eq2
     mov eax, p2
     call print_string
     jmp endlo

     eq2:
     cmp dword [ebx], 3
     jne eq3
     mov eax, p3
     call print_string
     jmp endlo

     eq3:
     cmp dword [ebx], 4
     jne eq4
     mov eax, p4
     call print_string
     jmp endlo

     eq4:
     cmp dword [ebx], 5
     jne eq5
     mov eax, p5
     call print_string
     jmp endlo

     eq5:
     cmp dword [ebx], 6
     jne eq6
     mov eax, p6
     call print_string
     jmp endlo

     eq6:
     cmp dword [ebx], 7
     jne eq7
     mov eax, p7
     call print_string
     jmp endlo

     eq7:
     cmp dword [ebx], 8
     jne eq8
     mov eax, p8
     call print_string
     jmp endlo

     eq8:
     mov eax, p9
     call print_string

     endlo:
     call print_nl
     sub ebx, 4
     dec ecx
     cmp ecx, 1
     jge printloop

     mov eax, base
     call print_string
     call print_nl

    popa
    leave
    ret


  Error1:      
    mov eax, error1
    call print_string
    jmp asm_main_end

  Error2: 
    mov eax, error2
    call print_string
    jmp asm_main_end

asm_main_end: 
  popa
  leave
  ret