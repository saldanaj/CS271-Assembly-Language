TITLE Program Template     (Project5.asm)

; Author: Joaquin Saldana 
; CS271-400 Sec / Project 05              Date: 11/21/2016
; Description: this is a program that requests the user enter a number from a range.  Based on the number entered is how many random integers 
; are created and placed in an array.  The numbers will be unsorted at first, which is displayed, then the numbers are sorted and displayed again
; afterwards the median value of the ints in the array is displayed and the sorted list is printed.  

INCLUDE Irvine32.inc

LOWNUMBER = 10
HIGHNUMBER = 200

.data

; strings to be displayed in the program 

intro1 			     BYTE   "Sorting Random Integers                      Programmed by Joaquin Saldana", 0
intro2 			     BYTE   "This program generates random numbers in the range [100 .. 999], ", 0
intro3 			     BYTE   "displays the original list, sorts the list, and calculates the ", 0
intro4 			     BYTE   "median value.  Finally, it displays the list sorted in descending order. ", 0
inputPrompt 		     BYTE   "How many numbers should we generate? [10 .. 200]: ", 0
invalidInputPrompt 	     BYTE   "Invalid Input", 0 
displayUnsortedPrompt 	BYTE   "The unsorted random numbers: ", 0 
medianPrompt 		     BYTE   "The median is: ", 0 
displaySortedPrompt 	BYTE   "The sorted list: ", 0 
padding                  BYTE   "   ", 0

; variables 

randomNumberArray   DWORD     HIGHNUMBER DUP(?)          ; initiating the arrary to the max size of 200 
numOfInts           DWORD     ?                          ; variable that will hold the number of ints in the array up to 200 
median              DWORD     ?


.code
main PROC

; calling the introduction procedure  
push OFFSET intro1
push OFFSET intro2
push OFFSET intro3
push OFFSET intro4
call intro          		

; calling the get data procedure 
push OFFSET inputPrompt 
push OFFSET invalidInputPrompt
push OFFSET numOfInts 
call getData       		

; calling the procedure to fill the array with random integers
push OFFSET displayUnsortedPrompt
push OFFSET randomNumberArray
push numOfInts
call fillArrayRandom
 
; calling the procedure to display the array
push OFFSET displayUnsortedPrompt
push OFFSET randomNumberArray
push numOfInts
call displayArray

call Crlf

; sort the array of random integers by using the bubble sort algorithm 
push OFFSET randomNumberArray 
push numOfInts
call sortBubble 

; find the median of the array and display it 
push    OFFSET  randomNumberArray
push    numOfInts
push    OFFSET  medianPrompt 
call    findMedian

call Crlf

; calling the procedure to display the array BUT NOW THE ARRAY IS SORTED 
push OFFSET displaySortedPrompt
push OFFSET randomNumberArray
push numOfInts
call displayArray

call Crlf

	exit	          ; exit to operating system

main ENDP


;**************************************************************
;INTRODUCTION PROCEDURE 
;
; in this procedure we introduce the program to the user 
; it's going to display with the labels "intro" 
;**************************************************************


intro PROC

	push 	ebp 
	mov 	ebp, esp 

	mov 	edx,[ebp+20]	; moved into EBP the address of intro1 
     call WriteString 
     call Crlf
     	
	mov 	edx, [ebp+16]	; moved into EBP the address of intro2
     call    WriteString 
     call    Crlf
     	
	mov 	edx, [ebp+12]	; moved into EBP the address of intro3
     call    WriteString 
     call    Crlf
     	
	mov 	edx, [ebp+8]	; moved into EBP the address of intro4
     call    WriteString 
     call    Crlf
     call    Crlf

	pop 	ebp 

	ret 	16		; remove the remaining elements from the stack 

intro ENDP 


;**************************************************************
;GETDATA PROCEDURE 
; 
;in this procedure we request the user enter a value between 
;10 and 200.  If the user enters a number below are above the max 
;number it will ask that they re-enter the number.  
;***************************************************************

getData PROC 

     	push 	ebp       
     	mov  	ebp, esp 
