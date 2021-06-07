global inplace_merge

section .text
; -----------------------------------------------------------------------------
; Inplace merge sort:
; * jaotab massiivi kaheks ligikaudu võrdseks osaks, kutsub kummagi
;   osa peal rekursiivselt ennast välja ning seejärel paneb saadud
;   kaks sorteeritud juppi kokku all kirjeldatud algoritmi abil,
;   mis ei kasuta lisa mälu
; * eismene argument pointer esimesele elemendile
; * teine argument pointer viimasele elemendile
; -----------------------------------------------------------------------------
inplace_merge:

push	EBP		; Jätan frame pointeri meelde
push	EBX
push	ESI
push	EDI		; Jätan välimise välja kutsumise registrid meelde
mov	EBP, ESP
add	EBP, 20
mov	EBX, [EBP]	; pointer esimesele elemendile -> EBX
mov	ESI, [EBP+4]	; pointer viimasele elemendile -> ESI

cmp	EBX, ESI
jge	.lopp		; kui massiivi pikkus on 1, on ta juba sorteeritud

add	EBX, 4
cmp	EBX, ESI	; kui massiivi pikkus on 2, tuleb sorteerida otse
jne	.edasi

 mov	EAX, [EBX-4]	; kontrollin kas need kaks elementi on
 cmp	EAX, [ESI]	; õiges järjekorras
 jle	.lopp
  mov	EDI, [ESI]	; vahetan elemendid ära
  mov	[ESI], EAX
  mov	[EBX-4], EDI
  jmp	.lopp 
.edasi:
sub	EBX, 4

mov 	EAX, ESI	; leian keskmise elemendi viimase ja esimese vahel
mov	EDX, 0
mov	ECX, 2		; aadressid tunduvad alati olevat ligikaudu
div	ECX		; 0xffff9fxx ümbruses ehk kahe aadressi liitmisel
mov	EDI, EAX	; tekib overflow, selle ennetamiseks jagan kumbagi
mov	EAX, EBX	; aadressit eraldi kahega ning liidan alles siis
mov	EDX, 0		; kokku registrisse EAX
mov	ECX, 2
div	ECX
add	EAX, EDI

mov	EDI, EAX	; dubleerin tulemuse EDI registrisse

mov	EDX, 0
mov	ECX, 4		; kontrollin kas saadud tulemus jagub 4ga, kui ei jagu,
div	ECX		; on tegu paarisarv elemente massiivis ehk keskmist
sub	EDI, EDX	; elementi ei leidu, sel juhul lahutan jäägi tulemusest

push	EDI		; panen massiivi alguse ja keskkoha pointerid stacki
push	EBX		; ja kutsun funktsiooni rekursiivselt välja
call	inplace_merge
add	ESP, 8

add	EDI, 4		; suurendan keskmise elemendi pointerit ühe võrra edasi
push	ESI		; panen keskkohale järgneva elemendi ja viimase
push	EDI		; elemendi stacki ja kutsun fuinktsiooni rekursiivselt välja
call	inplace_merge
add	ESP, 8

sub	EDI, 4		; tõstan keskkoha esimese poole lõppu tagasi

; -----------------------------------------------------------------------------
; Ühendan saadud kaks sorteeritud lõiku
; teostan ühendamise algoritmiga:
;
; for *i := arr2[m-1] to arr2[0]:
;	last := arr1[n-1]
;	for *j := arr1[n-2] to arr1[0]:
;		if *j <= *i:
;			break
;		*(j+1) = *j
;		
;	if j != &arr1[n-2] or last > *i:
;		*(j+1) = *i
;		*i = last
;
; * siin arr1 on massivi esimene pool, arr2 teine pool,
;   n esimese poole pikkus, m teise poole pikkus,
;   pointer i on registris ECX, pointer j on registris EDX
; * last väärtus asub stacki peal
; * registrites EBX, EDI, ESI on vastavalt pointerid massiivi
;   esimesele elemendile, esimese lõigu viimasele elemendile
;   ning massiivi viimasele elemendile

mov	ECX, ESI	; initsialiseerin esimese tsykli muutuja
.for1:
 cmp	ECX, EDI	; esimese tsykli tingimus
 je	.edasi1

 mov	EAX, [EDI]	; panen last väärtuse stacki
 push	EAX
 mov	EDX, EDI	; initsialiseerin teise tsykli muutuja
 sub	EDX, 4
 .for2:
  cmp	EDX, EBX	; teise tsykli tingimus
  jl	.edasi2
  mov	EAX, [EDX]
  cmp	EAX, [ECX]	; kontroll et *j <= *i ei kehtiks
  jle	.edasi2

  mov	EAX, [EDX]	; omistamine *(j+1) = *j
  mov	[EDX+4], EAX
  sub	EDX, 4		; liigutan iteraatorit

  jmp .for2		; hyppan tsykli algusesse tagasi
 .edasi2:

 sub	EDI, 4		; nihutan keskkohta tingimuse kontrollimiseks
 cmp	EDX, EDI	; if tingimused
 jne	.do
 mov	EAX, [ESP]
 cmp	EAX, [ECX]
 jle	.else

  .do:
  mov	EAX, [ECX]	; omistamine *(j+1) = *i
  mov	[EDX+4], EAX
  mov	EAX, [ESP]	; omistamine *i = last
  mov	[ECX], EAX

 .else:	
 add	ESP, 4		; eemaldan last väärtuse stackist
 add	EDI, 4		; panen keskkoha õigesse kohta tagasi
 sub	ECX, 4		; liigutan iteraatorit
jmp	.for1
.edasi1:

; -----------------------------------------------------------------------------
; epiloog:

.lopp:
pop	EDI		; taastan funktsiooni kutsumise eelsed registrid
pop	ESI
pop	EBX
pop	EBP
ret
