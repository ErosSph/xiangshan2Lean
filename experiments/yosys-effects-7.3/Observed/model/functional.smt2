(declare-datatype Observed_Inputs
  (
    (Observed_Inputs
      (Observed_Inputs_reset (_ BitVec 1))
      (Observed_Inputs_clock (_ BitVec 1))
      (Observed_Inputs_en (_ BitVec 1))
      (Observed_Inputs_d (_ BitVec 4))
      (Observed_Inputs_expected (_ BitVec 4))
      (Observed_Inputs_c2l_undefined_0 (_ BitVec 4)))))
(declare-datatype Observed_Outputs
  (
    (Observed_Outputs
      (Observed_Outputs_q (_ BitVec 4))
      (Observed_Outputs_c2l_effect_0_enable (_ BitVec 1))
      (Observed_Outputs_c2l_effect_0_condition (_ BitVec 1))
      (Observed_Outputs_c2l_effect_1_enable (_ BitVec 1))
      (Observed_Outputs_c2l_effect_1_arguments (_ BitVec 8))
      (Observed_Outputs_c2l_effect_2_enable (_ BitVec 1))
      (Observed_Outputs_c2l_effect_2_condition (_ BitVec 1))
      (Observed_Outputs_c2l_effect_3_enable (_ BitVec 1))
      (Observed_Outputs_c2l_effect_3_condition (_ BitVec 1)))))
(declare-datatype Observed_State
  (
    (Observed_State
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$2
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$16
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$28
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$42
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$60
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$58 (_ BitVec 4))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$56 (_ BitVec 4))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$8 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$22 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$34 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$48 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$14 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$20 (_ BitVec 8))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$40 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$54 (_ BitVec 1)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Observed
  ((inputs Observed_Inputs) (state Observed_State))
  (Pair Observed_Outputs Observed_State)
  (let ((clock (Observed_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$56$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$56 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$58$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$58 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$60$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$60 state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$60$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$62 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((q
      (ite
        (= $auto$rtlil.cc_3302_Eqx$62 #b1)
        $auto$clk2fflogic.cc_108_sample_data$58$_Q
        $auto$clk2fflogic.cc_108_sample_data$56$_Q))) ; (_ BitVec 4)
  (let ((d (Observed_Inputs_d inputs))) ; (_ BitVec 4)
  (let ((en (Observed_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($procmux$1$_Y (ite (= en #b1) d q))) ; (_ BitVec 4)
  (let ((c2l_undefined_0 (Observed_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 4)
  (let ((reset_0 (Observed_Inputs_reset inputs))) ; (_ BitVec 1)
  (let (($procmux$4$_Y (ite (= reset_0 #b1) c2l_undefined_0 $procmux$1$_Y))) ; (_ BitVec 4)
  (let (($procmux$8_Y (ite (= reset_0 #b1) #b0000 $procmux$4$_Y))) ; (_ BitVec 4)
  (let (($3$_Y (bvnot reset_0))) ; (_ BitVec 1)
  (let (($11 (ite (= $3$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($14 (ite (= $3$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($5 (ite (= $3$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($8 (ite (= $3$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let ((n24 (concat #b0000000000000000000000000000 q))) ; (_ BitVec 32)
  (let (($12y (ite (= n24 #b00000000000000000000000000000011) #b1 #b0))) ; (_ BitVec 1)
  (let ((n27 (concat d q))) ; (_ BitVec 8)
  (let ((expected (Observed_Inputs_expected inputs))) ; (_ BitVec 4)
  (let (($6y (ite (= q expected) #b1 #b0))) ; (_ BitVec 1)
  (let ((n31 (concat #b0000000000000000000000000000 d))) ; (_ BitVec 32)
  (let (($9y (ite (bvugt #b00000000000000000000000000001100 n31) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$8$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$8 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$2$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$2 state))) ; (_ BitVec 1)
  (let ((n35 (concat $auto$clk2fflogic.cc_92_sample_control_edge$2$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$9$_Y (ite (= n35 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_enable
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$8$_Q
        $auto$clk2fflogic.cc_261_execute$9$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_condition
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$14 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$22$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$22 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$16$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$16 state))) ; (_ BitVec 1)
  (let ((n41 (concat $auto$clk2fflogic.cc_92_sample_control_edge$16$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$23$_Y (ite (= n41 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_1_enable
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$22$_Q
        $auto$clk2fflogic.cc_261_execute$23$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_1_arguments
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$20 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$34$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$34 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$28$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$28 state))) ; (_ BitVec 1)
  (let ((n47 (concat $auto$clk2fflogic.cc_92_sample_control_edge$28$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$35$_Y (ite (= n47 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_2_enable
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$34$_Q
        $auto$clk2fflogic.cc_261_execute$35$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_2_condition
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$40 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$48$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$48 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$42$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$42 state))) ; (_ BitVec 1)
  (let ((n53 (concat $auto$clk2fflogic.cc_92_sample_control_edge$42$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$49$_Y (ite (= n53 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_3_enable
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$48$_Q
        $auto$clk2fflogic.cc_261_execute$49$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_3_condition
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$54 state))) ; (_ BitVec 1)
  (pair
    (Observed_Outputs
      q ; q
      c2l_effect_0_enable ; c2l_effect_0_enable
      c2l_effect_0_condition ; c2l_effect_0_condition
      c2l_effect_1_enable ; c2l_effect_1_enable
      c2l_effect_1_arguments ; c2l_effect_1_arguments
      c2l_effect_2_enable ; c2l_effect_2_enable
      c2l_effect_2_condition ; c2l_effect_2_condition
      c2l_effect_3_enable ; c2l_effect_3_enable
      c2l_effect_3_condition ; c2l_effect_3_condition
    )
    (Observed_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$2
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$16
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$28
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$42
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$60
      $procmux$8_Y ; $auto$clk2fflogic.cc:108:sample_data$58
      q ; $auto$clk2fflogic.cc:108:sample_data$56
      $11 ; $auto$clk2fflogic.cc:108:sample_data$8
      $14 ; $auto$clk2fflogic.cc:108:sample_data$22
      $5 ; $auto$clk2fflogic.cc:108:sample_data$34
      $8 ; $auto$clk2fflogic.cc:108:sample_data$48
      $12y ; $auto$clk2fflogic.cc:108:sample_data$14
      n27 ; $auto$clk2fflogic.cc:108:sample_data$20
      $6y ; $auto$clk2fflogic.cc:108:sample_data$40
      $9y ; $auto$clk2fflogic.cc:108:sample_data$54
    )))))))))))))))))))))))))))))))))))))))))))))))))))))
(declare-const Observed-initial Observed_State)
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$2
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$16
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$28
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$42
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$60
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$58 Observed-initial)
    #b0000))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$56 Observed-initial)
    #b0000))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$8 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$22 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$34 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$48 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$14 Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$20 Observed-initial)
    #b00000000))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$40 Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$54 Observed-initial)
    #b1))
