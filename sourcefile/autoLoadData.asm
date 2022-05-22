assume cs:code
code segment
      ;在代码段开辟空间存放数据:dw为列表的每一个元素分配一个字的内存空间,可以理解为顺序表
      List  dw   0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
      start:
            mov  ax,0
            mov  bx,0
            mov  cx,8

      lp:   add  ax,cs:[bx]
            add  bx,2
            loop lp
          
            mov  ax,4c00h
            int  21h
code ends
end start