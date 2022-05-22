assume cs:codesg
codesg segment
    start: 
    ;将ff00~ffff的数据拷贝到0200~02ffh
           mov  ax,20h
           mov  ds,ax         ;初始化目的段
           mov  ax,0ff0h
           mov  es,ax         ;初始化源段
           mov  cx,0ffh       ;初始化迭代器
           
    lp:    mov  bx,cx
           mov  al,es:[bx]
           mov  [bx],al
           loop lp

           mov  ax,4c00h
           int  21h
    
codesg ends

end start