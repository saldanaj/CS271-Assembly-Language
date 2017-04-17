; I would like to invoke 1 grace day please. Thank you.  

TITLE Fibonacci Arithmetic    (Project2.asm)

; Author: Joaquin Saldana
; CS271-400 / Project #2                Date: 10/17/2016
; Description: This is program which informs the user it will calculate and display a nth number of Fibonacci terms chosen by the user 
;              between 1 to 46 numbers 

INCLUDE Irvine32.inc

;constant variables 
INTLIMIT = 46 
FORMATTING =  5

.data

progTitle       BYTE "Fibonacci Arithmetic",0 
progAuthor      BYTE "Programmed by Joaquin Saldana",0
greetingMsg     BYTE "Hello, ",0
requestName     BYTE "What's your name? ",0
prompt1         BYTE "Enter the number of Fibonacci terms to be displayed.  Give the number as an integer in the range [1 .. 46]",0 
prompt2         BYTE "How many Fibonacci terms do you want? ",0 
invalidInput    BYTE "Out of range.  Enter a number in [1 .. 46]",0
goodbyeMsg      BYTE "Results certified by Joaquin Saldana",0
goodbyeMsg2     BYTE "Goodbye, ",0
numSpacing      BYTE "     ",0
numberEntered    DWORD     ? 
userName         BYTE      30 DUP(0)
countHolder      DWORD     ? 
sumValue         DWORD     ? 


.code
main PROC

; display program title and author 
mov edx, OFFSET progTitle 
call WriteString 
call CrLf
mov edx, OFFSET progAuthor
call WriteString 
call CrLf
call CrLf

; program request user input and displays greeting 
mov edx, OFFSET requestName
call WriteString 
mov edx, OFFSET userName
mov ecx, 29 
call ReadString 
call CrLf
mov edx, OFFSET greetingMsg 
call WriteString 
mov edx, OFFSET userName 
call WriteString 
call CrLf
mov edx, OFFSET prompt1
call WriteString
call CrLf
call CrLf

; read their input 
UserInput:
     mov edx, OFFSET prompt2 
     call WriteString 
     call ReadInt 
     mov  ecx, INTLIMIT
     cmp  eax, ecx
     jg   InvalidNum
     cmp  eax, 1
     jl   InvalidNum
     mov numberEntered, eax 
     jmp FibonacciLoop

; section of code that informs the user the integer entered is less 
; than 1 or greater than 46
InvalidNum: 
     mov edx, OFFSET invalidInput 
     call WriteString 
     call CrLf
     jmp UserInput


; beginning of the loop 
FibonacciLoop: 

     mov ecx, numberEntered 
     mov eax, 0
     mov ebx, 1

     L1:
     mov countHolder, ecx 
     mov ecx, FORMATTING

          L2:
          mov  edx, eax 
          add  edx, ebx
          mov  eax, ebx   
          mov  ebx, edx   
          call WriteDec 
          mov edx, OFFSET numSpacing
          call WriteString 
          loop L2
     
     call CrLf
     mov ecx, countHolder 
     ;mov sumValue, eax 
     ;mov eax, ecx 
     ;add eax, -5 
     ;mov ecx, eax 
     ;mov eax, sumValue
     loop L1

;program conclusion and end statement 
call CrLf
mov edx, OFFSET goodbyeMsg 
call WriteString 
call CrLf
mov edx, OFFSET goodbyeMsg2
call WriteString 
mov edx, OFFSET userName 
call WriteString
call CrLf
call CrLf

	exit	; exit to operating system
main ENDP

END main
