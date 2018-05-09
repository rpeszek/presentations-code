{-# LANGUAGE 
    TypeOperators
  , GADTs
  , DataKinds
  , AllowAmbiguousTypes
  , KindSignatures
  , Rank2Types
#-}
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

module Present.P5_VectRev1 where
import Data.Type.Equality
import Data.Vect
import Data.Nat
import Data.Theorems
import Present.P3_VectAppend (myAppend1) 


{-
 Compare some classic `reverse` implementations for List to Vect
 The easy stuff
-}

---- myReverse1 (slow) ----
myReverseL1 :: [a] -> [a]
myReverseL1 [] = []
myReverseL1 (x : xs) = myReverseL1 xs ++ [x]

-- Vector challenge
myReverseV1 :: Vect n a -> Vect n a
myReverseV1 v = myReverseV1Helper (vlength v) v

myReverseV1Helper :: SNat n -> Vect n elem -> Vect n elem
myReverseV1Helper _ VNil = undefined 
myReverseV1Helper (SS n) (x ::: xs) = undefined -- hint use `myAppend1` 

-- test:
-- listWithVect [1..9] (vectToList . myReverseV1)



---- myReverse2 (fast) ----
myReverseL2 :: [a] -> [a]
myReverseL2 xs = myReverseL2Helper xs []

myReverseL2Helper :: [a] -> [a] -> [a]
myReverseL2Helper [] acc = acc
myReverseL2Helper (x : xs) acc = myReverseL2Helper xs (x : acc)


--  Vector challenge 
myReverseV2 :: Vect n a -> Vect n a
myReverseV2 xs = myReverseV2Helper SZ (vlength xs) VNil xs

myReverseV2Helper :: SNat nacc -> SNat mxs -> Vect nacc a -> Vect mxs a -> Vect (nacc + mxs) a
myReverseV2Helper nacc _ acc VNil = undefined -- acc
myReverseV2Helper nacc (SS mxs) acc (x ::: xs)
                      = undefined -- myReverseV2Helper (SS nacc) mxs (x ::: acc) xs




{-
plusZeroRightNeutral :: SNat m -> m :~: m + 'Z
plusSuccRightSucc:: SNat left -> SNat right -> left + ('S right) :~: 'S (left + right)
-}  


---- myReverse3 (impossible) ----
-- myReverseL3 :: [a] -> [a]
-- myReverseL3 [] = []
-- myReverseL3 (xs ++ [x]) = x : myReverseL3 xs
