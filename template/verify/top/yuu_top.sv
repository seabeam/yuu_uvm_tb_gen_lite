{% from 'global.j2' import gen_vip_vif, set_vip_vif %}
`ifndef {{ module.upper() }}_TOP_SV
`define {{ module.upper() }}_TOP_SV

module {{ module }}_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import {{ module }}_test_pkg::*;

  {{ module }}_interface {{ module }}_if();
  {% if vip_info != {} %}

    {% for prot in vip_info %}
      {% for agt in vip_info[prot] %}
  {{ gen_vip_vif(prot, agt, vip_info[prot][agt] | length) }}
      {%- endfor %}
    {% endfor %}
  {% endif %}

  initial begin
    uvm_config_db#(virtual {{ module }}_interface)::set(null, "uvm_test_top", "vif", {{ module }}_if);
  {% if vip_info != {} %}
    {% for prot in vip_info %}
      {% for agt in vip_info[prot] %}
    {{ set_vip_vif(prot, agt, vip_info[prot][agt] | length) }}
      {%- endfor %}
    {% endfor %}
  {% endif %}
    run_test();
  end
endmodule

`endif