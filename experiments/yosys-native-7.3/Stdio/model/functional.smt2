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
      (Stdio_Outputs_c2l_effect_0_ARGS (_ BitVec 4))
      (Stdio_Outputs_c2l_effect_0_EN (_ BitVec 1))
      (Stdio_Outputs_c2l_effect_1_ARGS (_ BitVec 4))
      (Stdio_Outputs_c2l_effect_1_EN (_ BitVec 1)))))
(declare-datatype Stdio_State
  (
    (Stdio_State
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$18 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$30 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$12 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$10 (_ BitVec 4))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$8 (_ BitVec 4))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$24 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$36 (_ BitVec 1))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$22 (_ BitVec 4))
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$34 (_ BitVec 4)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Stdio
  ((inputs Stdio_Inputs) (state Stdio_State))
  (Pair Stdio_Outputs Stdio_State)
  (let ((clock (Stdio_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$8$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$8 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$10$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$10 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$12$_Q
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$12 state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$12$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$14 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((q
      (ite
        (= $auto$rtlil.cc_3302_Eqx$14 #b1)
        $auto$clk2fflogic.cc_108_sample_data$10$_Q
        $auto$clk2fflogic.cc_108_sample_data$8$_Q))) ; (_ BitVec 4)
  (let ((d (Stdio_Inputs_d inputs))) ; (_ BitVec 4)
  (let ((en (Stdio_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($procmux$1_Y (ite (= en #b1) d q))) ; (_ BitVec 4)
  (let (($4 (ite (= en #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($2 (ite (= en #b1) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_ARGS
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$22 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$24$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$24 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$18$_Q
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$18 state))) ; (_ BitVec 1)
  (let ((n18 (concat $auto$clk2fflogic.cc_92_sample_control_edge$18$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$25$_Y (ite (= n18 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_EN
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$24$_Q
        $auto$clk2fflogic.cc_261_execute$25$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_1_ARGS
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$34 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$36$_Q
      (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$36 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$30$_Q
      (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$30 state))) ; (_ BitVec 1)
  (let ((n24 (concat $auto$clk2fflogic.cc_92_sample_control_edge$30$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$37$_Y (ite (= n24 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_1_EN
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$36$_Q
        $auto$clk2fflogic.cc_261_execute$37$_Y))) ; (_ BitVec 1)
  (pair
    (Stdio_Outputs
      q ; q
      c2l_effect_0_ARGS ; c2l_effect_0_ARGS
      c2l_effect_0_EN ; c2l_effect_0_EN
      c2l_effect_1_ARGS ; c2l_effect_1_ARGS
      c2l_effect_1_EN ; c2l_effect_1_EN
    )
    (Stdio_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$18
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$30
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$12
      $procmux$1_Y ; $auto$clk2fflogic.cc:108:sample_data$10
      q ; $auto$clk2fflogic.cc:108:sample_data$8
      $4 ; $auto$clk2fflogic.cc:108:sample_data$24
      $2 ; $auto$clk2fflogic.cc:108:sample_data$36
      q ; $auto$clk2fflogic.cc:108:sample_data$22
      q ; $auto$clk2fflogic.cc:108:sample_data$34
    )))))))))))))))))))))))))))
(declare-const Stdio-initial Stdio_State)
(assert
  (=
    (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$18 Stdio-initial)
    #b1))
(assert
  (=
    (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$30 Stdio-initial)
    #b1))
(assert
  (=
    (Stdio_State_$auto$clk2fflogic.cc_92_sample_control_edge$12 Stdio-initial)
    #b1))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$10 Stdio-initial) #b0000))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$8 Stdio-initial) #b0000))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$24 Stdio-initial) #b0))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$36 Stdio-initial) #b0))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$22 Stdio-initial) #b0000))
(assert
  (= (Stdio_State_$auto$clk2fflogic.cc_108_sample_data$34 Stdio-initial) #b0000))
