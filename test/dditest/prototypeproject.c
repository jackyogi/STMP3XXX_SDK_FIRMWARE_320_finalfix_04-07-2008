////////////////////////////////////////////////////////////////////////////////
// Copyright(C) SigmaTel, Inc. 2003
//
// Filename: main.c
// Description: DDI Test
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//   Includes and external references
////////////////////////////////////////////////////////////////////////////////

#include "types.h"
#include "ddildl.h"

////////////////////////////////////////////////////////////////////////////////
// Symbol Exports
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// defs
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Variables
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Prototypes
////////////////////////////////////////////////////////////////////////////////
#pragma asm
    GLOBAL  SysCallFunction_P_LOGICAL_MEDIA_DESCRIPTOR_f
    EXTERN  SysCallFunction
SysCallFunction_P_LOGICAL_MEDIA_DESCRIPTOR_f equ SysCallFunction
#pragma endasm

////////////////////////////////////////////////////////////////////////////////
// Code
////////////////////////////////////////////////////////////////////////////////
