
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



