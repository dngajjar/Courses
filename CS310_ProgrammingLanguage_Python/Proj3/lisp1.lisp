(define area 
    (lambda (r) 
      (* 3.141592653 (* r r))))

(say (area 3))

(define fact 
    (lambda (n) 
      (if (<= n 1) 
	  1 
	  (* n (fact (- n 1))))))
; fact demo
(say (fact 10))
(say (fact 100))
(say (area (fact 10)))

; example of recursive function
(define first car)
(define rest cdr)
(define count 
    (lambda (item L) 
      (if L 
	  (+ (equal? item (first L)) 
	     (count item (rest L))) 
	  0)))

; demo of count
(say (count 0 (list 0 1 2 3 0 0)))

; assoc
(define nil (list))

(define assoc
    (lambda (x lst)
      (if lst
	  (if (equal? x (car (car lst)))
	      (car (cdr (car lst)))
	      (assoc x (cdr lst)))
	  nil)))

(define data (' ((name tim)
		 (age  53)
		 (gemder  m))))

(say (assoc (' name) data))
	     