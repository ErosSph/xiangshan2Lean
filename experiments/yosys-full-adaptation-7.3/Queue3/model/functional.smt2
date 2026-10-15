(declare-datatype Chisel2LeanReference_Inputs
  (
    (Chisel2LeanReference_Inputs
      (Chisel2LeanReference_Inputs_reset (_ BitVec 1))
      (Chisel2LeanReference_Inputs_clock (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_1 (_ BitVec 8))
      (Chisel2LeanReference_Inputs_c2l_port_3 (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_5 (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_undefined_0 (_ BitVec 8))
      (Chisel2LeanReference_Inputs_c2l_undefined_1 (_ BitVec 2))
      (Chisel2LeanReference_Inputs_c2l_undefined_2 (_ BitVec 2))
      (Chisel2LeanReference_Inputs_c2l_undefined_3 (_ BitVec 1)))))
(declare-datatype Chisel2LeanReference_Outputs
  (
    (Chisel2LeanReference_Outputs
      (Chisel2LeanReference_Outputs_c2l_port_0 (_ BitVec 2))
      (Chisel2LeanReference_Outputs_c2l_port_2 (_ BitVec 1))
      (Chisel2LeanReference_Outputs_c2l_port_4 (_ BitVec 8))
      (Chisel2LeanReference_Outputs_c2l_port_6 (_ BitVec 1)))))
(declare-datatype Chisel2LeanReference_State
  (
    (Chisel2LeanReference_State
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$28
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$18
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$38
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$26
        (_ BitVec 2))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$24
        (_ BitVec 2))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$16
        (_ BitVec 2))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$14
        (_ BitVec 2))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6
        (_ BitVec 8))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$36
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$34
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$10
        (_ BitVec 8))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$8
        (_ BitVec 2))
      (Chisel2LeanReference_State_QueueTop.queue.ram_ext.Memory
        (Array (_ BitVec 2) (_ BitVec 8))))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Chisel2LeanReference
  ((inputs Chisel2LeanReference_Inputs) (state Chisel2LeanReference_State))
  (Pair Chisel2LeanReference_Outputs Chisel2LeanReference_State)
  (let ((clock (Chisel2LeanReference_Inputs_clock inputs))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$24$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$24 state))) ; (_ BitVec 2)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$26$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$26 state))) ; (_ BitVec 2)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$28$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$28
        state))) ; (_ BitVec 1)
  (let ((n4 (concat $auto$clk2fflogic.cc_92_sample_control_edge$28$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$30 (ite (= n4 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((QueueTop.queue.ram_ext.W0_addr
      (ite
        (= $auto$rtlil.cc_3302_Eqx$30 #b1)
        $auto$clk2fflogic.cc_108_sample_data$26$_Q
        $auto$clk2fflogic.cc_108_sample_data$24$_Q))) ; (_ BitVec 2)
  (let (($15$_Y (bvadd QueueTop.queue.ram_ext.W0_addr #b01))) ; (_ BitVec 2)
  (let (($16$_Y (ite (= QueueTop.queue.ram_ext.W0_addr #b10) #b1 #b0))) ; (_ BitVec 1)
  (let (($17$_Y (ite (= $16$_Y #b1) #b00 $15$_Y))) ; (_ BitVec 2)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$14$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$14 state))) ; (_ BitVec 2)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$16$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$16 state))) ; (_ BitVec 2)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$18$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$18
        state))) ; (_ BitVec 1)
  (let ((n16 (concat $auto$clk2fflogic.cc_92_sample_control_edge$18$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$20 (ite (= n16 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((QueueTop.queue.ram_ext.R0_addr
      (ite
        (= $auto$rtlil.cc_3302_Eqx$20 #b1)
        $auto$clk2fflogic.cc_108_sample_data$16$_Q
        $auto$clk2fflogic.cc_108_sample_data$14$_Q))) ; (_ BitVec 2)
  (let
    (($0$_Y
      (ite
        (= QueueTop.queue.ram_ext.W0_addr QueueTop.queue.ram_ext.R0_addr)
        #b1
        #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$34$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$34 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$36$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$36 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$38$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$38
        state))) ; (_ BitVec 1)
  (let ((n23 (concat $auto$clk2fflogic.cc_92_sample_control_edge$38$_Q clock))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$40 (ite (= n23 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((QueueTop.queue.maybe_full
      (ite
        (= $auto$rtlil.cc_3302_Eqx$40 #b1)
        $auto$clk2fflogic.cc_108_sample_data$36$_Q
        $auto$clk2fflogic.cc_108_sample_data$34$_Q))) ; (_ BitVec 1)
  (let ((QueueTop.queue.full (bvand $0$_Y QueueTop.queue.maybe_full))) ; (_ BitVec 1)
  (let (($7$_Y (bvnot QueueTop.queue.full))) ; (_ BitVec 1)
  (let ((c2l_port_3 (Chisel2LeanReference_Inputs_c2l_port_3 inputs))) ; (_ BitVec 1)
  (let ((QueueTop.queue.ram_ext.W0_en (bvand $7$_Y c2l_port_3))) ; (_ BitVec 1)
  (let
    (($procmux$15$_Y
      (ite
        (= QueueTop.queue.ram_ext.W0_en #b1)
        $17$_Y
        QueueTop.queue.ram_ext.W0_addr))) ; (_ BitVec 2)
  (let ((c2l_undefined_2 (Chisel2LeanReference_Inputs_c2l_undefined_2 inputs))) ; (_ BitVec 2)
  (let ((reset_0 (Chisel2LeanReference_Inputs_reset inputs))) ; (_ BitVec 1)
  (let (($procmux$18$_Y (ite (= reset_0 #b1) c2l_undefined_2 $procmux$15$_Y))) ; (_ BitVec 2)
  (let
    (($QueueTop.queue.enq_ptr_value$25
      (ite (= reset_0 #b1) #b00 $procmux$18$_Y))) ; (_ BitVec 2)
  (let (($19$_Y (bvadd QueueTop.queue.ram_ext.R0_addr #b01))) ; (_ BitVec 2)
  (let (($20$_Y (ite (= QueueTop.queue.ram_ext.R0_addr #b10) #b1 #b0))) ; (_ BitVec 1)
  (let (($21$_Y (ite (= $20$_Y #b1) #b00 $19$_Y))) ; (_ BitVec 2)
  (let ((c2l_port_5 (Chisel2LeanReference_Inputs_c2l_port_5 inputs))) ; (_ BitVec 1)
  (let (($2$_Y (bvnot QueueTop.queue.maybe_full))) ; (_ BitVec 1)
  (let ((QueueTop.queue.empty (bvand $0$_Y $2$_Y))) ; (_ BitVec 1)
  (let (($13$_Y (bvnot QueueTop.queue.empty))) ; (_ BitVec 1)
  (let (($14$_Y (bvand c2l_port_5 $13$_Y))) ; (_ BitVec 1)
  (let
    (($procmux$10$_Y (ite (= $14$_Y #b1) $21$_Y QueueTop.queue.ram_ext.R0_addr))) ; (_ BitVec 2)
  (let ((c2l_undefined_1 (Chisel2LeanReference_Inputs_c2l_undefined_1 inputs))) ; (_ BitVec 2)
  (let (($procmux$13$_Y (ite (= reset_0 #b1) c2l_undefined_1 $procmux$10$_Y))) ; (_ BitVec 2)
  (let
    (($QueueTop.queue.deq_ptr_value$26
      (ite (= reset_0 #b1) #b00 $procmux$13$_Y))) ; (_ BitVec 2)
  (let (($29 (ite (= QueueTop.queue.ram_ext.W0_en #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($30y (ite (= $29 #b1) #b11111111 #b00000000))) ; (_ BitVec 8)
  (let (($23$_Y (ite (distinct QueueTop.queue.ram_ext.W0_en $14$_Y) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($procmux$4$_Y
      (ite
        (= $23$_Y #b1)
        QueueTop.queue.ram_ext.W0_en
        QueueTop.queue.maybe_full))) ; (_ BitVec 1)
  (let ((c2l_undefined_3 (Chisel2LeanReference_Inputs_c2l_undefined_3 inputs))) ; (_ BitVec 1)
  (let
    (($QueueTop.queue.maybe_full$24
      (ite (= reset_0 #b1) c2l_undefined_3 $procmux$4$_Y))) ; (_ BitVec 1)
  (let
    (($QueueTop.queue.maybe_full$27
      (ite (= reset_0 #b1) #b0 $QueueTop.queue.maybe_full$24))) ; (_ BitVec 1)
  (let ((c2l_port_1 (Chisel2LeanReference_Inputs_c2l_port_1 inputs))) ; (_ BitVec 8)
  (let ((n59 (Chisel2LeanReference_State_QueueTop.queue.ram_ext.Memory state))) ; (Array (_ BitVec 2) (_ BitVec 8))
  (let
    (($auto$clk2fflogic.cc_210_execute$8$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$8 state))) ; (_ BitVec 2)
  (let ((n61 (select n59 $auto$clk2fflogic.cc_210_execute$8$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_207_execute$6$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_192_execute$2$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2 state))) ; (_ BitVec 1)
  (let ((n64 (concat clock $auto$clk2fflogic.cc_192_execute$2$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$3$_Y (ite (= n64 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$11$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$3$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$6$_Q
        #b00000000))) ; (_ BitVec 8)
  (let ((n67 (bvnot $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 8)
  (let ((n68 (bvand n61 n67))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_213_execute$10$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$10 state))) ; (_ BitVec 8)
  (let
    ((n70
      (bvand
        $auto$clk2fflogic.cc_213_execute$10$_Q
        $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 8)
  (let ((n71 (bvor n68 n70))) ; (_ BitVec 8)
  (let ((n72 (store n59 $auto$clk2fflogic.cc_210_execute$8$_Q n71))) ; (Array (_ BitVec 2) (_ BitVec 8))
  (let
    (($10$_Y
      (bvsub QueueTop.queue.ram_ext.W0_addr QueueTop.queue.ram_ext.R0_addr))) ; (_ BitVec 2)
  (let (($48$_Y (bvsub $10$_Y #b01))) ; (_ BitVec 2)
  (let
    (($49$_Y
      (ite
        (bvugt QueueTop.queue.ram_ext.R0_addr QueueTop.queue.ram_ext.W0_addr)
        #b1
        #b0))) ; (_ BitVec 1)
  (let (($50$_Y (ite (= $49$_Y #b1) $48$_Y $10$_Y))) ; (_ BitVec 2)
  (let ((n77 (concat QueueTop.queue.maybe_full QueueTop.queue.maybe_full))) ; (_ BitVec 2)
  (let ((c2l_port_0 (ite (= $0$_Y #b1) n77 $50$_Y))) ; (_ BitVec 2)
  (let ((c2l_port_2 (bvnot QueueTop.queue.full))) ; (_ BitVec 1)
  (let ((c2l_undefined_0 (Chisel2LeanReference_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 8)
  (let
    ((QueueTop.queue.ram_ext.Memory$_RD_DATA
      (select n72 QueueTop.queue.ram_ext.R0_addr))) ; (_ BitVec 8)
  (let
    ((c2l_port_4
      (ite (= #b1 #b1) QueueTop.queue.ram_ext.Memory$_RD_DATA c2l_undefined_0))) ; (_ BitVec 8)
  (let ((c2l_port_6 (bvnot QueueTop.queue.empty))) ; (_ BitVec 1)
  (pair
    (Chisel2LeanReference_Outputs
      c2l_port_0 ; c2l_port_0
      c2l_port_2 ; c2l_port_2
      c2l_port_4 ; c2l_port_4
      c2l_port_6 ; c2l_port_6
    )
    (Chisel2LeanReference_State
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$28
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$18
      clock ; $auto$clk2fflogic.cc:92:sample_control_edge$38
      clock ; $auto$clk2fflogic.cc:192:execute$2
      $QueueTop.queue.enq_ptr_value$25 ; $auto$clk2fflogic.cc:108:sample_data$26
      QueueTop.queue.ram_ext.W0_addr ; $auto$clk2fflogic.cc:108:sample_data$24
      $QueueTop.queue.deq_ptr_value$26 ; $auto$clk2fflogic.cc:108:sample_data$16
      QueueTop.queue.ram_ext.R0_addr ; $auto$clk2fflogic.cc:108:sample_data$14
      $30y ; $auto$clk2fflogic.cc:207:execute$6
      $QueueTop.queue.maybe_full$27 ; $auto$clk2fflogic.cc:108:sample_data$36
      QueueTop.queue.maybe_full ; $auto$clk2fflogic.cc:108:sample_data$34
      c2l_port_1 ; $auto$clk2fflogic.cc:213:execute$10
      QueueTop.queue.ram_ext.W0_addr ; $auto$clk2fflogic.cc:210:execute$8
      n72 ; QueueTop.queue.ram_ext.Memory
    ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
  ))))
(declare-const Chisel2LeanReference-initial Chisel2LeanReference_State)
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$28
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$18
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$38
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$26
      Chisel2LeanReference-initial)
    #b00))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$24
      Chisel2LeanReference-initial)
    #b00))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$16
      Chisel2LeanReference-initial)
    #b00))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$14
      Chisel2LeanReference-initial)
    #b00))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6
      Chisel2LeanReference-initial)
    #b00000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$36
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$34
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$10
      Chisel2LeanReference-initial)
    #b00000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$8
      Chisel2LeanReference-initial)
    #b00))
(assert
  (=
    (select
      (Chisel2LeanReference_State_QueueTop.queue.ram_ext.Memory
        Chisel2LeanReference-initial)
      #b00)
    #b00000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_QueueTop.queue.ram_ext.Memory
        Chisel2LeanReference-initial)
      #b01)
    #b00000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_QueueTop.queue.ram_ext.Memory
        Chisel2LeanReference-initial)
      #b10)
    #b00000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_QueueTop.queue.ram_ext.Memory
        Chisel2LeanReference-initial)
      #b11)
    #b00000000))
