(declare-datatype Arbitrary_Inputs
  (
    (Arbitrary_Inputs
      (Arbitrary_Inputs_a (_ BitVec 65))
      (Arbitrary_Inputs_c2l_undefined_0 (_ BitVec 65)))))
(declare-datatype Arbitrary_Outputs
  (
    (Arbitrary_Outputs
      (Arbitrary_Outputs_y (_ BitVec 65)))))
(declare-datatype Arbitrary_State
  (
    (Arbitrary_State)))
(declare-datatypes ((Pair 2)) ((par (X Y) ((pair (first X) (second Y))))))
(define-fun
  Arbitrary
  ((inputs Arbitrary_Inputs) (state Arbitrary_State))
  (Pair Arbitrary_Outputs Arbitrary_State)
  (let ((a (Arbitrary_Inputs_a inputs))) ; (_ BitVec 65)
  (let ((c2l_undefined_0 (Arbitrary_Inputs_c2l_undefined_0 inputs))) ; (_ BitVec 65)
  (let ((y (bvxor a c2l_undefined_0))) ; (_ BitVec 65)
  (pair
    (Arbitrary_Outputs
      y ; y
    )
    Arbitrary_State)))))
(declare-const Arbitrary-initial Arbitrary_State)
