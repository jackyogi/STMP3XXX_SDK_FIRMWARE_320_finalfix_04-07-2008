////////////////////////////////////////////////////////////////////////////////
// Copyright(C) SigmaTel, Inc. 2002
//
// Filename: usbmtp_cmdoutbuf_ovly_mem.c
// Description: Project-specific USB MTP buffer for OUT Transfers (writes)
//    The variables added to this file are used only USB Transfers to the device, They
//	  can be overlaid with the Janus section.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//   Includes and external references
////////////////////////////////////////////////////////////////////////////////
#ifdef MTP_BUILD
#include "types.h"
#include "mtp.h"
#include "usbmscMtpSwitch.h"
////////////////////////////////////////////////////////////////////////////////
// Symbol Exports
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Externs
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Defs
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Prototypes
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Debug Variables
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Variables
////////////////////////////////////////////////////////////////////////////////

//Increased buffer size to 1.5K words to facilitate faster transfers on send_object calls.
WORD _X Device1CommandOutBuffer[TRANSFER_BUFFER_SIZE*3];
#endif
