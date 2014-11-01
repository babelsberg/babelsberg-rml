(set-option :pp.decimal true)
(set-option :model.compact true)

; These finite types need to be generated
(declare-datatypes () ((Reference invalid nil four)))
(declare-datatypes () ((Label x y)))


; Next block of declarations are the same everywhere
; We use a Union type for values
(declare-datatypes (U T) ((Value (Real (real U))
                                 (Reference (ref T)))))
; A default record has 'invalid' for all fields
(declare-const iRec (Array Label (Value Real Reference)))
(assert (= iRec ((as const (Array Label (Value Real Reference))) (Reference invalid))))
; Records are (Array Label (Value Real Reference))
(declare-fun H ((Value Real Reference)) (Array Label (Value Real Reference)))
(assert (and (= (H (Reference invalid)) iRec) (= (H (Reference nil)) iRec)))


; We declare each variable as a value type
(declare-const y3 (Value Real Reference))
(declare-const x2 (Value Real Reference))
(declare-const self1 (Value Real Reference))
(declare-const p10 (Value Real Reference))

; We declare all heap-records' fields
(declare-const four_x (Value Real Reference))
(declare-const four_y (Value Real Reference))

; The constraints
(assert-soft (= y3 (Real 10.0)) :weight 3)
(assert-soft (= x2 (Real 10.0)) :weight 3)
(assert-soft (= self1 (Reference nil)) :weight 3)

; The heap constraints. Each heap location maps to a record that is
; invalid in all but the defined fields
(assert (= (H (Reference four)) (store (store iRec x four_x) y four_y)))
(assert-soft (= four_x (Real 10.0)) :weight 3)
(assert-soft (= four_y (Real 10.0)) :weight 3)

(assert (= p10 (Reference four)))

(check-sat)
(get-model)
