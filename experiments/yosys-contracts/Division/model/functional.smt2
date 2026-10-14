(declare-datatype T_Inputs
  (
    (T_Inputs
      (T_Inputs_a (_ BitVec 4))
      (T_Inputs_b (_ BitVec 4))
      (T_Inputs_en (_ BitVec 1)))))
(declare-datatype T_Outputs
  (
    (T_Outputs
      (T_Outputs_q (_ BitVec 4)))))
(declare-datatype T_State
  (
    (T_State)))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun T ((inputs T_Inputs) (state T_State)) (Pair T_Outputs T_State)
  (let ((a (T_Inputs_a inputs))) ; (_ BitVec 4)
  (let ((b (T_Inputs_b inputs))) ; (_ BitVec 4)
  (let (($0$_Y (bvudiv a b))) ; (_ BitVec 4)
  (let ((en (T_Inputs_en inputs))) ; (_ BitVec 1)
  (let ((q (ite (= en #b1) $0$_Y a))) ; (_ BitVec 4)
  (pair
    (T_Outputs
      q ; q
    )
    T_State)))))))
(declare-const T-initial T_State)
