(declare-datatype T_Inputs
  (
    (T_Inputs
      (T_Inputs_d (_ BitVec 1))
      (T_Inputs_c2l_undefined_0 (_ BitVec 1)))))
(declare-datatype T_Outputs
  (
    (T_Outputs
      (T_Outputs_q (_ BitVec 1)))))
(declare-datatype T_State
  (
    (T_State)))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun T ((inputs T_Inputs) (state T_State)) (Pair T_Outputs T_State)
  (let ((q (T_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 1)
  (pair
    (T_Outputs
      q ; q
    )
    T_State)))
(declare-const T-initial T_State)
