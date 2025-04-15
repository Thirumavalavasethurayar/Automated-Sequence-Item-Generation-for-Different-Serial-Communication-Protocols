# Reading an excel file using Python 
import xlrd 
import sys
  

if len(sys.argv) == 1 :
  sys.exit(" Enter the Excel name")
# Give the location of the file 
# loc = ("/home/users/tpoongunran/Research/multiple_uvc_frame_code/excel_test/%s"%str(sys.argv[1])) 
loc = ("D:\PhD\Mchp lnx\Research\multiple_uvc_frame_code\excel_test\%s"%str(sys.argv[1])) 
fl_name = str(sys.argv[1]).split('.')
append_name = "_txn.svh"
f_name = fl_name[0]+append_name
f = open(f_name, "w")
f.write("`ifndef %s_TXN__SVH\n"%fl_name[0].upper())
f.write("`define %s_TXN__SVH\n\n"%fl_name[0].upper())

# To open Workbook 
wb = xlrd.open_workbook(loc) 
sheet = wb.sheet_by_index(0) 
  
f.write("class %s_txn extends basic_txn; \n"%fl_name[0])
f.write("\n")
for i in range(sheet.nrows):
  if str(sheet.cell_value(i, 2)) == "byte" :
     max_range = ''
  else :   
     if int(sheet.cell_value(i, 1)) != 1 :
       max_range = "[%s:0]"%str(int(sheet.cell_value(i, 1) -1))
     else  :  
       max_range = ''
  if str(sheet.cell_value(i, 7)) == "DA" :
     array_symbol = []
  else :   
     array_symbol =  ''
  f.write("\t%s\t%s\t%s\t\t\t\t\t%s%s;\n"%(str(sheet.cell_value(i, 6)),str(sheet.cell_value(i, 2)),str(max_range),str(sheet.cell_value(i, 0)),str(array_symbol)))
f.write("\n\t`uvm_object_utils_begin(%s_txn)\n"%fl_name[0])
for i in range(sheet.nrows):
  if str(sheet.cell_value(i, 8)) == "Factory" :
     if str(sheet.cell_value(i, 3)) == "pack" :
       pack_status = "|UVM_NOPACK"
     else :   
       pack_status = "|UVM_NOPACK"
     if str(sheet.cell_value(i, 7)) == "DA" :
        f.write("\t\t`uvm_field_array_int(%s,UVM_ALL_ON%s)\n"%(str(sheet.cell_value(i, 0)),str(pack_status)))
     else:   
        f.write("\t\t`uvm_field_int(%s,UVM_ALL_ON%s)\n"%(str(sheet.cell_value(i, 0)),str(pack_status)))
f.write("\t`uvm_object_utils_end\n")
f.write("\n")

