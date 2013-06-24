;///////////////////////////////////////////////////////////////////////////////
; Copyright(C) SigmaTel, Inc. 2000/2001
;
; STMP3400 ISR-level Decoder Module (CANNOT be overlayed)
;///////////////////////////////////////////////////////////////////////////////
        section DECAPP_DecAdpcmImaNonOverlay


;///////////////////////////////////////////////////////////////////////////////
;   External Definitions
;///////////////////////////////////////////////////////////////////////////////
       GLOBAL   DecAdpcmImaModuleTimerDisable
       GLOBAL   DecAdpcmImaModuleIsr
       GLOBAL   DecAdpcmProcess

;///////////////////////////////////////////////////////////////////////////////
;   External References
;///////////////////////////////////////////////////////////////////////////////
        ; System Functions
       EXTERN   SysAllLinear
       EXTERN   SysClearTimerIrq
       EXTERN   SysDisableTimer
       EXTERN   GetFilledSpace
       EXTERN   GetEmptySpace

        ; Decoder Module
       EXTERN   DecoderCSR
       EXTERN   DecoderSR
       EXTERN   AdpcmDecIsrSp
       EXTERN   DecoderTimerNum


        EXTERN  Fg_Wave_data_offset
       EXTERN   SongByteLengthHigh
       EXTERN   SongByteLengthLow


        ; Parser Module
       EXTERN   CurrentSongBad          ; GDA_20010530

        ; File System
       EXTERN   FILEClose
       EXTERN   FILEOpen
       EXTERN   FileEOF
       EXTERN   FileRead

;///////////////////////////////////////////////////////////////////////////////
;   Includes
;///////////////////////////////////////////////////////////////////////////////
        nolist
        include "sysequ.inc"
        include "hwequ.inc"
        include "dacequ.inc"
        include "msgequ.inc"
        include "adpcmequ.inc"
        include "irqequ.inc"
        include "stack.xref"
        include "stackmem.xref"
    include "const.xref"
		include "wave.xref"
		include "adpcm.xref"
        list
        page    132,60,0,0,0

;///////////////////////////////////////////////////////////////////////////////
;  Macros
;///////////////////////////////////////////////////////////////////////////////

    nolist
    include "sysmacro.asm"
    include "systrace.asm"
    list


;///////////////////////////////////////////////////////////////////////////////
;   Code
;///////////////////////////////////////////////////////////////////////////////
        org     p,"DECAPP_DecAdpcmImaNonOverlay_P":


;*******************************************************************************
; DecAdpcmImaModuleTimerDisable Routine
;*******************************************************************************
DecAdpcmImaModuleTimerDisable
        ; CANNOT be overlayed, called by ISR.

        ; Hardware Workaround -- Disable IVL at HW_IPR
        clr     a
        move    #>DECODER_IVL_MASK,a1
        move    x:HW_IPR,x0
        push    x0
        and     x0,a
        move    a1,x:HW_IPR                     ; disables decoder timer IVL

        ; Disable Timer0 Module for use by decoder
        move    #>DecoderTimerNum,x0
        move    #_TimerDisabled,r0
        jmp     SysDisableTimer
_TimerDisabled

        ; Hardware Workaround -- Restore IVL at HW_IPR
        pop     x0
        move    x0,x:HW_IPR                      ; re-enables the IVL line of decoder

        rts




;;***********************************************************************
;  Function:
;        DecAdpcmProcess
;  Description:
;      Main function
;  Parameters passed: 
;      None
;;***********************************************************************

DecAdpcmProcess
		; No need to check the input buffer.
		; We use the pull model, so we are never starved of input data.
        ; Get empty space from sink buffer
		jsr		SysAllLinear
        move    #g_AdpcmDecSinkBufDescriptor,r4
        jsr     GetEmptySpace

		; SamplestoDecode is different for different algorithms.
		; Last block is handled differently
        move   y:SamplestoDecode,B
		move    y:Fg_Wave_wChannels,x0
		rep	   x0
		asl	   B
		asr	   B
        cmp    B,A
        jge    _EnoughOutputSpace
        rts   

