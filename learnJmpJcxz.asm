assume cs:codesg,ds:datasg
codesg segment
    start: 
           mov  ax,datasg
           mov  ds,ax
           mov  bx,0
           mov  ch,0
    s:     mov  cl,[bx]
           jcxz ok
           inc  bx
           jmp  short s
    
    ok:    mov  dx,bx
           mov  ax,4c00h
           int  21h
           
codesg ends
datasg segment
           db 9 dup(1)
           db 0
datasg ends
end start