{-# LANGUAGE 
    TypeOperators
  , GADTs
  , DataKinds
  , AllowAmbiguousTypes
  , KindSignatures
  , Rank2Types
#-}
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

module Present.P3_VectAppend where

import Data.Type.Equality
import Data.Vect
import Data.Nat
import Data.Singletons
import qualified Data.Theorems as T

{- 
  The story of `append`
  Review Data.Nat and Data.Vect in Haskell (or not)
-}

myAppend1 :: Vect n a -> Vect m a -> Vect (n + m) a
myAppend1 VNil v2 = v2
myAppend1 (x ::: xs) v2 = x ::: (myAppend1 xs v2)



{-
ghci:
myAppend1 ("1" ::: "2" ::: VNil) ("3" ::: VNil)
-}

-- Challenge: I flipped (n + m) ==> (m + n)

{- convenience test -}
testAppend :: [a] -> [a] -> (forall n m. Vect n a -> Vect m a -> Vect (m + n) a) -> SomeVect a
testAppend xs ys fapp = listWithVect xs (\vxs -> listWithVect ys (\vys -> SomeVect $ fapp vxs vys))


-- Attempt 1
myAppend2 :: Vect n a -> Vect m a -> Vect (m + n) a
myAppend2 = undefined -- myAppend1 


-- Attempt 2:
-- myAppend2 :: (n + m) ~ (m + n) => 
--              Vect n a -> Vect m a -> Vect (m + n) a
-- myAppend2 = myAppend1 

{-
ghci:
myAppend2 ("1" ::: "2" ::: VNil) ("3" ::: VNil)
testAppend [1..5] [6..8] myAppend2
-}

-- Talking points
--     2+1 = 1+2 vs  n+m = m+n in Haskell 
--     proof responsibilty left to the caller
--     Type contraint `(n + m) ~ (m + n)` is hard to work with


-- Attempt 3:
myAppend3 :: Vect n a -> Vect m a -> Vect (m + n) a
myAppend3 v1 v2 = myAppend3Helper (vlength v1) (vlength v2) v1 v2

myAppend3' :: (SingI n, SingI m) => Vect n a -> Vect m a -> Vect (m + n) a
myAppend3' = myAppend3Helper sing sing

myAppend3Helper :: SNat n -> SNat m -> Vect n a -> Vect m a -> Vect (m + n) a
myAppend3Helper n m v1 v2 = undefined


{-
ghci:
myAppend3 ("1" ::: "2" ::: VNil) ("3" ::: VNil)
testAppend [1..5] [6..8] myAppend3
-}


-- Talking points: 
--    brittle 
--    not software engineer friendly
--    super cool
--    should language know n + m = m + n ?
--      if so what should langage not know?
