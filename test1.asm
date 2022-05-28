assume cs:codesg
codesg segment
    start: 
           
           mov ax,4c00h
           int 21h
   
           
          
codesg ends

end start