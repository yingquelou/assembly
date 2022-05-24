assume cs:codesg,ds:datasg
codesg segment
       start: 
              mov  ax,datasg
              mov  ds,ax
              mov  ax,0b800h
              mov  ss,ax
      
              mov  bp,0
              mov  cx,25
              mov  si,0
              mov  al,' '
       lp1:   mov  dx,cx
              mov  cx,80

       lp2:   mov  [bp+si],al
              add  si,2
              loop lp2
              mov  bp,160
              mov  cx,dx
              loop lp1

              mov  bp,1920            ;12*160
              mov  si,64
              mov  ah,10011100B
              mov  bx,0
              mov  cx,15

       lp3:   mov  al,[bx]
              mov  [bp+si],al
              mov  [bp+si].1,ah
              inc  bx
              add  si,2
              loop lp3

              mov  ax,4c00h
              int  21h

codesg ends
datasg segment
              db 'Hello Assembly!'       ;15byte
datasg ends
end start