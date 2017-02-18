; buttons.asm

;------------------------------------------
; Button Moves
;------------------------------------------
XREF PORTE
XDEF readButton, press

ButtonCode: SECTION

readButton:
    pshb
    ; branching statements
    ldab PORTE
    cmpb NOPRESS
    beq  noPress
    cmpb UP
    beq  up
    cmpb RIGHT
    beq  right
    cmpb LEFT
    beq  left
    cmpb DOWN
    beq  down
    ; catch edge case
    bra  endRead
up:
    movb #1, press
    bra  endRead   
right:
    movb #2 ,press
    bra  endRead   
left: 
    movb #3, press
    bra  endRead   
down:
    movb #4, press
    bra  endRead
noPress:
    movb #5, press 
endRead:
    pulb
    rtc

;------------------------------------------
; Variable data
;------------------------------------------
ButtonData: SECTION

press: ds.b 1 ; 1 for up
              ; 2 for right
              ; 3 for left
              ; 4 for down 
              ; 5 for no press

;------------------------------------------
; Constant data
;------------------------------------------
ButtonConstants: SECTION

NOPRESS:  dc.b $93   ; no button is pressed
UP:       dc.b $83   ; UL - Up
RIGHT:    dc.b $92   ; UR - Right
LEFT:     dc.b $91   ; BL - Left
DOWN:     dc.b $13   ; BR - Down
