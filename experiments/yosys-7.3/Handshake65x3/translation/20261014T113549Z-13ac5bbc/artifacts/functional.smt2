(declare-datatype Chisel2LeanReference_Inputs
  (
    (Chisel2LeanReference_Inputs
      (Chisel2LeanReference_Inputs_clock (_ BitVec 1))
      (Chisel2LeanReference_Inputs_reset (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_0 (_ BitVec 65))
      (Chisel2LeanReference_Inputs_c2l_port_2 (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_4 (_ BitVec 1)))))
(declare-datatype Chisel2LeanReference_Outputs
  (
    (Chisel2LeanReference_Outputs
      (Chisel2LeanReference_Outputs_c2l_port_1 (_ BitVec 1))
      (Chisel2LeanReference_Outputs_c2l_port_3 (_ BitVec 65))
      (Chisel2LeanReference_Outputs_c2l_port_5 (_ BitVec 1)))))
(declare-datatype Chisel2LeanReference_State
  (
    (Chisel2LeanReference_State
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$16
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$14
        (_ BitVec 65))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$12
        (_ BitVec 65))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$26
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$36
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$24
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$22
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$34
        (_ BitVec 65))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$32
        (_ BitVec 65))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$4
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$2
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$56
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$46
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$54
        (_ BitVec 65))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$52
        (_ BitVec 65))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$44
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$42
        (_ BitVec 1)))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Chisel2LeanReference
  ((inputs Chisel2LeanReference_Inputs) (state Chisel2LeanReference_State))
  (Pair Chisel2LeanReference_Outputs Chisel2LeanReference_State)
  (let ((clock (Chisel2LeanReference_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$12$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$12 state))) ; (_ BitVec 65)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$14$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$14 state))) ; (_ BitVec 65)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$16$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$16
        state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$16$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$18 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((HandshakeTop.chain_1.io_in_bits
      (ite
        (= $auto$rtlil.cc_3302_Eqx$18 #b1)
        $auto$clk2fflogic.cc_108_sample_data$14$_Q
        $auto$clk2fflogic.cc_108_sample_data$12$_Q))) ; (_ BitVec 65)
  (let ((c2l_port_0 (Chisel2LeanReference_Inputs_c2l_port_0 inputs))) ; (_ BitVec 65)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$2$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$2 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$4$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$4 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$6$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
        state))) ; (_ BitVec 1)
  (let ((n12 (concat $auto$clk2fflogic.cc_92_sample_control_edge$6$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$8 (ite (= n12 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((HandshakeTop.chain_1.io_in_valid
      (ite
        (= $auto$rtlil.cc_3302_Eqx$8 #b1)
        $auto$clk2fflogic.cc_108_sample_data$4$_Q
        $auto$clk2fflogic.cc_108_sample_data$2$_Q))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_0.$not$/work/design.v_15$1$_Y
      (bvnot HandshakeTop.chain_1.io_in_valid))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$22$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$22 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$24$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$24 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$26$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$26
        state))) ; (_ BitVec 1)
  (let ((n19 (concat $auto$clk2fflogic.cc_92_sample_control_edge$26$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$28 (ite (= n19 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((HandshakeTop.chain_2.io_in_valid
      (ite
        (= $auto$rtlil.cc_3302_Eqx$28 #b1)
        $auto$clk2fflogic.cc_108_sample_data$24$_Q
        $auto$clk2fflogic.cc_108_sample_data$22$_Q))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_1.$not$/work/design.v_15$1$_Y
      (bvnot HandshakeTop.chain_2.io_in_valid))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$42$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$42 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$44$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$44 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$46$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$46
        state))) ; (_ BitVec 1)
  (let ((n26 (concat $auto$clk2fflogic.cc_92_sample_control_edge$46$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$48 (ite (= n26 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_port_5
      (ite
        (= $auto$rtlil.cc_3302_Eqx$48 #b1)
        $auto$clk2fflogic.cc_108_sample_data$44$_Q
        $auto$clk2fflogic.cc_108_sample_data$42$_Q))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_2.$not$/work/design.v_15$1$_Y
      (bvnot c2l_port_5))) ; (_ BitVec 1)
  (let ((c2l_port_4 (Chisel2LeanReference_Inputs_c2l_port_4 inputs))) ; (_ BitVec 1)
  (let
    ((HandshakeTop.chain_2.io_in_ready_0
      (bvor
        $flatten_HandshakeTop._chain_2.$not$/work/design.v_15$1$_Y
        c2l_port_4))) ; (_ BitVec 1)
  (let
    ((HandshakeTop.chain_1.io_in_ready_0
      (bvor
        $flatten_HandshakeTop._chain_1.$not$/work/design.v_15$1$_Y
        HandshakeTop.chain_2.io_in_ready_0))) ; (_ BitVec 1)
  (let
    ((c2l_port_1
      (bvor
        $flatten_HandshakeTop._chain_0.$not$/work/design.v_15$1$_Y
        HandshakeTop.chain_1.io_in_ready_0))) ; (_ BitVec 1)
  (let ((c2l_port_2 (Chisel2LeanReference_Inputs_c2l_port_2 inputs))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_0.$and$/work/design.v_21$4$_Y
      (bvand c2l_port_1 c2l_port_2))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_0.$0_data_64_0_
      (ite
        (= $flatten_HandshakeTop._chain_0.$and$/work/design.v_21$4$_Y #b1)
        c2l_port_0
        HandshakeTop.chain_1.io_in_bits))) ; (_ BitVec 65)
  (let
    (($flatten_HandshakeTop._chain_1.$procmux$7_Y
      (ite
        (= HandshakeTop.chain_1.io_in_ready_0 #b1)
        HandshakeTop.chain_1.io_in_valid
        HandshakeTop.chain_2.io_in_valid))) ; (_ BitVec 1)
  (let ((reset_0 (Chisel2LeanReference_Inputs_reset inputs))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_1.$0_valid_0_0_
      (ite (= reset_0 #b1) #b0 $flatten_HandshakeTop._chain_1.$procmux$7_Y))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$32$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$32 state))) ; (_ BitVec 65)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$34$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$34 state))) ; (_ BitVec 65)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$36$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$36
        state))) ; (_ BitVec 1)
  (let ((n44 (concat $auto$clk2fflogic.cc_92_sample_control_edge$36$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$38 (ite (= n44 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((HandshakeTop.chain_2.io_in_bits
      (ite
        (= $auto$rtlil.cc_3302_Eqx$38 #b1)
        $auto$clk2fflogic.cc_108_sample_data$34$_Q
        $auto$clk2fflogic.cc_108_sample_data$32$_Q))) ; (_ BitVec 65)
  (let
    (($flatten_HandshakeTop._chain_1.$and$/work/design.v_21$4$_Y
      (bvand
        HandshakeTop.chain_1.io_in_ready_0
        HandshakeTop.chain_1.io_in_valid))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_1.$0_data_64_0_
      (ite
        (= $flatten_HandshakeTop._chain_1.$and$/work/design.v_21$4$_Y #b1)
        HandshakeTop.chain_1.io_in_bits
        HandshakeTop.chain_2.io_in_bits))) ; (_ BitVec 65)
  (let
    (($flatten_HandshakeTop._chain_0.$procmux$7_Y
      (ite (= c2l_port_1 #b1) c2l_port_2 HandshakeTop.chain_1.io_in_valid))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_0.$0_valid_0_0_
      (ite (= reset_0 #b1) #b0 $flatten_HandshakeTop._chain_0.$procmux$7_Y))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$52$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$52 state))) ; (_ BitVec 65)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$54$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$54 state))) ; (_ BitVec 65)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$56$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$56
        state))) ; (_ BitVec 1)
  (let ((n54 (concat $auto$clk2fflogic.cc_92_sample_control_edge$56$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$58 (ite (= n54 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((c2l_port_3
      (ite
        (= $auto$rtlil.cc_3302_Eqx$58 #b1)
        $auto$clk2fflogic.cc_108_sample_data$54$_Q
        $auto$clk2fflogic.cc_108_sample_data$52$_Q))) ; (_ BitVec 65)
  (let
    (($flatten_HandshakeTop._chain_2.$and$/work/design.v_21$4$_Y
      (bvand
        HandshakeTop.chain_2.io_in_ready_0
        HandshakeTop.chain_2.io_in_valid))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_2.$0_data_64_0_
      (ite
        (= $flatten_HandshakeTop._chain_2.$and$/work/design.v_21$4$_Y #b1)
        HandshakeTop.chain_2.io_in_bits
        c2l_port_3))) ; (_ BitVec 65)
  (let
    (($flatten_HandshakeTop._chain_2.$procmux$7_Y
      (ite
        (= HandshakeTop.chain_2.io_in_ready_0 #b1)
        HandshakeTop.chain_2.io_in_valid
        c2l_port_5))) ; (_ BitVec 1)
  (let
    (($flatten_HandshakeTop._chain_2.$0_valid_0_0_
      (ite (= reset_0 #b1) #b0 $flatten_HandshakeTop._chain_2.$procmux$7_Y))) ; (_ BitVec 1)
  (pair
    (Chisel2LeanReference_Outputs
      c2l_port_1 ; c2l_port_1
      c2l_port_3 ; c2l_port_3
      c2l_port_5 ; c2l_port_5
    )
    (Chisel2LeanReference_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$16
      $flatten_HandshakeTop._chain_0.$0_data_64_0_ ; $auto$clk2fflogic.cc:108:sample_data$14
      HandshakeTop.chain_1.io_in_bits ; $auto$clk2fflogic.cc:108:sample_data$12
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$26
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$36
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$6
      $flatten_HandshakeTop._chain_1.$0_valid_0_0_ ; $auto$clk2fflogic.cc:108:sample_data$24
      HandshakeTop.chain_2.io_in_valid ; $auto$clk2fflogic.cc:108:sample_data$22
      $flatten_HandshakeTop._chain_1.$0_data_64_0_ ; $auto$clk2fflogic.cc:108:sample_data$34
      HandshakeTop.chain_2.io_in_bits ; $auto$clk2fflogic.cc:108:sample_data$32
      $flatten_HandshakeTop._chain_0.$0_valid_0_0_ ; $auto$clk2fflogic.cc:108:sample_data$4
      HandshakeTop.chain_1.io_in_valid ; $auto$clk2fflogic.cc:108:sample_data$2
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$56
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$46
      $flatten_HandshakeTop._chain_2.$0_data_64_0_ ; $auto$clk2fflogic.cc:108:sample_data$54
      c2l_port_3 ; $auto$clk2fflogic.cc:108:sample_data$52
      $flatten_HandshakeTop._chain_2.$0_valid_0_0_ ; $auto$clk2fflogic.cc:108:sample_data$44
      c2l_port_5 ; $auto$clk2fflogic.cc:108:sample_data$42
    ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
(declare-const Chisel2LeanReference-initial Chisel2LeanReference_State)
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$16
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$14
      Chisel2LeanReference-initial)
    #b00000000000000000000000000000000000000000000000000000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$12
      Chisel2LeanReference-initial)
    #b00000000000000000000000000000000000000000000000000000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$26
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$36
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$6
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$24
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$22
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$34
      Chisel2LeanReference-initial)
    #b00000000000000000000000000000000000000000000000000000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$32
      Chisel2LeanReference-initial)
    #b00000000000000000000000000000000000000000000000000000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$4
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$2
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$56
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$46
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$54
      Chisel2LeanReference-initial)
    #b00000000000000000000000000000000000000000000000000000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$52
      Chisel2LeanReference-initial)
    #b00000000000000000000000000000000000000000000000000000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$44
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$42
      Chisel2LeanReference-initial)
    #b0))
