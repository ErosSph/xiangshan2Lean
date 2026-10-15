(declare-datatype Chisel2LeanReference_Inputs
  (
    (Chisel2LeanReference_Inputs
      (Chisel2LeanReference_Inputs_reset (_ BitVec 1))
      (Chisel2LeanReference_Inputs_clock (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_0 (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_1 (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_2 (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_3 (_ BitVec 1))
      (Chisel2LeanReference_Inputs_c2l_port_4 (_ BitVec 3))
      (Chisel2LeanReference_Inputs_c2l_port_5 (_ BitVec 3))
      (Chisel2LeanReference_Inputs_c2l_port_6 (_ BitVec 16))
      (Chisel2LeanReference_Inputs_c2l_port_7 (_ BitVec 2))
      (Chisel2LeanReference_Inputs_c2l_undefined_0 (_ BitVec 8))
      (Chisel2LeanReference_Inputs_c2l_undefined_1 (_ BitVec 8))
      (Chisel2LeanReference_Inputs_c2l_undefined_2 (_ BitVec 16)))))
(declare-datatype Chisel2LeanReference_Outputs
  (
    (Chisel2LeanReference_Outputs
      (Chisel2LeanReference_Outputs_c2l_port_8 (_ BitVec 16)))))
(declare-datatype Chisel2LeanReference_State
  (
    (Chisel2LeanReference_State
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$50
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$40
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$30
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$48
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$46
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$14
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$38
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$36
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$28
        (_ BitVec 3))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$26
        (_ BitVec 3))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$18
        (_ BitVec 16))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6
        (_ BitVec 16))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$22
        (_ BitVec 16))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$20
        (_ BitVec 3))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$10
        (_ BitVec 16))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$8
        (_ BitVec 3))
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        (Array (_ BitVec 3) (_ BitVec 16))))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Chisel2LeanReference
  ((inputs Chisel2LeanReference_Inputs) (state Chisel2LeanReference_State))
  (Pair Chisel2LeanReference_Outputs Chisel2LeanReference_State)
  (let ((c2l_port_0 (Chisel2LeanReference_Inputs_c2l_port_0 inputs))) ; (_ BitVec 1)
  (let ((c2l_port_3 (Chisel2LeanReference_Inputs_c2l_port_3 inputs))) ; (_ BitVec 1)
  (let ((c2l_port_7 (Chisel2LeanReference_Inputs_c2l_port_7 inputs))) ; (_ BitVec 2)
  (let (($24$_Y (ite (distinct c2l_port_7 #b00) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((SramArrayValidation.ram.array_ext.RW0_wmode (bvand c2l_port_3 $24$_Y))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$46$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$46 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$48$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$48 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$50$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$50
        state))) ; (_ BitVec 1)
  (let
    ((n8 (concat $auto$clk2fflogic.cc_92_sample_control_edge$50$_Q c2l_port_0))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$52 (ite (= n8 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((SramArrayValidation.ram.array_ext._RW0_rmode_d0
      (ite
        (= $auto$rtlil.cc_3302_Eqx$52 #b1)
        $auto$clk2fflogic.cc_108_sample_data$48$_Q
        $auto$clk2fflogic.cc_108_sample_data$46$_Q))) ; (_ BitVec 1)
  (let ((c2l_port_2 (Chisel2LeanReference_Inputs_c2l_port_2 inputs))) ; (_ BitVec 1)
  (let
    ((SramArrayValidation.ram.array_ext.RW0_en (bvor c2l_port_2 c2l_port_3))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$36$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$36 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$38$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$38 state))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$40$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$40
        state))) ; (_ BitVec 1)
  (let
    ((n17 (concat $auto$clk2fflogic.cc_92_sample_control_edge$40$_Q c2l_port_0))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$42 (ite (= n17 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((SramArrayValidation.ram.array_ext._RW0_ren_d0
      (ite
        (= $auto$rtlil.cc_3302_Eqx$42 #b1)
        $auto$clk2fflogic.cc_108_sample_data$38$_Q
        $auto$clk2fflogic.cc_108_sample_data$36$_Q))) ; (_ BitVec 1)
  (let ((c2l_port_4 (Chisel2LeanReference_Inputs_c2l_port_4 inputs))) ; (_ BitVec 3)
  (let ((c2l_port_5 (Chisel2LeanReference_Inputs_c2l_port_5 inputs))) ; (_ BitVec 3)
  (let
    ((SramArrayValidation.ram.array_ext.RW0_addr
      (ite (= c2l_port_3 #b1) c2l_port_5 c2l_port_4))) ; (_ BitVec 3)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$26$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$26 state))) ; (_ BitVec 3)
  (let
    (($auto$clk2fflogic.cc_108_sample_data$28$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$28 state))) ; (_ BitVec 3)
  (let
    (($auto$clk2fflogic.cc_92_sample_control_edge$30$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$30
        state))) ; (_ BitVec 1)
  (let
    ((n26 (concat $auto$clk2fflogic.cc_92_sample_control_edge$30$_Q c2l_port_0))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$32 (ite (= n26 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((SramArrayValidation.ram.array_ext._RW0_raddr_d0
      (ite
        (= $auto$rtlil.cc_3302_Eqx$32 #b1)
        $auto$clk2fflogic.cc_108_sample_data$28$_Q
        $auto$clk2fflogic.cc_108_sample_data$26$_Q))) ; (_ BitVec 3)
  (let ((n33 ((_ extract 0 0) c2l_port_7))) ; (_ BitVec 1)
  (let (($0$_Y (bvand c2l_port_3 n33))) ; (_ BitVec 1)
  (let ((n35 ((_ extract 1 1) c2l_port_7))) ; (_ BitVec 1)
  (let (($2$_Y (bvand c2l_port_3 n35))) ; (_ BitVec 1)
  (let ((SramArrayValidation.ram.array_ext.RW0_wmask (concat $2$_Y $0$_Y))) ; (_ BitVec 2)
  (let ((n38 ((_ extract 1 1) SramArrayValidation.ram.array_ext.RW0_wmask))) ; (_ BitVec 1)
  (let (($10$_Y (bvand SramArrayValidation.ram.array_ext.RW0_en n38))) ; (_ BitVec 1)
  (let (($11$_Y (bvand $10$_Y SramArrayValidation.ram.array_ext.RW0_wmode))) ; (_ BitVec 1)
  (let (($12 (ite (= $11$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($13y (ite (= $12 #b1) #b1111111100000000 #b0000000000000000))) ; (_ BitVec 16)
  (let (($5$_Y (bvand SramArrayValidation.ram.array_ext.RW0_en $0$_Y))) ; (_ BitVec 1)
  (let (($6$_Y (bvand $5$_Y SramArrayValidation.ram.array_ext.RW0_wmode))) ; (_ BitVec 1)
  (let (($7 (ite (= $6$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($8y (ite (= $7 #b1) #b0000000011111111 #b0000000000000000))) ; (_ BitVec 16)
  (let ((c2l_undefined_0 (Chisel2LeanReference_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 8)
  (let ((c2l_port_6 (Chisel2LeanReference_Inputs_c2l_port_6 inputs))) ; (_ BitVec 16)
  (let ((n50 ((_ extract 15 8) c2l_port_6))) ; (_ BitVec 8)
  (let ((n51 (concat n50 c2l_undefined_0))) ; (_ BitVec 16)
  (let ((n52 ((_ extract 7 0) c2l_port_6))) ; (_ BitVec 8)
  (let ((c2l_undefined_1 (Chisel2LeanReference_Inputs_c2l_undefined_1 inputs))) ; (_ BitVec 8)
  (let ((n54 (concat c2l_undefined_1 n52))) ; (_ BitVec 16)
  (let
    ((n55
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        state))) ; (Array (_ BitVec 3) (_ BitVec 16))
  (let
    (($auto$clk2fflogic.cc_210_execute$8$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$8 state))) ; (_ BitVec 3)
  (let ((n57 (select n55 $auto$clk2fflogic.cc_210_execute$8$_Q))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_207_execute$6$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6 state))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_192_execute$2$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2 state))) ; (_ BitVec 1)
  (let ((n60 (concat c2l_port_0 $auto$clk2fflogic.cc_192_execute$2$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$3$_Y (ite (= n60 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$11$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$3$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$6$_Q
        #b0000000000000000))) ; (_ BitVec 16)
  (let ((n64 (bvnot $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 16)
  (let ((n65 (bvand n57 n64))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_213_execute$10$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$10 state))) ; (_ BitVec 16)
  (let
    ((n67
      (bvand
        $auto$clk2fflogic.cc_213_execute$10$_Q
        $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 16)
  (let ((n68 (bvor n65 n67))) ; (_ BitVec 16)
  (let ((n69 (store n55 $auto$clk2fflogic.cc_210_execute$8$_Q n68))) ; (Array (_ BitVec 3) (_ BitVec 16))
  (let
    (($auto$clk2fflogic.cc_210_execute$20$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$20 state))) ; (_ BitVec 3)
  (let ((n71 (select n69 $auto$clk2fflogic.cc_210_execute$20$_Q))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_207_execute$18$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$18 state))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_192_execute$14$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$14 state))) ; (_ BitVec 1)
  (let ((n74 (concat c2l_port_0 $auto$clk2fflogic.cc_192_execute$14$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$15$_Y (ite (= n74 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$23$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$15$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$18$_Q
        #b0000000000000000))) ; (_ BitVec 16)
  (let ((n77 (bvnot $auto$clk2fflogic.cc_216_execute$23$_Y))) ; (_ BitVec 16)
  (let ((n78 (bvand n71 n77))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_213_execute$22$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$22 state))) ; (_ BitVec 16)
  (let
    ((n80
      (bvand
        $auto$clk2fflogic.cc_213_execute$22$_Q
        $auto$clk2fflogic.cc_216_execute$23$_Y))) ; (_ BitVec 16)
  (let ((n81 (bvor n78 n80))) ; (_ BitVec 16)
  (let ((n82 (store n69 $auto$clk2fflogic.cc_210_execute$20$_Q n81))) ; (Array (_ BitVec 3) (_ BitVec 16))
  (let ((c2l_undefined_2 (Chisel2LeanReference_Inputs_c2l_undefined_2 inputs))) ; (_ BitVec 16)
  (let
    ((SramArrayValidation.ram.array_ext.Memory$_RD_DATA
      (select n82 SramArrayValidation.ram.array_ext._RW0_raddr_d0))) ; (_ BitVec 16)
  (let (($17$_Y (bvnot SramArrayValidation.ram.array_ext._RW0_rmode_d0))) ; (_ BitVec 1)
  (let (($18$_Y (bvand SramArrayValidation.ram.array_ext._RW0_ren_d0 $17$_Y))) ; (_ BitVec 1)
  (let
    ((c2l_port_8
      (ite
        (= $18$_Y #b1)
        SramArrayValidation.ram.array_ext.Memory$_RD_DATA
        c2l_undefined_2))) ; (_ BitVec 16)
  (pair
    (Chisel2LeanReference_Outputs
      c2l_port_8 ; c2l_port_8
    )
    (Chisel2LeanReference_State
      c2l_port_0 ; $auto$clk2fflogic.cc:92:sample_control_edge$50
      c2l_port_0 ; $auto$clk2fflogic.cc:92:sample_control_edge$40
      c2l_port_0 ; $auto$clk2fflogic.cc:92:sample_control_edge$30
      SramArrayValidation.ram.array_ext.RW0_wmode ; $auto$clk2fflogic.cc:108:sample_data$48
      SramArrayValidation.ram.array_ext._RW0_rmode_d0 ; $auto$clk2fflogic.cc:108:sample_data$46
      c2l_port_0 ; $auto$clk2fflogic.cc:192:execute$14
      c2l_port_0 ; $auto$clk2fflogic.cc:192:execute$2
      SramArrayValidation.ram.array_ext.RW0_en ; $auto$clk2fflogic.cc:108:sample_data$38
      SramArrayValidation.ram.array_ext._RW0_ren_d0 ; $auto$clk2fflogic.cc:108:sample_data$36
      SramArrayValidation.ram.array_ext.RW0_addr ; $auto$clk2fflogic.cc:108:sample_data$28
      SramArrayValidation.ram.array_ext._RW0_raddr_d0 ; $auto$clk2fflogic.cc:108:sample_data$26
      $13y ; $auto$clk2fflogic.cc:207:execute$18
      $8y ; $auto$clk2fflogic.cc:207:execute$6
      n51 ; $auto$clk2fflogic.cc:213:execute$22
      SramArrayValidation.ram.array_ext.RW0_addr ; $auto$clk2fflogic.cc:210:execute$20
      n54 ; $auto$clk2fflogic.cc:213:execute$10
      SramArrayValidation.ram.array_ext.RW0_addr ; $auto$clk2fflogic.cc:210:execute$8
      n82 ; SramArrayValidation.ram.array_ext.Memory
    ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
  ))))))))
(declare-const Chisel2LeanReference-initial Chisel2LeanReference_State)
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$50
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$40
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$30
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$48
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$46
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$14
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2
      Chisel2LeanReference-initial)
    #b1))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$38
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$36
      Chisel2LeanReference-initial)
    #b0))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$28
      Chisel2LeanReference-initial)
    #b000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$26
      Chisel2LeanReference-initial)
    #b000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$18
      Chisel2LeanReference-initial)
    #b0000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6
      Chisel2LeanReference-initial)
    #b0000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$22
      Chisel2LeanReference-initial)
    #b0000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$20
      Chisel2LeanReference-initial)
    #b000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$10
      Chisel2LeanReference-initial)
    #b0000000000000000))
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$8
      Chisel2LeanReference-initial)
    #b000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b000)
    #b0000000000000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b001)
    #b0000000000000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b010)
    #b0000000000000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b011)
    #b0000000000000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b100)
    #b0000000000000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b101)
    #b0000000000000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b110)
    #b0000000000000000))
(assert
  (=
    (select
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        Chisel2LeanReference-initial)
      #b111)
    #b0000000000000000))
