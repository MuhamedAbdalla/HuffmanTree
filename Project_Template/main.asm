INCLUDE Irvine32.inc

.data
;incode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lev struct 
	index1 dword 0
	arr DWORD 60 dup(0)
lev ends
codes struct 
	index2 dword 0
	chr dword 0
	ot DWORD 60 dup(0)
codes ends
level lev 60 dup(<0, <0>>)
arr_c codes 60 dup(<0, 0, <0>>)
arr_code dword 60 dup(0)
ind dword 0
np dword 0
pn dword 0
lvl dword 0
n_ch dword 0
parent_c dword 30 dup(0)
parent_n dword 30 dup(0)
child_c dword 60 dup(0)
child_n dword 60 dup(0)
external DWORD 1
indx DWORD 0
indx1 DWORD 0
temp byte ?

;For Add to file
fileN BYTE "C:\Irvine\Project_Template\Debug\tree.txt",0
newline BYTE ' ', 13, 10, 0
fileH HANDLE ?
arr_to_file dword 50000 dup(?)
index3 dword 0
numberstring dword 8 DUP (0)
numberChar dword 0
fmt byte "%d",0
sav2 dword ?
sav3 dword ?
sav4 dword ?
fileN2 BYTE "C:\Irvine\Project_Template\Debug\codes.txt",0
fileH2 HANDLE ?
numberstring2 dword 1 DUP (0)

;file info.
fileName BYTE "C:\Irvine\Project_Template\Debug\data.txt",0
inFile DWORD ?
inBuff byte 10000 DUP(?)
buffer_size dword 0
fileHandle HANDLE ?

;sort and info array
var dword ?
sz DWORD 0
num DWORD 0
num2 DWORD 0
arr_str DWORD 30 dup(2)
fre Dword 30 dup(0)
sav dword 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;decode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
treap struct
val DWORD 0
left DWORD ?
right DWORD ?
comeFrom DWORD ?
chr DWORD ?
treap ends

texture dword 1000 dup(?)
index_texture dword 0
memo dword ?
save_mem dword ?
strfinal dword ?

fileIN byte "C:\Irvine\Project_Template\Debug\Texture.txt", 0
fileHAN HANDLE ?

fileCode BYTE "C:\Irvine\Project_Template\Debug\Moin.txt",0
code byte 10000 DUP(?)
codesz dword 0
indexcode dword 0
fileHand HANDLE ?

file BYTE "C:\Irvine\Project_Template\Debug\MO.txt",0
buffer byte 10000 DUP(?)
buffersz dword 0
handfile HANDLE ?
qoute dword ' '
temp2 byte ?
arr treap  100 DUP({0, 0, 0, 2, '0'})
revar DWORD 0
;info
array_num dword 1000 dup(0)
index1 dword 0
array_char byte 1000 dup(0)
index2 dword 0

.code					
MAIN PROC
   call build_Tree
   call setter
   call get_text
   EXIT
MAIN ENDP

build_Tree proc
   mov EDX,OFFSET fileName
   call openInputFile
   mov fileHandle, eax
   mov EDX, OFFSET inBuff
   mov ECX, lengthof inBuff
   call ReadFromFile
   mov buffer_size, eax
   mov edx, offset inBuff
   call writestring
   call crlf
   mov sz, eax
   mov ecx, sz
   l1:
	mov eax, ecx
	mov ecx, 0
	l2:
		cmp [arr_str + ecx * 4], 2
		jz there
		movzx ebx, byte ptr [edx]
		cmp [arr_str + ecx * 4], ebx
		jnz rip
		inc [fre + ecx * 4]
		jmp here
		rip:
		inc ecx
		cmp [arr_str + ecx * 4], 2
		jz there
	jmp l2
	there:
	inc num
	movzx ebx, byte ptr [edx]
	mov [arr_str + ecx * 4], ebx
	mov [fre + ecx * 4], 1
	here:
	inc edx
	mov ecx, eax
   loop l1
   mov edx, num
   mov num2, edx
   call setter
   call Insertion
   call setter
   call tree
   call setter
   dec indx
   mov edx, indx
   mov indx1, edx
   mov ebx, edx
   mov edx, parent_c[ebx * 4]
   mov np, edx
   mov edx, parent_n[ebx * 4]
   mov pn, edx
   mov ebx, 0
   mov edx, offset level
   mov esi, offset arr_c
   call getlv
   mov edx, offset level
   mov ecx, 0
   blabla:
	mov sav, ecx
	mov ecx, 0
	mov eax, 0
	mov esi, 0
	mov ebx, 0
	mov sav2, eax
	mov sav3, eax
	bla:
	 mov sav2, edx
	 mov sav3, ecx
	 mov eax, [edx].lev.arr[ecx * 4]
	 push eax
     push offset fmt
     push offset numberstring
     call wsprintf
	 pop ecx
	 pop ecx
	 pop ecx
     mov numberChar, eax
	 mov eax, numberstring
	 mov edx, sav2
	 mov ecx, sav3
	 mov ebx, index3
	 mov arr_to_file[ebx * 4], eax
	 inc ecx
	 inc index3
	 cmp ecx, [edx].lev.index1
	 jz bye1
	jmp bla
	bye1:
	mov ecx, sav
	inc ecx
	cmp ecx, lvl
	jz bye
	add edx, sizeof lev
   jmp blabla
   bye:
   mov edx, OFFSET fileN
   call CreateOutputFile
   inc eax
   mov fileH, eax
   mov ecx, 0
   lppl:
    mov sav2, ecx
    mov ebx, arr_to_file[ecx * 4]
	mov numberstring, ebx
	mov eax, fileH
    mov edx, OFFSET numberstring
    mov ecx, lengthof numberstring
	call WriteToFile
	mov ecx, sav2
	inc ecx
	cmp ecx, index3
	jz bye4
   jmp lppl
   bye4:
   mov eax, fileH
   mov edx, OFFSET newline
   mov ecx, 3
   call WriteToFile
   mov esi, offset arr_c
   mov ecx, 0
   mov num, 0
   blabla2:
	mov sav, ecx
	mov eax, [esi].codes.index2
	mov ebx, num
	mov [fre + ebx * 4], eax
	mov eax, [esi].codes.chr
	mov [arr_str + ebx * 4], eax
	inc num
	mov ecx, sav
	inc ecx
	cmp ecx, n_ch
	jz bye2
	add esi, sizeof codes
   jmp blabla2
   bye2:
   call Insertion
   mov ecx, 0
   blabla4:
	mov sav, ecx
	mov eax, [arr_str + ecx * 4]
	mov numberstring, eax
	mov eax, fileH
    mov edx, OFFSET numberstring
    mov ecx, lengthof numberstring
    call WriteToFile
	mov ecx, sav
	inc ecx
	cmp ecx, num
	jz bey
   jmp blabla4
   bey:
   call CloseFile
   mov edx, OFFSET fileN2
   call CreateOutputFile
   inc eax
   mov fileH2, eax
   mov ecx, 0
   mov edx, offset inBuff
   blabla3:
    mov esi, offset arr_c
	mov sav, ecx
	mov ebx, 0
	lal:
	    mov eax, [edx]
		mov temp, al
		movzx eax, temp
		cmp [esi].codes.chr, eax
        jz lol
		add esi, sizeof codes
	jmp lal
	lol:
		mov sav2, esi
		mov sav3, edx
		mov sav4, ebx
		mov eax, [esi].codes.ot[ebx * 4]
   		push eax
		push offset fmt
		push offset numberstring2
		call wsprintf
		pop ecx
		pop ecx
		pop ecx
		mov eax, fileH2
		mov edx, OFFSET numberstring2
		mov ecx, 1
		call WriteToFile
		mov esi, sav2
		mov edx, sav3
		mov ebx, sav4
		inc ebx
		cmp ebx, [esi].codes.index2
		jz heno
	jmp lol
	heno:
	inc edx
	mov ecx, sav
	inc ecx
	cmp ecx, buffer_size
	jz bey2
   jmp blabla3
   bey2:
   call CloseFile
   ret
build_Tree endp

