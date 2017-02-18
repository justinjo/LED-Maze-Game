; player.asm

;------------------------------------------
; Player Control
;------------------------------------------
XDEF prow, pcol, pdisp, won
XDEF initPlayer, movePlayer, decPlayer, checkPlayer
XREF maze, press
		
PlayerCode: SECTION

initPlayer:
    ; initialize player position and attributes
    movb #%00000001, prow
    movb #%00000001, pcol
    movb #1, pdisp
    movw #$0FFF, ptoggle
    movb #0, press
    movb #0, lastMove
    movb #0, rowNum
    movb #0, won
    rtc
    

; controls the player's current display state (blinks on/off)
decPlayer:
    pshd
    ldd  ptoggle
    dbeq D, toggle
notoggle:
    std  ptoggle
    bra  endDec
toggle:
    ldaa pdisp
    eora #1
    staa pdisp
    movw #$04FF, ptoggle
endDec:
    puld
    rtc
    

movePlayer:
    pshd
    pshy
    ; move only when button pressed changes
    ldab press
    cmpb lastMove  
    lbeq endMove
    
    movb press, lastMove
    dbeq B, moveUp   
    dbeq B, moveRight  
    dbeq B, moveLeft
    dbeq B, moveDown  
    dbeq B, endMove
    

moveUp:
    ; check for edge
    ldab prow
    cmpb #1        
    beq  endMove
    ; check for obstacle
    ldy  #maze
    ldaa rowNum
    deca    
    ldaa A, Y
    anda pcol
    tsta
    bne  endMove
    
    lsrb
    stab prow
    dec  rowNum
    bra  endMove

    
moveRight:
    ; check for edge
    ldab pcol
    cmpb #%10000000 
    beq  endMove
    ; check for obstacle
    ldy  #maze
    ldaa rowNum
    ldaa A, Y
    lsra
    anda pcol
    tsta
    bne  endMove
    
    lslb
    stab pcol
    bra  endMove

    
moveLeft:
    ; check for edge
    ldab pcol
    cmpb #1
    beq  endMove
    ; check for obstacle
    ldy  #maze
    ldaa rowNum    
    ldaa A, Y
    lsla
    anda pcol
    tsta
    bne  endMove
    
    lsrb
    stab pcol    
    bra  endMove 

    
moveDown:
    ; check for edge
    ldab prow
    cmpb #%10000000
    beq  endMove
    ; check for obstacle 
    ldy  #maze
    ldaa rowNum
    inca    
    ldaa A, Y
    anda pcol
    tsta
    bne endMove
    
    lslb
    stab prow
    inc  rowNum

    
endMove:
    puly
    puld
    rtc




checkPlayer:
    pshd
    ldaa prow
    cmpa WROW
    bne endCheck
    ldab pcol
    cmpb WCOL
    bne endCheck
    
    ; congrats, you've won!
    movb #1,won
    
endCheck:
    puld    
    rtc
    

;------------------------------------------
; Variable data
;------------------------------------------
BoardData: SECTION

prow:     ds.b 1
pcol:     ds.b 1
pdisp:    ds.b 1 ; toggled between 0/1
ptoggle:  ds.w 1 
lastMove: ds.b 1
rowNum:   ds.b 1
won:      ds.b 1

;------------------------------------------
; Constant data
;------------------------------------------
BoardConstants: SECTION

WROW: dc.b $80
WCOL: dc.b $80
