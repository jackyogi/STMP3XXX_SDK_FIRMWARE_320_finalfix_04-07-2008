/////////////////////////////////////////////////////////////////////////////////
// Copyright(C) SigmaTel, Inc. 2000
// System Resource stuff
/////////////////////////////////////////////////////////////////////////////////

#if (!defined(SYSRESOURCES_INC))
#define SYSRESOURCES_INC 1

/////////////////////////////////////////////////////////////////////////////////
// Resource Structs
/////////////////////////////////////////////////////////////////////////////////

// Standard resource header
#define RSRC_HEADER_SIZE 3
#define RSRC_HEADER_RESOURCE_NUMBER 0
#define RSRC_HEADER_BYTE_COUNT 1
#define RSRC_HEADER_RESOURCE_TYPE 2

// Button resource
#define RSRC_BUTTON_NUM_MSGS 0
#define RSRC_BUTTON_START_MSGS RSRC_BUTTON_NUM_MSGS+1

// Button timing resource
#define RSRC_BUTTON_TIMING_SIZE 2
#define RSRC_BUTTON_TIMING_START 0
#define RSRC_BUTTON_TIMING_DEBOUNCE 0
#define RSRC_BUTTON_TIMING_HOLD RSRC_BUTTON_TIMING_DEBOUNCE+1

// ButtonPhysicalMap resource
#define RSRC_BUTTON_PHYS_MAP_NUM_ROWS 0
#define RSRC_BUTTON_PHYS_MAP_OFF_ROWS RSRC_BUTTON_PHYS_MAP_NUM_ROWS+1
#define RSRC_BUTTON_PHYS_MAP_NUM_COLS RSRC_BUTTON_PHYS_MAP_OFF_ROWS+1
#define RSRC_BUTTON_PHYS_MAP_OFF_COLS RSRC_BUTTON_PHYS_MAP_NUM_COLS+1
#define RSRC_BUTTON_PHYS_MAP_OFF_BNUM RSRC_BUTTON_PHYS_MAP_OFF_COLS+1
#define RSRC_BUTTON_PHYS_MAP_NUM_NSBS RSRC_BUTTON_PHYS_MAP_OFF_BNUM+1
#define RSRC_BUTTON_PHYS_MAP_OFF_NSBS RSRC_BUTTON_PHYS_MAP_NUM_NSBS+1
#define RSRC_BUTTON_PHYS_MAP_OFF_NSBN RSRC_BUTTON_PHYS_MAP_OFF_NSBS+1
#define RSRC_BUTTON_PHYS_MAP_HOLD_SPT RSRC_BUTTON_PHYS_MAP_OFF_NSBN+1
#define RSRC_BUTTON_PHYS_MAP_HOLD_MASK RSRC_BUTTON_PHYS_MAP_HOLD_SPT+1

// ButtonEventMap resource
#define RSRC_BUTTON_EVENT_MAP_NUM_EVNT 0

// Timer resource
#define RSRC_TIMER_SIZE 5
#define RSRC_TIMER_START 0
#define RSRC_TIMER_NUMBER 0
#define RSRC_TIMER_COUNT_VALUE RSRC_TIMER_NUMBER+1
#define RSRC_TIMER_CONTROL_VALUE RSRC_TIMER_COUNT_VALUE+1
#define RSRC_TIMER_CONTROL_REG RSRC_TIMER_CONTROL_VALUE+1
#define RSRC_TIMER_COUNT_REG RSRC_TIMER_CONTROL_REG+1

// Interrupt resource
#define RSRC_INTERRUPT_SIZE 12
#define RSRC_INTERRUPT_START 0
#define RSRC_INTERRUPT_ICL_EN 0
#define RSRC_INTERRUPT_ICL_EN_MASK RSRC_INTERRUPT_ICL_EN+1
#define RSRC_INTERRUPT_ICL_PRIOR RSRC_INTERRUPT_ICL_EN_MASK+1
#define RSRC_INTERRUPT_ICL_PRIOR_MASK RSRC_INTERRUPT_ICL_PRIOR+1
#define RSRC_INTERRUPT_ICL_PRIOR_CLEAR_MASK RSRC_INTERRUPT_ICL_PRIOR_MASK+1
#define RSRC_INTERRUPT_ICL_STEER RSRC_INTERRUPT_ICL_PRIOR_CLEAR_MASK+1
#define RSRC_INTERRUPT_ICL_STEER_MASK RSRC_INTERRUPT_ICL_STEER+1
#define RSRC_INTERRUPT_ICL_STEER_CLEAR_MASK RSRC_INTERRUPT_ICL_STEER_MASK+1
#define RSRC_INTERRUPT_ICL_STATUS RSRC_INTERRUPT_ICL_STEER_CLEAR_MASK+1
#define RSRC_INTERRUPT_ICL_STATUS_MASK RSRC_INTERRUPT_ICL_STATUS+1
#define RSRC_INTERRUPT_VECTOR_ADDRESS RSRC_INTERRUPT_ICL_STATUS_MASK+1
#define RSRC_INTERRUPT_ISR_ADDRESS RSRC_INTERRUPT_VECTOR_ADDRESS+1


/////////////////////////////////////////////////////////////////////////////////
// Resource Types
/////////////////////////////////////////////////////////////////////////////////
#define RSRC_TYPE_NULL 0x000000
#define RSRC_TYPE_STRING 0x000001
#define RSRC_TYPE_DATA 0x000002
#define RSRC_TYPE_BITMAP 0x000003
#define RSRC_TYPE_BUTTON 0x000004
#define RSRC_TYPE_BUTTON_TIMING 0x000005
#define RSRC_TYPE_TIMER 0x000006
#define RSRC_TYPE_INTERRUPT 0x000007
#define RSRC_TYPE_SYSTEM_INTERRUPT 0x000008
#define RSRC_TYPE_NESTED_RESOURCE 0x000009

/////////////////////////////////////////////////////////////////////////////////
// Pre-defined resources
/////////////////////////////////////////////////////////////////////////////////
// RSRC_TYPE_NULL
#define RSRC_NULL 0x000000     


#endif //IF (!@def(SYSRESOURCES_INC))

