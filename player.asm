; player.asm

;------------------------------------------
; Player Control
;------------------------------------------
    XDEF prow,pcol,pdisp,won
    XDEF initPlayer,movePlayer,decPlayer, checkPlayer
		XREF maze,press
		
PlayerCode: SECTION

initPlayer:
    movb #%00000001,prow
    movb #%00000001,pcol
    movb #1,pdisp
    movw #$0FFF,ptoggle
    movb #0,press
    movb #0,lastMove
    movb #0,rowNum
    movb #0,won
    rtc
    
    
decPlayer:
    pshd
    ldd ptoggle
    dbeq D,toggle
notoggle:
    std ptoggle
    bra endDec
toggle:
    ldaa pdisp
    eora #1
    staa pdisp
    movw #$04FF,ptoggle
endDec:
    puld
    rtc
    

movePlayer:
    pshd
    pshy
    
    ldab press
    cmpb lastMove  ; move only when press changes
    lbeq endMove
    
    movb press,lastMove
    dbeq B,moveUp   
    dbeq B,moveRight  
    dbeq B,moveLeft
    dbeq B,moveDown  
    dbeq B,endMove
    
moveUp:
    ldab prow
    cmpb #1         ; check for edge
    beq  endMove
    
    ldy  #maze      ; check for obstacle
    ldaa rowNum
    deca    
    ldaa A,Y
    anda pcol
    tsta
    bne  endMove
    
    lsrb
    stab prow
    dec  rowNum
    bra  endMove
    
moveRight:     
    ldab pcol
    cmpb #%10000000 ; check for edge
    beq  endMove
    
    ldy  #maze      ; check for obstacle
    ldaa rowNum    
    ldaa A,Y
    lsra
    anda pcol
    tsta
    bne  endMove
    
    lslb
    stab pcol
    bra  endMove
    
moveLeft:           ; check for edge
    ldab pcol
    cmpb #1
    beq  endMove
        
    ldy  #maze      ; check for obstacle
    ldaa rowNum    
    ldaa A,Y
    lsla
    anda pcol
    tsta
    bne  endMove
    
    lsrb
    stab pcol    
    bra  endMove 
    
moveDown:
    ldab prow
    cmpb #%10000000 ; check for edge
    beq  endMove
    
    ldy  #maze      ; check for obstacle
    ldaa rowNum
    inca    
    ldaa A,Y
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
    
    ; congrats!
    movb #1,won
    
endCheck:
    puld    
    rtc
    
    




;------------------------------------------
; Variable data
;------------------------------------------
BoardData: SECTION

prow:   ds.b 1
pcol:   ds.b 1
pdisp:  ds.b 1 ; either 1 or 0
ptoggle:ds.w 1 
lastMove: ds.b 1
rowNum: ds.b 1
won:    ds.b 1

;------------------------------------------
; Constant data
;------------------------------------------
BoardConstants: SECTION

WROW: dc.b $80
WCOL: dc.b $80


 