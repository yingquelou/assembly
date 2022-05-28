assume cs:codesg
codesg segment
    start: 
    ; je
    ; jp
    ; jb
    ; ja
    ; js
    ; jc
    ; jo
    ; adc
    ; sbb
    ; jna
    ; cmp
           mov ax,4c00h
           int 21h
codesg ends
 
end start