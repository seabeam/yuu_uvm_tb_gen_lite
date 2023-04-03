`ifndef {{ module.upper() }}_COVERAGE_SV
`define {{ module.upper() }}_COVERAGE_SV

class {{ module }}_coverage extends uvm_object;
  `uvm_object_utils({{ module }}_coverage)

  // TODO: add your functional coverage here

  function new(string name = "{{ module }}_coverage");
    super.new(name);
  endfunction
endclass

`endif