get_text proc
   mov EDX,OFFSET file
   call openInputFile
   mov handfile, eax
   mov EDX, OFFSET buffer
   mov ECX, lengthof buffer
   call ReadFromFile
   mov buffersz, eax
   mov edx, offset buffer
   mov eax, 0
   mov ebx, 0
   mov ecx, 0
   mov esi, 0
   push_to_arr:
    mov ecx, 0
	dec buffersz
	mov ecx, qoute
	mov ebx, [edx]
	mov temp2, bl
	mov temp2, bl
	movzx ebx, temp2
	cmp ebx, ecx
	jnz not_found
	inc edx
	mov esi, eax
	mov eax, 0
	mov ebx, index1
	mov [array_num + ebx * 4], esi
	inc index1
	jmp push_to_arr
	not_found:
	mov ebx, 0Ah
	mov ecx, [edx]
	mov temp2, cl
	movzx ecx, temp2
	cmp ecx, ebx
	jz break
	call mult
	mov ebx, 0
	mov ebx, [edx]
	mov temp2, bl
	movzx ebx, temp2
	sub bl, '0'
	add eax, ebx
	inc edx
   jmp push_to_arr
   break:

   inc buffersz
   inc edx
   mov eax, 0
   mov ebx, 0
   mov ecx, 0
   mov esi, 0
  
  push_to_char:
	dec buffersz
	mov ecx, 0
	mov ecx, qoute
	mov ebx, 0
	mov ebx, [edx]
	mov temp2, bl
	movzx ebx, temp2
	cmp ebx, ecx
	jnz notfound
	inc edx
	mov ebx, index2
	mov [array_char + ebx], al
	mov eax, 0
	inc index2
	jmp push_to_char
	notfound:
	mov eax, [edx]
	mov ecx, buffersz
	cmp ecx, 0
	jz rbreak
	inc edx
   jmp push_to_char
   rbreak:

    mov eax, 0
	mov esi, 0
	mov ebx, 0
	mov ecx, index1
	mov ebx , offset arr
	mov esi , offset arr
	mov edx , offset array_num
	mov revar , 0
	
	l1:
	mov eax , [edx]
	mov [ebx].treap.val , eax
	cmp eax , 0
	je l3
	add revar , type treap
	mov eax , revar
	mov [ebx].treap.left , eax
 
	push edx
	mov edx , offset arr
	add edx , revar
	mov [edx].treap.comeFrom , 0
	pop edx
	add revar , type treap
	mov eax , revar
	mov [ebx].treap.right , eax
	push edx
	mov edx , offset arr
	add edx , revar
	mov[edx].treap.comeFrom , 1
	pop edx
	add ebx , type treap
	add edx , type DWORD
	jmp l4
	l3:
	add ebx , type treap
	add edx , type DWORD
	l4: 
	loop l1

	mov ecx , index1
	mov ebx , offset arr
	mov edx , offset arr
	mov esi , offset array_char
	l2:
		mov eax , [ebx].treap.left
		mov eax , [edx + eax].treap.val
		cmp eax , 0
		jnz l5
			mov [ebx].treap.chr , esi
			mov eax , [ebx].treap.chr
			mov save_mem, ebx
			push ebx
			mov bl , [eax]
			push eax
			mov al , bl
			movzx ebx, al
			movzx eax, bl
			mov ebx, save_mem
			mov [ebx].treap.chr, 0
			mov [ebx].treap.chr, eax
			pop eax
			pop ebx
			add esi , byte
		l5:
		add ebx , treap
	loop l2

   mov EDX,OFFSET fileCode
   call openInputFile
   mov fileHand, eax
   mov EDX, OFFSET code
   mov ECX, lengthof code
   call ReadFromFile
   mov codesz, eax
   mov edx, offset code

   mov eax, 0
   mov ebx, 0
   mov ecx, codesz
   mov edx, 0
   mov esi, offset arr

   forlop:
	mov eax, 0
    mov ebx, 0
    mov edx, 0
    mov esi, offset arr
	call traverse
	inc ecx
   loop forlop 

   mov edx, OFFSET fileIN
   call CreateOutputFile
   inc eax
   mov fileHAN, eax
   mov esi, OFFSET texture
   mov ecx, index_texture
   mov ebx, 0
   mov eax, 0
   final:
	   mov memo, ecx
	   mov eax, fileHAN
	   mov ebx, [esi]
	   mov strfinal, ebx
	   mov edx, offset strfinal
	   mov ecx, 1
	   call WriteToFile
	   add esi, 4
	   mov ecx, memo
   loop final
   ret
get_text endp

mult proc
mov ecx, 9
mov ebx, eax
lop_mult:

add eax, ebx

loop lop_mult
ret
mult endp

traverse proc
mov save_mem, esi
mov edx, [esi].treap.left
mov memo, edx
mov esi, offset arr
add esi, memo
mov edx, [esi].treap.val
mov esi, save_mem
cmp edx, 0
jnz not_leaf
mov ebx, index_texture
mov eax, [esi].treap.chr
mov [texture + ebx * 4], eax
inc index_texture
jmp base_case
not_leaf:
mov ebx, indexcode
movzx edx, [code + ebx]
inc indexcode
dec ecx
sub edx, '0'
cmp edx, 0
jnz notzero
mov eax, [esi].treap.left
mov memo, eax
mov esi, offset arr
add esi, memo
call traverse
sub esi, memo
jmp base_case
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
notzero:
mov eax, [esi].treap.right
mov memo, eax
mov esi, offset arr
add esi, memo
call traverse
sub esi, memo
base_case:
ret
traverse endp

