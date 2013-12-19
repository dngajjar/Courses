(define area 
   (lambda (r) 
      (* 3.141592653 (* r r))))

(map area '(2 1))
(map (lambda (r) 
      (* 3.141592653 (* r r)))
	   '(2 1))
