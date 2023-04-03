`ifndef {{ module.upper() }}_VIRTUAL_SEQUENCER_SV
`define {{ module.upper() }}_VIRTUAL_SEQUENCER_SV

class {{ module }}_virtual_sequencer extends uvm_virtual_sequencer;
  // Data members
  virtual {{ module }}_interface vif;

  {{ module }}_config cfg;
  uvm_event_pool events;
  {% if 'reg_file_path' in global_info %}
  {{ module }}_reg_model reg_model;
  {% endif %}

  `uvm_component_utils({{ module }}_virtual_sequencer)

  // Function declarations
  extern function      new(string name, uvm_component parent);
  extern function void connect_phase(uvm_phase phase);
endclass : {{ module }}_virtual_sequencer

function {{ module }}_virtual_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void {{ module }}_virtual_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (cfg == null)
    `uvm_fatal("connect_phase", "Virtual sequencer cannot get env configuration object")

  vif = cfg.vif;
  events = cfg.events;
endfunction

`endif
