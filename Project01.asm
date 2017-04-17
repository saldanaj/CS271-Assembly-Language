TITLE Elementary Arithmetic     (Project01.asm)

; Author: Joaquin Saldana 
; CS271-400 / Project 01               Date: 10/05/2016
; Description: This program will request the user enter two numbers and will provide the user with the products of several 
; simple mathematical arithmetics (addition, subtraction, multiplication, and division with remainder)

INCLUDE Irvine32.inc

.data
firstNumber    DWORD  ?             ; first integer to be entered by the user 
secondNumber   DWORD  ?             ; second integer to be entered by the user 
addResult      DWORD  ?             ; addition result variable 
subResult      DWORD  ?             ; subtraction result variable 
mulResult      DWORD  ?             ; multiplication result variable 
divResult      DWORD  ?             ; division result variable 
remainder      DWORD  ?             ; remainder result variable 
introPrompt    BYTE "Elementary Arithmetic, by Joaquin Saldana", 0    ; prompt that discloses author and program title 
firstStatement BYTE "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0 
firstPrompt    BYTE "First Number: ", 0             ; prompt for the first number 
secondPrompt   BYTE "Second Number: ", 0            ; prompt for the second number 
equalSign      BYTE " = ", 0                        ; string equal sign 
addSign        BYTE " + ", 0                        ; addition sign 
subSign        BYTE " - ", 0                        ; subtraction sign 
mulSign        BYTE " x ", 0                        ; multiplication sign
divSign        BYTE " / ", 0                        ; division sign 
remainSign     BYTE " remainder ", 0                ; remainder string 
endingStmt     BYTE "Impressed? Bye!", 0            ; conclusion statement             

.code
main PROC

; opening statement 

mov       edx, OFFSET introPrompt 
call      WriteString 
call      CrLf 
call      CrLf
mov       edx, OFFSET firstStatement 
call      WriteString
call      CrLf
call      CrLf

; get user input of the two numbers to perform the calculations 
mov       edx, OFFSET firstPrompt 
call      WriteString 
call      ReadInt
mov       firstNumber, eax 
mov       edx, OFFSET secondPrompt 
call      WriteString 
call      ReadInt
mov       secondNumber, eax 
call      CrLf

; addition code 
mov  eax, firstNumber 
add  eax, secondNumber 
mov  addResult, eax 
mov  eax, firstNumber 
call WriteDec
mov  edx, OFFSET addSign 
call WriteString
mov  eax, secondNumber 
call WriteDec 
mov  edx, OFFSET equalSign 
call WriteString 
mov  eax, addResult 
call WriteDec
call CrLf

; subtraction code 
mov  eax, firstNumber 
sub  eax, secondNumber 
mov  subResult, eax 
mov  eax, firstNumber 
call WriteDec
mov  edx, OFFSET subSign 
call WriteString
mov  eax, secondNumber 
call WriteDec 
mov  edx, OFFSET equalSign 
call WriteString 
mov  eax, subResult 
call WriteDec
call CrLf

; multiplication code 
mov  eax, firstNumber 
mov  ebx, secondNumber
mul  ebx
mov  mulResult, eax
mov  eax, firstNumber 
call WriteDec
mov  edx, OFFSET mulSign 
call WriteString
mov  eax, secondNumber 
call WriteDec 
mov  edx, OFFSET equalSign 
call WriteString 
mov  eax, mulResult 
call WriteDec
call CrLf

; division code 
mov edx, 0
mov eax, firstNumber 
mov ebx, secondNumber
div ebx
mov divResult, eax 
mov remainder, edx  
mov  eax, firstNumber 
call WriteDec
mov  edx, OFFSET divSign 
call WriteString
mov  eax, secondNumber 
call WriteDec 
mov  edx, OFFSET equalSign 
call WriteString 
mov  eax, divResult 
call WriteDec
mov  edx, OFFSET remainSign
call WriteString
mov  eax, remainder
call WriteDec
call CrLf

; exit statement to the user 
call CrLf
mov edx, OFFSET endingStmt
call WriteString 
call CrLF

	exit	; exit to operating system
main ENDP

END main
