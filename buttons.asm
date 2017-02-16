; buttons.asm

;------------------------------------------
; Button Moves
;------------------------------------------
    XREF PORTE
    XDEF readButton,press

ButtonCode: SECTION

readButton:
    pshb
    ldab PORTE   ; branching statements
    cmpb NOPRESS ; no press
    beq  noPress
    cmpb UP      ; up
    beq  up
    cmpb RIGHT   ; right
    beq  right
    cmpb LEFT    ; left
    beq  left
    cmpb DOWN    ; down
    beq  down
    bra  endRead ; edge case 
up:
    movb #1,press
    bra endRead   
right:
    movb #2,press
    bra endRead   
left: 
    movb #3,press
    bra endRead   
down:
    movb #4,press
    bra endRead
noPress:
    movb #5,press 
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

NOPRESS:  dc.b $93 ; no button is pressed
UP:       dc.b $83   ; UL - Up
RIGHT:    dc.b $92   ; UR - Right
LEFT:     dc.b $91   ; BL - Left
DOWN:     dc.b $13   ; BR - Down