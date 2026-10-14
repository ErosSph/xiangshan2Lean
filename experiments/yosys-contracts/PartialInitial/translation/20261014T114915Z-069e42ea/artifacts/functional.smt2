(declare-datatype T_Inputs
  (
    (T_Inputs
      (T_Inputs_clock (_ BitVec 1))
      (T_Inputs_en (_ BitVec 1)))))
(declare-datatype T_Outputs
  (
    (T_Outputs
      (T_Outputs_q (_ BitVec 4)))))
(declare-datatype T_State
  (
    (T_State
      (T_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 (_ BitVec 1))
      (T_State_$auto$clk2fflogic.cc_108_sample_data$4 (_ BitVec 4))
      (T_State_$auto$clk2fflogic.cc_108_sample_data$2 (_ BitVec 4)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun T ((inputs T_Inputs) (state T_State)) (Pair T_Outputs T_State)
  (let ((clock (T_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$2$_Q
      (T_State_$auto$clk2fflogic.cc_108_sample_data$2 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$4$_Q
      (T_State_$auto$clk2fflogic.cc_108_sample_data$4 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$6$_Q
      (T_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$6$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$8 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((q
      (ite
        (= $auto$rtlil.cc_3302_Eqx$8 #b1)
        $auto$clk2fflogic.cc_108_sample_data$4$_Q
        $auto$clk2fflogic.cc_108_sample_data$2$_Q))) ; (_ BitVec 4)
  (let ((n9 (concat #b0000000000000000000000000000 q))) ; (_ BitVec 32)
  (let (($1$_Y (bvadd n9 #b00000000000000000000000000000001))) ; (_ BitVec 32)
  (let ((n12 ((_ extract 3 0) $1$_Y))) ; (_ BitVec 4)
  (let ((en (T_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($procmux$1_Y (ite (= en #b1) n12 q))) ; (_ BitVec 4)
  (pair
    (T_Outputs
      q ; q
    )
    (T_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$6
      $procmux$1_Y ; $auto$clk2fflogic.cc:108:sample_data$4
      q ; $auto$clk2fflogic.cc:108:sample_data$2
    )))))))))))))))
(declare-const T-initial T_State)
(assert
  (= (T_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 T-initial) #b1))
(assert (= (T_State_$auto$clk2fflogic.cc_108_sample_data$4 T-initial) #b0000))
(assert (= (T_State_$auto$clk2fflogic.cc_108_sample_data$2 T-initial) #b1000))
