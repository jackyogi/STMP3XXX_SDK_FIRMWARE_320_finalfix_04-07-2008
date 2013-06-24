#include "types.h"
#include "regsgpio.h"
#include "messages.h"
#include "project.h"
#include "resource.h"
#include "sysresourceapi.h"
#include "displaydrv.h"
#include "..\displaydriver.h"
#include "SED15xx.h"

#pragma optimize 1

#if  FRAMEBUFFER_MEMORY_SPACE==TARGET_MEM_X
#define GetByteFromArray GetByteFromArrayInX
#else
#define GetByteFromArray GetByteFromArrayInY
#endif



_asmfunc GetByteFromArray(WORD iIndex, WORD *pBuffer);
WORD _reentrant DisplayGetContrast(void);

	INT  gTUNER_STFM1000;

_reentrant void HALDisplaySendCommand(WORD wCommand)
{
    //set up the data to go out

    LCD_DC_GPDO = FALSE;        //This is command mode
    _MultiNop();
    LCD_RDE_GPDO = TRUE;        
    _MultiNop();    
    LCD_CS1_GPDO = FALSE;   	//Chip select
    _MultiNop();
    LCD_RW_GPDO = FALSE;   	//Tell System only Write Mode
    _MultiNop();

	if (gTUNER_STFM1000) 
	{
//#ifdef TUNER_STFM1000
    LCD_DATA_D00 = wCommand & 1;
    LCD_DATA_D03 = (wCommand>>3) & 1;
    LCD_DATA_D04 = (wCommand>>4) & 1;
//#endif 
    }
    
    LCD_DATA_DO = wCommand;
    _MultiNop();
    LCD_RW_GPDO = TRUE;   
    _MultiNop();
    LCD_RDE_GPDO = FALSE;
    _MultiNop();
    LCD_CS1_GPDO = TRUE;
    _MultiNop();_MultiNop();_MultiNop();_MultiNop();
    
}

_reentrant void HALDisplaySendData(WORD wPage, WORD wColumn, WORD wCount, WORD wByteIndex,WORD* pBuffer, WORD wDisplayOperation)
{
    int i;
    WORD wByte;
    //set up the data to go out
    HALDisplaySendCommand(CMD_SET_LOWER_COLUMN_ADDRESS(wColumn));
    HALDisplaySendCommand(CMD_SET_HIGHER_COLUMN_ADDRESS(wColumn));
    HALDisplaySendCommand(CMD_SET_PAGE_ADDRESS(wPage));
    for(i=0;i<wCount;i++)
    {
        LCD_DC_GPDO = TRUE;    	//This is data mode
    _MultiNop();
        LCD_RDE_GPDO = TRUE;    
    _MultiNop();
        LCD_CS1_GPDO = FALSE;   
    _MultiNop();
        LCD_RW_GPDO = FALSE;   	//Tell system only Write Mode
    _MultiNop();
        if(wDisplayOperation&DISPLAY_CLEAR)
        {
            wByte = 0;
        }
        else
        {
            wByte = GetByteFromArrayInY(wByteIndex++,pBuffer);
        }
        if(wDisplayOperation&DISPLAY_INVERT)
        {
            wByte = ~wByte;
        }
        
		if (gTUNER_STFM1000) 
		{
	//#ifdef TUNER_STFM1000
	    LCD_DATA_D00 = wByte & 1;  
	    LCD_DATA_D03 = (wByte>>3) & 1;
	    LCD_DATA_D04 = (wByte>>4) & 1;
	//#endif   
	    }
     
    LCD_DATA_DO = wByte&0xff;
    _MultiNop();
        LCD_RW_GPDO = TRUE;
    _MultiNop();
        LCD_RDE_GPDO = FALSE;
    _MultiNop();
        LCD_CS1_GPDO = TRUE;
    _MultiNop();_MultiNop();_MultiNop();
        
    }
}


_reentrant void HALDisplaySetContrast(INT  iContrast)
{
    //the incoming contrast will saturate against the lower and upper bounds

    if(iContrast < 0)
        g_iContrastPercentage = 0;
    else if(iContrast > 100)
        g_iContrastPercentage = 100;
    else
        g_iContrastPercentage = iContrast;

    //contrast is an 'extended' command...takes two command words to execute
    HALDisplaySendCommand(CMD_SET_CONTRAST);
    HALDisplaySendCommand(LCD_MIN_CONTRAST+ ((g_iContrastPercentage*(LCD_MAX_CONTRAST-LCD_MIN_CONTRAST))/100));

}
_reentrant void HALDisplayDecContrast(void)
{
#ifdef CONTRAST_CALIBRATION    
    HALDisplaySetContrast(g_iContrastPercentage-LCD_STEPSIZE_CONTRAST);
#else
    HALDisplaySetContrast(DisplayGetContrast()-LCD_STEPSIZE_CONTRAST);
#endif
}

_reentrant void HALDisplayIncContrast(void)
{
#ifdef CONTRAST_CALIBRATION    
    HALDisplaySetContrast(g_iContrastPercentage+LCD_STEPSIZE_CONTRAST);
#else
    HALDisplaySetContrast(DisplayGetContrast()+LCD_STEPSIZE_CONTRAST);
#endif
}

/*--------------------------------------------------------
Temporarily set the display contrast to compensate for Vddio changes
--------------------------------------------------------*/
_reentrant void SetTemporaryContrast(INT  iChange)
{
    //contrast is an 'extended' command...takes two command words to execute
    HALDisplaySendCommand(CMD_SET_CONTRAST);
    HALDisplaySendCommand(LCD_MIN_CONTRAST + (((g_iContrastPercentage+iChange)*(LCD_MAX_CONTRAST-LCD_MIN_CONTRAST))/100));
}

_reentrant void HALHandleMessage(Message *pMsg)
{
    switch(pMsg->m_wMessage)
    {
    case LCD_SET_CONTRAST:
        HALDisplaySetContrast(pMsg->m_wParams[0]);
        break;
    case LCD_INC_CONTRAST:
        HALDisplayIncContrast();
        break;
    case LCD_DEC_CONTRAST:
        HALDisplayDecContrast();
        break;
    case LCD_TEMP_CONTRAST:
        SetTemporaryContrast(pMsg->m_wParams[0]);
        break;
   case LCD_BACKLIGHT_OFF:
   		LCD_VCC_GPDO = FALSE;
   	break;	
   case LCD_BACKLIGHT_ON:
   	LCD_VCC_GPDO = TRUE;
   	break;	
    default:
        break;
    }
}

