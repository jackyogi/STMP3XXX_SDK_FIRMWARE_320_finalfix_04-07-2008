@echo off
REM  Filename:    QEtest.bat 
REM  Description: Tests quadrature encoder with SigmaTel SOC.

rem  Check for minimum of one argument
goto :CheckArgs
:EchoUsage
@echo off
rem  This batch file is written to work with Win2k/Me/98, so
rem  the logic is simplified due to limitations in batch
rem  processing in Me/98
echo *******************************************
echo ; Usage : qetest [ALL] DEVICE [LIBS]
echo ;
echo ;      ALL    = rebuilds all files (param must be first if present)
echo ;
echo ;      DEVICE = D3500 (required parameter)
echo ;
echo ;      LIBS   = *** SIGMATEL USE ONLY *** Forces libraries to build
echo ;                       (defaults to pre-built libs)
echo ;
echo ;
echo ; Notes: Verify that your Quadrature Encoder is supported.
echo ;        SDK2400 defines are automatic in this build. DEBUG build.
echo *******************************************
@echo off
goto :ERROR

:CheckArgs
if not "%1"=="" goto :EnoughArgs
echo *******************************************
echo ; Usage error : Not enough arguments
goto :EchoUsage
:EnoughArgs
if "%1"=="D3500" goto :DeviceTypeOk          
if "%2"=="D3500" goto :DeviceTypeOk          
if "%3"=="D3500" goto :DeviceTypeOk
if "%4"=="D3500" goto :DeviceTypeOk          
echo *******************************************
echo ; Usage error : A valid DEVICE param was not entered  
goto :EchoUsage
:DeviceTypeOk

call ..\..\..\dspenv.bat

set BLD=
set NO_LIB_DEPENDANCIES=

:ARG4
if "%4"=="" goto :ARG3
set BLD=-D%1 -D%2 -D%3 -D%4
set C_ASM_OPTS=-Wa-D%1 -Wa-D%2 -Wa-D%3 -Wa-D%4
goto :READY
:ARG3
if "%3"=="" goto :ARG2
set BLD=-D%1 -D%2 -D%3
set C_ASM_OPTS=-Wa-D%1 -Wa-D%2 -Wa-D%3
goto :READY
:ARG2
if "%2"=="" goto :ARG1
set BLD=-D%1 -D%2
set C_ASM_OPTS=-Wa-D%1 -Wa-D%2
goto :READY
:ARG1
set BLD=-D%1
set C_ASM_OPTS=-Wa-D%1

:READY
rem WinMe doesn't support "(" in an if statement, this is ugly below
if "%1" == "ALL" echo ******************************************* 
if "%1" == "ALL" echo **********   Rebuilding ALL     ***********   
if "%1" == "ALL" echo ******************************************* 
if "%1" == "ALL" echo mk2410 -a -f qetest.mk D_%1=TRUE D_%2=TRUE D_%3=TRUE D_%4=TRUE
if "%1" == "ALL" mk2410 -a -f qetest.mk D_%1=TRUE D_%2=TRUE D_%3=TRUE D_%4=TRUE
if not "%1" == "ALL" echo ******************************************* 
if not "%1" == "ALL" echo **********  Partial rebuild     ***********   
if not "%1" == "ALL" echo *******************************************
if not "%1" == "ALL" echo mk2410 -f qetest.mk D_%1=TRUE D_%2=TRUE D_%3=TRUE D_%4=TRUE
if not "%1" == "ALL" mk2410 -f qetest.mk D_%1=TRUE D_%2=TRUE D_%3=TRUE D_%4=TRUE

if ERRORLEVEL 1 goto :ERROR
echo *******************************************
echo ************ BUILD SUCCESSFUL  ************
echo ******************************************* 
goto EXIT

:ERROR
echo *******************************************
echo !!!!!!!!!!!!!!! BUILD ERRORS !!!!!!!!!!!!!!
echo *******************************************
:EXIT

set BLD=
set C_ASM_OPTS=

