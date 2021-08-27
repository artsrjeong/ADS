# Linker.cmd file for DSP56805EVM 
#        using internal data memory only ( EX = 0, Boot Mode 0A )

MEMORY {

	.pflash (RX)  : ORIGIN = 0x0000, LENGTH = 0x7E00  # program flash memory
	.pram   (RWX) : ORIGIN = 0x7E00, LENGTH = 0x0200  # program ram memory
	.bflash (RX)  : ORIGIN = 0x8000, LENGTH = 0x0800  # boot flash memory
	.phole1 (RX)  : ORIGIN = 0x8800, LENGTH = 0x7800  # reserved program memory

	.avail  (RW)  : ORIGIN = 0x0000, LENGTH = 0x0030  # available
	.cwregs (RW)  : ORIGIN = 0x0030, LENGTH = 0x0010  # C temp registrs in CodeWarrior
	.data	  (RW)  : ORIGIN = 0x0040, LENGTH = 0x0660  # data
	.stack  (RW)  : ORIGIN = 0x06A0, LENGTH = 0x0160  # stack
	.dhole1 (R)   : ORIGIN = 0x0800, LENGTH = 0x0400  # the first internal memory hole
	.regs	  (RW)  : ORIGIN = 0x0C00, LENGTH = 0x0400  # periperal registers
	.xflash (R)   : ORIGIN = 0x1000, LENGTH = 0x1000  # data flash memory to place constant 
	                                                  # and initialized values for .data
	.dhole2 (R)   : ORIGIN = 0x2000, LENGTH = 0xDF80  # the second internal memory hole
	.onchip (RW)  : ORIGIN = 0xFF80, LENGTH = 0x0080  # on-chip core configuration registers

}


FORCE_ACTIVE {FconfigInterruptVector}

SECTIONS {
	
   # code section
   
	.main_application_program :
	{
		# .text sections
		
		#  config.c MUST be placed first, otherwise the Interrupt Vector
		#  configInterruptVector will not be located at the correct address, P:0x0000
		
		config.c (.text)
		* (.text)
		* (rtlib.text)
		* (fp_engine.text)
		* (user.text)
		
	} > .pflash

   
	.main_application_const :
	{
      #  Constant section 
      
	   # .data sections contains ONLY constant variables
	   
#		const.c (.data)
		
	} > .xflash

   
	.main_application_data : AT (ADDR(.xflash) + SIZEOF(.xflash) / 2)
	{
      # Sections contains initialized variables

		# Define variables for C initialization code
		
		F_Xdata_start_addr_in_ROM = ADDR(.xflash) + SIZEOF(.xflash) / 2;
		F_StackAddr               = ADDR(.stack);
		F_StackEndAddr            = ADDR(.stack) + SIZEOF(.stack) / 2  - 1;
		
		F_Xdata_start_addr_in_RAM = .;
		_DATA_ADDR = .;
							 		
      # .data sections 

		* (.data)
		* (fp_state.data)
		* (rtlib.data)

		F_Xdata_ROMtoRAM_length = . - _DATA_ADDR;

      # sections contains uninitialized variables
      
		# Define variables for C initialization code

		F_bss_start_addr = .;
		_BSS_ADDR = .;

      # .bss sections 
      
	  	* (rtlib.bss.lo)
		* (.bss)
		
		F_bss_length = . - _BSS_ADDR;
				
	} > .data

	FArchIO   = ADDR(.regs);
	FArchCore = ADDR(.onchip);
}
