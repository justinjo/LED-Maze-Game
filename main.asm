;------------------------------------------
; Register and Function Declarations
;------------------------------------------

PORTA		equ	$0000		;port a
DDRA		equ	$0002		;port a direction
PORTB		equ	$0001		;port b
DDRB		equ	$0003		;port b direction
PORTE		equ $0008		;Port E Data Register
DDRE		equ $0009		;Data Direction Register E
PEAR		equ $000A		;Port E Assignment Register
PUCR		equ	$000C		;internal pullup control register

TCNT    equ $0044   ;Timer Count Register
TSCR		equ	$0046		;Timer System Control
TIE 		equ	$004c		;Timer Interrupt Mask  1
TSCR2		equ	$004d		;Timer Interrupt Mask  2
TFLG1		equ	$004e		;Timer Interrupt Flag  1
TC7			equ	$005e		;TIC/TOC compare value 7
TIOS		equ	$0040		;Timer Input Capture/Output Compare Select

INTCR   equ $001e
IRQE    equ %10000000
IRQEN   equ %01000000

timeover equ	$AC56		;define time that game lasts

;------------------------------------------
; Begin Program
;------------------------------------------
  XDEF  Entry, main
  XDEF  maze, lose, win
  XDEF  PORTA, PORTB, PORTE
  XREF  __SEG_END_SSTACK, board
MainCode: SECTION
Entry:
main:
    lds   #__SEG_END_SSTACK
; Initialize all variables
		movb	#%11001100, maze 	;row 1
		movb	#%00010000, maze+1 	;row 2
		movb	#%01000101, maze+2	;row 3
		movb	#%00110100, maze+3 	;row 4
		movb	#%00100010, maze+4 	;row 5
		movb	#%10011000, maze+5 	;row 6
		movb	#%00100101, maze+6 	;row 7
		movb	#%00110001, maze+7 	;row 8

		movb	#%00000000, lose
		movb	#%01100110, lose+1
		movb	#%01100110, lose+2
		movb	#%00000000, lose+3
		movb	#%00111100, lose+4
		movb	#%01100110, lose+5
		movb	#%01000010, lose+6
		movb	#%00000000, lose+7

		movb	#%00000000, win
		movb	#%01100110, win+1
		movb	#%01100110, win+2
		movb	#%00000000, win+3
		movb	#%01000010, win+4
		movb	#%01100110, win+5
		movb	#%00111100, win+6
		movb	#%00000000, win+7	
; Variable initilization ends
		movb	#$ff,DDRA 	;set port A as outputs
		movb	#$ff,DDRB	;set port B as outputs
		movb	#$00,DDRE	;all pins are input
		movb	#%00010000,PEAR	;set up port e as input
		movb	#%00010000,PUCR	;setup pins to have internal pullups

		bclr  INTCR,IRQE
		bclr  INTCR,IRQEN
		
		movb	#%10000000,TIOS  ;configure  timer 7
		movb	#%10000000,TIE   ;enable interrupts from timer  7 overflow
		movb	#%00001101,TSCR2 ;config to reset timer when TC7 is reached
					 ;& set prescaler for 32
		
		movw	#$ff,TC7	 ;set timer7 compare register
		movb	#$e0,TSCR        ;enable and configure timer
		
		movw  #0,count
		           
 		cli			 ;enable interrupts

		call board

    ; IOS7 is output, rest are input
    ; bit7 enables hardware interrupt for TFLG1 bit 7
    ; Timer Counter Reset Enable, allows timer to count up
    ; 750 kHz
    ; interrupt frequency - (24 MHz / 32 / 255) = 2.941 kHz
    ; interrupt frequency * desired seconds = counter max value
    ; ex 2.941 kHz * 15 sec = 44,118 times = $AC56

;------------------------------------------
; Interrupt Service Routine
;------------------------------------------

  XREF checkPlayer,won,gameWon,gameLost
  
interruptfunc:	
    bset	TFLG1, #$80	;clear int flag
    pshd
    ; check player position
      ; position at end = happy face
    call checkPlayer
    tst won
    beq incTimer
    call gameWon                                     
    
incTimer:  
    ; increment interrupt call counter
    ldd count
    addd #1
    std count
    cpd #timeover
    blo endInterrupt
    call gameLost   
      ; timer >= timeover = frown face
      ; timer <  timeover = carry on w/ program
    
endInterrupt:
    puld
  	rti
  	
;------------------------------------------
; Variables and image data
;------------------------------------------
MainData: SECTION

; define your variables here
maze:   ds.b 8
lose:   ds.b 8
win:    ds.b 8
count:  ds.w 1



MainConstants: SECTION

T7C_FLAG: dc.b $80
	
;------------------------------------------
; Interrupt vectors
;------------------------------------------

		org $ffe0
		dc.w interruptfunc




