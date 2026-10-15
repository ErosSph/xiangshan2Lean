(declare-datatype ResetProbe_Inputs
  (
    (ResetProbe_Inputs
      (ResetProbe_Inputs_reset (_ BitVec 1))
      (ResetProbe_Inputs_clock (_ BitVec 1))
      (ResetProbe_Inputs_d (_ BitVec 8)))))
(declare-datatype ResetProbe_Outputs
  (
    (ResetProbe_Outputs
      (ResetProbe_Outputs_q (_ BitVec 8)))))
(declare-datatype ResetProbe_State
  (
    (ResetProbe_State
      (ResetProbe_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
        (_ BitVec 1))
      (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$4 (_ BitVec 8))
      (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$2 (_ BitVec 8))
      (ResetProbe_State_$auto$clk2fflogic.cc_80_sample_control$12 (_ BitVec 1))
      (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$14 (_ BitVec 8)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  ResetProbe
  ((inputs ResetProbe_Inputs) (state ResetProbe_State))
  (Pair ResetProbe_Outputs ResetProbe_State)
  (let ((clock (ResetProbe_Inputs_clock inputs))) ; (_ BitVec 1)
  (let ((d (ResetProbe_Inputs_d inputs))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$2$_Q
      (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$2 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$4$_Q
      (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$4 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$6$_Q
      (ResetProbe_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 state))) ; (_ BitVec 1)
  (let ((n5 (concat $auto$clk2fflogic.cc_92_sample_control_edge$6$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$8 (ite (= n5 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$rtlil.cc_3381_Mux$10
      (ite
        (= $auto$rtlil.cc_3302_Eqx$8 #b1)
        $auto$clk2fflogic.cc_108_sample_data$4$_Q
        $auto$clk2fflogic.cc_108_sample_data$2$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$14$_Q
      (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$14 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$_reset_sampled$11
      (ResetProbe_State_$auto$clk2fflogic.cc_80_sample_control$12 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$15$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$_reset_sampled$11 #b1)
        $auto$clk2fflogic.cc_108_sample_data$14$_Q
        $auto$rtlil.cc_3381_Mux$10))) ; (_ BitVec 8)
  (let ((reset_0 (ResetProbe_Inputs_reset inputs))) ; (_ BitVec 1)
  (let
    ((q (ite (= reset_0 #b1) #b10100111 $auto$clk2fflogic.cc_123_mux$15$_Y))) ; (_ BitVec 8)
  (pair
    (ResetProbe_Outputs
      q ; q
    )
    (ResetProbe_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$6
      d ; $auto$clk2fflogic.cc:108:sample_data$4
      q ; $auto$clk2fflogic.cc:108:sample_data$2
      reset_0 ; $auto$clk2fflogic.cc:80:sample_control$12
      #b10100111 ; $auto$clk2fflogic.cc:108:sample_data$14
    ))))))))))))))))
(declare-const ResetProbe-initial ResetProbe_State)
(assert
  (=
    (ResetProbe_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
      ResetProbe-initial)
    #b1))
(assert
  (=
    (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$4 ResetProbe-initial)
    #b00000000))
(assert
  (=
    (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$2 ResetProbe-initial)
    #b00000000))
(assert
  (=
    (ResetProbe_State_$auto$clk2fflogic.cc_80_sample_control$12
      ResetProbe-initial)
    #b0))
(assert
  (=
    (ResetProbe_State_$auto$clk2fflogic.cc_108_sample_data$14
      ResetProbe-initial)
    #b00000000))
