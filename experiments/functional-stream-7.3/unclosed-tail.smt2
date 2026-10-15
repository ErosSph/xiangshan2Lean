(declare-datatype Layer_Inputs
  (
    (Layer_Inputs
      (Layer_Inputs_clock (_ BitVec 1))
      (Layer_Inputs_en (_ BitVec 1))
      (Layer_Inputs_ok (_ BitVec 1)))))
(declare-datatype Layer_Outputs
  (
    (Layer_Outputs
      (Layer_Outputs_q (_ BitVec 1))
      (Layer_Outputs_c2l_effect_0_enable (_ BitVec 1))
      (Layer_Outputs_c2l_effect_0_condition (_ BitVec 1)))))
(declare-datatype Layer_State
  (
    (Layer_State
      (Layer_State_$auto$clk2fflogic.cc_92_sample_control_edge$2 (_ BitVec 1))
      (Layer_State_$auto$clk2fflogic.cc_108_sample_data$8 (_ BitVec 1))
      (Layer_State_$auto$clk2fflogic.cc_108_sample_data$14 (_ BitVec 1)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Layer
  ((inputs Layer_Inputs) (state Layer_State))
  (Pair Layer_Outputs Layer_State)
  (let ((clock (Layer_Inputs_clock inputs))) ; (_ BitVec 1)
  (let ((en (Layer_Inputs_en inputs))) ; (_ BitVec 1)
  (let (($1 (ite (= en #b1) #b1 #b0))) ; (_ BitVec 1)
  (let ((q (Layer_Inputs_ok inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$8$_Q
      (Layer_State_$auto$clk2fflogic.cc_108_sample_data$8 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$2$_Q
      (Layer_State_$auto$clk2fflogic.cc_92_sample_control_edge$2 state))) ; (_ BitVec 1)
  (let ((n8 (concat $auto$clk2fflogic.cc_92_sample_control_edge$2$_Q clock))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_261_execute$9$_Y (ite (= n8 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_enable
      (bvand
        $auto$clk2fflogic.cc_108_sample_data$8$_Q
        $auto$clk2fflogic.cc_261_execute$9$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_effect_0_condition
      (Layer_State_$auto$clk2fflogic.cc_108_sample_data$14 state))) ; (_ BitVec 1)
  (pair
    (Layer_Outputs
      q ; q
      c2l_effect_0_enable ; c2l_effect_0_enable
      c2l_effect_0_condition ; c2l_effect_0_condition
    )
    (Layer_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$2
      $1 ; $auto$clk2fflogic.cc:108:sample_data$8
      q ; $auto$clk2fflogic.cc:108:sample_data$14
    )))))))))))))
(declare-const Layer-initial Layer_State)
(assert
  (=
    (Layer_State_$auto$clk2fflogic.cc_92_sample_control_edge$2 Layer-initial)
    #b1))
(assert
  (= (Layer_State_$auto$clk2fflogic.cc_108_sample_data$8 Layer-initial) #b0))
(assert
  (= (Layer_State_$auto$clk2fflogic.cc_108_sample_data$14 Layer-initial) #b1))

(assert (