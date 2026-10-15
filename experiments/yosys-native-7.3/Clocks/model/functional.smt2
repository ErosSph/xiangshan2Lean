(declare-datatype Clocks_Inputs
  (
    (Clocks_Inputs
      (Clocks_Inputs_reset (_ BitVec 1))
      (Clocks_Inputs_c1 (_ BitVec 1))
      (Clocks_Inputs_c2 (_ BitVec 1))
      (Clocks_Inputs_latch_en (_ BitVec 1))
      (Clocks_Inputs_gate_en (_ BitVec 1))
      (Clocks_Inputs_d (_ BitVec 8))
      (Clocks_Inputs_c2l_undefined_0_Y (_ BitVec 1))
      (Clocks_Inputs_c2l_undefined_1_Y (_ BitVec 8)))))
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
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$26 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$28 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$24 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$118
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$116 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$114 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$96 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$156
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$136
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$36 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$46 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$56 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$66 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$76 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$86 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$98 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$94 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$106 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$18 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$146
        (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$124 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$38 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$34 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$48 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$44 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$58 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$54 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$68 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$64 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$78 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$74 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$88 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$84 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$108 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$104 (_ BitVec 1))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$126 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$154 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$152 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$134 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$132 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$16 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$14 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$144 (_ BitVec 8))
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$142 (_ BitVec 8)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Clocks
  ((inputs Clocks_Inputs) (state Clocks_State))
  (Pair Clocks_Outputs Clocks_State)
  (let ((c1 (Clocks_Inputs_c1 inputs))) ; (_ BitVec 1)
  (let (($17$_Y (bvnot c1))) ; (_ BitVec 1)
  (let (($19 (ite (= $17$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let ((c2l_undefined_0_Y (Clocks_Inputs_c2l_undefined_0_Y inputs))) ; (_ BitVec 1)
  (let ((gate_en (Clocks_Inputs_gate_en inputs))) ; (_ BitVec 1)
  (let (($20 (ite (= $17$_Y #b1) gate_en c2l_undefined_0_Y))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$24$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$24 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$28$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$28 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$19_sampled$25
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$26 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$29$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$19_sampled$25 #b1)
        $auto$clk2fflogic.cc_108_sample_data$28$_Q
        $auto$clk2fflogic.cc_108_sample_data$24$_Q))) ; (_ BitVec 1)
  (let ((gate_open (ite (= $19 #b1) $20 $auto$clk2fflogic.cc_123_mux$29$_Y))) ; (_ BitVec 1)
  (let ((d (Clocks_Inputs_d inputs))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$114$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$114 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$116$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$116 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$118$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$118 state))) ; (_ BitVec 1)
  (let ((n17 (concat $auto$clk2fflogic.cc_92_sample_control_edge$118$_Q c1))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$120 (ite (= n17 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$121$_Y
      (ite
        (= $auto$rtlil.cc_3302_Eqx$120 #b1)
        $auto$clk2fflogic.cc_108_sample_data$116$_Q
        $auto$clk2fflogic.cc_108_sample_data$114$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$126$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$126 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$_reset_sampled$123
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$124 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$127$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$_reset_sampled$123 #b1)
        $auto$clk2fflogic.cc_108_sample_data$126$_Q
        $auto$clk2fflogic.cc_123_mux$121$_Y))) ; (_ BitVec 8)
  (let ((reset_0 (Clocks_Inputs_reset inputs))) ; (_ BitVec 1)
  (let
    ((a (ite (= reset_0 #b1) #b00000000 $auto$clk2fflogic.cc_123_mux$127$_Y))) ; (_ BitVec 8)
  (let ((latch_en (Clocks_Inputs_latch_en inputs))) ; (_ BitVec 1)
  (let (($6 (ite (= latch_en #b1) #b11111111 #b00000000))) ; (_ BitVec 8)
  (let ((n30 ((_ extract 1 1) $6))) ; (_ BitVec 1)
  (let ((c2 (Clocks_Inputs_c2 inputs))) ; (_ BitVec 1)
  (let ((n32 ((_ extract 7 7) $6))) ; (_ BitVec 1)
  (let ((n33 ((_ extract 6 6) $6))) ; (_ BitVec 1)
  (let ((n34 ((_ extract 5 5) $6))) ; (_ BitVec 1)
  (let ((n35 ((_ extract 4 4) $6))) ; (_ BitVec 1)
  (let ((n36 ((_ extract 3 3) $6))) ; (_ BitVec 1)
  (let ((n37 ((_ extract 2 2) $6))) ; (_ BitVec 1)
  (let ((c2l_undefined_1_Y (Clocks_Inputs_c2l_undefined_1_Y inputs))) ; (_ BitVec 8)
  (let (($7 (ite (= latch_en #b1) d c2l_undefined_1_Y))) ; (_ BitVec 8)
  (let ((n40 ((_ extract 1 1) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$104$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$104 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$108$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$108 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_0__sampled$105
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$106 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$109$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_0__sampled$105 #b1)
        $auto$clk2fflogic.cc_108_sample_data$108$_Q
        $auto$clk2fflogic.cc_108_sample_data$104$_Q))) ; (_ BitVec 1)
  (let ((n45 ((_ extract 0 0) $7))) ; (_ BitVec 1)
  (let ((n46 ((_ extract 0 0) $6))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$111$_Y
      (ite (= n46 #b1) n45 $auto$clk2fflogic.cc_123_mux$109$_Y))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$94$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$94 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$98$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$98 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_1__sampled$95
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$96 state))) ; (_ BitVec 1)
  (let
    (($auto$rtlil.cc_3381_Mux$100
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_1__sampled$95 #b1)
        $auto$clk2fflogic.cc_108_sample_data$98$_Q
        $auto$clk2fflogic.cc_108_sample_data$94$_Q))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$101$_Y
      (ite (= n30 #b1) n40 $auto$rtlil.cc_3381_Mux$100))) ; (_ BitVec 1)
  (let
    ((n53
      (concat
        $auto$clk2fflogic.cc_123_mux$101$_Y
        $auto$clk2fflogic.cc_123_mux$111$_Y))) ; (_ BitVec 2)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$84$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$84 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$88$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$88 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_2__sampled$85
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$86 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$89$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_2__sampled$85 #b1)
        $auto$clk2fflogic.cc_108_sample_data$88$_Q
        $auto$clk2fflogic.cc_108_sample_data$84$_Q))) ; (_ BitVec 1)
  (let ((n58 ((_ extract 2 2) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$91$_Y
      (ite (= n37 #b1) n58 $auto$clk2fflogic.cc_123_mux$89$_Y))) ; (_ BitVec 1)
  (let ((n60 (concat $auto$clk2fflogic.cc_123_mux$91$_Y n53))) ; (_ BitVec 3)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$74$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$74 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$78$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$78 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_3__sampled$75
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$76 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$79$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_3__sampled$75 #b1)
        $auto$clk2fflogic.cc_108_sample_data$78$_Q
        $auto$clk2fflogic.cc_108_sample_data$74$_Q))) ; (_ BitVec 1)
  (let ((n65 ((_ extract 3 3) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$81$_Y
      (ite (= n36 #b1) n65 $auto$clk2fflogic.cc_123_mux$79$_Y))) ; (_ BitVec 1)
  (let ((n67 (concat $auto$clk2fflogic.cc_123_mux$81$_Y n60))) ; (_ BitVec 4)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$64$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$64 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$68$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$68 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_4__sampled$65
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$66 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$69$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_4__sampled$65 #b1)
        $auto$clk2fflogic.cc_108_sample_data$68$_Q
        $auto$clk2fflogic.cc_108_sample_data$64$_Q))) ; (_ BitVec 1)
  (let ((n72 ((_ extract 4 4) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$71$_Y
      (ite (= n35 #b1) n72 $auto$clk2fflogic.cc_123_mux$69$_Y))) ; (_ BitVec 1)
  (let ((n74 (concat $auto$clk2fflogic.cc_123_mux$71$_Y n67))) ; (_ BitVec 5)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$54$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$54 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$58$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$58 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_5__sampled$55
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$56 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$59$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_5__sampled$55 #b1)
        $auto$clk2fflogic.cc_108_sample_data$58$_Q
        $auto$clk2fflogic.cc_108_sample_data$54$_Q))) ; (_ BitVec 1)
  (let ((n79 ((_ extract 5 5) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$61$_Y
      (ite (= n34 #b1) n79 $auto$clk2fflogic.cc_123_mux$59$_Y))) ; (_ BitVec 1)
  (let ((n81 (concat $auto$clk2fflogic.cc_123_mux$61$_Y n74))) ; (_ BitVec 6)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$44$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$44 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$48$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$48 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_6__sampled$45
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$46 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$49$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_6__sampled$45 #b1)
        $auto$clk2fflogic.cc_108_sample_data$48$_Q
        $auto$clk2fflogic.cc_108_sample_data$44$_Q))) ; (_ BitVec 1)
  (let ((n86 ((_ extract 6 6) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$51$_Y
      (ite (= n33 #b1) n86 $auto$clk2fflogic.cc_123_mux$49$_Y))) ; (_ BitVec 1)
  (let ((n88 (concat $auto$clk2fflogic.cc_123_mux$51$_Y n81))) ; (_ BitVec 7)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$34$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$34 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$38$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$38 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_75_sample_control$$6_7__sampled$35
      (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$36 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$39$_Y
      (ite
        (= $auto$clk2fflogic.cc_75_sample_control$$6_7__sampled$35 #b1)
        $auto$clk2fflogic.cc_108_sample_data$38$_Q
        $auto$clk2fflogic.cc_108_sample_data$34$_Q))) ; (_ BitVec 1)
  (let ((n93 ((_ extract 7 7) $7))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_123_mux$41$_Y
      (ite (= n32 #b1) n93 $auto$clk2fflogic.cc_123_mux$39$_Y))) ; (_ BitVec 1)
  (let ((l (concat $auto$clk2fflogic.cc_123_mux$41$_Y n88))) ; (_ BitVec 8)
  (let ((n96 ((_ extract 1 1) l))) ; (_ BitVec 1)
  (let ((gated_clock (bvand c1 gate_open))) ; (_ BitVec 1)
  (let ((n98 ((_ extract 7 7) l))) ; (_ BitVec 1)
  (let ((n99 ((_ extract 6 6) l))) ; (_ BitVec 1)
  (let ((n100 ((_ extract 5 5) l))) ; (_ BitVec 1)
  (let ((n101 ((_ extract 4 4) l))) ; (_ BitVec 1)
  (let ((n102 ((_ extract 3 3) l))) ; (_ BitVec 1)
  (let ((n103 ((_ extract 2 2) l))) ; (_ BitVec 1)
  (let ((n104 ((_ extract 0 0) l))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$152$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$152 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$154$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$154 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$156$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$156 state))) ; (_ BitVec 1)
  (let ((n108 (concat $auto$clk2fflogic.cc_92_sample_control_edge$156$_Q c1))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$158 (ite (= n108 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((p
      (ite
        (= $auto$rtlil.cc_3302_Eqx$158 #b1)
        $auto$clk2fflogic.cc_108_sample_data$154$_Q
        $auto$clk2fflogic.cc_108_sample_data$152$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$132$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$132 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$134$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$134 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$136$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$136 state))) ; (_ BitVec 1)
  (let ((n114 (concat $auto$clk2fflogic.cc_92_sample_control_edge$136$_Q c2))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$138 (ite (= n114 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((n
      (ite
        (= $auto$rtlil.cc_3302_Eqx$138 #b1)
        $auto$clk2fflogic.cc_108_sample_data$134$_Q
        $auto$clk2fflogic.cc_108_sample_data$132$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$14$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$14 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$16$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$16 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$18$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$18 state))) ; (_ BitVec 1)
  (let
    ((n121
      (concat $auto$clk2fflogic.cc_92_sample_control_edge$18$_Q gated_clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$20 (ite (= n121 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((g
      (ite
        (= $auto$rtlil.cc_3302_Eqx$20 #b1)
        $auto$clk2fflogic.cc_108_sample_data$16$_Q
        $auto$clk2fflogic.cc_108_sample_data$14$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$142$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$142 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$144$_Q
      (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$144 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$146$_Q
      (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$146 state))) ; (_ BitVec 1)
  (let ((n127 (concat $auto$clk2fflogic.cc_92_sample_control_edge$146$_Q c1))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$148 (ite (= n127 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((crossed
      (ite
        (= $auto$rtlil.cc_3302_Eqx$148 #b1)
        $auto$clk2fflogic.cc_108_sample_data$144$_Q
        $auto$clk2fflogic.cc_108_sample_data$142$_Q))) ; (_ BitVec 8)
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
      $19 ; $auto$clk2fflogic.cc:80:sample_control$26
      $20 ; $auto$clk2fflogic.cc:108:sample_data$28
      gate_open ; $auto$clk2fflogic.cc:108:sample_data$24
      c1 ; $auto$clk2fflogic.cc:92:sample_control_edge$118
      d ; $auto$clk2fflogic.cc:108:sample_data$116
      a ; $auto$clk2fflogic.cc:108:sample_data$114
      n30 ; $auto$clk2fflogic.cc:80:sample_control$96
      c1 ; $auto$clk2fflogic.cc:92:sample_control_edge$156
      c2 ; $auto$clk2fflogic.cc:92:sample_control_edge$136
      n32 ; $auto$clk2fflogic.cc:80:sample_control$36
      n33 ; $auto$clk2fflogic.cc:80:sample_control$46
      n34 ; $auto$clk2fflogic.cc:80:sample_control$56
      n35 ; $auto$clk2fflogic.cc:80:sample_control$66
      n36 ; $auto$clk2fflogic.cc:80:sample_control$76
      n37 ; $auto$clk2fflogic.cc:80:sample_control$86
      n40 ; $auto$clk2fflogic.cc:108:sample_data$98
      n96 ; $auto$clk2fflogic.cc:108:sample_data$94
      n46 ; $auto$clk2fflogic.cc:80:sample_control$106
      gated_clock ; $auto$clk2fflogic.cc:92:sample_control_edge$18
      c1 ; $auto$clk2fflogic.cc:92:sample_control_edge$146
      reset_0 ; $auto$clk2fflogic.cc:80:sample_control$124
      n93 ; $auto$clk2fflogic.cc:108:sample_data$38
      n98 ; $auto$clk2fflogic.cc:108:sample_data$34
      n86 ; $auto$clk2fflogic.cc:108:sample_data$48
      n99 ; $auto$clk2fflogic.cc:108:sample_data$44
      n79 ; $auto$clk2fflogic.cc:108:sample_data$58
      n100 ; $auto$clk2fflogic.cc:108:sample_data$54
      n72 ; $auto$clk2fflogic.cc:108:sample_data$68
      n101 ; $auto$clk2fflogic.cc:108:sample_data$64
      n65 ; $auto$clk2fflogic.cc:108:sample_data$78
      n102 ; $auto$clk2fflogic.cc:108:sample_data$74
      n58 ; $auto$clk2fflogic.cc:108:sample_data$88
      n103 ; $auto$clk2fflogic.cc:108:sample_data$84
      n45 ; $auto$clk2fflogic.cc:108:sample_data$108
      n104 ; $auto$clk2fflogic.cc:108:sample_data$104
      #b00000000 ; $auto$clk2fflogic.cc:108:sample_data$126
      d ; $auto$clk2fflogic.cc:108:sample_data$154
      p ; $auto$clk2fflogic.cc:108:sample_data$152
      d ; $auto$clk2fflogic.cc:108:sample_data$134
      n ; $auto$clk2fflogic.cc:108:sample_data$132
      d ; $auto$clk2fflogic.cc:108:sample_data$16
      g ; $auto$clk2fflogic.cc:108:sample_data$14
      n ; $auto$clk2fflogic.cc:108:sample_data$144
      crossed ; $auto$clk2fflogic.cc:108:sample_data$142
    ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
  )))))))))))))))))))))))))))))))))))))))))))))))))))
(declare-const Clocks-initial Clocks_State)
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$26 Clocks-initial)
    #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$28 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$24 Clocks-initial) #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$118
      Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$116 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$114 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$96 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$156
      Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$136
      Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$36 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$46 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$56 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$66 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$76 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$86 Clocks-initial)
    #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$98 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$94 Clocks-initial) #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$106 Clocks-initial)
    #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$18 Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_92_sample_control_edge$146
      Clocks-initial)
    #b1))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_80_sample_control$124 Clocks-initial)
    #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$38 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$34 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$48 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$44 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$58 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$54 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$68 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$64 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$78 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$74 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$88 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$84 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$108 Clocks-initial) #b0))
(assert
  (= (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$104 Clocks-initial) #b0))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$126 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$154 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$152 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$134 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$132 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$16 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$14 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$144 Clocks-initial)
    #b00000000))
(assert
  (=
    (Clocks_State_$auto$clk2fflogic.cc_108_sample_data$142 Clocks-initial)
    #b00000000))
