(declare-datatypes (U T) ((Value (Real (real U))
                                 (Reference (ref T)))))

(declare-datatypes () ((Reference nil four)))

(declare-fun H (Reference) (Record (Value Real Reference) (Value Real Reference)))

(declare-const y3 (Value Real Reference))
(declare-const x2 (Value Real Reference))
(declare-const self1 (Value Real Reference))
(declare-const p10 (Value Real Reference))

(declare-const p10record (Record (Value Real Reference) (Value Real Reference)))

(assert-soft (= y3 (Real 10.0)) :weight 3)
(assert-soft (= x2 (Real 10.0)) :weight 3)
(assert-soft (= self1 (Reference nil)) :weight 3)

(assert (= (H four) p10record))
(assert-soft (= (x p10record) (Real 10.0)) :weight 3)
(assert-soft (= (y p10record) (Real 10.0)) :weight 3)

(assert (= p10 (Reference four)))

(check-sat)
(get-model)
