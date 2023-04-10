`ifndef {{ module.upper() }}_SEQUENCE_PKG_SV
`define {{ module.upper() }}_SEQUENCE_PKG_SV

package {{ module }}_sequence_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import {{ module }}_pkg::*;

  class {{ module }}_sequence_base extends uvm_sequence #(uvm_sequence_item);
    // Data members
    virtual {{ module }}_interface vif;

    {{ module }}_config cfg;
    uvm_event_pool events;

    `uvm_object_utils_begin({{ module }}_sequence_base)
    `uvm_object_utils_end
    `uvm_declare_p_sequencer({{ module }}_virtual_sequencer)

    function new(string name="{{ module }}_sequence_base");
      super.new(name);
    endfunction

    virtual task pre_start();
      cfg = p_sequencer.cfg;
      vif = cfg.vif;
      events = cfg.events;
    endtask

    virtual task body();
      return;
    endtask
  endclass

  // Include sequence file here
endpackage

`endif