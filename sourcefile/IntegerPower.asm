;实现求解正整数幂,例如3的4次幂
assume cs:codesg,ss:stack
stack segment
             dw 0000h       ;此例中仅需分配一个字作为栈空间
stack ends
codesg segment
       start: 
              mov  ax,stack
              mov  ss,ax
              mov  ax,2h
              mov  sp,ax          ;栈初始化完成
           
              mov  dx,2           ;在此处修改底数
              mov  cx,4           ;在此处修改指数
           
              mov  bx,1h
           
       o:     push cx

              mov  ax,0h
              mov  cx,dx

       i:     add  ax,bx
              loop i

              mov  bx,ax

              pop  cx
              loop o

              mov  ax,4c00h       ;最终结果在寄存器bx中
              int  21h
    
codesg ends

end start