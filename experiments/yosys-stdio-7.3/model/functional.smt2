(declare-datatype Stdio_Inputs
  (
    (Stdio_Inputs
      (Stdio_Inputs_clock (_ BitVec 1))
      (Stdio_Inputs_en (_ BitVec 1))
      (Stdio_Inputs_d (_ BitVec 4)))))
(declare-datatype Stdio_Outputs
  (
    (Stdio_Outputs
      (Stdio_Outputs_q (_ BitVec 4))
      (Stdio_Outputs_c2l_effect_0_enable (_ BitVec 1))
      (Stdio_Outputs_c2l_effect_0_arguments (_ BitVec 4))
      (Stdio_Outputs_c2l_effect_1_enable (_ BitVec 1))
      (Stdio_Outputs_c2l_effect_1_arguments (_ BitVec 4)))))
(declare-datatype Stdio_State
  (
    (Stdio_State
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$2 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$14 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$30 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$28 (_ BitVec 4))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$26 (_ BitVec 4))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$8 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$20 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$6 (_ BitVec 4))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$18 (_ BitVec 4)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Stdio
  ((inputs Stdio_Inputs) (state Stdio_State))
  (Pair Stdio_Outputs Stdio_State)
  (let ((clock (Stdio_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$26$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$26 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$28$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$28 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$30$_Q
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$30 state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$30$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$32 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((q
      (ite
        (= $auto$rtlil.cc_3302_Eqx$32 #b1)
        $auto$clk2fflogic.cc_108_sample_data$28$_Q
        $auto$clk2fflogic.cc_108_sample_data$26$_Q))) ; (_ BitVec 4)
  (let ((d (Stdio_Inputs_d inputs))) ; (_ BitVec 4)
  (let ((en (Stdio_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($procmux$1_Y (ite (= en #b1) d q))) ; (_ BitVec 4)
  (let (($2 (ite (= en #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($4 (ite (= en #b1) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$8$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$8 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$2$_Q
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$2 state))) ; (_ BitVec 1)
  (let ((n17 (concat $auto$clk2fflogic.cc_92_sample_control_edge$2$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$9$_Y (ite (= n17 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_enable
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$8$_Q
        $auto$clk2fflogic.cc_261_execute$9$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_arguments
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$6 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$20$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$20 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$14$_Q
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$14 state))) ; (_ BitVec 1)
  (let ((n23 (concat $auto$clk2fflogic.cc_92_sample_control_edge$14$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$21$_Y (ite (= n23 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_1_enable
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$20$_Q
        $auto$clk2fflogic.cc_261_execute$21$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_1_arguments
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$18 state))) ; (_ BitVec 4)
  (pair
    (Stdio_Outputs
      q ; q
      c2l_effect_0_enable ; c2l_effect_0_enable
      c2l_effect_0_arguments ; c2l_effect_0_arguments
      c2l_effect_1_enable ; c2l_effect_1_enable
      c2l_effect_1_arguments ; c2l_effect_1_arguments
    )
    (Stdio_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$2
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$14
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$30
      $procmux$1_Y ; $auto$clk2fflogic.cc:108:sample_data$28
      q ; $auto$clk2fflogic.cc:108:sample_data$26
      $2 ; $auto$clk2fflogic.cc:108:sample_data$8
      $4 ; $auto$clk2fflogic.cc:108:sample_data$20
      q ; $auto$clk2fflogic.cc:108:sample_data$6
      q ; $auto$clk2fflogic.cc:108:sample_data$18
    )))))))))))))))))))))))))))
(declare-const Stdio-initial Stdio_State)
(assert
  (=
    (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$2 Stdio-initial)
    #b1))
(assert
  (=
    (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$14 Stdio-initial)
    #b1))
(assert
  (=
    (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$30 Stdio-initial)
    #b1))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$28 Stdio-initial) #b0000))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$26 Stdio-initial) #b0000))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$8 Stdio-initial) #b0))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$20 Stdio-initial) #b0))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$6 Stdio-initial) #b0000))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$18 Stdio-initial) #b0000))
