`ifndef {{ module.upper() }}_CONFIG_SV
`define {{ module.upper() }}_CONFIG_SV

// Class: {{ module }}_config
// Configuration object of {{ module }}, which to control TB building or
// share message between TB component
class {{ module }}_config extends uvm_object;
  // Variable: is_active
  // To control agent to active or non-active
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Variable: vif
  // Virtual interface handle of {{ module }}
  virtual {{ module }}_interface vif;

  // Variable: events
  // Events for components communication
  uvm_event_pool events;

  // Variable: timeout
  // TB timeout value
  int timeout = 1000;

  // Variable: coverage_enable
  // Switch of enable/disable functional coverage collector
  bit coverage_enable = 1'b0;

  // Variable: analysis_enable
  // Switch of enable/disable performance analyzer
  bit analysis_enable = 1'b0;

  // Variable: checker_enable
  // Switch of enable/disable checker
  bit checker_enable = 1'b1;
  {% if 'reg_file_path' in global_info %}

  // Variable: reg_model_enable
  // Switch of enable/disable register model
  bit reg_model_enable = 1'b1;
  {% endif %}

  `uvm_object_utils_begin({{ module }}_config)
    `uvm_field_int (timeout, UVM_PRINT | UVM_COPY)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_PRINT | UVM_COPY)
    `uvm_field_int(coverage_enable, UVM_PRINT | UVM_COPY)
    `uvm_field_int(analysis_enable, UVM_PRINT | UVM_COPY)
    `uvm_field_int(checker_enable, UVM_PRINT | UVM_COPY)
    {% if 'reg_file_path' in global_info %}
    `uvm_field_int(reg_model_enable, UVM_PRINT | UVM_COPY)
    {% endif %}
  `uvm_object_utils_end

  extern function new(string name="{{ module }}_config");
endclass

// Function: new
// Allocate object
function {{ module }}_config::new(string name="{{ module }}_config");
  super.new(name);

  events = new("events");
endfunction

`endif
