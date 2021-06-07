global test

section .text

test:

push    EBP         ; Retrieve parameter and put it
push	EBX
mov     EBP,ESP     ; into EBX register
add     EBP,12      ;
mov     EBX,[EBP]   ; EBX = Param
;mov	EDX,[EBP+4]

;mov	EAX,[EBX+4]
;inc	EAX
;mov	[EBX+4],EAX
mov	EAX, 4
add	EAX, EBX

pop	EBX
pop     EBP         ; Release EBP
ret

