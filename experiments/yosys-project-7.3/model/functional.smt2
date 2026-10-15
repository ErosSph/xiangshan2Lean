(declare-datatype ProjectTop_Inputs
  (
    (ProjectTop_Inputs
      (ProjectTop_Inputs_clock (_ BitVec 1))
      (ProjectTop_Inputs_en (_ BitVec 1))
      (ProjectTop_Inputs_d (_ BitVec 5)))))
(declare-datatype ProjectTop_Outputs
  (
    (ProjectTop_Outputs
      (ProjectTop_Outputs_q (_ BitVec 5)))))
(declare-datatype ProjectTop_State
  (
    (ProjectTop_State
      (ProjectTop_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
        (_ BitVec 1))
      (ProjectTop_State_$auto$clk2fflogic.cc_108_sample_data$4 (_ BitVec 5))
      (ProjectTop_State_$auto$clk2fflogic.cc_108_sample_data$2 (_ BitVec 5)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  ProjectTop
  ((inputs ProjectTop_Inputs) (state ProjectTop_State))
  (Pair ProjectTop_Outputs ProjectTop_State)
  (let ((clock (ProjectTop_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$2$_Q
      (ProjectTop_State_$auto$clk2fflogic.cc_108_sample_data$2 state))) ; (_ BitVec 5)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$4$_Q
      (ProjectTop_State_$auto$clk2fflogic.cc_108_sample_data$4 state))) ; (_ BitVec 5)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$6$_Q
      (ProjectTop_State_$auto$clk2fflogic.cc_92_sample_control_edge$6 state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$6$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$8 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((q
      (ite
        (= $auto$rtlil.cc_3302_Eqx$8 #b1)
        $auto$clk2fflogic.cc_108_sample_data$4$_Q
        $auto$clk2fflogic.cc_108_sample_data$2$_Q))) ; (_ BitVec 5)
  (let ((d (ProjectTop_Inputs_d inputs))) ; (_ BitVec 5)
  (let ((n10 (concat #b000000000000000000000000000 d))) ; (_ BitVec 32)
  (let (($flatten_lane.$1$_Y (bvadd n10 #b00000000000000000000000000000001))) ; (_ BitVec 32)
  (let ((n13 ((_ extract 4 0) $flatten_lane.$1$_Y))) ; (_ BitVec 5)
  (let ((en (ProjectTop_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($flatten_lane.$procmux$1_Y (ite (= en #b1) n13 q))) ; (_ BitVec 5)
  (pair
    (ProjectTop_Outputs
      q ; q
    )
    (ProjectTop_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$6
      $flatten_lane.$procmux$1_Y ; $auto$clk2fflogic.cc:108:sample_data$4
      q ; $auto$clk2fflogic.cc:108:sample_data$2
    ))))))))))))))))
(declare-const ProjectTop-initial ProjectTop_State)
(assert
  (=
    (ProjectTop_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
      ProjectTop-initial)
    #b1))
(assert
  (=
    (ProjectTop_State_$auto$clk2fflogic.cc_108_sample_data$4 ProjectTop-initial)
    #b00000))
(assert
  (=
    (ProjectTop_State_$auto$clk2fflogic.cc_108_sample_data$2 ProjectTop-initial)
    #b00000))
