; Please note I would like to invoke 1 grace day.  Thank you.  

TITLE Assignment # 3      (Joaquin Saldana_Project3.asm)

; Author: Joaquin Saldana
; CS271-400 / Assignment # 3              Date: 10/31/16
; Description: this is an assignment involving integer arithmetic and data validation 

INCLUDE Irvine32.inc

; constant variables 
LOWEST = -100
HIGHEST = -1 

.data

progTitle      BYTE      "Welcome to the Integer Accumulator by Joaquin Saldana", 0
requestName    BYTE      "What's your name? ",0
greetingMsg    BYTE      "Hello, ",0
userName       BYTE      30 DUP(0)

prompt1        BYTE      "Please enter number in the following range [-100, -1].",0
prompt2        BYTE      "Enter a non-negative number when you are finished to see results.", 0
prompt3        BYTE      "Enter number: ", 0 
prompt4        BYTE      "You entered ",0
prompt5        BYTE      " valid numbers", 0
prompt6        BYTE      "The sum of your valid number is: ", 0
prompt7        BYTE      "The rounded average is: ",0
prompt8        BYTE      "Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0

numberEntered  DWORD     ? 
sumValue       DWORD     ? 
counter        DWORD     0 




.code
main PROC

; displaying the program name and it's author 
mov edx, OFFSET progTitle 
call WriteString 
call CrLf

; interaction with the user 
; requesting they enter their name and we display it 
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

; displaying to the user what numbers to enter 
; and how to terminate the loop 
mov edx, OFFSET prompt1
call WriteString
call CrLf
mov edx, OFFSET prompt2
call WriteString
call CrLf

; start reading the input 
; and beginning of the loop

mov ecx, 0 
mov eax, 0
mov ebx, 0
 
IntInput: 
     mov  edx, OFFSET prompt3
     call WriteString
     call ReadInt 
     mov  numberEntered, eax 
     cmp  numberEntered, LOWEST
     jb   Looptermination 
     cmp  numberEntered, HIGHEST
     ja   Looptermination
     mov  eax, sumValue 
     add  eax, numberEntered 
     mov  sumValue, eax 
     inc  ebx
     mov  counter, ebx 
 
     loop IntInput       ; it loops back to the top of the loop 

; after the loop terminates 
Looptermination: 
     
     ; this piece of code shows the user how many integers he entered 
     ; by accessing the accumulator 

     mov  edx, OFFSET prompt4
     call WriteString
     mov  eax, counter 
     call WriteInt
     mov  edx, OFFSET prompt5
     call WriteString 
     call CrLf

     ; this piece of code shows the user the sum value of the integers 
     ; they entered 

     mov  edx, OFFSET prompt6
     call WriteString
     mov  eax, sumValue
     call WriteInt
     call CrLf

     ; this piece of code shows the user the average 
     ; of the number he entered 
     mov  edx, OFFSET prompt7
     call WriteString

     ; division code 
     mov eax, 0
     mov ebx, 0
     mov eax, sumValue
     cwd
     mov ebx, counter
     idiv bx
     call WriteInt
     call CrLf

; goodbye message 

mov  edx, OFFSET prompt8
call WriteString
mov edx, OFFSET userName 
call WriteString 
call CrLf

; exit to operating system
	exit	
main ENDP



END main
