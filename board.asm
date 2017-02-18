; board.asm

;------------------------------------------
; Macro Definitions
;------------------------------------------
delay: MACRO
    pshx
    ldx  #$0F
\@loop:
    call readButton
    dbne x, \@loop
    pulx
    ENDM

;------------------------------------------
; Board Display
;------------------------------------------
XDEF board, gameWon, gameLost
XREF maze, lose, win
XREF PORTA, PORTB
XREF prow, pcol, pdisp
XREF initPlayer, decPlayer, movePlayer
XREF readButton

BoardCode: SECTION

board:
    ; initialize player
    call initPlayer 
gameLoop:
    ; display 8 rows
    ldx  #maze
    ldy  #8 
    movb #1,row  
 
 ; first check if player is in current row
display:
    ldaa prow
    cmpa row
    bne  displayBoard

; then check if player should be displayed
displayPlayer: 
    ; if 0, branch to playerOff
    tst  pdisp
    beq  playerOff 

playerOn:
    movb pcol, PORTA
    movb prow, PORTB
    delay

playerOff:
    call decPlayer
    
displayBoard:
    movb 1, X+, PORTA
    movb row, PORTB
    delay
    ; shift row over then repeat
    ldab row  
    aslb
    stab row
    
    call movePlayer
    
    dbne Y, display
    bra  gameLoop    
    swi



gameWon:
    ldx  #win
    ldy  #8
    movb #1,row

displayWon:    
    movb 1, X+, PORTA
    movb row, PORTB
    delay
    ; shift row over then repeat
    ldab row  
    aslb
    stab row
    
    dbne Y, displayWon
    bra  gameWon  
    
    
gameLost:
    ldx  #lose
    ldy  #8
    movb #1,row

displayLost:    
    movb 1, X+, PORTA
    movb row, PORTB
    delay
     ; shift row over then repeat
    ldab row 
    aslb
    stab row
    
    dbne Y, displayLost
    bra  gameLost  

;------------------------------------------
; Variable data
;------------------------------------------
BoardData: SECTION

row:    ds.b 1
