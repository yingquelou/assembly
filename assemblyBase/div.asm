assume cs:codesg,ds:div8,ds:div16
codesg segment
       ;数学公式:                                         被除数÷ 除数=商……余数
       ;相应操作对象及操作结果的指定存放位置                    ax÷ 8bit=al……ah    当除数不大于0ffh且被除数不大于0ffffh时
       ;相应操作对象及操作结果的指定存放位置    <dx(高位),ax(低位)>÷16bit=ax……dx   当除数大于0ffh或被除数大于0ffffh时
       start: 
       ; 测试——当除数不大于0ffh且被除数不大于0ffffh时
              mov  ax,div8
              mov  ds,ax
           
              mov  bx,0                     ;初始化被除数基址
              mov  ss,ax                    ;此句对bp有用
              mov  bp,10h                   ;初始化除数基址

              mov  cx,8h                    ;初始化计数器

       lp1:   mov  ax,[bx]
              div  byte ptr [bp]            ;如果未显示的指明段地址,[bp]的段地址默认是ss.即此句等价于div  byte ptr ss:[bp]
              mov  byte ptr 8[bp],al        ;保存商
              mov  byte ptr 16[bp],ah       ;保存余数
              add  bx,2
              inc  bp
              loop lp1
       ; 测试——当除数大于0ffh或被除数大于0ffffh时
              mov  bx,40
              mov  di,bx
              add  di,12
              mov  cx,3

       lp2:   mov  ax,[bx]
              mov  dx,[bx].2
              div  word ptr[di]
              mov  6[di],ax
              mov  12[di],dx
              add  bx,4
              add  di,2
              loop lp2
              
              mov  ax,4c00h                 ;返回
              int  21h
codesg ends
div8 segment
       ; 当除数不大于0ffh且被除数不大于0ffffh时
            dw 12,23,12,34,48,81,121,144       ;被除数
            db 12,11,15,1,96,9,11,12           ;除数
            db 8 dup(0)                        ;商保存位置
            db 8 dup(0)                        ;余数保存位置
       ; 当除数不大于0ffh且被除数不大于0ffffh时
            dd 0fffffffh,0,129600              ;被除数
            dw 0ffffh,64,9                     ;除数
            dw 0,0,0                           ;商保存位置
            dw 0,0,0                           ;余数保存位置
div8 ends
div16 segment

div16 ends
end start