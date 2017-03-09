;Real Embedded System ,Designed by Farnborough HE Student
;Bernard Chisumo
;Digital Counter Timer  (02:00-00:00)
 
ORG 0;Start at origin
;Pattern Allocation to the register
MOV 1BH, #0;Clear Memory Location
MOV 1AH, #0C0H ;Move pattern #0C0H->0 to register 1AH
MOV 19H, #0F9H ;Move pattern #0F9H->1 to register 19H
MOV 18H, #0A4H ;Move pattern #0A4H->2 to register 18H
MOV 17H, #0B0H ;Move pattern #0B0H->3 to register 17H
MOV 16H, #099H ;Move pattern #099H->4 to register 16H
MOV 15H, #092H ;Move pattern #092H->5 to register 15H
MOV 14H, #082H ;Move pattern #082H->6 to register 14H
MOV 13H, #0F8H ;Move pattern #0F8H->7 to register 13H
MOV 12H, #080H ;Move pattern #080H->8 to register 12H
MOV 11H, #090H ;Move pattern #090H->9 to register 11H
MOV 10H, #0C0H ;Move pattern #0C0H->0 to register 10H


;Timer Delay (Minutes)
MOV 2AH, #0;Move the value 0 to register 2AH
MOV 29H, #40H ;Move the hex value #40H to register 29H
MOV 28H, #079H ;load the hex value 0F9H to register 28H
MOV 27H, #24H ;Move the hex value 24H to register 27H

MOV R2, #27H  ;Move the content of register 27H to register R2

;Beginning the display routines 
BEGIN:
ACALL screenFour ; calling third display
;MOV P1, #11000000b
MOV P1, #0C0H;Move pattern #0C0H->0 on Pin ->P1
ACALL DELAY  ; Calling the delay routine

ACALL  screenThird ;Calling third display
MOV P1, #024H ;Move pattern #024H on P1
ACALL DELAY ;Calling the delay routine

ACALL screenSecond ;calling second display
MOV P1, #0C0H ;Move pattern #0C0H on Pin ->P1
ACALL DELAY ; Calling the delay routine

ACALL screenOne ;Calling 1st Display - Absolute call
MOV P1, #0C0H ;Moving Data  #0C0H to Pin P1
ACALL DELAY ;Calling the delay routine

;looping between registers and swapping contents
loopOne:
ACALL SecondLoading   ;calling the SecondLoading  routine
MOV 5, 0   ;save entry in register 0 to register 5
MOV 0, 2   ;save entry in register 2 to register 0
INC R0		;increment pointer R0
MOV A, @R0  ;Move the content R0 points to into the accumulator
JZ OFF		 ;jump to  OFF if the Accumulator is zero
MOV 2, 0   ;save entry in register 0 to register 0
MOV 0, 5   ;save entry in register 5 to register 0
JMP loopTwo

;Incrementing pointer R1
loopTwo: 
ACALL FirstMoving   ;calling the FirstMoving  routine
INC R1    ;increment pointer R1
MOV A, @R1 ;load the content R1 is pointing to into the accumulator
JZ loopOne ;jump to label loopOne if the accumulator is zero
JMP loopThree ;jump to  loopThree

loopThree:
MOV A, @R0 ;Move the content R0 is pointing to into the accumulator
JZ loopTwo ;Jump to loopTwo if the accumulator is zero
ACALL Display ;Calling the Display routine
INC R0 ;Increment pointer R0
JMP loopThree;Jump to label loopThree

;Displaying the patterns on the the display
Display:
ACALL screenFour;Calling fourth display
MOV P1, #0C0H ; Move pattern #0C0H->0 on P1
ACALL DELAY ; Calling the delay routine

ACALL  screenThird ; Calling third display
MOV 5, 0  ;Save Entry in Register 0 to register 5
MOV 0, 2  ;Save Entry in Register 2 to register 0
MOV A, @R0 ;Move the content  Register->R0 is pointing to into the accumulator
MOV P1, A  ; Save A in P1
ACALL DELAY   ; Calling the delay routine
MOV 2, 0  ;Save Entry in Register 0 to Register 2
MOV 0, 5 ;Save Entry in register 0 to Register 0

ACALL screenSecond; Calling ScreenSecond
MOV A, @R1;Move the content R1 is pointing to into the accumulator
MOV P1, A ; Save A in P1
ACALL DELAY

ACALL screenOne;Calling the first display
MOV A, @R0;Move the content R0 is pointing to into the accumulator
MOV P1, A ;Save Accumulator->A in Pin P1
ACALL DELAY	 ; calling the delay routine
RET	;Return to the caller

;Initialise Pointer R1
SecondLoading:
MOV R1, #14H
RET

;Change the register R0 points to
FirstMoving :
MOV R0, #11H
RET

;Enable fourth display 
screenFour:
SETB p3.3
SETB p3.4
RET

;Enable third display 
screenThird:
CLR p3.3
SETB p3.4
RET

;Enable second display 
screenSecond:
SETB p3.3
CLR p3.4
RET

;Enable first display
screenOne:
CLR p3.3
CLR p3.4
RET

;Delay routine
DELAY:	
MOV R4, #0C8H
;MOV R4, #05H
DJNZ R4, $
MOV P1, #0FFH
RET

;the final display 
OFF: ;Turning off the display OFF
ACALL  screenThird
MOV P1, #0C0H ; Clears patterns on port 1
ACALL DELAY
       
ACALL screenSecond
MOV P1, #08EH ; Display pattern F on port 1
ACALL DELAY
       
ACALL screenOne
MOV P1,#08EH  ; Display pattern F on port 1
ACALL DELAY
ACALL Infinite ;Call infinte loop


;infinte loop function 
Infinite:
MOV R4, #0FFH
;MOV R4, #05H
DJNZ R4, $
MOV R4, #0FFH
ACALL Infinite ;call infinte loop
RET

end ;END of program
