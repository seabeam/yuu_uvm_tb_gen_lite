`ifndef {{ module.upper() }}_PKG_SV
`define {{ module.upper() }}_PKG_SV

`include "{{ module }}_defines.svh"
`include "{{ module }}_interface.svi"

package {{ module }}_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  {% if 'reg_file_path' in global_info %}

  `include "{{ module }}_ral.sv"
  {% endif %}

  `include "{{ module }}_type.sv"
  `include "{{ module }}_config.sv"
  {% if global_info['use_item'] %}
  `include "{{ module }}_item.sv"
  {% endif %}
  `include "{{ module }}_coverage.sv"
  `include "{{ module }}_callbacks.sv"
  `include "{{ module }}_driver.sv"
  `include "{{ module }}_monitor.sv"
  `include "{{ module }}_analyzer.sv"
  `include "{{ module }}_collector.sv"
  `include "{{ module }}_checker.sv"
  `include "{{ module }}_virtual_sequencer.sv"
  `include "{{ module }}_env.sv"
endpackage

`endif
