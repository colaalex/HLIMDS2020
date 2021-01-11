import fpu_agent_pkg::*;

class fpu_test_neg_sqr_sequence extends fpu_test_base;
`ovm_component_utils(fpu_test_neg_sqr_sequence)
  fpu_sequence_neg_sqr s_seq; // The sequence to execute

function new(string name = "fpu_test_neg_sqr_sequence", ovm_component parent=null);
      super.new(name, parent);
endfunction // new


function void build();
      //set_config_int("*sequencer", "count", 0);
      // create the main sequence
      s_seq = fpu_sequence_neg_sqr::type_id::create("s_seq");
      super.build();
endfunction // new

virtual task run;
      int timeout = `TIMEOUT;
      fork : thread_fpu_neg_sqr
      	s_seq.start(seqr_handle, null);
      	#timeout;
      join_any
      ovm_report_info(get_type_name(), "Stopping test...", OVM_LOW );      
      global_stop_request();
endtask

endclass
