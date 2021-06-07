global merge

section .text
; -----------------------------------------------------------
; Merge sort:
; * eismene argument pointer massiivi algusele
; * teine argument massiivi pikkus
; * pointer väljund massiivile
; -----------------------------------------------------------
merge:

push	EBP		; Jätan frame pointeri meelde
push	EAX
push	EBX
push	ECX		
push	EDX		; Jätan välimise välja kutsumise registrid meelde
mov	EBP, ESP	; ?
add	EBP, 24		; ??
mov	EBX, [EBP+8]	; massiivi asukoht -> EBX
mov	ESI, [EBP+4]	; massiivi pikkus -> ECX
mov	EDI, [EBP]	; väljund massiivi asukoht

cmp	ESI, 1
je	lopp		; kui massiivi pikkus on 1, on ta juba sorteeritud

mov 	EAX, ESI
mov	EDX, 2
div	EDX		; leian poole massiivi pikkuse

push	EBX
push	EAX
push	EDI
call	merge

;add	[EBP], 4*[EBP+4]	; liidan massiivi asukohale esimese poole jagu pikkust juurde
cmp	EDX, 0		; vaatan, kas pikkuse jagamisel jäi jääk
je	jaagita
inc	[EBP]
jaagita:
call	merge

mov	ECX, ESI
kopeeri:
mov	[EBX+ECX],[EDI+ECX]
loop	kopeeri		; kopeeri alamfunktsioonidest saadud massiivid sisendmassiivi

mov	ECX, ESI
yhenda: