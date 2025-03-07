Lambda Calculus - Beta Reduction

Q1. (λx. x x) ((λx y. y x) z (λx. x))


1-1. Normal-order reduction:
     Reduce the leftmost redex (top-level application)
     (\x.x x) ((\xy.y x) z (\x.x))

-- De-sugaring: remove the syntactic sugar
-- \xyz.f is equivalent to \x.\y.\z.f

= (\x.x x) (((\x.(\y.y x)) z) (\x.x))
  ---------------------------------
-> ((\x.(\y.y x)) z (\x.x)) ((\x.(\y.y x)) z (\x.x))
   ---------------- [Abstractions extend far right]
-> (\y.(y z) (\x.x)) ((\x.(\y.y x)) z (\x.x))
   ----------------
-> ((\x.x) z) ((\x.(\y.y x)) z (\x.x))
   ---------
-> z ((\x.(\y.y x)) z (\x.x))
       --------------
-> z  (\y.y z (\x.x))
      ---------------
-> z  ((\x.x) z)
      --------
-> z z


1-2. Applicative-order reduction:
     Reduce the leftmost of the innermost redexes

     (\x.x x) ((\xy.y x) z (\x.x))

-- Desugaring: remove the syntactic sugar
-- \xyz.f is equivalent to \x.\y.\z.f

= (\x.x x) (((\x.(\y.y x)) z) (\x.x))
              -------------- [The leftmost of the innermost redex w/ the body of abstraction (\y.y x)]
-> (\x.x x) ((\y.(y z))(\x.x))
            ---------------- [The innermost redex w/ the body of abstraction, (y z)]
-> (\x.x x) ((\x.x) z)
            ---------- [The innermost redex]
-> (\x.x x) z
   ----------
-> z z


Q2. (λxyz.(x z)) (λz.z) ((λy.y) (λz.z)) x

 (((λxyz. (x z)) (λz. z)) ((λy. y) (λz. z))) x
----------------------[Redex 1]
                         ------------------[Redex 2]
-- There are TWO Redexes
-- which one to reduce first depends on the reduction strategy


2-1. Normal Order Reduction: Reduce the leftmost redex
    (\xyz.x z) (\z.z) ((\y.y)(\z.z)) x
    ----------------- safe substitution \z. -> \w.
-> (\yw.(\z.z) w) ((\y.y)(\z.z)) x
   ----------------------------- application is left-associative
-> (\w.(\z.z) w) x
   ---------------
->  (\z.z) x
    --------
-> x

2-2. Applicative-order reduction: reduce the leftmost of innermost
    (\xyz.x z) (\z.z) ((\y.y)(\z.z)) x
    ----------------- safe substitution \z. -> \w.
-> (\yw.(\z.z) w) ((\y.y)(\z.z)) x
        -------- this is the left-most of the innermost redex
-> (\yw.w) ((\y.y)(\z.z)) x
           --------------[Redex 2: Applicative-order]
    ---------------------[Redex 1: Normal-order]
-> (\yw.w)(\z.z)x
   ------------
-> (\w.w)x
   -------
-> x

-- We can't rename the arguments we're passing into abstraction



STEPS:
1. Identify the redexes
2. Figure out which one is innermost

e.g., (\xy.xy) (\x.x) (\z.z)

e.g., (\x. (\y.y) z) ((\w.w) z)
      ------------------------- Redex1 (Normal Order)
           --------- Redex2 (Innermost -- Leftmost -- Applicative-order)
                    ----------- Redex3 (Innermost -- Rightmost -- following the Applicative-order on Rdex2)

e.g., (\yw. w y z) (\x.x) (\y.y) 
    -> ((\y.(\w. w y z)) (\x.x)) (\y.y)  --desugar
    -> (\w.w (\x.x) z) (\y.y)
    -> (\y.y) (\x.x) z
    -> (\x.x) z 
    -> z

    e1 e2 e3
    (e1 e2) e3

e.g.,   (\yw. w y z) ((\x.x) (\y.y))
        ---------------------------- Redex 1
                     --------------- Redex 2
Normal: (\w. w ((\x.x) (\y.y)) z)
Applicative: (\yw. w y z) (\y.y)

Normal-order vs. Applicative-order reduction
-- CALL BY VALUE -- Applicative-order reduction: mostly used by real programming languages
-- LAZY EVAL -- Normal-order evaluation: it will do exactly what it's needed to do (time performance, difficult to predict on space usage)


When does an applicative order reduction that doesn't converge into a reduction?
-- This is a halting problem.

* Abstraction extends far right
-- \x.x z --- which is not a redex because the body of the abstraction is x z
-- \x.x (\y.y) z w q -- which is not a redex
* Application is left-associative
-- \x. ((((x (\y.y)) z) w) q) 

-- Desugaring: remove the syntactic sugar
-- \xyz.f is equivalent to \x.\y.\z.f