_EnoughOutputSpace

		; Update the SongByte pointer
		move	y:inputbufsize,x0
		clr 	A		#0,x1
		move	y:SongByteTotalLow,A0
        move    y:SongByteTotalHigh,A1
		add		x,A
		move	A0,y:SongByteTotalLow
        move    A1,y:SongByteTotalHigh

        ;added code start
        move    y:SongByteLengthHigh,b1   ; high bytes of song length
        move    y:SongByteLengthLow,b0    ; low bytes of song length
        cmp     a,b
        jgt     _do_src_buf_check         ; jump & continue if decode limit in b > a
        move    b0,y:SongByteTotalLow
        move    b1,y:SongByteTotalHigh
        clr     a
        move    a0,y:inputbufsize
    
_do_src_buf_check
        ; added code end

        ; So read in the data
		; Typical data read is block align size. 
		; Take care of last block which may be smaller.
		move	y:inputbufsize,A
		move    #>g_AdpcmDataSrc_buf,r0
        jsr     SysAllLinear
        jsr     FWave_Fill_Input_Bitstream_Buffer  ; checks if buffer full, reads in more if not
                                             	  ; returns with A1 = num bytes read

		tst     A; This will handle the case where return value is zero due to EOF or some other scenario
		jgt     _ContinueDecoding
		move	y:<Const_000001,x0
		move	x0,y:Last_block_flag

;        jcc     _ContinueDecoding
        bset    #EndOfSong,x:DecoderCSR ; Signal the top level modules to stop Decoding.
		move	y:Last_block_flag,A
        tst     A		
        jne     _Exit
        bset    #FileReadError,x:DecoderCSR ; failed to read data
        jmp     _Exit

_ContinueDecoding
		move    #>g_AdpcmDataSrc_buf,r0
        move    y:g_pAdpcmDecSinkBufMod,m4 ; m4=modulo of the sink buffer
        move    y:g_pAdpcmDecSinkBufHead,r4 ; r4=sink buffer head ptr
		move	y:AdpcmDecoderPointer,r6
		move	y:SamplestoDecode,A
		; Call the appropriate Decoder
		jsr		(r6)
		move	y:SamplestoDecode,A
		move    y:Fg_Wave_wChannels,x0
		rep	   x0
		asl		A		
		asr		A		y:g_pAdpcmDecSinkBufHead,r4
		move	A,n4
		nop
		move	(r4)+n4
        move    r4,y:g_pAdpcmDecSinkBufHead
        move	y:<Const_ffffff,m4 ; Modulo back to linear
        ; Was this the last block?
		move	y:Last_block_flag,A
        tst     A		
        jeq     _ComputeSamplesLeft
		; This was the last block
        bset    #EndOfSong,x:DecoderCSR ; Signal the top level modules to stop Decoding.
        jmp     _Exit
_ComputeSamplesLeft
		; Prepare for the next block.
		move    y:(Fg_Wave_datachunksize+1),A
		move    y:Fg_Wave_datachunksize,A0
		move	#0,x1
		move	y:Fg_Wave_wBlockAlign,x0
		sub		x,A
		move    A0,y:Fg_Wave_datachunksize
		move    A1,y:(Fg_Wave_datachunksize+1)
		jgt		_Continue
		; Else this is the last block. Handle the last block correctly.
		move	y:<Const_000001,x0
		move	x0,y:Last_block_flag
		move	y:Fg_Wave_wFormatTag,B
		; First Parameter is A = Fg_Wave_datachunksize
		jsr		FGetSamplestoDecodeLastBlock
		move	A,y:SamplestoDecode
		move    y:(Fg_Wave_datachunksize+1),A
		move    y:Fg_Wave_datachunksize,A0
		move	#0,x1
		move	y:Fg_Wave_wBlockAlign,x0
		add		x,A
		move	A0,y:inputbufsize
_Continue
_Exit
        rts




