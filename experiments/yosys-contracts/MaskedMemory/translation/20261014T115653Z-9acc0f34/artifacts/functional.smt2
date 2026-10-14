(declare-datatype MaskedMemory_Inputs
  (
    (MaskedMemory_Inputs
      (MaskedMemory_Inputs_clock (_ BitVec 1))
      (MaskedMemory_Inputs_addr0 (_ BitVec 2))
      (MaskedMemory_Inputs_addr1 (_ BitVec 2))
      (MaskedMemory_Inputs_readAddr (_ BitVec 2))
      (MaskedMemory_Inputs_en0 (_ BitVec 1))
      (MaskedMemory_Inputs_en1 (_ BitVec 1))
      (MaskedMemory_Inputs_mask0 (_ BitVec 2))
      (MaskedMemory_Inputs_mask1 (_ BitVec 2))
      (MaskedMemory_Inputs_data0 (_ BitVec 8))
      (MaskedMemory_Inputs_data1 (_ BitVec 8))
      (MaskedMemory_Inputs_c2l_undefined_0 (_ BitVec 4))
      (MaskedMemory_Inputs_c2l_undefined_1 (_ BitVec 4))
      (MaskedMemory_Inputs_c2l_undefined_2 (_ BitVec 4))
      (MaskedMemory_Inputs_c2l_undefined_3 (_ BitVec 4)))))
(declare-datatype MaskedMemory_Outputs
  (
    (MaskedMemory_Outputs
      (MaskedMemory_Outputs_q (_ BitVec 8)))))
