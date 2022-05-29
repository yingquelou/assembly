.8086
assume cs:codesg
codesg segment
    start: 
           imul
           mov ax,4c00h
           int 21h
   
           
          
codesg ends

end start