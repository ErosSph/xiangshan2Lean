(declare-datatype Clocks_Inputs
  (
    (Clocks_Inputs
      (Clocks_Inputs_reset (_ BitVec 1))
      (Clocks_Inputs_c1 (_ BitVec 1))
      (Clocks_Inputs_c2 (_ BitVec 1))
      (Clocks_Inputs_latch_en (_ BitVec 1))
      (Clocks_Inputs_gate_en (_ BitVec 1))
      (Clocks_Inputs_d (_ BitVec 8))
      (Clocks_Inputs_c2l_undefined_0 (_ BitVec 8))
      (Clocks_Inputs_c2l_undefined_1 (_ BitVec 1)))))
(declare-datatype Clocks_Outputs
  (
    (Clocks_Outputs
      (Clocks_Outputs_a (_ BitVec 8))
      (Clocks_Outputs_p (_ BitVec 8))
      (Clocks_Outputs_n (_ BitVec 8))
      (Clocks_Outputs_l (_ BitVec 8))
      (Clocks_Outputs_g (_ BitVec 8))
      (Clocks_Outputs_crossed (_ BitVec 8)))))
(declare-datatype Clocks_State
  (
    (Clocks_State
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$64 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$66 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$62 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$96 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$94 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$92 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$144
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$134
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$54 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$44 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$34 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$24 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$14 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$4 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$84 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$74 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$124
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$114
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$102 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$56 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$52 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$46 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$42 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$36 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$32 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$26 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$22 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$16 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$12 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$6 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$2 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$86 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$82 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$76 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$72 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$104 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$142 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$140 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$132 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$130 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$122 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$120 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$112 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$110 (_ BitVec 8)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Clocks
  ((inputs Clocks_Inputs) (state Clocks_State))
  (Pair Clocks_Outputs Clocks_State)
  (let ((c1 (Clocks_Inputs_c1 inputs))) ; (_ BitVec 1)
  (let (($17$_Y (bvnot c1))) ; (_ BitVec 1)
  (let (($19 (ite (= $17$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let ((c2l_undefined_1 (Clocks_Inputs_c2l_undefined_1 inputs))) ; (_ BitVec 1)
  (let ((gate_en (Clocks_Inputs_gate_en inputs))) ; (_ BitVec 1)
  (let (($20 (ite (= $17$_Y #b1) gate_en c2l_undefined_1))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$62$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$62 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$66$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$66 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$19_sampled$63
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$64 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$67$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$19_sampled$63 #b1)
        $auto$clk2fflogic.cc_108_sample_data$66$_Q
        $auto$clk2fflogic.cc_108_sample_data$62$_Q))) ; (_ BitVec 1)
  (let ((gate_open (ite (= $19 #b1) $20 $auto$clk2fflogic.cc_123_mux$67$_Y))) ; (_ BitVec 1)
  (let ((d (Clocks_Inputs_d inputs))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$92$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$92 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$94$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$94 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$96$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$96 state))) ; (_ BitVec 1)
  (let ((n17 (concat $auto$clk2fflogic.cc_92_sample_control_edge$96$_Q c1))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$98 (ite (= n17 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$rtlil.cc_3381_Mux$100
      (ite
        (= $auto$rtlil.cc_3302_Eqx$98 #b1)
        $auto$clk2fflogic.cc_108_sample_data$94$_Q
        $auto$clk2fflogic.cc_108_sample_data$92$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$104$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$104 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$_reset_sampled$101
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$102 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$105$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$_reset_sampled$101 #b1)
        $auto$clk2fflogic.cc_108_sample_data$104$_Q
        $auto$rtlil.cc_3381_Mux$100))) ; (_ BitVec 8)
  (let ((reset_0 (Clocks_Inputs_reset inputs))) ; (_ BitVec 1)
  (let
    ((a (ite (= reset_0 #b1) #b00000000 $auto$clk2fflogic.cc_123_mux$105$_Y))) ; (_ BitVec 8)
  (let ((c2 (Clocks_Inputs_c2 inputs))) ; (_ BitVec 1)
  (let ((latch_en (Clocks_Inputs_latch_en inputs))) ; (_ BitVec 1)
  (let (($6 (ite (= latch_en #b1) #b11111111 #b00000000))) ; (_ BitVec 8)
  (let ((n31 ((_ extract 7 7) $6))) ; (_ BitVec 1)
  (let ((n32 ((_ extract 6 6) $6))) ; (_ BitVec 1)
  (let ((n33 ((_ extract 5 5) $6))) ; (_ BitVec 1)
  (let ((n34 ((_ extract 4 4) $6))) ; (_ BitVec 1)
  (let ((n35 ((_ extract 3 3) $6))) ; (_ BitVec 1)
  (let ((n36 ((_ extract 2 2) $6))) ; (_ BitVec 1)
  (let ((n37 ((_ extract 1 1) $6))) ; (_ BitVec 1)
  (let ((n38 ((_ extract 0 0) $6))) ; (_ BitVec 1)
  (let ((gated_clock (bvand c1 gate_open))) ; (_ BitVec 1)
  (let ((c2l_undefined_0 (Clocks_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 8)
  (let (($7 (ite (= latch_en #b1) d c2l_undefined_0))) ; (_ BitVec 8)
  (let ((n42 ((_ extract 7 7) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$72$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$72 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$76$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$76 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_0__sampled$73
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$74 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$77$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_0__sampled$73 #b1)
        $auto$clk2fflogic.cc_108_sample_data$76$_Q
        $auto$clk2fflogic.cc_108_sample_data$72$_Q))) ; (_ BitVec 1)
  (let ((n47 ((_ extract 0 0) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$79$_Y
      (ite (= n38 #b1) n47 $auto$clk2fflogic.cc_123_mux$77$_Y))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$82$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$82 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$86$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$86 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_1__sampled$83
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$84 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$87$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_1__sampled$83 #b1)
        $auto$clk2fflogic.cc_108_sample_data$86$_Q
        $auto$clk2fflogic.cc_108_sample_data$82$_Q))) ; (_ BitVec 1)
  (let ((n53 ((_ extract 1 1) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$89$_Y
      (ite (= n37 #b1) n53 $auto$clk2fflogic.cc_123_mux$87$_Y))) ; (_ BitVec 1)
  (let
    ((n55
      (concat
        $auto$clk2fflogic.cc_123_mux$89$_Y
        $auto$clk2fflogic.cc_123_mux$79$_Y))) ; (_ BitVec 2)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$2$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$2 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$6$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$6 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_2__sampled$3
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$4 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$7$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_2__sampled$3 #b1)
        $auto$clk2fflogic.cc_108_sample_data$6$_Q
        $auto$clk2fflogic.cc_108_sample_data$2$_Q))) ; (_ BitVec 1)
  (let ((n60 ((_ extract 2 2) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$9$_Y
      (ite (= n36 #b1) n60 $auto$clk2fflogic.cc_123_mux$7$_Y))) ; (_ BitVec 1)
  (let ((n62 (concat $auto$clk2fflogic.cc_123_mux$9$_Y n55))) ; (_ BitVec 3)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$12$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$12 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$16$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$16 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_3__sampled$13
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$14 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$17$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_3__sampled$13 #b1)
        $auto$clk2fflogic.cc_108_sample_data$16$_Q
        $auto$clk2fflogic.cc_108_sample_data$12$_Q))) ; (_ BitVec 1)
  (let ((n67 ((_ extract 3 3) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$19$_Y
      (ite (= n35 #b1) n67 $auto$clk2fflogic.cc_123_mux$17$_Y))) ; (_ BitVec 1)
  (let ((n69 (concat $auto$clk2fflogic.cc_123_mux$19$_Y n62))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$22$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$22 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$26$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$26 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_4__sampled$23
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$24 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$27$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_4__sampled$23 #b1)
        $auto$clk2fflogic.cc_108_sample_data$26$_Q
        $auto$clk2fflogic.cc_108_sample_data$22$_Q))) ; (_ BitVec 1)
  (let ((n74 ((_ extract 4 4) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$29$_Y
      (ite (= n34 #b1) n74 $auto$clk2fflogic.cc_123_mux$27$_Y))) ; (_ BitVec 1)
  (let ((n76 (concat $auto$clk2fflogic.cc_123_mux$29$_Y n69))) ; (_ BitVec 5)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$32$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$32 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$36$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$36 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_5__sampled$33
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$34 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$37$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_5__sampled$33 #b1)
        $auto$clk2fflogic.cc_108_sample_data$36$_Q
        $auto$clk2fflogic.cc_108_sample_data$32$_Q))) ; (_ BitVec 1)
  (let ((n81 ((_ extract 5 5) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$39$_Y
      (ite (= n33 #b1) n81 $auto$clk2fflogic.cc_123_mux$37$_Y))) ; (_ BitVec 1)
  (let ((n83 (concat $auto$clk2fflogic.cc_123_mux$39$_Y n76))) ; (_ BitVec 6)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$42$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$42 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$46$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$46 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_6__sampled$43
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$44 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$47$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_6__sampled$43 #b1)
        $auto$clk2fflogic.cc_108_sample_data$46$_Q
        $auto$clk2fflogic.cc_108_sample_data$42$_Q))) ; (_ BitVec 1)
  (let ((n88 ((_ extract 6 6) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$49$_Y
      (ite (= n32 #b1) n88 $auto$clk2fflogic.cc_123_mux$47$_Y))) ; (_ BitVec 1)
  (let ((n90 (concat $auto$clk2fflogic.cc_123_mux$49$_Y n83))) ; (_ BitVec 7)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$52$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$52 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$56$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$56 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_7__sampled$53
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$54 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$57$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_7__sampled$53 #b1)
        $auto$clk2fflogic.cc_108_sample_data$56$_Q
        $auto$clk2fflogic.cc_108_sample_data$52$_Q))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$59$_Y
      (ite (= n31 #b1) n42 $auto$clk2fflogic.cc_123_mux$57$_Y))) ; (_ BitVec 1)
  (let ((l (concat $auto$clk2fflogic.cc_123_mux$59$_Y n90))) ; (_ BitVec 8)
  (let ((n97 ((_ extract 7 7) l))) ; (_ BitVec 1)
  (let ((n98 ((_ extract 6 6) l))) ; (_ BitVec 1)
  (let ((n99 ((_ extract 5 5) l))) ; (_ BitVec 1)
  (let ((n100 ((_ extract 4 4) l))) ; (_ BitVec 1)
  (let ((n101 ((_ extract 3 3) l))) ; (_ BitVec 1)
  (let ((n102 ((_ extract 2 2) l))) ; (_ BitVec 1)
  (let ((n103 ((_ extract 1 1) l))) ; (_ BitVec 1)
  (let ((n104 ((_ extract 0 0) l))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$140$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$140 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$142$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$142 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$144$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$144 state))) ; (_ BitVec 1)
  (let ((n108 (concat $auto$clk2fflogic.cc_92_sample_control_edge$144$_Q c1))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$146 (ite (= n108 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((p
      (ite
        (= $auto$rtlil.cc_3302_Eqx$146 #b1)
        $auto$clk2fflogic.cc_108_sample_data$142$_Q
        $auto$clk2fflogic.cc_108_sample_data$140$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$130$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$130 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$132$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$132 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$134$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$134 state))) ; (_ BitVec 1)
  (let ((n114 (concat $auto$clk2fflogic.cc_92_sample_control_edge$134$_Q c2))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$136 (ite (= n114 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((n
      (ite
        (= $auto$rtlil.cc_3302_Eqx$136 #b1)
        $auto$clk2fflogic.cc_108_sample_data$132$_Q
        $auto$clk2fflogic.cc_108_sample_data$130$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$120$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$120 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$122$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$122 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$124$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$124 state))) ; (_ BitVec 1)
  (let
    ((n121
      (concat $auto$clk2fflogic.cc_92_sample_control_edge$124$_Q gated_clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$126 (ite (= n121 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((g
      (ite
        (= $auto$rtlil.cc_3302_Eqx$126 #b1)
        $auto$clk2fflogic.cc_108_sample_data$122$_Q
        $auto$clk2fflogic.cc_108_sample_data$120$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$110$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$110 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$112$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$112 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$114$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$114 state))) ; (_ BitVec 1)
  (let ((n127 (concat $auto$clk2fflogic.cc_92_sample_control_edge$114$_Q c1))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$116 (ite (= n127 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((crossed
      (ite
        (= $auto$rtlil.cc_3302_Eqx$116 #b1)
        $auto$clk2fflogic.cc_108_sample_data$112$_Q
        $auto$clk2fflogic.cc_108_sample_data$110$_Q))) ; (_ BitVec 8)
  (pair
    (Clocks_Outputs
      a ; a
      p ; p
      n ; n
      l ; l
      g ; g
      crossed ; crossed
    )
    (Clocks_State
      $19 ; $auto$clk2fflogic.cc:80:sample_control$64
      $20 ; $auto$clk2fflogic.cc:108:sample_data$66
      gate_open ; $auto$clk2fflogic.cc:108:sample_data$62
      c1 ; $auto$clk2fflogic.cc:92:sample_control_edge$96
      d ; $auto$clk2fflogic.cc:108:sample_data$94
      a ; $auto$clk2fflogic.cc:108:sample_data$92
      c1 ; $auto$clk2fflogic.cc:92:sample_control_edge$144
      c2 ; $auto$clk2fflogic.cc:92:sample_control_edge$134
      n31 ; $auto$clk2fflogic.cc:80:sample_control$54
      n32 ; $auto$clk2fflogic.cc:80:sample_control$44
      n33 ; $auto$clk2fflogic.cc:80:sample_control$34
      n34 ; $auto$clk2fflogic.cc:80:sample_control$24
      n35 ; $auto$clk2fflogic.cc:80:sample_control$14
      n36 ; $auto$clk2fflogic.cc:80:sample_control$4
      n37 ; $auto$clk2fflogic.cc:80:sample_control$84
      n38 ; $auto$clk2fflogic.cc:80:sample_control$74
      gated_clock ; $auto$clk2fflogic.cc:92:sample_control_edge$124
      c1 ; $auto$clk2fflogic.cc:92:sample_control_edge$114
      reset_0 ; $auto$clk2fflogic.cc:80:sample_control$102
      n42 ; $auto$clk2fflogic.cc:108:sample_data$56
      n97 ; $auto$clk2fflogic.cc:108:sample_data$52
      n88 ; $auto$clk2fflogic.cc:108:sample_data$46
      n98 ; $auto$clk2fflogic.cc:108:sample_data$42
      n81 ; $auto$clk2fflogic.cc:108:sample_data$36
      n99 ; $auto$clk2fflogic.cc:108:sample_data$32
      n74 ; $auto$clk2fflogic.cc:108:sample_data$26
      n100 ; $auto$clk2fflogic.cc:108:sample_data$22
      n67 ; $auto$clk2fflogic.cc:108:sample_data$16
      n101 ; $auto$clk2fflogic.cc:108:sample_data$12
      n60 ; $auto$clk2fflogic.cc:108:sample_data$6
      n102 ; $auto$clk2fflogic.cc:108:sample_data$2
      n53 ; $auto$clk2fflogic.cc:108:sample_data$86
      n103 ; $auto$clk2fflogic.cc:108:sample_data$82
      n47 ; $auto$clk2fflogic.cc:108:sample_data$76
      n104 ; $auto$clk2fflogic.cc:108:sample_data$72
      #b00000000 ; $auto$clk2fflogic.cc:108:sample_data$104
      d ; $auto$clk2fflogic.cc:108:sample_data$142
      p ; $auto$clk2fflogic.cc:108:sample_data$140
      d ; $auto$clk2fflogic.cc:108:sample_data$132
      n ; $auto$clk2fflogic.cc:108:sample_data$130
      d ; $auto$clk2fflogic.cc:108:sample_data$122
      g ; $auto$clk2fflogic.cc:108:sample_data$120
      n ; $auto$clk2fflogic.cc:108:sample_data$112
      crossed ; $auto$clk2fflogic.cc:108:sample_data$110
    ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
  )))))))))))))))))))))))))))))))))))))))))))))))))))
(declare-const Clocks-initial Clocks_State)
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$64 Clocks-initial)
    #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$66 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$62 Clocks-initial) #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$96 Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$94 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$92 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$144
      Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$134
      Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$54 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$44 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$34 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$24 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$14 Clocks-initial)
    #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$4 Clocks-initial) #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$84 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$74 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$124
      Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$114
      Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$102 Clocks-initial)
    #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$56 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$52 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$46 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$42 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$36 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$32 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$26 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$22 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$16 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$12 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$6 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$2 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$86 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$82 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$76 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$72 Clocks-initial) #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$104 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$142 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$140 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$132 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$130 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$122 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$120 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$112 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$110 Clocks-initial)
    #b00000000))
