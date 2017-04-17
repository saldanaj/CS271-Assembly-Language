TITLE Joaquin_SaldanaProject04    (Joaquin_SaldanaProject04.asm)

; Author: Joaquin Saldana 
; CS271-400 / Project 04                 Date: 11/05/2016
; Description: this program will ask the user to enter the number of composite numbers they wish to 
; to be displayed.  The range of numbers must be from 1 to 400.  The program calculates and displays
; all of the composites up to and including the nth composite number.  

INCLUDE Irvine32.inc

LOWEST = 1
HIGHEST = 400

.data

; variables 

compositeNumber     DWORD ? 
increasingNum       DWORD 0
loopCounterHold     DWORD ? 
divisibleNumber     DWORD 2 
endLineCounter      DWORD 0

; string messages 

prompt1   BYTE      "Composite Numbers     Programmed by Joaquin Saldana",0
prompt2   BYTE      "Enter the number of composite numbers you would like to see.",0
prompt3   BYTE      "I'll accept orders from up to 400 composites.",0 
prompt4   BYTE      "Enter the number of composites to display (Number must be 1 to 400): ",0
prompt5   BYTE      "Out of range.  Try again.", 0 
byeMsg    BYTE      "Programmer Joaquin Saldana says GOODBYTE", 0
empPad    BYTE      "    ", 0 

.code
main PROC

call intro 
call userInput
call compositeNum
call endMsg



	exit	; exit to operating system


main ENDP


; PROCEDURES 
;***********************************

;intro Procedure
;introduces the program to the user 
;with instructions to enter a number between 1 to 400 

intro	PROC
     mov       edx,OFFSET prompt1
	call	     WriteString
	call	     Crlf
     mov       edx,OFFSET prompt2
	call	     WriteString
	call	     Crlf
     mov       edx,OFFSET prompt3
	call	     WriteString
	call	     Crlf

	ret
intro	ENDP

;*******************************************

;userInput Procedure 
;after requesting the user to enter a number 
; between 1 and 400 the procedures reads the 
; integer entered and validatse the input.  
; if user did not enter a valid number, then it 
; loops until they do.  

userInput	PROC

L1: 
	mov		edx,OFFSET prompt4
	call	     WriteString
	call	     ReadInt
	mov		compositeNumber,eax
     cmp       compositeNumber, LOWEST
     jb        L2
     cmp       compositeNumber, HIGHEST
     ja        L2
     jmp       L3

L2: 
     mov		edx,OFFSET prompt5
     call	     WriteString 
     call	     Crlf
     loop      L1
     
L3: 
	ret

userInput	ENDP

;****************************************


;compositeNum PROCEDURE
;This procedure returns the number of composite 
;numbers the user wishes to see.  
; variables used are: 
; compositeNumber ,  increasingNum , loopCounterHold , divisibleNumber
; equivalent to the following high level logic: 
; 
;
; while (i  < numberOfCompositesRequested)
; {
;      for(divisibleNumber = 2; divisibleNumber  < increasingNum; divisibleNumber++)
;         {
;              if(increasingNum % divisibleNumber == 0)
;               {    
;                    std::cout << increasingNum ; 
;                   i++;
;               }
;          }
;         increasingNum++; 
; }


compositeNum	PROC
     
     mov  ecx, compositeNumber

     L1: 

          mov loopCounterHold, ecx 
          mov ecx, 0

     L2: 
          mov edx, 0
          mov  eax, increasingNum
          mov  ebx, divisibleNumber
          cmp  eax, ebx
          jb   IncrementIncreasingNum 
          cmp  eax, ebx                 
          je   IncrementIncreasingNum   
          div  ebx
          cmp  edx, 0
          je   PrintNumber
          inc  divisibleNumber 
          loop L2

     IncrementIncreasingNum: 

          inc  increasingNum
          mov  divisibleNumber, 2 
          loop L2


     PrintNumber: 

          mov  eax, increasingNum
          call WriteInt 
          call Crlf                         ;code disabled 
          mov  edx, OFFSET empPad            ;new code 
          inc  endLineCounter                ; new code 
          mov  eax, endLineCounter           ;
          
          mov  ebx, 10                       ;    
          
          ;div  ebx                           ;         
          ;cmp  edx, 0                        ;    
          ;je   endLine                       ;
          mov  divisibleNumber, 2
          mov  ecx, loopCounterHold 
          inc  increasingNum
          loop L1


     ;endLine:                                     ; new jump
          
          ;call Crlf
          ;mov  endLineCounter, 0
          ;mov  divisibleNumber, 2
          ;mov  ecx, loopCounterHold 
          ;inc  increasingNum
          ;loop L1



	ret

compositeNum	ENDP

;*****************************************

;exitGreeting Procedure
;departure message to the user stating the program has finished 

endMsg	PROC
    
    mov		edx,OFFSET byeMsg
    call	     WriteString
    call       Crlf 

	ret
endMsg	ENDP

;*******************************************


END main