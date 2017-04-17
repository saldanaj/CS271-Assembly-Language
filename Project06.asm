TITLE Project6     (Project06.asm)

;=========================================================================================================================
; Author: Joaquin Saldana 
; CS271-400 / Project ID : Project06 (Option A)                Date: 12/03/16
; Description: As per the instructions provided on the PDF, this program gets 10 valid integers from the 
; user and stores the numeric values in an array.  Then the program displays the integers, their sum, and their average.  
;=========================================================================================================================

INCLUDE Irvine32.inc

;======================================
; MACROS: getString and displayString   
;======================================

;*********************************************************************************************
; Macro: stackFrame
; Description: simply repeats the code to push ebp onto the stack and assign ebp esp's current 
; value 
;*********************************************************************************************

stackFrame MACRO 

     push ebp 
     mov  ebp, esp 

ENDM

;*********************************************************************************************
; Macro: getString 
;
; Description: displays a prompt, then get's the user's keyboard input into a memory location
;*********************************************************************************************

getString MACRO	request, requestCount

	push	edx
	push	ecx
	push	eax
	push	ebx

	displayString OFFSET requestInt
	
     mov		edx, OFFSET request
	mov		ecx, SIZEOF request
	call	     ReadString
	mov		requestCount, 0
	mov		requestCount, eax	

	pop  ebx
	pop	eax
	pop  ecx
	pop	edx

ENDM

;**********************************************************************
; Macro: displayString 
; 
; Description: show the string stored in a specified memory location 
; Parameters (stringAddress): pass the address of the string  
;
; Registers used: EDX 
;**********************************************************************

displayString MACRO stringAddress 
     
     push edx 
     mov  edx, stringAddress
     call WriteString 
     ;call CrLf    
     pop edx 

ENDM

;====================
; CONSTANT VARIABLES 
;====================

MAXNUMBERS = 10
IntLoASCII = 48
IntHiASCII = 57

.data

;==========================================================================
; PROMPT MESSAGES ALREADY PREDEFINED FOR THE PROGRAM TO DISPLAY TO THE USER  
;==========================================================================

introduction1   BYTE     "Programming Assignment 6: Designing Low Level I/O Procedures",0 
introduction2   BYTE     "Written by: Joaquin Saldana", 0

introduction3   BYTE     "Please provide 10 unsigned decimal integers.",0
introduction4   BYTE     "Each number needs to be small enough to fit inside a 32 bit register.",0
introduction5   BYTE     "After you have finished inputting the raw numbers I will display a list of integers, their sum, and their average value.",0

requestInt     BYTE      "Please enter an unsigned number: ", 0 

incorrectInt1   BYTE      "ERROR: You did not enter an unsigned number or your number was too big.",0 
incorrectInt2   BYTE      "Please try again: ", 0 

displayInts    BYTE      "You entered the following numbers: ", 0

commaSeparater BYTE      ", ", 0

sumPrompt      BYTE      "The sum of these numbers is: ", 0 

averagePrompt  BYTE      "The average is: ", 0 

goodbyeMsg     BYTE      "Thank you for playing the game! PEACE OUT", 0 

;=============================
; DECLARED ARRAYS AND VARIABLES 
;=============================

numberArray         DWORD     MAXNUMBERS DUP(?)   ; ARRAY THAT HOLDS THE USER'S 10 DIGITS ENTERED 
strgIntEntered      BYTE      MAXNUMBERS DUP(?)   ; ARRAY TO HOLD THE THE NUMBER ENTERED BY THE USER AS A "STRING"/CHAR 

request		     DWORD  MAXNUMBERS DUP(0)
requestCount	     DWORD  ? 

number              DWORD     0
sumResult           DWORD     0 
averageResult       DWORD     0 

stringResult	     db 16 dup (0)

;==========================
; MAIN PROCEDURE
;==========================
	
.code

main PROC

; CALL THE INTRO PROCEDURE
; which introduces the program to the user and explains what it does 

call intro           

; CALL READ VAL PROCEDURE

push	OFFSET numberArray
push	OFFSET request
push	OFFSET requestCount
call	readVal

call	CrLf

push	OFFSET averagePrompt
push	OFFSET sumPrompt
push	OFFSET numberArray
call	findSumAverage

displayString OFFSET displayInts


call	CrLf

push	OFFSET stringResult 
push	OFFSET numberArray
call	writeVal

call	CrLf

; exit to operating system

