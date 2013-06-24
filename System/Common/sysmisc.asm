;///////////////////////////////////////////////////////////////////////////////
;  Copyright(C) SigmaTel, Inc. 2000-2001
;
;  File        : sysmisc.asm
;  Description : Misc System Routines
;///////////////////////////////////////////////////////////////////////////////

    page    255,255,0

    section SYSFUN_SysMisc

;///////////////////////////////////////////////////////////////////////////////
;   Macros
;///////////////////////////////////////////////////////////////////////////////

;///////////////////////////////////////////////////////////////////////////////
;   Includes
;///////////////////////////////////////////////////////////////////////////////

    nolist
    include "hwequ.inc"
    include "const.xref"
    list
     
;///////////////////////////////////////////////////////////////////////////////
;   External Definitions
;///////////////////////////////////////////////////////////////////////////////

    ;Functions  
    global  DelayLongB
    global  InvalidIsrVector
    global  ProgrammingError
    global  SystemError
    global  SystemNullRoutine
    global  SysAllLinear
    global  SysGetMicVR

;///////////////////////////////////////////////////////////////////////////////
;   External References
;///////////////////////////////////////////////////////////////////////////////

;///////////////////////////////////////////////////////////////////////////////
;   Equates
;///////////////////////////////////////////////////////////////////////////////
        
;///////////////////////////////////////////////////////////////////////////////
;   X Memory
;///////////////////////////////////////////////////////////////////////////////
        
    org     x,"SYSFUN_SysMisc_X":

;///////////////////////////////////////////////////////////////////////////////
;   Y Memory
;///////////////////////////////////////////////////////////////////////////////

    org     y,"SYSFUN_SysMisc_Y":

;///////////////////////////////////////////////////////////////////////////////
;   P Memory
;///////////////////////////////////////////////////////////////////////////////

    org     p,"SYSFUN_SysMisc_P":

;///////////////////////////////////////////////////////////////////////////////
;
;>  Name:           DelayLongB
;
;   Type:           Function
;
;   Description:    ???
;
;   Inputs:         b = count
;
;   Outputs:        none
;                   
;   Notes:          none
;<
;///////////////////////////////////////////////////////////////////////////////
DelayLongB
    dec b
    jne DelayLongB
    rts

;///////////////////////////////////////////////////////////////////////////////
;
;>  Name:           ProgrammingError
;
;   Type:           Function
;
;   Description:    Old - should remove
;
;   Inputs:         none
;
;   Outputs:        none
;                   
;   Notes:          This function does not return - it executes "jmp *"
;<
;///////////////////////////////////////////////////////////////////////////////
ProgrammingError
    jmp     *

;///////////////////////////////////////////////////////////////////////////////
;
;>  Name:           SystemError
;
;   Type:           function
;
;   Description:    Old - should remove
;
;   Inputs:         none
;
;   Outputs:        none
;                   
;   Notes:          This function does not return - it executes "jmp *"
;<
;///////////////////////////////////////////////////////////////////////////////
SystemError
    jmp     *

;///////////////////////////////////////////////////////////////////////////////
;
;>  Name:           SystemNullRoutine
;
;   Type:           Function
;
;   Description:    Empty function
;
;   Inputs:         none
;
;   Outputs:        none
;                   
;   Notes:          Used to fill unused descriptors
;<
;///////////////////////////////////////////////////////////////////////////////
SystemNullRoutine
    rts

;///////////////////////////////////////////////////////////////////////////////
;
;>  Name:           InvalidIsrVector
;
;   Type:           Interrupt Service Routine
;
;   Description:    Old - should remove
;
;   Inputs:         none
;
;   Outputs:        none
;                   
;   Notes:          ???
;<
;///////////////////////////////////////////////////////////////////////////////
InvalidIsrVector
    jmp     *

;///////////////////////////////////////////////////////////////////////////////
;
;>  Name:           SysAllLinear
;
;   Type:           Function
;
;   Description:    Forces all modulo registers to linear
;
;   Inputs:         none
;
;   Outputs:        none
;                   
;   Notes:          Does not force m7
;<
;///////////////////////////////////////////////////////////////////////////////
SysAllLinear
    move    y:<Const_ffffff,m0
    move    m0,m1
    move    m0,m2
    move    m0,m3
    move    m0,m4
    move    m0,m5
    move    m0,m6
    rts

;///////////////////////////////////////////////////////////////////////////////
;
;>  Name:           SysGetMicVR
;
;   Type:           Function
;
;   Description:    Returns the HW_MIXMICINVR register.
;
;   Inputs:         none
;
;   Outputs:        a1 = HW_MIXMICINVR contents
;                   
;   Notes:          none
;<
;///////////////////////////////////////////////////////////////////////////////
SysGetMicVR
    move    x:HW_MIXMICINVR,a
    rts

    endsec

