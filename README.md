# Automated-Sequence-Item-Generation-for-Different-Serial-Communication-Protocols

**A. Conversion script:** All the files are stored in excel_test folder

  _**Description:**_
    Conversion script named _excel.py_ can generate the UVM sequences from the spreadsheet.
    Input files are _can.xlsx_, _eth.xlsx_ and _uart.xlsx_.
    Output files are stored in the input name with the extension of svh. The output files are _can.svh_, _eth.svh_ and _uart.svh_ respectively.
    No specific tool license are required to run these modules.
    
_  **Steps to run:**_
    python <script_name.py> <spreadsheet_name>
    Example : python excel.py can.xlsx
  
**B. Basic Testbench and UVC:**

  _**Description:**_
     Basic UVC is  a universal verification component which implements the CAN protocol. Basic UVC is instantiated inside the Universal verification methodology test bench. 
     Basic UVC folder consists of two main sub folders, those are _src_ and _example_. src directory has the UVC related files like sequencer, driver, monitor, sequence_item and agent.
     example folder has the test bench related files which are env, test and top files. 
     Detailed description of the UVC and TB is captured in basic_uvc_readme document. The basic_uvc_readme document also details the simulation results and CAN protocol implementation.
     UVM is the methodology of system verilog language. All the codes in this modules are written in UVM, so EDA tools are required to compile/run this modules.
     Makefile for QUESTASIM EDA tool is provoided in example/run_ folder
     
  _**Steps to run:**_
      Go to the run folder. 
      make clean [ used to clean the compile/run time logs and the dumps from the simultion]
      make basic [to compile and run the basic uvc]
      
   _**Result analysis:**_
      comp.log is the compilation log, which tells us the errors present in the code.
      basic.log is used to store the simulation print messages.
      dump.wlf is used to dump the RTL signals.   

  **C. Variable UVC:**

  _**Description:**_
     Basic UVC is  a universal verification component which implements either CAN protocol or Ethernet protocol.  
     Here all the components and objects has both CAN and Ethernet members.
     One of the IPs got the values based on the agent configuration variable.
     Example : mode = 0 [CAN mode]; mode = 1[Ethernet mode].
     Simulated this module for both the modes in UVM methodology. 
     Detailed description of the variable UVC and TB is captured in variable_uvc_readme document along with simulation results. 
     Directory structure is same as the basic UVC method.
     
  _**Steps to run:**_ same as section B.
            
   _**Result analysis:**_ same as section B and detailed result analysis in variable_uvc_readme document.

**D. Override UVC:**

  _**Description:**_
     Override UVC is also same as varibale UVC. Base sequence item is the parent of all the items.
     CAN and Ethernet sequence items are coded by extending the parent sequence item.
     UVC is configured as either CAN or Ethernet by using override methods from UVM.  
     Here sequence item objects has both either CAN or Ethernet members based on the configuration.
     Detailed description of the variable UVC and TB is captured in override_uvc_readme document along with simulation results. 
     Directory structure is same as the basic UVC method.
     
  _**Steps to run:**_ same as section B.
            
   _**Result analysis:**_ same as section B and detailed result analysis in override_uvc_readme document. 

**E. Automated UVC**

 _**Description:**_
     User doesnot require to write the sequence items for each protocol manually. Time taken by the user to write a single sequence item based on the frame format is huge.
     Automated UVC reduces huge time, because user needs to fill only the spreadsheet based on the protocol's frame format.
     User can execute the script mentioned in section A and the output files needs to be copied inside the UVC i.e. src folder.
          
  _**Steps to run:**_ same as section B.
            
   _**Result analysis:**_ same as section B and detailed result analysis in automated_uvc_readme document. 



  
  

  

  

  
