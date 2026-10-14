(declare-datatype Chisel2LeanReference_Inputs
  (
    (Chisel2LeanReference_Inputs
      (Chisel2LeanReference_Inputs_clock (_ BitVec 1))
      (Chisel2LeanReference_Inputs_reset (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_0 (_ BitVec 1)))))
(declare-datatype Chisel2LeanReference_Outputs
  (
    (Chisel2LeanReference_Outputs
      (Chisel2LeanReference_Outputs_c2l_port_1 (_ BitVec 4)))))
(declare-datatype Chisel2LeanReference_State
  (
    (Chisel2LeanReference_State
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$4
        (_ BitVec 4))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$2
        (_ BitVec 4)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Chisel2LeanReference
  ((inputs Chisel2LeanReference_Inputs) (state Chisel2LeanReference_State))
  (Pair Chisel2LeanReference_Outputs Chisel2LeanReference_State)
  (let ((clock (Chisel2LeanReference_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$2$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$2 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$4$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$4 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$6$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
        state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$6$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$8 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_port_1
      (ite
        (= $auto$rtlil.cc_3302_Eqx$8 #b1)
        $auto$clk2fflogic.cc_108_sample_data$4$_Q
        $auto$clk2fflogic.cc_108_sample_data$2$_Q))) ; (_ BitVec 4)
  (let
    (($flatten_Counter.$add$/work/design.v_14$2$_Y (bvadd c2l_port_1 #b0001))) ; (_ BitVec 4)
  (let ((c2l_port_0 (Chisel2LeanReference_Inputs_c2l_port_0 inputs))) ; (_ BitVec 1)
  (let
    (($flatten_Counter.$procmux$3$_Y
      (ite
        (= c2l_port_0 #b1)
        $flatten_Counter.$add$/work/design.v_14$2$_Y
        c2l_port_1))) ; (_ BitVec 4)
  (let ((reset_0 (Chisel2LeanReference_Inputs_reset inputs))) ; (_ BitVec 1)
  (let
    (($flatten_Counter.$0_cnt_3_0_
      (ite (= reset_0 #b1) #b0000 $flatten_Counter.$procmux$3$_Y))) ; (_ BitVec 4)
  (pair
    (Chisel2LeanReference_Outputs
      c2l_port_1 ; c2l_port_1
    )
    (Chisel2LeanReference_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$6
      $flatten_Counter.$0_cnt_3_0_ ; $auto$clk2fflogic.cc:108:sample_data$4
      c2l_port_1 ; $auto$clk2fflogic.cc:108:sample_data$2
    )))))))))))))))
(declare-const Chisel2LeanReference-initial Chisel2LeanReference_State)
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$4
      Chisel2LeanReference-initial)
    #b0000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$2
      Chisel2LeanReference-initial)
    #b0000))
