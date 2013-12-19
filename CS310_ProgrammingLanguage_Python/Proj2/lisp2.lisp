(define area 
    (lambda (r) 
      (* 3.14 (* r r))))

(define half
    (lambda (r)
      (* 0.5 (area r))))

(define quater
    (lambda(r)
      (* 0.5 (half r))))

(trace area)
(trace half)
(trace quater)

(say (quater 2))
