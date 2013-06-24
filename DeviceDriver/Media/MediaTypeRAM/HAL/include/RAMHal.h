////////////////////////////////////////////////////////////////////////////////
// Copyright(C) SigmaTel, Inc. 2003
//
// Filename: hal_ram.h
// Description: 
////////////////////////////////////////////////////////////////////////////////

#ifndef _HAL_RAM_H
#define _HAL_RAM_H

///////////////////////////////////////////////////////////////////////////////
// Includes
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Definitions
///////////////////////////////////////////////////////////////////////////////
#define RAM_SECTOR_BUFFER_MEM_X _X
#define RAM_SECTOR_BUFFER_MEM_Y _Y
#define RAM_SECTOR_BUFFER_MEM RAM_SECTOR_BUFFER_MEM_Y
typedef WORD RAM_SECTOR_BUFFER_MEM RAM_SECTOR_BUFFER;
typedef RAM_SECTOR_BUFFER * P_RAM_SECTOR_BUFFER;

///////////////////////////////////////////////////////////////////////////////
// Error codes
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Typedefs
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Prototypes
///////////////////////////////////////////////////////////////////////////////
RETCODE RamReadRawSector(
    P_RAM_DRIVE_INFO pRamDriveInfo,
    DWORD dwSectorNumber,
    P_SECTOR_BUFFER pSectorData);
RETCODE RamWriteRawSector(
    P_RAM_DRIVE_INFO pRamDriveInfo,
    DWORD dwSectorNumber,
    P_SECTOR_BUFFER pSectorData);

///////////////////////////////////////////////////////////////////////////////
// Global variables
///////////////////////////////////////////////////////////////////////////////

#endif // #ifndef _HAL_RAM_H