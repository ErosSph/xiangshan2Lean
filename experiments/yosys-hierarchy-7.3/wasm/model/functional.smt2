(declare-datatype Nested_Inputs
  (
    (Nested_Inputs
      (Nested_Inputs_reset (_ BitVec 1))
      (Nested_Inputs_clock (_ BitVec 1))
      (Nested_Inputs_en (_ BitVec 1))
      (Nested_Inputs_d (_ BitVec 8))
      (Nested_Inputs_c2l_undefined_0 (_ BitVec 8))
      (Nested_Inputs_c2l_undefined_1 (_ BitVec 8)))))
(declare-datatype Nested_Outputs
  (
    (Nested_Outputs
      (Nested_Outputs_a (_ BitVec 8))
      (Nested_Outputs_b (_ BitVec 8)))))
(declare-datatype Nested_State
  (
    (Nested_State
      (Nested_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 (_ BitVec 1))
      (Nested_State_$auto$clk2fflogic.cc_92_sample_control_edge$16 (_ BitVec 1))
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$4 (_ BitVec 8))
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$2 (_ BitVec 8))
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$14 (_ BitVec 8))
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$12 (_ BitVec 8)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Nested
  ((inputs Nested_Inputs) (state Nested_State))
  (Pair Nested_Outputs Nested_State)
  (let ((clock (Nested_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$2$_Q
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$2 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$4$_Q
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$4 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$6$_Q
      (Nested_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$6$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$8 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((a
      (ite
        (= $auto$rtlil.cc_3302_Eqx$8 #b1)
        $auto$clk2fflogic.cc_108_sample_data$4$_Q
        $auto$clk2fflogic.cc_108_sample_data$2$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$12$_Q
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$12 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$14$_Q
      (Nested_State_$auto$clk2fflogic.cc_108_sample_data$14 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$16$_Q
      (Nested_State_$auto$clk2fflogic.cc_92_sample_control_edge$16 state))) ; (_ BitVec 1)
  (let ((n11 (concat $auto$clk2fflogic.cc_92_sample_control_edge$16$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$18 (ite (= n11 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((b
      (ite
        (= $auto$rtlil.cc_3302_Eqx$18 #b1)
        $auto$clk2fflogic.cc_108_sample_data$14$_Q
        $auto$clk2fflogic.cc_108_sample_data$12$_Q))) ; (_ BitVec 8)
  (let ((d (Nested_Inputs_d inputs))) ; (_ BitVec 8)
  (let (($0$_Y (bvadd b d))) ; (_ BitVec 8)
  (let ((n17 (concat #b000000000000000000000000 $0$_Y))) ; (_ BitVec 32)
  (let
    (($flatten_left.middle.leaf.$1$_Y
      (bvadd n17 #b00000000000000000000000000000001))) ; (_ BitVec 32)
  (let ((n20 ((_ extract 7 0) $flatten_left.middle.leaf.$1$_Y))) ; (_ BitVec 8)
  (let ((en (Nested_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($flatten_left.middle.leaf.$procmux$10$_Y (ite (= en #b1) n20 a))) ; (_ BitVec 8)
  (let ((c2l_undefined_0 (Nested_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 8)
  (let ((reset_0 (Nested_Inputs_reset inputs))) ; (_ BitVec 1)
  (let
    (($flatten_left.middle.leaf.$procmux$13$_Y
      (ite
        (= reset_0 #b1)
        c2l_undefined_0
        $flatten_left.middle.leaf.$procmux$10$_Y))) ; (_ BitVec 8)
  (let
    (($flatten_left.middle.leaf.$procmux$17_Y
      (ite (= reset_0 #b1) #b00000000 $flatten_left.middle.leaf.$procmux$13$_Y))) ; (_ BitVec 8)
  (let (($1$_Y (bvxor a d))) ; (_ BitVec 8)
  (let ((n29 (concat #b000000000000000000000000 $1$_Y))) ; (_ BitVec 32)
  (let
    (($flatten_right.middle.leaf.$1$_Y
      (bvadd n29 #b00000000000000000000000000000001))) ; (_ BitVec 32)
  (let ((n31 ((_ extract 7 0) $flatten_right.middle.leaf.$1$_Y))) ; (_ BitVec 8)
  (let (($flatten_right.middle.leaf.$procmux$1$_Y (ite (= en #b1) n31 b))) ; (_ BitVec 8)
  (let ((c2l_undefined_1 (Nested_Inputs_c2l_undefined_1 inputs))) ; (_ BitVec 8)
  (let
    (($flatten_right.middle.leaf.$procmux$4$_Y
      (ite
        (= reset_0 #b1)
        c2l_undefined_1
        $flatten_right.middle.leaf.$procmux$1$_Y))) ; (_ BitVec 8)
  (let
    (($flatten_right.middle.leaf.$procmux$8_Y
      (ite (= reset_0 #b1) #b00000000 $flatten_right.middle.leaf.$procmux$4$_Y))) ; (_ BitVec 8)
  (pair
    (Nested_Outputs
      a ; a
      b ; b
    )
    (Nested_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$6
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$16
      $flatten_left.middle.leaf.$procmux$17_Y ; $auto$clk2fflogic.cc:108:sample_data$4
      a ; $auto$clk2fflogic.cc:108:sample_data$2
      $flatten_right.middle.leaf.$procmux$8_Y ; $auto$clk2fflogic.cc:108:sample_data$14
      b ; $auto$clk2fflogic.cc:108:sample_data$12
    )))))))))))))))))))))))))))))))))))
(declare-const Nested-initial Nested_State)
(assert
  (=
    (Nested_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 Nested-initial)
    #b1))
(assert
  (=
    (Nested_State_$auto$clk2fflogic.cc_92_sample_control_edge$16 Nested-initial)
    #b1))
(assert
  (=
    (Nested_State_$auto$clk2fflogic.cc_108_sample_data$4 Nested-initial)
    #b00000000))
(assert
  (=
    (Nested_State_$auto$clk2fflogic.cc_108_sample_data$2 Nested-initial)
    #b00000000))
(assert
  (=
    (Nested_State_$auto$clk2fflogic.cc_108_sample_data$14 Nested-initial)
    #b00000000))
(assert
  (=
    (Nested_State_$auto$clk2fflogic.cc_108_sample_data$12 Nested-initial)
    #b00000000))
