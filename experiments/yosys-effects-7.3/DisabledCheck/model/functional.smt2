(declare-datatype T_Inputs
  (
    (T_Inputs
      (T_Inputs_a (_ BitVec 4))
      (T_Inputs_b (_ BitVec 4))
      (T_Inputs_en (_ BitVec 1)))))
(declare-datatype T_Outputs
  (
    (T_Outputs
      (T_Outputs_q (_ BitVec 1))
      (T_Outputs_c2l_effect_0_enable (_ BitVec 1))
      (T_Outputs_c2l_effect_0_condition (_ BitVec 1)))))
(declare-datatype T_State
  (
    (T_State)))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun T ((inputs T_Inputs) (state T_State)) (Pair T_Outputs T_State)
  (let ((en (T_Inputs_en inputs))) ; (_ BitVec 1)
  (let ((c2l_effect_0_enable (ite (= en #b1) #b1 #b0))) ; (_ BitVec 1)
  (let ((a (T_Inputs_a inputs))) ; (_ BitVec 4)
  (let ((n6 (concat #b0000000000000000000000000000 a))) ; (_ BitVec 32)
  (let ((b (T_Inputs_b inputs))) ; (_ BitVec 4)
  (let ((n8 (concat #b0000000000000000000000000000 b))) ; (_ BitVec 32)
  (let (($4$_Y (bvudiv n6 n8))) ; (_ BitVec 32)
  (let
    ((c2l_effect_0_condition
      (ite (bvugt $4$_Y #b00000000000000000000000000000000) #b1 #b0))) ; (_ BitVec 1)
  (pair
    (T_Outputs
      #b1 ; q
      c2l_effect_0_enable ; c2l_effect_0_enable
      c2l_effect_0_condition ; c2l_effect_0_condition
    )
    T_State))))))))))
(declare-const T-initial T_State)
