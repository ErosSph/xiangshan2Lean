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
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$30
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$14
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$40
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$28
        (_ BitVec 3))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$26
        (_ BitVec 3))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$18
        (_ BitVec 16))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6
        (_ BitVec 16))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$38
        (_ BitVec 1))
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_108_sample_data$36
        (_ BitVec 1))
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
  (let ((c2l_port_1 (Chisel2LeanReference_Inputs_c2l_port_1 inputs))) ; (_ BitVec 1)
  (let ((c2l_port_4 (Chisel2LeanReference_Inputs_c2l_port_4 inputs))) ; (_ BitVec 3)
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
    ((n6 (concat $auto$clk2fflogic.cc_92_sample_control_edge$30$_Q c2l_port_0))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$32 (ite (= n6 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((SramArrayValidation.ram.array_ext._R0_addr_d0
      (ite
        (= $auto$rtlil.cc_3302_Eqx$32 #b1)
        $auto$clk2fflogic.cc_108_sample_data$28$_Q
        $auto$clk2fflogic.cc_108_sample_data$26$_Q))) ; (_ BitVec 3)
  (let ((c2l_port_3 (Chisel2LeanReference_Inputs_c2l_port_3 inputs))) ; (_ BitVec 1)
  (let ((c2l_port_7 (Chisel2LeanReference_Inputs_c2l_port_7 inputs))) ; (_ BitVec 2)
  (let ((n16 ((_ extract 1 1) c2l_port_7))) ; (_ BitVec 1)
  (let (($6$_Y (bvand c2l_port_3 n16))) ; (_ BitVec 1)
  (let (($7 (ite (= $6$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($8y (ite (= $7 #b1) #b1111111100000000 #b0000000000000000))) ; (_ BitVec 16)
  (let ((n21 ((_ extract 0 0) c2l_port_7))) ; (_ BitVec 1)
  (let (($2$_Y (bvand c2l_port_3 n21))) ; (_ BitVec 1)
  (let (($3 (ite (= $2$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($4y (ite (= $3 #b1) #b0000000011111111 #b0000000000000000))) ; (_ BitVec 16)
  (let ((c2l_port_2 (Chisel2LeanReference_Inputs_c2l_port_2 inputs))) ; (_ BitVec 1)
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
    ((n29 (concat $auto$clk2fflogic.cc_92_sample_control_edge$40$_Q c2l_port_0))) ; (_ BitVec 2)
  (let (($auto$rtlil.cc_3302_Eqx$42 (ite (= n29 #b01) #b1 #b0))) ; (_ BitVec 1)
  (let
    ((SramArrayValidation.ram.array_ext._R0_en_d0
      (ite
        (= $auto$rtlil.cc_3302_Eqx$42 #b1)
        $auto$clk2fflogic.cc_108_sample_data$38$_Q
        $auto$clk2fflogic.cc_108_sample_data$36$_Q))) ; (_ BitVec 1)
  (let ((c2l_undefined_0 (Chisel2LeanReference_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 8)
  (let ((c2l_port_6 (Chisel2LeanReference_Inputs_c2l_port_6 inputs))) ; (_ BitVec 16)
  (let ((n34 ((_ extract 15 8) c2l_port_6))) ; (_ BitVec 8)
  (let ((n35 (concat n34 c2l_undefined_0))) ; (_ BitVec 16)
  (let ((c2l_port_5 (Chisel2LeanReference_Inputs_c2l_port_5 inputs))) ; (_ BitVec 3)
  (let ((n37 ((_ extract 7 0) c2l_port_6))) ; (_ BitVec 8)
  (let ((c2l_undefined_1 (Chisel2LeanReference_Inputs_c2l_undefined_1 inputs))) ; (_ BitVec 8)
  (let ((n39 (concat c2l_undefined_1 n37))) ; (_ BitVec 16)
  (let
    ((n40
      (Chisel2LeanReference_State_SramArrayValidation.ram.array_ext.Memory
        state))) ; (Array (_ BitVec 3) (_ BitVec 16))
  (let
    (($auto$clk2fflogic.cc_210_execute$8$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$8 state))) ; (_ BitVec 3)
  (let ((n42 (select n40 $auto$clk2fflogic.cc_210_execute$8$_Q))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_207_execute$6$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$6 state))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_192_execute$2$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$2 state))) ; (_ BitVec 1)
  (let ((n45 (concat c2l_port_1 $auto$clk2fflogic.cc_192_execute$2$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$3$_Y (ite (= n45 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$11$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$3$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$6$_Q
        #b0000000000000000))) ; (_ BitVec 16)
  (let ((n49 (bvnot $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 16)
  (let ((n50 (bvand n42 n49))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_213_execute$10$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$10 state))) ; (_ BitVec 16)
  (let
    ((n52
      (bvand
        $auto$clk2fflogic.cc_213_execute$10$_Q
        $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 16)
  (let ((n53 (bvor n50 n52))) ; (_ BitVec 16)
  (let ((n54 (store n40 $auto$clk2fflogic.cc_210_execute$8$_Q n53))) ; (Array (_ BitVec 3) (_ BitVec 16))
  (let
    (($auto$clk2fflogic.cc_210_execute$20$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_210_execute$20 state))) ; (_ BitVec 3)
  (let ((n56 (select n54 $auto$clk2fflogic.cc_210_execute$20$_Q))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_207_execute$18$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_207_execute$18 state))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_192_execute$14$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_192_execute$14 state))) ; (_ BitVec 1)
  (let ((n59 (concat c2l_port_1 $auto$clk2fflogic.cc_192_execute$14$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$15$_Y (ite (= n59 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$23$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$15$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$18$_Q
        #b0000000000000000))) ; (_ BitVec 16)
  (let ((n62 (bvnot $auto$clk2fflogic.cc_216_execute$23$_Y))) ; (_ BitVec 16)
  (let ((n63 (bvand n56 n62))) ; (_ BitVec 16)
  (let
    (($auto$clk2fflogic.cc_213_execute$22$_Q
      (Chisel2LeanReference_State_$auto$clk2fflogic.cc_213_execute$22 state))) ; (_ BitVec 16)
  (let
    ((n65
      (bvand
        $auto$clk2fflogic.cc_213_execute$22$_Q
        $auto$clk2fflogic.cc_216_execute$23$_Y))) ; (_ BitVec 16)
  (let ((n66 (bvor n63 n65))) ; (_ BitVec 16)
  (let ((n67 (store n54 $auto$clk2fflogic.cc_210_execute$20$_Q n66))) ; (Array (_ BitVec 3) (_ BitVec 16))
  (let ((c2l_undefined_2 (Chisel2LeanReference_Inputs_c2l_undefined_2 inputs))) ; (_ BitVec 16)
  (let
    ((SramArrayValidation.ram.array_ext.Memory$_RD_DATA
      (select n67 SramArrayValidation.ram.array_ext._R0_addr_d0))) ; (_ BitVec 16)
  (let
    ((c2l_port_8
      (ite
        (= SramArrayValidation.ram.array_ext._R0_en_d0 #b1)
        SramArrayValidation.ram.array_ext.Memory$_RD_DATA
        c2l_undefined_2))) ; (_ BitVec 16)
  (pair
    (Chisel2LeanReference_Outputs
      c2l_port_8 ; c2l_port_8
    )
    (Chisel2LeanReference_State
      c2l_port_0 ; $auto$clk2fflogic.cc:92:sample_control_edge$30
      c2l_port_1 ; $auto$clk2fflogic.cc:192:execute$14
      c2l_port_1 ; $auto$clk2fflogic.cc:192:execute$2
      c2l_port_0 ; $auto$clk2fflogic.cc:92:sample_control_edge$40
      c2l_port_4 ; $auto$clk2fflogic.cc:108:sample_data$28
      SramArrayValidation.ram.array_ext._R0_addr_d0 ; $auto$clk2fflogic.cc:108:sample_data$26
      $8y ; $auto$clk2fflogic.cc:207:execute$18
      $4y ; $auto$clk2fflogic.cc:207:execute$6
      c2l_port_2 ; $auto$clk2fflogic.cc:108:sample_data$38
      SramArrayValidation.ram.array_ext._R0_en_d0 ; $auto$clk2fflogic.cc:108:sample_data$36
      n35 ; $auto$clk2fflogic.cc:213:execute$22
      c2l_port_5 ; $auto$clk2fflogic.cc:210:execute$20
      n39 ; $auto$clk2fflogic.cc:213:execute$10
      c2l_port_5 ; $auto$clk2fflogic.cc:210:execute$8
      n67 ; SramArrayValidation.ram.array_ext.Memory
    )))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
(declare-const Chisel2LeanReference-initial Chisel2LeanReference_State)
(assert
  (=
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$30
      Chisel2LeanReference-initial)
    #b1))
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
    (Chisel2LeanReference_State_$auto$clk2fflogic.cc_92_sample_control_edge$40
      Chisel2LeanReference-initial)
    #b1))
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
