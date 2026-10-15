(declare-datatype Observed_Inputs
  (
    (Observed_Inputs
      (Observed_Inputs_reset (_ BitVec 1))
      (Observed_Inputs_clock (_ BitVec 1))
      (Observed_Inputs_en (_ BitVec 1))
      (Observed_Inputs_d (_ BitVec 4))
      (Observed_Inputs_c2l_undefined_0_Y (_ BitVec 4)))))
(declare-datatype Observed_Outputs
  (
    (Observed_Outputs
      (Observed_Outputs_q (_ BitVec 4))
      (Observed_Outputs_c2l_effect_0_ARGS (_ BitVec 4))
      (Observed_Outputs_c2l_effect_0_EN (_ BitVec 1))
      (Observed_Outputs_c2l_effect_1_EN (_ BitVec 1))
      (Observed_Outputs_c2l_effect_2_A (_ BitVec 1))
      (Observed_Outputs_c2l_effect_2_EN (_ BitVec 1))
      (Observed_Outputs_c2l_effect_3_A (_ BitVec 1))
      (Observed_Outputs_c2l_effect_3_EN (_ BitVec 1))
      (Observed_Outputs_c2l_effect_4_A (_ BitVec 1))
      (Observed_Outputs_c2l_effect_4_EN (_ BitVec 1)))))
(declare-datatype Observed_State
  (
    (Observed_State
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$21
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$33
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$45
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$59
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$73
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$91
        (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$89 (_ BitVec 4))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$87 (_ BitVec 4))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$27 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$39 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$51 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$65 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$79 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$25 (_ BitVec 4))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$57 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$71 (_ BitVec 1))
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$85 (_ BitVec 1)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Observed
  ((inputs Observed_Inputs) (state Observed_State))
  (Pair Observed_Outputs Observed_State)
  (let ((clock (Observed_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$87$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$87 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$89$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$89 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$91$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$91 state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$91$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$93 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((q
      (ite
        (= $auto$rtlil.cc_3302_Eqx$93 #b1)
        $auto$clk2fflogic.cc_108_sample_data$89$_Q
        $auto$clk2fflogic.cc_108_sample_data$87$_Q))) ; (_ BitVec 4)
  (let ((d (Observed_Inputs_d inputs))) ; (_ BitVec 4)
  (let ((en (Observed_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($procmux$11$_Y (ite (= en #b1) d q))) ; (_ BitVec 4)
  (let ((c2l_undefined_0_Y (Observed_Inputs_c2l_undefined_0_Y inputs))) ; (_ BitVec 4)
  (let ((reset_0 (Observed_Inputs_reset inputs))) ; (_ BitVec 1)
  (let
    (($procmux$14$_Y (ite (= reset_0 #b1) c2l_undefined_0_Y $procmux$11$_Y))) ; (_ BitVec 4)
  (let (($procmux$18_Y (ite (= reset_0 #b1) #b0000 $procmux$14$_Y))) ; (_ BitVec 4)
  (let (($4$_Y (bvnot reset_0))) ; (_ BitVec 1)
  (let (($5$_Y (bvand $4$_Y en))) ; (_ BitVec 1)
  (let (($18 (ite (= $5$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($16 (ite (= $5$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($13 (ite (= $5$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($10 (ite (= $5$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($7 (ite (= $5$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let ((n26 (concat #b0000000000000000000000000000 d))) ; (_ BitVec 32)
  (let (($14y (ite (= n26 #b00000000000000000000000000000111) #b1 #b0))) ; (_ BitVec 1)
  (let (($11y (ite (bvugt #b00000000000000000000000000001111 n26) #b1 #b0))) ; (_ BitVec 1)
  (let (($8y (ite (distinct n26 #b00000000000000000000000000001111) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_ARGS
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$25 state))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$27$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$27 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$21$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$21 state))) ; (_ BitVec 1)
  (let ((n35 (concat $auto$clk2fflogic.cc_92_sample_control_edge$21$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$28$_Y (ite (= n35 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_EN
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$27$_Q
        $auto$clk2fflogic.cc_261_execute$28$_Y))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$39$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$39 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$33$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$33 state))) ; (_ BitVec 1)
  (let ((n40 (concat $auto$clk2fflogic.cc_92_sample_control_edge$33$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$40$_Y (ite (= n40 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_1_EN
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$39$_Q
        $auto$clk2fflogic.cc_261_execute$40$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_2_A
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$57 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$51$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$51 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$45$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$45 state))) ; (_ BitVec 1)
  (let ((n46 (concat $auto$clk2fflogic.cc_92_sample_control_edge$45$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$52$_Y (ite (= n46 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_2_EN
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$51$_Q
        $auto$clk2fflogic.cc_261_execute$52$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_3_A
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$71 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$65$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$65 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$59$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$59 state))) ; (_ BitVec 1)
  (let ((n52 (concat $auto$clk2fflogic.cc_92_sample_control_edge$59$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$66$_Y (ite (= n52 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_3_EN
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$65$_Q
        $auto$clk2fflogic.cc_261_execute$66$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_4_A
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$85 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$79$_Q
      (Observed_State_$auto$clk2fflogic.cc_108_sample_data$79 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$73$_Q
      (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$73 state))) ; (_ BitVec 1)
  (let ((n58 (concat $auto$clk2fflogic.cc_92_sample_control_edge$73$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$80$_Y (ite (= n58 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_4_EN
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$79$_Q
        $auto$clk2fflogic.cc_261_execute$80$_Y))) ; (_ BitVec 1)
  (pair
    (Observed_Outputs
      q ; q
      c2l_effect_0_ARGS ; c2l_effect_0_ARGS
      c2l_effect_0_EN ; c2l_effect_0_EN
      c2l_effect_1_EN ; c2l_effect_1_EN
      c2l_effect_2_A ; c2l_effect_2_A
      c2l_effect_2_EN ; c2l_effect_2_EN
      c2l_effect_3_A ; c2l_effect_3_A
      c2l_effect_3_EN ; c2l_effect_3_EN
      c2l_effect_4_A ; c2l_effect_4_A
      c2l_effect_4_EN ; c2l_effect_4_EN
    )
    (Observed_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$21
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$33
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$45
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$59
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$73
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$91
      $procmux$18_Y ; $auto$clk2fflogic.cc:108:sample_data$89
      q ; $auto$clk2fflogic.cc:108:sample_data$87
      $18 ; $auto$clk2fflogic.cc:108:sample_data$27
      $16 ; $auto$clk2fflogic.cc:108:sample_data$39
      $13 ; $auto$clk2fflogic.cc:108:sample_data$51
      $10 ; $auto$clk2fflogic.cc:108:sample_data$65
      $7 ; $auto$clk2fflogic.cc:108:sample_data$79
      q ; $auto$clk2fflogic.cc:108:sample_data$25
      $14y ; $auto$clk2fflogic.cc:108:sample_data$57
      $11y ; $auto$clk2fflogic.cc:108:sample_data$71
      $8y ; $auto$clk2fflogic.cc:108:sample_data$85
    )))))))))))))))))))))))))))))))))))))))))))))))))))))))))
(declare-const Observed-initial Observed_State)
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$21
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$33
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$45
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$59
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$73
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_92_sample_control_edge$91
      Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$89 Observed-initial)
    #b0000))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$87 Observed-initial)
    #b0000))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$27 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$39 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$51 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$65 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$79 Observed-initial)
    #b0))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$25 Observed-initial)
    #b0000))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$57 Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$71 Observed-initial)
    #b1))
(assert
  (=
    (Observed_State_$auto$clk2fflogic.cc_108_sample_data$85 Observed-initial)
    #b1))
