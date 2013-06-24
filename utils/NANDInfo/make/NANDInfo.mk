ifndef VERSION
VERSION=999.999
endif

ifdef D_D3410
DEVICE=3410
# DELETE THESE COMMENTED LINES EVENTUALLY. ALREADY IN STANDARD.MK
#else
#ifdef D_D3500
#DEVICE=3500
#else
#BLD=$(BLD) -DDEVICE_3500 
#C_ASM_OPTS=$(C_ASM_OPTS) -Wa-DDEVICE_3500
#DEVICE=3500
#endif
endif

# WARNING: standard.mk depends upon the following macros existing
# PROJ is basename for all executables -- must be the same as subdir name
PROJ    = NANDInfo
# relative pointer to SDK root directory \Mp3BaseCc
RELBASE_PATH        =..\..\..
ROOT                = $(RELBASE_PATH)

# these macros are project dependent
PROJ_PATH           = $(ROOT)\utils\NANDInfo
MAIN_PATH           = $(PROJ_PATH)

#########################################
#
include $(ROOT)\etc\options.mk
#########################################
#
include $(ROOT)\etc\standard.mk
#########################################
include $(RELBASE_PATH)\etc\sysserialnumber.mk
#########################################
#
include $(ETC_PATH)\includes.mk
#########################################
#
include $(ROOT)\etc\ddildl.mk
#########################################
#
include $(ROOT)\etc\kernel.mk
#########################################
#
include $(ROOT)\etc\NANDDataDrive.mk
#########################################
#
include $(ROOT)\etc\NANDCommonDdi.mk
#########################################
#
include $(ROOT)\etc\NANDSystemDrive.mk
#########################################
#
include $(ROOT)\etc\NANDMedia.mk
#########################################
#
include $(ROOT)\etc\NANDHal.mk
#########################################

#########################################
#
ifdef D_D3500
include $(ROOT)\etc\GPPortHil.mk
else
include $(ROOT)\etc\CFPortHil.mk
endif
#########################################
#
include $(ROOT)\etc\ResourceManager.mk
#########################################
#
include $(ROOT)\etc\Stringlib.mk
#########################################

CC_OPTS = $(CC_OPTS) $(C_ASM_OPTS)
LK_OPTS = $(LK_OPTS) -u SysWaitOnObject -u FSysReleaseObject -u NANDSystemDriveApi

# must follow standard.mk, where base INC_ALL gets defined
INC_ALL=-I$(PROJRSRC_PATH);$(COMMON_PROJ_PATH);$(OUTPUT_PATH);$(OUTPUT_INCLUDE_PATH);$(PROJ_PATH);$(FAT12INC_PATH);$(INC_ALL)
INC_ALL_C = -Wc-I$(OUTPUT_INCLUDE_PATH) $(INC_ALL_C)

LIB_OPT_LIST =  $(LIB_OPT_LIST)\
                -u Rdiv_ululul \
				-u Rmod_ululul
                
OBJLIST =   $(OBJLIST) \
            $(OBJ_PATH)\task0.obj \
            $(OBJ_PATH)\kernelproject.obj \
            $(OBJ_PATH)\miscproject.obj\
            $(OBJ_PATH)\prototypeproject.obj \
	    $(OBJ_PATH)\main.obj

ifdef D_D3410
OBJLIST =   $(OBJLIST)\
    $(OBJ_PATH)\cfporthil_resource.obj
endif

MODLIST =   
MODULELIST = 
DEBUGABSLIST= 

MAKELIST =  $(OBJLIST) $(ALLLIBLIST)

ALL : $(OUTPUT_PATH)\$(PROJ).abs   $(DEBUGABSLIST)
# remove comment before $(DEBUGABSLIST) above to build debug .abs

#///////////////////////////////////////////////////////////////////////////////
# Link
#///////////////////////////////////////////////////////////////////////////////
"$(OUTPUT_PATH)\$(PROJ).out" : $(PROJ).mk stmp3500.dsc stmpsys.dsc $(MAKELIST)
    @echo Linking $(PROJ).out
        @$(LK_EXE) -o $@ $(LK_OPTS) $(match .obj $!) $(LIB_OPT_LIST) $(match .a $!)

"$(OUTPUT_PATH)\$(PROJ).abs"                 : "$(OUTPUT_PATH)\$(PROJ).out" stmpsys.dsc 
    @echo Creating IEEE-695 absolute file $@
        @$(LC_EXE) -o $@ $(LC_OPTS) -d$(match .dsc $!) $(OUTPUT_PATH)\$(PROJ).out

#///////////////////////////////////////////////////////////////////////////////
# Debug Module Links
#      These links provide an .abs that can be used to load source-level symbols for each overlaid module
#///////////////////////////////////////////////////////////////////////////////

#///////////////////////////////////////////////////////////////////////////////
# Project-specific files
#///////////////////////////////////////////////////////////////////////////////
"$(OBJ_PATH)\task0.obj" : $(PROJ_PATH)\task0.c $(OUTPUT_INCLUDE_PATH)\resource.h  $(OUTPUT_INCLUDE_PATH)\project.h
"$(OBJ_PATH)\kernelproject.obj" : $(PROJ_PATH)\kernelproject.c $(OUTPUT_INCLUDE_PATH)\resource.h $(OUTPUT_INCLUDE_PATH)\project.h

"$(OBJ_PATH)\miscproject.obj" : $(PROJ_PATH)\miscproject.c  $(OUTPUT_INCLUDE_PATH)\errors.h


"$(OBJ_PATH)\prototypeproject.obj" : $(PROJ_PATH)\prototypeproject.c
"$(OBJ_PATH)\ddiproject.obj" : $(PROJ_PATH)\ddiproject.c $(OUTPUT_INCLUDE_PATH)\errors.h $(OUTPUT_INCLUDE_PATH)\resource.h
"$(OBJ_PATH)\dditest_resource.obj" : $(PROJ_PATH)\dditest_resource.asm $(OUTPUT_INCLUDE_PATH)\resource.inc
"$(OBJ_PATH)\nandhalproject.obj" : $(PROJ_PATH)\nandhalproject.c
"$(OBJ_PATH)\nandporthilproject.obj" : $(PROJ_PATH)\nandporthilproject.c

"$(OBJ_PATH)\main.obj" : $(PROJ_PATH)\main.c
ifdef D_D3500
"$(OBJ_PATH)\main.obj" : $(OUTPUT_INCLUDE_PATH)\regsgpflash.h
endif
#///////////////////////////////////////////////////////////////////////////////
# General System
#///////////////////////////////////////////////////////////////////////////////

$(OBJ_PATH)\const.obj : $(SYS_PATH)\data_management\const.asm

ifdef D_D3410
$(OBJ_PATH)\cfporthil_resource.obj : $(SYMBOLS_PATH)\cfporthil_resource.asm
endif
#///////////////////////////////////////////////////////////////////////////////
# Resource build
#///////////////////////////////////////////////////////////////////////////////