;*******************************************************************************
; DecAdpcmImaModuleIsr
;*******************************************************************************
DecAdpcmImaModuleIsr

        ; Clear the DM bit (double-precision multiply mode, bit 6) of the Mode Register
        ; This will be returned to its previous state when the RTI occurs (since the SR
        ; will be popped back off System Stack Low (SSL).
        ; Accumulator behavior is unpredictable when the DM bit is set.
        ; Next cycle after clearing it should NOT be an ALU instruction.
        andi #$BF,mr

        move    x0,y:IntL1_SaveR6           ; save x0 state
        ; Check if spurious interrupt. If so exit ...
        move    x:HW_ICLSTATUS0R,x0
        jset    #HW_ICLSTATUS0R_SST13_BITPOS,x0,_ContinueIsr
        ; None of the above, exit interruption
        move    y:IntL1_SaveR6,x0           ; restore x0 state
        rti

_ContinueIsr
        move    y:IntL1_SaveR6,x0           ; restore x0 state

        ; save off all registers
        move    r6,y:IntL1_SaveR6            ; r6 used for return mechanism
        move    #_DecoderSaveRegReturn,r6    ; setup the return address
        jmp     SaveRegs                     ; save the remaining registers
_DecoderSaveRegReturn

        ; save off stack
        move    #_DecoderSaveStackReturn,r6  ; setup the return address
        move    #AdpcmDecIsrSp,r5                 ; pointer to the SP local save
        jmp     SaveSystemStack              ; save the hardware stack
_DecoderSaveStackReturn

_DecoderStateMachine
        move    x:DecoderCSR,x0
        jset    #Stop,x0,_IsrStopSequence
        jset    #Pause,x0,_IsrPauseSequence

_IsrPlaySequence
        bset    #Play,x0
        move    x0,x:DecoderCSR

        ; Set the status register
        bclr    #Stop,x:DecoderSR
        bclr    #Pause,x:DecoderSR
        bset    #Play,x:DecoderSR

        ; enable the dac
        move    x:HW_DACCSR,x0
; GDA_20010530        jset    #HW_DACCSR_TXEN_BITPOS,x0,_callDecoder
        jset    #HW_DACCSR_TXEN_BITPOS,x0,_checkFileOK
        bset    #HW_DACCSR_TXEN_BITPOS,x:HW_DACCSR

_checkFileOK                ; GDA_20010530
    move    y:CurrentSongBad,x0
    jclr    #0,x0,_callDecoder
        bset    #EndOfSong,x:DecoderCSR     ; force to end of bad file
        jmp     _IsrStopSequence
    
_callDecoder
        jsr     DecAdpcmProcess
_getMoreBytes
        move    x:DecoderCSR,x0
        jset    #FileReadError,x0,_IsrStopSequence
        jclr    #EndOfSong,x0,_restore_stack   ; continue decoding song if bit not yet set

_IsrStopSequence
        ; Set the status register
        bset    #Stop,x:DecoderSR
        bclr    #Pause,x:DecoderSR
        bclr    #Play,x:DecoderSR
        jmp     _decoderTimerOff

_IsrPauseSequence
        ; Set the status register
        bset    #Pause,x:DecoderSR
        bclr    #Play,x:DecoderSR


_decoderTimerOff
        ; if done decoding song, turn timer off
        ; user level will turn dac off before advancing to next song
        move    x:DecoderCSR,x0
        bclr    #Play,x0                     ; clear to avoid "Pause" on next song
        move    x0,x:DecoderCSR

        jsr     DecAdpcmImaModuleTimerDisable ; turn off timer

_restore_stack
        ; reset the isr for next time
        move    #>DecoderTimerNum,x0
        move    #_TimerReset,r0
        jmp     SysClearTimerIrq
_TimerReset
        ; restore stack
        move    #AdpcmDecIsrSp,r5                 ; pointer to the SP local save
        move    #_stackRestored,r6           ; setup the return address
        jmp     RestoreSystemStack           ; restore the hardware stack
_stackRestored
        ; restore all registers
        move    #DecoderRestoreRegReturn,r6  ; setup the return address
        jmp     RestoreRegs                  ; restore registers
DecoderRestoreRegReturn
        move    y:IntL1_SaveR6,r6            ; restore minimal reg set
        rti

;--------------------------------------------------

    
        endsec


