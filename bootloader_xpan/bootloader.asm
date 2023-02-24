
bits 16


; first we move the address to the data segment
; note can't move directly to the segmented memory
mov ax, 0x7C0
mov ds, ax

; we move the stack storage right after the bootsector
; .i.e 0x7c0 + 512 bytes = 0x7E0
mov ax, 0x7E0
mov ss, ax                              ; stack segment at 0x7E0

; we set stack pointer to a num of bytes past ss and equal to desired stack size
; to get a stack size 8k, we use 0x2000 from the 64k memory segment
mov sp, 0x2000                          ; moved 8k size to stack pointer


; here we call clearscreen, movecursor
call clearscreen

push 0x0000
call movecursor
add sp, 2

push msg
call print
add sp, 2

cli
hlt

clearscreen:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x07                        ; make bios scroll down window
    mov al, 0x00                        ; clear entire window
    mov bh, 0x07                        ; black bg - light grey text
    mov cx, 0x00                        ; clear starting from top left (0,0)
    mov dh, 0x18                        ; clear to 24th row down (0, 24)
    mov dl, 0x4f                        ; clear to 79th column (79, 24)

    int 0x10                            ; call video interrupt

    popa
    mov sp, bp
    pop bp
    ret


movecursor:
    push bp
    mov bp, sp
    pusha

    ; so dx should have position where cursor should be (row, column) int0x10 ah:02h
    ; offset dx by 4 cause it contains 2 bytes and arg takes 2bytes
    ; AH be 0x02 BH be page number, we use 0
    mov dx, [bp+4]                      ; get arg from stack, todo: dont understand this instruction well yet
    mov ah, 0x02                        ; set cursor position
    mov bh, 0x00                        ; page number 0 - not using multiple buffering
    int 0x100                           ; well call video interrupt

    popa
    mov sp, bp
    pop bp
    ret



print:
    push bp
    mov bp, sp
    pusha

    ; using int0x10 ah:0eh
    mov si, [bp+4]                      ; get pointer to the data
    mov bh, 0x00                        ; page number 0
    mov bl, 0x00                        ; foreground color
    mov ah, 0x0e                        ; print character to TTY


char:
    ; subroutine for individual character
    mov al, [si]                        ; get current char from position pointer
    add si, 1                           ; inc si till we get null
    or al, 0
    je .return                          ; return if null
    int 0x10                            ; print char if not done
    jmp .char                           ; keep looping


return:
    popa
    mov sp, bp
    pop bp
    ret



msg:    db "Hello world, xpan's bootloader is crappy but works, lol!", 0

; the 512 bytes of the bootsector, ends with 0xAA55 .i.e the boot signature
times 510-(\$-$$) db 0
dw 0xAA55
