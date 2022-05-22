assume cs:code,ds:data
data segment
    List dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
data ends

code segment
    start:
          mov  ax,data
          mov  ds,ax
          mov  bx,0

          mov  ax,0
          mov  cx,8

    lp:   add  ax,[bx]
          add  bx,2
          loop lp
          
          mov  ax,4c00h
          int  21h
code ends
end start