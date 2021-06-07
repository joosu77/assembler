global bin_search

section .text
; -----------------------------------------------------------------------------
; Binary search:
; * väljastab otsitava elemendi indeksi 0st indekseerituna
;   antud massiivis logaritmilises ajas
; * eeldab, et massiiv on sorteeritud, võrdleb otsitavat väärtust antud
;   keskmise väärtusega ja kutsub ennast rekursiivselt välja vastuavalt
;   parema või vasaku poole peal, olenevalt kas otsitav on suurem või väiksem
; * kui otsitavat väärtust ei leidu massiivis, antakse suurima elemendi indeks,
;   mis ei ole suurem kui otsitav väärtus, kui otsitav väärtus on väiksem kui
;   vähim element, väljastatakse väikseima elemendi indeks massiivis
; * esimene parameeter on pointer massiivi esimesele elemendile
; * teine parameeter on massiivi pikkus
; * kolmas parameeter on otsitav element
; -----------------------------------------------------------------------------

bin_search:
push    EBP
push	EBX
mov     EBP, ESP
add     EBP, 12
mov     EBX, [EBP]	; massiivi asukoht -> EBX
mov	EDI, [EBP+4]	; massiivi pikkus -> EDX
mov	ECX, [EBP+8]	; otsitav väärtus -> ECX

cmp	EDI, 1		; kui lõigus on ainult üks element,
jne	.edasi1		; on vastus 0
 mov	EAX, 0
 jmp	.lopp

.edasi1:
cmp	EDI, 2		; kui lõigus on kaks elementi,
jne	.edasi2		; tuleb tagastada 1, kui otsitav
 cmp	ECX, [EBX+4]	; väärtus on esimese elemendiga võrdne
 jl	.vaiksem	; või suurem ning 0 muul juhul
 mov	EAX, 1
 jmp	.lopp
 .vaiksem:
 mov	EAX, 0
 jmp	.lopp

.edasi2:
mov	EAX, EDI	; jagan pikkuse 2ga et saada keskmise
mov	EDX, 0		; elemendi indeks
mov	ESI, 2
div	ESI

cmp	ECX, [EBX+4*EAX]
je	.lopp		; kui keskmine indeks on õige, ongi see vastus
jl	.alumine

push	EAX		; panen keskmise indeks stacki hiljem kasutamiseks

push	ECX		; lisan otsitava väärtuse stacki
sub	EDI, EAX	; teise poole pikkuse saamiseks lahutan kogu
push	EDI		; pikkusest esimese poole pikkus ja lisan stacki
mov	ESI, 4
mul	ESI		; korrutan keskmise indeksi 4ga ja liidan esimese
add	EBX, EAX	; elemendi pointerile et saada keskmise elemendi pointer
push	EBX
call	bin_search
add	EAX, [ESP+12]	; liidan sisemise funktsiooni tulemusele varem
			; stacki pandud keskmise indeksi
add	ESP, 16
jmp	.lopp

.alumine:
push	ECX		; lisan otsitava väärtuse stacki
push	EAX		; lisan keskmise indeksi ehk pikkuse stacki
push	EBX		; alumisel poolel on sama alguskoht, lisan selle stacki
call	bin_search
add	ESP, 12
jmp	.lopp


.lopp:
pop	EBX		; taastan registrid
pop     EBP
ret

