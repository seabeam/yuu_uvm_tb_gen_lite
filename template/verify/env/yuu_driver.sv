{% from 'global.j2' import get_item with context -%}
`ifndef {{ module.upper() }}_DRIVER_SV
`define {{ module.upper() }}_DRIVER_SV

class {{ module }}_driver extends uvm_driver #({{ get_item(global_info['use_item']) }});
  // Data members
  virtual {{ module }}_interface vif;
  uvm_analysis_port #({{ get_item(global_info['use_item']) }}) out_driver_ap;

  {{ module }}_config cfg;
  uvm_event_pool events;

  `uvm_register_cb({{ module }}_driver, {{ module }}_driver_callback)

  `uvm_component_utils_begin({{ module }}_driver)
  `uvm_component_utils_end

  // Function declarations
  extern         function      new(string name, uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);

  extern virtual task          send();
endclass

function {{ module }}_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void {{ module }}_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  out_driver_ap = new("out_driver_ap", this);
endfunction

function void {{ module }}_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  this.vif = cfg.vif;
  this.events = cfg.events;
endfunction

task {{ module }}_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);

  send();
endtask

task {{ module }}_driver::send();
endtask

`endif