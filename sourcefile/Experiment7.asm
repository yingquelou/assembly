;《汇编语言》第三版 实验7
assume cs:codesg,ds:data,ss:table
data segment
       ;以下是表示21年的21个字符串--显然年份的数据基址为data:0,数据项占4byte
            db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
            db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
            db '1993','1994','1995'
       ;以下是表示21年公司总收入的21个dword数据--观察知道:收入数据的基址为data:54h,数据项占4byte
            dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
            dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
       ;以下是相应年的雇员人数--同理人员数据的基址为data:0a8h,数据项占2byte
            dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
            dw 11542,14430,15257,17800
data ends
table segment
             db 21 dup ('year summ ne ?? ')
table ends
codesg segment
       start: 
              mov  ax,data
              mov  ds,ax
              mov  bx,0
       ;使用[bx]的默认段地址为ds,故用以处理data段,
       ;同时由于年份和总收入的数据结构类似,数据项都占用4byte,且数据项个数相等,可以共用bx进行迭代追踪
              mov  si,0
       ;雇员人数的数据项个数虽然与年份和总收入的数据项个数都相同,但数据项占用2byte,故另用si进行迭代追踪
              mov  cx,21
              mov  bp,0
       ;由于data段的各类数据项个数与table段的数据项个数一样都是21,
       ;故仅单层循环即可,也因此不需要push、pop与ss:sp配合使用(多层循环需要的)(1)
       ;还需考虑table绑定的段寄存器:现cs段、ds段已使用,仅剩ss,es可选,而由于ss与bp配合使用时可以简化寻址方式(2)
       ;故综合(1)(2)两点,table应与ss绑定
              mov  ax,table
              mov  ss,ax
       ;单次循环处理table的一行
       lp:    mov  ax,[bx]
              mov  [bp],ax
              mov  ax,2[bx]
              mov  2[bp],ax          ;year
              mov  ax,54h[bx]
              mov  5h[bp],ax
              mov  dx,56h[bx]
              mov  7h[bp],dx         ;summ 这里为什么用dx?想一想

              mov  sp,0a8h[si]
              mov  0ah[bp],sp        ;ne
     
              div  sp                ;div时dx,ax刚好放了应该放的数据
              mov  0dh[bp],ax
            
              add  bx,4h
              add  si,2h
              add  bp,10h
              loop lp

              mov  ax,4c00h          ;返回
              int  21h
           
codesg ends
end start