global quick

section .text
; ----------------------------------------------------------------------------- 
; Quick sort:
; * kõigepealt valin viimase elemendi pivotiks, jaotan antud massiivi lõigus
;   pivotist väiksemad elemendid vasakule ning suuremad paremale ja kutsun
;   rekursiivselt sama funktsiooni välja vasaku ja parema lõigu peal
; * esimene argument on pointer massiivi algusele
; * teine argument on pointer viimasele elemendile
; -----------------------------------------------------------------------------
quick:
push	EBP		; lükkan frame pointeri ja muud vajalikud registrid
push	EDX		;  stacki et need funktsiooni lõpus taastada
push	ESI
push	EBX
mov	EBP, ESP
add	EBP, 20
mov	EBX, [EBP]	; massiivi esimese elemendi asukoht -> EBX
mov	ESI, [EBP+4]	; massiivi viimase elemendi asukoht -> ESI

cmp	EBX, ESI	; kui esimene ja viimane element on samad
jge	.lopp		;  pole vaja midagi teha

; -----------------------------------------------------------------------------
; Valin vaadeldava massiivi lõigu viimase elemendi pivotiks ning
; itereerin üle lõigu iteraatoriga ECX, iga väärtuse puhul kui väärtus on
; väiksem kui pivot, siis vahetan ta ära teise iteraatori juures oleva
; elemendiga ning suurendan seda teist iteratorit

mov	ECX, EBX	; esimene iteraator, algab esimesest elemendist
mov	EDX, EBX	; teine iteraator, algab esimesest elemendist

.tsykkel:
 mov	EAX, [ECX]	; võrdlen iteraatorit viimase elemendi ehk pivotiga
 cmp	EAX, [ESI]
 jge	.edasi
  mov	EAX, [ECX]	; vahetan iteraatorite juures olevad elemendid ära,
  mov	EDI, [EDX]	; kasutan EAX ja EDI registreid puhvritena
  mov	[ECX], EDI
  mov	[EDX], EAX
  add	EDX,4		; suurendan teist iteraatorit
 .edasi:
 add	ECX,4		; suurendan esimest iteraatorit

 cmp	ECX, ESI	; hüppan tsükli algusesse tagasi kui pole
 jle	.tsykkel	; veel viimase elemendini jõutud

mov	EAX, [EDX]	; vahetan ära viimase elemendi ehk pivoti
mov	EDI, [ESI]	; ja teise iteraatori juures oleva elemendi
mov	[ESI], EAX	; ehk esimese elemendi, mis on pivotist suurem
mov	[EDX], EDI

; -----------------------------------------------------------------------------
; kutsun funktsiooni välja paremal ja vasakul pool,
; jättes väja pivot elemendi enda

sub	EDX,4		; EDX näitab pivot elemendile, vähendan seda et see
			;  näitaks vasaku lõigu viimasele elemendile
push	EDX		; panen vasaku lõigu viimase elemendi stacki
push	EBX		; panen esimese elemendi stacki
call	quick		; kutsun välja funktsiooni vasaku lõigu peal
add	ESP, 8		; eemaldan argumendid stackist

add	EDX,8		; nihutan EDX pointeri parema lõigu algusesse
push	ESI		; panen viimase elemendi stacki
push	EDX		; panen parema lõigu esimese elemendi stacki
call	quick		; kutsun välja funktsiooni parema lõigu peal
add	ESP, 8		; eemaldan argumendid stackist

.lopp:
pop	EBX		; taastan funktsiooni kutsumise eelsed registrid
pop	ESI
pop	EDX
pop	EBP
ret