
{-# LANGUAGE 
    TypeOperators
  , DataKinds
  , GADTs
  , TypeFamilies
  , KindSignatures
  , PolyKinds
#-}
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

module Present.P4_TypeEq where
  
import Data.Type.Equality
import Data.Nat

{-
  What is :~: ?
  Prove some theorems
-}


-- Need to bring SNat evidence to be able to case split and apply inductive reasoning
-- What is (+) ???
plusCommutative :: SNat left -> SNat right -> ((left + right) :~: (right + left))
plusCommutative = undefined




plusZeroRightNeutral :: SNat mx -> 'Z + mx :~: mx + 'Z
plusZeroRightNeutral SZ     = undefined
plusZeroRightNeutral (SS k) = undefined

plusSuccRightSucc :: SNat left -> SNat right -> (left + 'S right) :~: 'S (left + right)
plusSuccRightSucc SZ right        = undefined
plusSuccRightSucc (SS left) right = undefined 


-- type level function
type family F (a :: k1) :: k2 
type instance F n = 'S n

-- type family is a type level partial function so if x = y => f x = f y
cong :: (x :~: y) -> F x :~: F y
cong Refl = Refl 


{- 
Talking points: 
 - Hey, there is induction!
-}
