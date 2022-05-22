;将字符串全部转换为小写
assume cs:code,ds:data
code segment
    start:
          mov  ax,data
          mov  ds,ax
          mov  bx,0
          mov  cx,6          ;字符数量

          mov  al,100000B
    ;or 1对应的位置1,0对应的位不变
    ;and 1对应的位不变,0对应的位置0
    lp:   
          or   [bx],al
          inc  bx
          loop lp

          mov  ax,4c00h
          int  21h
code ends
data segment
         db 'aWaDCX'    ;
data ends
end start