displayString OFFSET goodbyeMsg
call CrLf 

	exit	             
      
main ENDP

;============================
; PROCEDURES
;============================


;=============================================================================
; Procedure: intro
;
; Description: introduces the program to the user and displays the purpose   
; of the program and what's required of the user for the program to 
; successfully execute. 
;
;=============================================================================== 

intro     PROC 
    
     displayString OFFSET introduction1
     call CrLf 
     displayString OFFSET introduction2
     call CrLf
     displayString OFFSET introduction3
     displayString OFFSET introduction4
     displayString OFFSET introduction5
     call CrLf

     ret

intro     ENDP 


;=============================================================================
; Procedure: readVal 
;
; Description: invokes the getString macro to get the user string of digits.  
; it then converts the digit string to numeric, while validating the user's 
; input  
;=============================================================================== 

readVal   PROC  

     stackFrame 

     mov	  ecx, 10				; set the loop counter to number of ints we need 
     mov	  edi, [ebp+16]		; edi has the @ of numberArray

userInput: 	
					
	getString request, requestCount    

	push	ecx
	mov		esi, [ebp+12]			
	mov		ecx, [ebp+8]			
	mov		ecx, [ecx]				
	cld								
	mov		eax, 0			
	mov		ebx, 0			
					
convert:
	lodsb					
     						
	cmp		eax, IntLoASCII			
	jb		invalidInput		
	cmp		eax, IntHiASCII			
	ja		invalidInput		
							
     sub		eax, IntLoASCII			
	push	eax
	mov		eax, ebx
	mov		ebx, MAXNUMBERS
	mul		ebx
	mov		ebx, eax
	pop		eax
	add		ebx, eax
	mov		eax, ebx
							
cont:
	mov		eax, 0
	loop	     convert

	mov		eax,ebx 
	stosd							
					
	add		esi, 4					
	pop		ecx						
	loop	     userInput
	jmp		readValEnd
		
invalidInput:
	pop		ecx
     displayString OFFSET incorrectInt1
     call CrLf 
	jmp		userInput

readValEnd:
	pop ebp			
	ret 12					

readVal   ENDP


;=============================================================================
; Procedure: findSumAverage 
;
; Description: the procedures finds the sum and average of the 10 numbers  
; in the numbersArray 
;=============================================================================== 

findSumAverage PROC 

     stackFrame 

	mov       esi, [ebp + 8]  ; @list
	mov	     eax, 10										; loop control 
	mov       edx, 0
	mov	     ebx, 0
	mov	     ecx, eax

averageLoop:
	mov		eax, [esi]
	add		ebx, eax
	add		esi, 4
	loop	     averageLoop
	
endAverageLoop:
	
	mov		edx, 0
	mov		eax, ebx
	mov		edx, [ebp+12]
	call	WriteString
	call	WriteDec
	call	CrLf
	mov		edx, 0
	mov		ebx, 10
	div		ebx
	mov		edx, [ebp+16]
	call	WriteString
	call	WriteDec
	call	CrLf

endDisplayAverage:

	pop		ebp
     ret  12

findSumAverage ENDP 


;=============================================================================
; Procedure: writeVal  
;
; Description: converts a numeric value to a string of digits, and invokes the   
; displayString MACRO to produce the output 
;=============================================================================== 

writeVal  PROC 

     stackFrame 

     mov		edi, [ebp + 8]				; move address of numberArray to EDI register 
	mov		ecx, 10
L1:	
	push	ecx
	mov		eax, [edi]
     mov		ecx, 10                       ; ECX will contain the divisor, our loop terminator will be if we have 0 (zero) in EDX 
     xor		bx, bx                        ; trying to find out how many digits the value has 

divide:
     xor		edx, edx				  
     div		ecx					     ; EDX will have the remainder 
	push	dx						 
	inc		bx						  
	test	eax, eax				          ; check if EAX zero.
     jnz		divide					; if not zero, then loop back 

												
	mov		cx, bx					  
	lea		esi, stringResult		  

nextDigit:
	pop		ax
	add		ax, '0'					  ; convert each number to ASCII value/char
	mov		[esi], ax				  
	displayString OFFSET stringResult
	loop	nextDigit
			
     pop		ecx 
     displayString OFFSET commaSeparater
	mov		edx, 0
	mov		ebx, 0
	add		edi, 4
	loop L1


     pop ebp
     ret 8

writeVal  ENDP 



END main