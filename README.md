# yuu_tb_gen
Lightweight common UVM TB generator

## Useage
It's recommand to add the script bin folder to your $PATH environment 
variable if the first time to use the script.

yuu_tb_gen.py [OPTION] [TB config file ...]

optional arguments:  
　-h, --help            show this help message and exit  
　-i                    [Required] TB config file in TOML format

## TB config file format
A TOML format configuration file in used. Here is an example:

```
[global]
# Target module name in DUT source file
in_name = 'example_wrap'

# Generated module name in TB
out_name = 'example'

# Target DUT source file path
dut_path = './example_wrap.sv'

# TB output path
out_path = '$HOME/workspace/git/yuu_uvm_tb_gen_lite/test'

# Has module specific transaction
use_item = true
```

Only one group named "global" in used now, and it'a also a REQUIRED group name.

in_name : The module name of DUT file, which used for auto-connection (TODO)

out_name : The output name of TB, will be the generated UVC class prefix and 
           source file prefix

dut_path : DUT source file location(TODO)

out_path : The location which the TB will be generated. Can used environment 
           variable. The absolute path is preferred, a relative path may leading 
           a compile error.

use_item : Self-defined transaction in used if true, uvm_sequence_item otherwise

reg_file_path : The register defined file use to generate UVM register model (TODO)
