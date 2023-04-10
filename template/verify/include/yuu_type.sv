{% from 'global.j2' import get_item with context %}
`ifndef {{ module.upper() }}_TYPE_SV
`define {{ module.upper() }}_TYPE_SV

  {% if 'reg_file_path' in global_info %}
  typedef ral_block_{{  module }} {{ module }}_reg_model;
  {% endif %}
  {% if 'reg_prot_type' in global_info %}
  typedef uvm_reg_predictor #({{ get_item(global_info['use_item']) }}) {{ module }}_predictor;
  {% endif %}

`endif
