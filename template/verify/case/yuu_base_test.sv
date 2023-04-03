`ifndef {{ module.upper() }}_BASE_TEST_SV
`define {{ module.upper() }}_BASE_TEST_SV

class {{ module }}_base_test extends uvm_test;
  {{ module }}_config cfg;
  {{ module }}_virtual_sequencer vsequencer;
  {{ module }}_env env;

  `uvm_component_utils({{ module }}_base_test)

  // Function declarations
  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

  extern function void set_cfg(ref {{ module }}_config cfg);
endclass

function {{ module }}_base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void {{ module }}_base_test::build_phase(uvm_phase phase);
  cfg = {{ module }}_config::type_id::create("cfg");
  env = {{ module }}_env::type_id::create("env", this);

  if (!uvm_config_db#(virtual {{ module }}_interface)::get(null, get_full_name(), "vif", cfg.vif))
    `uvm_fatal("build_phase", "Cannot get virtual interface");
  set_cfg(cfg);
  env.cfg = cfg;
endfunction

function void {{ module }}_base_test::connect_phase(uvm_phase phase);
  vsequencer = env.vsequencer;
endfunction

function void {{ module }}_base_test::set_cfg(ref {{ module }}_config cfg);
endfunction

`endif