for i in range(sheet.nrows):
  if str(sheet.cell_value(i, 7)) == "DA" :
    try:
      z1_name = str(int(sheet.cell_value(i, 9)))
    except : 
      z1_name = str(sheet.cell_value(i, 9))
    f.write('\t constraint c_%s_size {%s.size()==%s;}\n'%(str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0)),z1_name))
    if str(sheet.cell_value(i, 11)) != "" :
      f.write('\t constraint c_%s_i {foreach(%s[i]) %s[i]==%s;}\n'%(str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 11))))
  if str(sheet.cell_value(i, 10)) != "" :
    t1_name = str(sheet.cell_value(i, 10)).split(';')
    for j in range(len(t1_name)):
      if(len(t1_name[j].split('=>')) == 1):
        if(len(t1_name[j].split(':')) != 1):
          f.write('\t constraint c_%s_%s {%s inside {[%s]};}\n'%(str(sheet.cell_value(i, 0)),str(j),str(sheet.cell_value(i, 0)),str(t1_name[j])))
        elif(len(t1_name[j].split(',')) != 1):
          f.write('\t constraint c_%s_%s {%s inside {%s};}\n'%(str(sheet.cell_value(i, 0)),str(j),str(sheet.cell_value(i, 0)),str(t1_name[j])))
        elif(len(t1_name[j].split('<=')) != 1):
          f.write('\t constraint c_%s_%s {%s %s;}\n'%(str(sheet.cell_value(i, 0)),str(j),str(sheet.cell_value(i, 0)),str(t1_name[j])))
        elif(len(t1_name[j].split('<')) != 1):
          f.write('\t constraint c_%s_%s {%s %s;}\n'%(str(sheet.cell_value(i, 0)),str(j),str(sheet.cell_value(i, 0)),str(t1_name[j])))
        elif(len(t1_name[j].split('>=')) != 1):
          f.write('\t constraint c_%s_%s {%s %s;}\n'%(str(sheet.cell_value(i, 0)),str(j),str(sheet.cell_value(i, 0)),str(t1_name[j])))
        elif(len(t1_name[j].split('>')) != 1):
          f.write('\t constraint c_%s_%s {%s %s;}\n'%(str(sheet.cell_value(i, 0)),str(j),str(sheet.cell_value(i, 0)),str(t1_name[j])))
        else :  
          f.write('\t constraint c_%s_%s {%s == %s;}\n'%(str(sheet.cell_value(i, 0)),str(j),str(sheet.cell_value(i, 0)),str(t1_name[j])))
      else:    
        t2_name = t1_name[j].split('=>') 
        t_name = t2_name[0].split(':')
        t3_name = t_name[1].split(']')
        if(len(t2_name[1].split(':')) != 1):
          f.write('\t constraint c_%s_%s {%s[%s] inside {[%s]};}\n'%(str(sheet.cell_value(i, 0)),str(t3_name[0]),str(sheet.cell_value(i, 0)),str(t2_name[0]),str(t2_name[1])))
        elif(len(t2_name[1].split(',')) != 1):
          f.write('\t constraint c_%s_%s {%s[%s] inside {%s};}\n'%(str(sheet.cell_value(i, 0)),str(t3_name[0]),str(sheet.cell_value(i, 0)),str(t2_name[0]),str(t2_name[1])))
        elif(len(t2_name[1].split('<=')) != 1):
          f.write('\t constraint c_%s_%s {%s[%s] %s;}\n'%(str(sheet.cell_value(i, 0)),str(t3_name[0]),str(sheet.cell_value(i, 0)),str(t2_name[0]),str(t2_name[1])))
        elif(len(t2_name[1].split('<')) != 1):
          f.write('\t constraint c_%s_%s {%s[%s] %s;}\n'%(str(sheet.cell_value(i, 0)),str(t3_name[0]),str(sheet.cell_value(i, 0)),str(t2_name[0]),str(t2_name[1])))
        elif(len(t2_name[1].split('>=')) != 1):
          f.write('\t constraint c_%s_%s {%s[%s] %s;}\n'%(str(sheet.cell_value(i, 0)),str(t3_name[0]),str(sheet.cell_value(i, 0)),str(t2_name[0]),str(t2_name[1])))
        elif(len(t2_name[1].split('>')) != 1):
          f.write('\t constraint c_%s_%s {%s[%s] %s;}\n'%(str(sheet.cell_value(i, 0)),str(t3_name[0]),str(sheet.cell_value(i, 0)),str(t2_name[0]),str(t2_name[1])))
        else : 
          f.write('\t constraint c_%s_%s {%s[%s] ==    %s;}\n'%(str(sheet.cell_value(i, 0)),str(t3_name[0]),str(sheet.cell_value(i, 0)),str(t2_name[0]),str(t2_name[1])))

f.write("\n")

f.write('\tfunction new (string name = "%s_txn");\n\t\tsuper.new(name);\n\tendfunction:new\n'%fl_name[0])
f.write('\n\tfunction void do_pack (uvm_packer packer);\n\t\tsuper.do_pack(packer);\n')
for i in range(sheet.nrows):
  if str(sheet.cell_value(i, 3)) == "pack" :
     if str(sheet.cell_value(i, 7)) == "DA" :
        f.write("\t\tforeach(%s[i])\n\t\t\tpacker.pack_field_int(%s[i],%s);\n"%(str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0)),str(int(sheet.cell_value(i, 1)))))
     else :   
        f.write("\t\tpacker.pack_field_int(%s,$bits(%s));\n"%(str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0))))
f.write('\tendfunction : do_pack \n')

f.write('\n\tfunction void do_unpack (uvm_packer packer);\n\t\tsuper.do_unpack(packer);\n')
for i in range(sheet.nrows):
  if str(sheet.cell_value(i, 4)) == "unpack" :
     if str(sheet.cell_value(i, 7)) == "DA" :
        try:
          z_name = str(int(sheet.cell_value(i, 9)))
        except : 
          z_name = str(sheet.cell_value(i, 9))
        f.write("\t\t%s.delete();\n\t\t%s = new[%s];\n"%(str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0)),z_name))
        f.write("\t\tforeach(%s[i])\n\t\t\t%s[i] = packer.unpack_field_int(%s);\n"%(str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0)),str(int(sheet.cell_value(i, 1)))))
     else :   
        f.write("\t\t%s = packer.unpack_field_int($bits(%s));\n"%(str(sheet.cell_value(i, 0)),str(sheet.cell_value(i, 0))))
f.write('\tendfunction : do_unpack \n')

f.write("\nendclass : %s_txn \n"%fl_name[0])
# For row 0 and column 0 
f.write("\n`endif //%s_TXN__SVH"%fl_name[0].upper())
#f.write("Woops! I have deleted the content!")
f.close()
