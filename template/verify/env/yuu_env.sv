`ifndef {{ module.upper() }}_ENV_SV
`define {{ module.upper() }}_ENV_SV

class {{ module }}_env extends uvm_env;
  {{ module }}_config cfg;

  {{ module }}_driver       driver;
  {{ module }}_monitor      monitor;
  {{ module }}_collector    collector;
  {{ module }}_analyzer     analyzer;
  {% if 'reg_file_path' in global_info %}
  {{ module }}_predictor    predictor;
  {% endif %}
  {{ module }}_checker      checker;
  {{ module }}_virtual_sequencer  vsequencer;
  {% if 'reg_file_path' in global_info %}

  {{ module }}_reg_model reg_model;
  {% endif %}

  `uvm_component_utils({{ module }}_env)

  // Function declarations
  extern function      new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

  extern function void vip_build();
endclass

function {{ module }}_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void {{ module }}_env::build_phase(uvm_phase phase);
  if (!uvm_config_db#({{ module }}_config)::get(null, get_full_name(), "cfg", cfg) && cfg == null)
    `uvm_fatal("build_phase", "Cannot get configuration");

  vsequencer = {{ module }}_virtual_sequencer::type_id::create("vsequencer", this);
  vsequencer.cfg = cfg;

  monitor = {{ module }}_monitor::type_id::create("monitor", this);
  monitor.cfg = cfg;
  if (cfg.is_active == UVM_ACTIVE) begin
    driver = {{ module }}_driver::type_id::create("driver", this);
    driver.cfg = cfg;
  end
  if (cfg.coverage_enable) begin
    collector = {{ module }}_collector::type_id::create("collector", this);
    collector.cfg = cfg;
  end
  if (cfg.analysis_enable) begin
    analyzer = {{ module }}_analyzer::type_id::create("analyzer", this);
    analyzer.cfg = cfg;
  end
  if (cfg.checker_enable) begin
    checker = {{ module }}_checker::type_id::create("checker", this);
    checker.cfg = cfg;
  end
  {% if 'reg_file_path' in global_info %}
  if (cfg.reg_model_enable) begin
    predictor = new("predictor", this);

    reg_model = {{ module }}_reg_model::type_id::create("reg_model");
    reg_model.configure(null, "");
    reg_model.build();
    reg_model.lock_model();
    reg_model.reset();
  end
  {% endif %}
  vip_build();
endfunction

function void {{ module }}_env::connect_phase(uvm_phase phase);
  {% if 'reg_file_path' in global_info %}
  if (cfg.reg_model_enable) begin
    // reg_model.default_map.set_sequencer(sequencer, {{ module }}_adapter);
    // reg_model.default_map.set_auto_predict(0);
    // predictor.map = reg_model.get_default_map();
    // predictor.adapter = {{ module }}_adapter;
    vsequencer.reg_model = reg_model;
  end
  {% endif %}
endfunction

function void {{ module }}_env::vip_build();
endfunction

`endif
