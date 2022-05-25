assume cs:codesg,ss:stacksg
stacksg segment
            dw 6 dup(0)
stacksg ends

codesg segment
    start:    
              mov  ax,stacksg
              mov  ss,ax
              mov  sp,12
              mov  dh,20                ;开始传参
              mov  dl,0
              mov  bh,' '
              mov  bl,0ffh


              mov  cx,80
              
    lp:       push cx
              mov  cx,bx                ;传参完成
              mov  ax,dx
              call far ptr show_char
              dec  bl
              inc  dl
              pop  cx
              loop lp


    last:     mov  ax,4c00h
              int  21h




    show_char:
    ;功能——在指定的位置,以指定样式显示一个字符
    ;参数——(ah)=行号(0~24),(al)=列号(0~79),(ch)=字符,(cl)=字符显示样式
    ;返回——本来没有设计返回值的
    ;不过最终发现cx原封不动,而ax保存了该字符显示地址相对于显存首页起始地址的偏移量
    ;这可能有用,所以返回值是:ax,cx
    ;注意:栈至少预留4word的空间
    ;函数缺乏泛用性：待泛函完成后再作修改——类似c语言的memcpy/memmove,注意空间重叠问题
              push ds
              push bx                   ;保存寄存器环境

              mov  bx,0b800h            ;正文开始
              mov  ds,bx                ;让ds指向显存起始段

              mov  bl,al                ;开始找显示的位置
              mov  al,160
              mul  ah
              add  bl,bl
              xor  bh,bh
              add  ax,bx
              mov  bx,ax                ;找到了,地址在bx里

              mov  [bx],ch              ;字符入显存
              mov  [bx].1,cl            ;样式入显存
    ;已用寄存器:ax,bx,cx,ds,其中用作参数的寄存器是ax、cx,其余寄存器要作合适的栈处理
              pop  bx
              pop  ds
              retf
    show_str: 
    ;功能——在指定的位置,以指定的颜色显示一个以0结尾的字符串
    ;参数——(dh)=行号(0~24),(dl)=列号(0~79),()=字符串显示样式,(ds:si)=字符串首地址
    ;返回——无

              retf
    memcopy:  
    ;从指定内存读取给定长度的数据到另一个给定内存(copy)
    
              retf
codesg ends


end start