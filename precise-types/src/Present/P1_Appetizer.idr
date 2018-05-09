module Present.P1_Appetizer

import Data.Primitives.Views

{-
  Type precision and pattern match example

   - a very precise type 
   - dependently typed view
   - pattern matching on type level expressions!

  .. TODO come back to it at the end of the talk
-}

total
myMod : (d : Integer) -> Integer -> Integer
myMod d num with (divides num d) 
  myMod d ((d * div) + rem) | (DivBy prf) = rem 
  myMod d x | DevideByZero = 0

total
test : (period : Integer) -> Stream Integer
test period = map (myMod period) (iterate (+1) 0)
-- :exec take 10 (test 3)



-- Talking points
--    holy smoke!
--    what is total, why is test total?