(declare-datatype MaskedMemory_State
  (
    (MaskedMemory_State
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$38 (_ BitVec 1))
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$26 (_ BitVec 1))
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$14 (_ BitVec 1))
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$2 (_ BitVec 1))
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$42 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$30 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$18 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$6 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$46 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$44 (_ BitVec 2))
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$34 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$32 (_ BitVec 2))
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$22 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$20 (_ BitVec 2))
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$10 (_ BitVec 8))
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$8 (_ BitVec 2))
      (MaskedMemory_State_mem (Array (_ BitVec 2) (_ BitVec 8))))))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  MaskedMemory
  ((inputs MaskedMemory_Inputs) (state MaskedMemory_State))
  (Pair MaskedMemory_Outputs MaskedMemory_State)
  (let ((clock (MaskedMemory_Inputs_clock inputs))) ; (_ BitVec 1)
  (let ((en1 (MaskedMemory_Inputs_en1 inputs))) ; (_ BitVec 1)
  (let ((mask1 (MaskedMemory_Inputs_mask1 inputs))) ; (_ BitVec 2)
  (let ((n7 ((_ extract 1 1) mask1))) ; (_ BitVec 1)
  (let (($13$_Y (bvand en1 n7))) ; (_ BitVec 1)
  (let (($14 (ite (= $13$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($15y (ite (= $14 #b1) #b11110000 #b00000000))) ; (_ BitVec 8)
  (let ((en0 (MaskedMemory_Inputs_en0 inputs))) ; (_ BitVec 1)
  (let ((mask0 (MaskedMemory_Inputs_mask0 inputs))) ; (_ BitVec 2)
  (let ((n13 ((_ extract 1 1) mask0))) ; (_ BitVec 1)
  (let (($9$_Y (bvand en0 n13))) ; (_ BitVec 1)
  (let (($10 (ite (= $9$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($11y (ite (= $10 #b1) #b11110000 #b00000000))) ; (_ BitVec 8)
  (let ((n18 ((_ extract 0 0) mask1))) ; (_ BitVec 1)
  (let (($5$_Y (bvand en1 n18))) ; (_ BitVec 1)
  (let (($6 (ite (= $5$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($7y (ite (= $6 #b1) #b00001111 #b00000000))) ; (_ BitVec 8)
  (let ((n22 ((_ extract 0 0) mask0))) ; (_ BitVec 1)
  (let (($1$_Y (bvand en0 n22))) ; (_ BitVec 1)
  (let (($2 (ite (= $1$_Y #b1) #b1 #b0))) ; (_ BitVec 1)
  (let (($3y (ite (= $2 #b1) #b00001111 #b00000000))) ; (_ BitVec 8)
  (let ((c2l_undefined_0 (MaskedMemory_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 4)
  (let ((data1 (MaskedMemory_Inputs_data1 inputs))) ; (_ BitVec 8)
  (let ((n28 ((_ extract 7 4) data1))) ; (_ BitVec 4)
  (let ((n29 (concat n28 c2l_undefined_0))) ; (_ BitVec 8)
  (let ((addr1 (MaskedMemory_Inputs_addr1 inputs))) ; (_ BitVec 2)
  (let ((c2l_undefined_1 (MaskedMemory_Inputs_c2l_undefined_1 inputs))) ; (_ BitVec 4)
  (let ((data0 (MaskedMemory_Inputs_data0 inputs))) ; (_ BitVec 8)
  (let ((n33 ((_ extract 7 4) data0))) ; (_ BitVec 4)
  (let ((n34 (concat n33 c2l_undefined_1))) ; (_ BitVec 8)
  (let ((addr0 (MaskedMemory_Inputs_addr0 inputs))) ; (_ BitVec 2)
  (let ((n36 ((_ extract 3 0) data1))) ; (_ BitVec 4)
  (let ((c2l_undefined_2 (MaskedMemory_Inputs_c2l_undefined_2 inputs))) ; (_ BitVec 4)
  (let ((n38 (concat c2l_undefined_2 n36))) ; (_ BitVec 8)
  (let ((n39 ((_ extract 3 0) data0))) ; (_ BitVec 4)
  (let ((c2l_undefined_3 (MaskedMemory_Inputs_c2l_undefined_3 inputs))) ; (_ BitVec 4)
  (let ((n41 (concat c2l_undefined_3 n39))) ; (_ BitVec 8)
  (let ((n42 (MaskedMemory_State_mem state))) ; (Array (_ BitVec 2) (_ BitVec 8))
  (let
    (($auto$clk2fflogic.cc_210_execute$8$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$8 state))) ; (_ BitVec 2)
  (let ((n44 (select n42 $auto$clk2fflogic.cc_210_execute$8$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_207_execute$6$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$6 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_192_execute$2$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$2 state))) ; (_ BitVec 1)
  (let ((n47 (concat clock $auto$clk2fflogic.cc_192_execute$2$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$3$_Y (ite (= n47 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$11$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$3$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$6$_Q
        #b00000000))) ; (_ BitVec 8)
  (let ((n51 (bvnot $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 8)
  (let ((n52 (bvand n44 n51))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_213_execute$10$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$10 state))) ; (_ BitVec 8)
  (let
    ((n54
      (bvand
        $auto$clk2fflogic.cc_213_execute$10$_Q
        $auto$clk2fflogic.cc_216_execute$11$_Y))) ; (_ BitVec 8)
  (let ((n55 (bvor n52 n54))) ; (_ BitVec 8)
  (let ((n56 (store n42 $auto$clk2fflogic.cc_210_execute$8$_Q n55))) ; (Array (_ BitVec 2) (_ BitVec 8))
  (let
    (($auto$clk2fflogic.cc_210_execute$20$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$20 state))) ; (_ BitVec 2)
  (let ((n58 (select n56 $auto$clk2fflogic.cc_210_execute$20$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_207_execute$18$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$18 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_192_execute$14$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$14 state))) ; (_ BitVec 1)
  (let ((n61 (concat clock $auto$clk2fflogic.cc_192_execute$14$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$15$_Y (ite (= n61 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$23$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$15$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$18$_Q
        #b00000000))) ; (_ BitVec 8)
  (let ((n64 (bvnot $auto$clk2fflogic.cc_216_execute$23$_Y))) ; (_ BitVec 8)
  (let ((n65 (bvand n58 n64))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_213_execute$22$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$22 state))) ; (_ BitVec 8)
  (let
    ((n67
      (bvand
        $auto$clk2fflogic.cc_213_execute$22$_Q
        $auto$clk2fflogic.cc_216_execute$23$_Y))) ; (_ BitVec 8)
  (let ((n68 (bvor n65 n67))) ; (_ BitVec 8)
  (let ((n69 (store n56 $auto$clk2fflogic.cc_210_execute$20$_Q n68))) ; (Array (_ BitVec 2) (_ BitVec 8))
  (let
    (($auto$clk2fflogic.cc_210_execute$32$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$32 state))) ; (_ BitVec 2)
  (let ((n71 (select n69 $auto$clk2fflogic.cc_210_execute$32$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_207_execute$30$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$30 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_192_execute$26$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$26 state))) ; (_ BitVec 1)
  (let ((n74 (concat clock $auto$clk2fflogic.cc_192_execute$26$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$27$_Y (ite (= n74 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$35$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$27$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$30$_Q
        #b00000000))) ; (_ BitVec 8)
  (let ((n77 (bvnot $auto$clk2fflogic.cc_216_execute$35$_Y))) ; (_ BitVec 8)
  (let ((n78 (bvand n71 n77))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_213_execute$34$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$34 state))) ; (_ BitVec 8)
  (let
    ((n80
      (bvand
        $auto$clk2fflogic.cc_213_execute$34$_Q
        $auto$clk2fflogic.cc_216_execute$35$_Y))) ; (_ BitVec 8)
  (let ((n81 (bvor n78 n80))) ; (_ BitVec 8)
  (let ((n82 (store n69 $auto$clk2fflogic.cc_210_execute$32$_Q n81))) ; (Array (_ BitVec 2) (_ BitVec 8))
  (let
    (($auto$clk2fflogic.cc_210_execute$44$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$44 state))) ; (_ BitVec 2)
  (let ((n84 (select n82 $auto$clk2fflogic.cc_210_execute$44$_Q))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_207_execute$42$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$42 state))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_192_execute$38$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$38 state))) ; (_ BitVec 1)
  (let ((n87 (concat clock $auto$clk2fflogic.cc_192_execute$38$_Q))) ; (_ BitVec 2)
  (let (($auto$clk2fflogic.cc_204_execute$39$_Y (ite (= n87 #b10) #b1 #b0))) ; (_ BitVec 1)
  (let
    (($auto$clk2fflogic.cc_216_execute$47$_Y
      (ite
        (= $auto$clk2fflogic.cc_204_execute$39$_Y #b1)
        $auto$clk2fflogic.cc_207_execute$42$_Q
        #b00000000))) ; (_ BitVec 8)
  (let ((n90 (bvnot $auto$clk2fflogic.cc_216_execute$47$_Y))) ; (_ BitVec 8)
  (let ((n91 (bvand n84 n90))) ; (_ BitVec 8)
  (let
    (($auto$clk2fflogic.cc_213_execute$46$_Q
      (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$46 state))) ; (_ BitVec 8)
  (let
    ((n93
      (bvand
        $auto$clk2fflogic.cc_213_execute$46$_Q
        $auto$clk2fflogic.cc_216_execute$47$_Y))) ; (_ BitVec 8)
  (let ((n94 (bvor n91 n93))) ; (_ BitVec 8)
  (let ((n95 (store n82 $auto$clk2fflogic.cc_210_execute$44$_Q n94))) ; (Array (_ BitVec 2) (_ BitVec 8))
  (let ((readAddr (MaskedMemory_Inputs_readAddr inputs))) ; (_ BitVec 2)
  (let ((q (select n95 readAddr))) ; (_ BitVec 8)
  (pair
    (MaskedMemory_Outputs
      q ; q
    )
    (MaskedMemory_State
      clock ; $auto$clk2fflogic.cc:192:execute$38
      clock ; $auto$clk2fflogic.cc:192:execute$26
      clock ; $auto$clk2fflogic.cc:192:execute$14
      clock ; $auto$clk2fflogic.cc:192:execute$2
      $15y ; $auto$clk2fflogic.cc:207:execute$42
      $11y ; $auto$clk2fflogic.cc:207:execute$30
      $7y ; $auto$clk2fflogic.cc:207:execute$18
      $3y ; $auto$clk2fflogic.cc:207:execute$6
      n29 ; $auto$clk2fflogic.cc:213:execute$46
      addr1 ; $auto$clk2fflogic.cc:210:execute$44
      n34 ; $auto$clk2fflogic.cc:213:execute$34
      addr0 ; $auto$clk2fflogic.cc:210:execute$32
      n38 ; $auto$clk2fflogic.cc:213:execute$22
      addr1 ; $auto$clk2fflogic.cc:210:execute$20
      n41 ; $auto$clk2fflogic.cc:213:execute$10
      addr0 ; $auto$clk2fflogic.cc:210:execute$8
      n95 ; mem
    ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
  )))))))))))))))))))
(declare-const MaskedMemory-initial MaskedMemory_State)
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$38
      MaskedMemory-initial)
    #b1))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$26
      MaskedMemory-initial)
    #b1))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$14
      MaskedMemory-initial)
    #b1))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_192_execute$2 MaskedMemory-initial)
    #b1))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$42
      MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$30
      MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$18
      MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_207_execute$6 MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$46
      MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$44
      MaskedMemory-initial)
    #b00))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$34
      MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$32
      MaskedMemory-initial)
    #b00))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$22
      MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$20
      MaskedMemory-initial)
    #b00))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_213_execute$10
      MaskedMemory-initial)
    #b00000000))
(assert
  (=
    (MaskedMemory_State_$auto$clk2fflogic.cc_210_execute$8 MaskedMemory-initial)
    #b00))
(assert
  (= (select (MaskedMemory_State_mem MaskedMemory-initial) #b00) #b00000000))
(assert
  (= (select (MaskedMemory_State_mem MaskedMemory-initial) #b01) #b00000000))
(assert
  (= (select (MaskedMemory_State_mem MaskedMemory-initial) #b10) #b00000000))
(assert
  (= (select (MaskedMemory_State_mem MaskedMemory-initial) #b11) #b00000000))
