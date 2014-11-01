(set-option :pp.decimal true)

(declare-datatypes () ((Reference nil four)))

(declare-datatypes (TX TY) ((Record (mk-record (x TX) (y TY)))))

(declare-fun H (Reference) (Record Real Real))

(declare-const y3 Real)
(declare-const x2 Real)
(declare-const self1 Reference)
(declare-const p10 Reference)
(declare-const p10record (Record Real Real))

(assert-soft (= y3 10.0) :weight 3)
(assert-soft (= x2 10.0) :weight 3)
(assert-soft (= self1 nil) :weight 3)

(assert (= (H four) p10record))
(assert-soft (= (x p10record) 10.0) :weight 3)
(assert-soft (= (y p10record) 10.0) :weight 3)

(assert (= p10 four))

(check-sat)
(get-model)
