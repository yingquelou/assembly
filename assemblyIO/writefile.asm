;中断处理程序
    ; INT 21h / AH=1 - read character from standard input, with echo, result is stored in AL.
    ; if there is no character in the keyboard buffer, the function waits until any key is pressed.
INT21H_GETCHAR_STDIN equ 1
    ; INT 21h / AH=1 - read character from standard input, with echo, result is stored in AL.
    ; if there is no character in the keyboard buffer, the function waits until any key is pressed.
INT21H_PUTCHAR_STDOUT equ 2
    ; INT 21h / AH=5 - output character to printer.
    ; entry: DL = character to print, after execution AL = DL.
INT21H_PUTCHAR_PRINTER equ 5
    ; INT 21h / AH=6 - direct console input or output.

    ; parameters for output: DL = 0..254 (ascii code)
    ; parameters for input: DL = 255

    ; for output returns: AL = DL
    ; for input returns: ZF set if no character available and AL = 00h, ZF clear if character available.
    ; AL = character read; buffer is cleared.
INT21H_CONSOLE_IO equ 6
    ; INT 21h / AH=7 - character input without echo to AL.
    ; if there is no character in the keyboard buffer, the function waits until any key is pressed.
INT21H_VOID_GETCHAR_STDIN equ 7
    ; INT 21h / AH=9 - output of a string at DS:DX. String must be terminated by '$'.
INT21H_PUTSTRING_STDOUT equ 9
    ; INT 21h / AH=0Ah - input of a string to DS:DX, fist byte is buffer size, second byte is number of chars actually read. this function does not add '$' in the end of string. to print using INT 21h / AH=9 you must set dollar character at the end of it and start printing from address DS:DX + 2.
INT21H_GETSTRING_STDIN equ 0ah
    ; INT 21h / AH=0Bh - get input status;
    ; returns: AL = 00h if no character available, AL = 0FFh if character is available.
INT21H_GETSTATUS_STDIN equ 0BH
    ; INT 21h / AH=0Ch - flush keyboard buffer and read standard input.
    ; entry: AL = number of input function to execute after flushing buffer (can be 01h,06h,07h,08h, or 0Ah - for other values the buffer is flushed but no input is attempted); other registers as appropriate for the selected input function
INT21H_FLUSH_STDIN equ 0CH
    ; INT 21h / AH= 0Eh - select default drive.

    ; Entry: DL = new default drive (0=A:, 1=B:, etc)
    ; Return: AL = number of potentially valid drive letters
    ; Notes: the return value is the highest drive present.
INT21H_SETDEFAULT_DRIVE equ 0EH
    ; INT 21h / AH= 19h - get current default drive.
    ; Return: AL = drive (0=A:, 1=B:, etc)
INT21H_GETDEFAULT_DRIVE equ 19H
    ; INT 21h / AH=25h - set interrupt vector;
    ; input: AL = interrupt number. DS:DX -> new interrupt handler
INT21H_SET_INT_VECTOR equ 25H
    ; INT 21h / AH=2Ah - get system date;
    ; return: CX = year (1980-2099). DH = month. DL = day. AL = day of week (00h=Sunday)
INT21H_GETSYSTEMDATE equ 2AH
    ; INT 21h / AH=2Ch - get system time;
    ; return: CH = hour. CL = minute. DH = second. DL = 1/100 seconds.
INT21H_GETSYSTEMTIME equ 2CH
    ; INT 21h / AH=35h - get interrupt vector;

    ; entry: AL = interrupt number;
    ; return: ES:BX -> current interrupt handler.
INT21H_GET_INT_VECTOR equ 35H
    ; INT 21h / AH= 39h - make directory.
    ; entry: DS:DX -> ASCIZ pathname; zero terminated string

    ; Return: CF clear if successful AX destroyed. CF set on error AX = error code.
    ; Note: all directories in the given path must exist except the last one.

INT21H_MKDIR equ 39H
    ; INT 21h / AH= 3Ah - remove directory.

    ; Entry: DS:DX -> ASCIZ pathname of directory to be removed.
    ; Return:
    ; +　CF is clear if successful, AX destroyed CF is set on error AX = error code.
    ; Notes: directory must be empty (there should be no files inside of it).
INT21H_RMDIR equ 3AH
    ; INT 21h / AH= 3Bh - set current directory.

    ; Entry: DS:DX -> ASCIZ pathname to become current directory (max 64 bytes).
    ; Return:
    ; Carry Flag is clear if successful, AX destroyed.
    ; Carry Flag is set on error AX = error code.
    ; Notes: even if new directory name includes a drive letter, the default drive is not changed,
    ; only the current directory on that drive.
INT21H_CHDIR equ 3BH
    ; INT 21h / AH= 3Ch - create or truncate file.

    ; entry:
    ; CX = file attributes:
    ;  mov cx, 0       ;  normal - no attributes.
    ;  mov cx, 1       ;  read-only.
    ;  mov cx, 2       ;  hidden.
    ;  mov cx, 4       ;  system
    ;  mov cx, 7       ;  hidden, system and read-only!
    ;  mov cx, 16      ;  archive
    ; DS:DX -> ASCIZ filename.

    ; returns:
    ; CF clear if successful, AX = file handle.
    ; CF set on error AX = error code.
    ; note: if specified file exists it is deleted without a warning
INT21H_CREATE_FILE equ 3CH
    ; INT 21h / AH= 3Dh - open existing file.

    ; Entry:
    ; AL = access and sharing modes:
    ; mov al, 0   ; read
    ; mov al, 1   ; write
    ; mov al, 2   ; read/write
    ; DS:DX -> ASCIZ filename.

    ; Return:
    ; CF clear if successful, AX = file handle.
    ; CF set on error AX = error code.

    ; note 1: file pointer is set to start of file.
    ; note 2: file must exist.
