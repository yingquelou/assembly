;实现求解正整数幂,例如3的4次幂
assume cs:codesg,ss:stack
stack segment
             dw 10 dup(0)
stack ends
codesg segment
       start: 
              mov  ax,stack
              mov  ss,ax
              mov  ax,20
              mov  sp,ax          ;栈初始化完成
           
              mov  dx,12          ;传入底数
              mov  cx,2           ;传入指数
              call pow

              mov  ax,4c00h
              int  21h

       ;不使用mul如何完成计算
       pow:   
       ;参数——dx(底数),cx(指数)
       ;请保证栈空间充足,不少于7byte
              push bx
              push ax

              mov  bx,1h
       o:     push cx

              mov  ax,0h
              mov  cx,dx

       i:     add  ax,bx
              loop i

              mov  bx,ax

              pop  cx
              loop o
              mov  dx,bx

              pop  ax
              pop  bx
       ;返回值在dx中,计算数据过大时dx溢出
              ret
codesg ends

end start