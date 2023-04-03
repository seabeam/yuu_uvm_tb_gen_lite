`ifndef {{ module.upper() }}_ITEM_SV
`define {{ module.upper() }}_ITEN_SV

class {{ module }}_item extends uvm_sequence_item;
  `uvm_object_utils({{ module }}_item)

  function new(string name = "{{ module }}_item");
    super.new(name);
  endfunction
endclass

`endif