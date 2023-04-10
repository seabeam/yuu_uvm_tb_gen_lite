`ifndef {{ module.upper() }}_TEST_PKG_SV
`define {{ module.upper() }}_TEST_PKG_SV

package {{ module }}_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import {{ module }}_pkg::*;
  import {{ module }}_sequence_pkg::*;

  `include "{{ module }}_base_test.sv"
endpackage

`endif