L1:
     	mov  	edx, [ebp+16]		; prompt the user to enter a number between 10 and 200  
     	call 	WriteString
     	call 	ReadInt

     	mov   	ebx, [ebp+8]		; store the value in the address of the variable numOfInts 
     	mov  	[ebx], eax 

	     cmp 	eax, LOWNUMBER	; validating if the number is less than 10
	     jb 	L2
	     cmp	eax, HIGHNUMBER	; validating if the number is greater than 200 
	     ja 	L2
	     jmp	L3

L2:
     	mov 	     edx, [ebp+12]
     	call 	WriteString 
     	call 	Crlf
     	jmp   	L1

L3: 
     	pop 	ebp

     	ret	12 

getData ENDP


;**************************************************************
;FILLARRAYRANDOM  PROCEDURE 
; 
; fills an array with random integers  
; i'd like to credit the code to the lectures slide for random
; arrays and demo5.asm 
;***************************************************************

fillArrayRandom PROC 

     push ebp 
     mov  ebp, esp 

     mov  ebx, [ebp+12]  ; offset of array 
     mov  ecx, [ebp+8]   ; loop counter 

fill: 

     mov  eax, HIGHNUMBER
     sub  eax, LOWNUMBER
     inc  eax
     call RandomRange 
     add  eax, LOWNUMBER
     mov  [ebx], eax 
     add  ebx, 4 
     loop fill 

     pop  ebp 

     ret  12 

fillArrayRandom ENDP 

;**************************************************************
;DISPLAYARRAY  PROCEDURE 
; 
;this procedure displays the array onto console
;***************************************************************

displayArray   PROC

     push ebp 
     mov  ebp, esp 
     
     mov  ebx, [ebp+12]       ; edx has the address of the randomArray
     mov  ecx, [ebp+8]        ; ecx will be the loop counter and holds the copy of the value numOfInts

     mov edx, [ebp+16]        ; will display the prompt 
     call WriteString 
     call Crlf

     ;mov edx, 10

show: 
     mov  eax, [ebx]
     call WriteDec
     call Crlf

     add  ebx, 4
     ;dec  edx 

     loop show

adjustLineCounter: 

     ;mov edx, 10
     ;call Crlf

finish: 

     pop ebp
     ret  12
     
displayArray ENDP 


;**************************************************************
;BUBBLESORT  PROCEDURE 
; 
; this procedure will sort the array of random integers using the 
; bubble sort algorithm.  
; citing the Bsort.asm example from the Kip Text Book example
; of asm's avaialble.  My algorithm is very similar to the 
; one of Mr. Ivrine
;***************************************************************

sortBubble PROC 
     
     push ebp 
     mov ebp, esp 

     mov ecx, [ebp+8]   ; loop counter using count variable  
     dec ecx 

L1: 
     push ecx 
     mov edx, [ebp+12]  ; offset of array
          
L2: 
     mov eax, [edx]
     cmp [edx+4], eax 
     jb   L3
     xchg eax, [edx+4] 
     mov  [edx], eax  
     
L3: 
     add edx, 4   
     loop L2
        
     pop ecx 
     loop L1

L4: 
     pop ebp 
     ret 8
     
sortBubble ENDP 

;-------------------------------------------------------
; FINDMEDIAN PROCEDURE 
;
; Displays the median of an integer array
;-------------------------------------------------------

findMedian PROC

	push ebp
	mov  ebp, esp

	mov   esi, [ebp + 16]   ; esi holds the address of the first element in the now sorted array
	mov	 eax, [ebp + 12]   ; loop control based on request
	mov   edx, 0
	mov	 ebx, 2
	div	 ebx
	mov	 ecx, eax


medianLoop:
	add		esi, 4
	loop	     medianLoop

	cmp		edx, 0    	; check for zero
	jnz       itsOdd
	
	mov		eax, [esi-4]   ; its even
	add		eax, [esi]
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	mov		edx, [ebp+8]
	call	WriteString
	call	WriteDec
	call	CrLf
	jmp		endDisplayMedian

itsOdd:
	mov		eax, [esi]
	mov		edx, [ebp+8]
	call	WriteString
	call	WriteDec
	call	CrLf

endDisplayMedian:

	pop  ebp
	ret  12

findMedian ENDP



END main