INT21H_OPEN_FILE  equ    3dh
    ; INT 21h / AH= 3Eh - close file.

    ; Entry:
    ; BX = file handle
    
    ; Return:
    ; CF clear if successful, AX destroyed.
    ; CF set on error, AX = error code (06h)
INT21H_CLOSE_FILE equ    3eh
    ; INT 21h / AH= 3Fh - read from file.

    ; Entry:
    ; BX = file handle.
    ; CX = number of bytes to read.
    ; DS:DX -> buffer for data.

    ; Return:
    ; CF is clear if successful - AX = number of bytes actually read; 0 if at EOF (end of file) before call.
    ; CF is set on error AX = error code.
    ; Note: data is read beginning at current file position, and the file position is updated after a successful read the returned AX may be smaller than the request in CX if a partial read occurred.
INT21H_READ_FILE  equ    3fh
    ; INT 21h / AH= 40h - write to file.

    ; entry:
    ; BX = file handle.
    ; CX = number of bytes to write.
    ; DS:DX -> data to write.
    ; return:
    ; CF clear if successful; AX = number of bytes actually written.
    ; CF set on error; AX = error code.
    ; note: if CX is zero, no data is written, and the file is truncated or extended to the current position data is written beginning at the current file position, and the file position is updated after a successful write the usual cause for AX < CX on return is a full disk.
INT21H_WRITE_FILE equ    40h
    ; INT 21h / AH= 41h - delete file (unlink).

    ; Entry:
    ; DS:DX -> ASCIZ filename (no wildcards, but see notes).
    ; return:
    ; CF clear if successful, AX destroyed. AL is the drive of deleted file (undocumented).
    ; CF set on error AX = error code.
    ; Note: DOS does not erase the file's data; it merely becomes inaccessible because the FAT chain for the file is cleared deleting a file which is currently open may lead to filesystem corruption.
INT21H_DELETE_FILE equ    41h
    ; INT 21h / AH= 42h - SEEK - set current file position.

    ; Entry:
    ; AL = origin of move: 0 - start of file. 1 - current file position. 2 - end of file.
    ; BX = file handle.
    ; CX:DX = offset from origin of new file position.
    ; Return:
    ; CF clear if successful, DX:AX = new file position in bytes from start of file.
    ; CF set on error, AX = error code.
    ; Notes:

    ; for origins 1 and 2, the pointer may be positioned before the start of the file; no error is returned in that case, but subsequent attempts to read or write the file will produce errors. If the new position is beyond the current end of file, the file will be extended by the next write (see AH=40h).
INT21H_SEEK_FILE equ    42h;
    ; INT 21h / AH= 47h - get current directory.

    ; Entry:
    ; DL = drive number (00h = default, 01h = A:, etc)
    ; DS:SI -> 64-byte buffer for ASCIZ pathname.
    ; Return:
    ; Carry is clear if successful
    ; Carry is set on error, AX = error code (0Fh)
    ; Notes:

    ; the returned path does not include a drive and the initial backslash.
INT21H_GETPATH_DIR equ    47h;

COMS_ADRESS_PORT equ 70H
COMS_DATA_PORT equ 71H
;The CMOS time uses BCD CODE
COMS_SECOND_ADRESS equ 0
COMS_MINUTE_ADRESS equ 2
COMS_HOUR_ADRESS equ 4
COMS_DAY_ADRESS equ 7
COMS_MONTH_ADRESS equ 8
COMS_YEAR_ADRESS equ 9
; 扫描码:断码=通码+80h
; 扫描码对应字符时,该字符及通码被送入键盘缓冲区
; 扫描码对应控制键或切换键时,对应状态信息被送入状态字节单元
; 键盘状态字节单元:0040:17,其各个比特位记录的信息如下:
; 0:右shift状态,置1表示按下右shift键
; 1:左shift状态,置1表示按下左shift键
; 2:Ctrl状态,置1表示按下Ctrl键
; 3:Alt状态,置1表示按下Alt键
; 4:ScrollLock状态,置1表示Scroll指示灯亮
; 5:NumLock状态,置1表示小键盘输入的是数字
; 6:CapsLock状态,置1表示输入大写字母
; 7:Insert状态,置1表示处于删除态。
KEYBOARD_PORT equ 60H
; 响应键盘输入到键盘缓冲区的中断
INT9H equ 9
; 从键盘缓冲区读取一个键盘输入
; entry:none
; return:(ah)=扫描码,(al)=ASCII码
INT16H_GETCHAR_BUFFER equ 0
  

assume cs:codesg
assume ds:datasg
datasg segment
           db 'ch.txt',250 dup(0)
datasg ends
codesg segment use16
    start: 
           MOV  DX,datasg
           MOV  DS,DX

           xor  cx,cx
           xor  dx,dx


           mov  ah,INT21H_CREATE_FILE
           INT  21H
           jc   rt

    ;    mov ah,INT21H_OPEN_FILE
    ;    INT 21H
    ;    jc  rt
           mov  bx,0
           mov  cx,0ffh+1
    lp:    mov  [bx],bx
           inc  bx
           loop lp

           mov  bx,ax
           xor  dx,dx
           mov  cx,0ffh+1
           mov  ah,INT21H_WRITE_FILE
           INT  21H
           jc   rt

           mov  ah,INT21H_CLOSE_FILE
           INT  21H
           jc   rt

           
    rt:    mov  ax,4c00h
           int  21h
codesg ends
end start