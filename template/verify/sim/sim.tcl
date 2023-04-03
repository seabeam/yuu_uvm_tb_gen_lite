if {[info command verdiWindowRaise] == "verdiWindowRaise"} {
  puts "Running in Verdi mode"
  fsdbDumpvars 0 "{{ module }}_top" +all +trace_process
  checkpoint -add "init"
} elseif {[ucliGUI::guiActive]} {
  puts "Running in DVE mode"
  dump -add "{{ module }}_top" -depth 0
  checkpoint -add "init"
} else {
  puts "Running batch mode"
  run
}