getlv proc
mov eax, indx1
mov indx, eax
mov eax, 0
cmp eax, np
jnz plpl
mov eax, 0
mov ebx, [edx].lev.index1
cmp ebx, 0
jnz lplp1
inc lvl
lplp1:
mov [edx].lev.arr[ebx * 4], eax
inc [edx].lev.index1
mov eax, 0
mov ebx, [edx].lev.index1
mov [edx].lev.arr[ebx * 4], eax
inc [edx].lev.index1
jmp tala
plpl:
mov ecx, indx
lp1:
 mov eax, np
 cmp eax, parent_c[ecx * 4]
 jz hena
 dec indx
loop lp1
mov eax, np
cmp eax, parent_c[ecx * 4]
jnz poro
hena:
mov eax, 0
mov ebx, ind
mov arr_code[ebx * 4], eax
mov eax, pn
mov ebx, [edx].lev.index1
cmp ebx, 0
jnz lplp
inc lvl
lplp:
mov [edx].lev.arr[ebx * 4], eax
inc [edx].lev.index1
add edx, sizeof lev
mov ebx, indx
mov eax, child_c[ebx * 8]
mov np, eax
mov eax, child_n[ebx * 8]
mov pn, eax
push indx
inc ind
call getlv
dec ind
pop indx
mov eax, 1
mov ebx, ind
mov arr_code[ebx * 4], eax
mov ebx, indx
mov eax, child_c[ebx * 8 + 4]
mov np, eax
mov eax, child_n[ebx * 8 + 4]
mov pn, eax
push indx
inc ind
call getlv
dec ind
pop indx
sub edx, sizeof lev
jmp tala
poro:
mov ebx, [edx].lev.index1
cmp ebx, 0
jnz lplp2
inc lvl
lplp2:
mov eax, pn
mov [edx].lev.arr[ebx * 4], eax
inc [edx].lev.index1
mov ecx, np
mov [esi].codes.chr, ecx
mov ecx, 0
lpp:
mov eax, arr_code[ecx * 4]
mov ebx, [esi].codes.index2
mov [esi].codes.ot[ebx * 4], eax
inc [esi].codes.index2
inc ecx
cmp ecx, ind
jz m1
jmp lpp
m1:
inc n_ch
add esi, sizeof codes
mov eax, 0
mov np, eax
mov pn, eax
add edx, sizeof lev
call getlv
sub edx, sizeof lev
tala:
ret
getlv endp

tree proc
mov eax, 0
mov ecx, 0
mov ebx, 0
call Insertion
mov eax, 0
mov ecx, 0
mov ebx, 0
cmp num2, 1
jz hna
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx, external
mov parent_c[edx * 4], ecx
mov ebx, [fre]
add ebx, [fre + 4]
mov parent_n[edx * 4], ebx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx, [arr_str]
mov child_c[edx * 8], ecx
mov ebx, [fre]
mov child_n[edx * 8], ebx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ecx, [arr_str + 4]
mov child_c[edx * 8 + 4], ecx
mov ebx, [fre + 4]
mov child_n[edx * 8 + 4], ebx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov eax, [fre + 4]
add eax, [fre]
mov [fre], eax
mov ebx, 10000
mov [fre + 4], ebx
mov ebx, external
mov [arr_str], ebx
inc edx
inc indx
dec num2
inc external
call tree
hna:
ret
tree endp

Insertion Proc
mov ecx, 0
lp:
inc ecx
cmp ecx, num
jz th
mov var, ecx
  wl:
   mov eax, [fre + ecx * 4]
   mov ebx, ecx
   dec ebx
   cmp [fre + ebx * 4], eax
   jbe pos
   mov eax, [fre + ecx * 4]
   xchg eax, [fre + ebx * 4]
   mov [fre + ecx * 4], eax
   mov eax, 0
   mov eax, [arr_str + ecx * 4]
   xchg eax, [arr_str + ebx * 4]
   mov [arr_str + ecx * 4], eax
   dec ecx
   cmp ecx, 0
   jz pos
  jmp wl
  pos:
mov ecx, var
jmp lp
th:
ret
Insertion ENDP

vis proc
mov ecx, 0
   l3:
    mov eax, 0
    mov eax, [arr_str + ecx * 4]
    call writechar
	mov eax, 0
    mov al, ' '
    call writechar
    mov eax, [fre + ecx * 4]
    call writedec
	call crlf
	inc ecx
	cmp ecx, num2
	jz bo
   jmp l3
   bo:
   ret
vis endp

setter proc
mov edx, 0
mov esi, 0
mov esi, 0
mov ecx, 0
mov eax, 0
ret
setter endp

END MAIN