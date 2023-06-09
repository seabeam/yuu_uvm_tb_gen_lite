{% from 'global.j2' import get_item with context -%}
`ifndef {{ module.upper() }}_CALLBACKS_SV
`define {{ module.upper() }}_CALLBACKS_SV

typedef class {{ module }}_driver;
typedef class {{ module }}_monitor;

class {{ module }}_driver_callback extends uvm_callback;
  `uvm_object_utils({{ module }}_driver_callback)

  function new(string name="{{ module }}_driver_callback");
    super.new(name);
  endfunction

  virtual task pre_send({{ module }}_driver driver, {{ get_item(global_info['use_item']) }} item);
  endtask

  virtual task post_send({{ module }}_driver driver, {{ get_item(global_info['use_item']) }} item);
  endtask
endclass


class {{ module }}_monitor_callback extends uvm_callback;
  `uvm_object_utils({{ module }}_monitor_callback)

  function new(string name="{{ module }}_monitor_callback");
    super.new(name);
  endfunction

  virtual task pre_collect({{ module }}_monitor monitor, {{ get_item(global_info['use_item']) }} item);
  endtask

  virtual task post_collect({{ module }}_monitor monitor, {{ get_item(global_info['use_item']) }} item);
  endtask
endclass

`endif