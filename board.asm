; board.asm

;------------------------------------------
; Macro Definitions
;------------------------------------------
delay: MACRO
    pshx
    ldx  #$0F
\@loop:
    call readButton
    dbne x,\@loop
    pulx
    ENDM

;------------------------------------------
; Board Display
;------------------------------------------
		XDEF board,gameWon,gameLost
		XREF maze,lose,win
		XREF PORTA,PORTB
		XREF prow,pcol,pdisp
		XREF initPlayer,decPlayer,movePlayer
		XREF readButton
BoardCode: SECTION

board:
    call initPlayer ; initialize player
gameLoop:    
    ldx  #maze
    ldy  #8 ; display 8 rows
    movb #1,row  
    
display:       ; first check if player is in current row
    ldaa prow
    cmpa row
    bne  displayBoard
    
displayPlayer: ; then check if player should be displayed
    tst  pdisp
    beq  playerOff  ; if 0, branch to playerOff
playerOn:
    movb pcol,PORTA
    movb prow,PORTB
    delay
playerOff:
    call decPlayer
    
displayBoard:
    movb 1,X+,PORTA
    movb row,PORTB
    delay
    
    ldab row  ; shift row over then repeat
    aslb
    stab row
    
    call movePlayer
    
    dbne Y,display
    bra  gameLoop    
		swi


gameWon:
    ldx #win
    ldy #8
    movb #1,row
displayWon:    
    movb 1,X+,PORTA
    movb row,PORTB
    delay
    
    ldab row  ; shift row over then repeat
    aslb
    stab row
    
    dbne Y,displayWon
    bra  gameWon  
    
    
gameLost:
    ldx #lose
    ldy #8
    movb #1,row
displayLost:    
    movb 1,X+,PORTA
    movb row,PORTB
    delay
    
    ldab row  ; shift row over then repeat
    aslb
    stab row
    
    dbne Y,displayLost
    bra  gameLost  

;------------------------------------------
; Variable data
;------------------------------------------
BoardData: SECTION

row:    ds.b 1