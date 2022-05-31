.8086
assume cs:codesg,ss:stacksg,ds:string
stacksg segment
            word 15 dup(0)
stacksg ends
string segment
           byte 256 dup(0,0)
string ends

codesg segment use16
    start:        mov   ax,stacksg
                  mov   ss,ax
                  mov   sp,30

                  mov   ax,string
                  mov   ds,ax

                  mov   bx,256*2-1
                  mov   cx,0ffh
    lp:           
    ;           mov   [bx],cl
    ;               and   byte ptr [bx],01111111B
                  mov   byte ptr [bx],00000111B
                  mov   -1[bx],cl
                  sub   bx,2
                  loop  lp

                  mov   ax,0b800h
                  mov   es,ax
                  mov   di,990
                  xor   si,si
                  mov   cx,(0ffh+1)*2

                  call  far ptr memmove




                  mov   ax,4c00h
                  int   21h




    show_char:    
    ;功能——在指定的位置,以指定样式显示一个字符
    ;参数——(ah)=行号(0~24),(al)=列号(0~79),(ch)=字符,(cl)=字符显示样式
    ;返回——本来没有设计返回值的
    ;不过最终发现cx原封不动,而ax保存了该字符显示地址相对于显存首页起始地址的偏移量
    ;这可能有用,所以返回值是:ax,cx
    ;注意:栈至少预留4word的空间
    ;函数缺乏泛用性：待泛函完成后再作修改——类似c语言的memcpy/memmove,注意空间重叠问题
                  push  ds
                  push  bx                         ;保存寄存器环境

                  mov   bx,0b800h                  ;正文开始
                  mov   ds,bx                      ;让ds指向显存起始段

                  mov   bl,al                      ;开始找显示的位置
                  mov   al,160
                  mul   ah
                  add   bl,bl
                  xor   bh,bh
                  add   ax,bx
                  mov   bx,ax                      ;找到了,地址在bx里

                  mov   [bx],ch                    ;字符入显存
                  mov   [bx].1,cl                  ;样式入显存
    ;已用寄存器:ax,bx,cx,ds,其中用作参数的寄存器是ax、cx,其余寄存器要作合适的栈处理
                  pop   bx
                  pop   ds
                  retf
   
    
    getRealAdress:
    ; entry:(ax)=EA,(dx)=SA
    ; return:(ax)=物理地址低位,(dx)=物理地址高位
    ; 栈空间预留1word
                  pushf
                  push  si

                  mov   si,ax
                  mov   ax,16
                  mul   dx
                  add   ax,si
                  adc   dx,0

                  pop   si
                  popf
                  retf
    memmove:      
    ;从指定内存读取给定长度的数据到另一个给定内存(源空间与目的空间有重叠可能)
    ; entry:source——ds:si,dest——es:di,length——cx
                  pushf
                  push  ax
                  push  dx
                  
                  xor   ax,ax
                  push  ax
                  popf
                  jmp   j
                  tmp   word 2 dup(?)

    j:            mov   ax,di
                  mov   dx,es
                  call  far ptr getRealAdress
                  mov   tmp[0],ax
                  mov   tmp[2],dx
                  mov   ax,si
                  mov   dx,ds
                  call  far ptr getRealAdress
                 
                  cmp   dx,tmp[2]                  ;比较高位
                  ja    cp
                  jne   recp

                  cmp   ax,tmp[0]                  ;比较低位
                  ja    cp
                  jne   recp
                  jmp   rt

    recp:         std
                  dec   cx
                  add   si,cx                      ;是否有进位？
                  add   di,cx                      ;是否有进位？
                  inc   cx
    cp:           rep   movsb                      ;复制
    rt:           
                  pop   dx
                  pop   ax
                  popf
                  retf
    show_str:     
    ;功能——在指定的位置,以指定的颜色显示一个以0结尾的字符串
    ;参数——(dh)=行号(0~24),(dl)=列号(0~79),()=字符串显示样式,(ds:si)=字符串首地址
    ;返回——无

                  retf
codesg ends


end start