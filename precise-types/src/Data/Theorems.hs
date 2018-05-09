{-# LANGUAGE 
    TypeOperators
  , DataKinds
  , GADTs
  , TypeFamilies
  , KindSignatures
  , PolyKinds
#-}
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

module Data.Theorems where

import Data.Nat
import Data.Vect (Vect)
import Unsafe.Coerce
import Data.Type.Equality ((:~:)(Refl), sym)

because :: a :~: b -> f a x -> f b x
because prf x = case prf of Refl -> x

believe_me :: a -> b
believe_me = unsafeCoerce

{- type level function -}
type family F (a :: k1) :: k2 
type instance F n = 'S n

-- type family is a type level partial function so if x = y => f x = f y
cong :: (x :~: y) -> F x :~: F y
cong Refl = Refl 


plusZeroRightNeutral :: SNat mx -> 'Z + mx :~: mx + 'Z
plusZeroRightNeutral SZ     = Refl
plusZeroRightNeutral (SS k) = cong (plusZeroRightNeutral k)

plusSuccRightSucc :: SNat left -> SNat right -> (left + 'S right) :~: 'S (left + right)
plusSuccRightSucc SZ right        = Refl
plusSuccRightSucc (SS left) right = cong $ plusSuccRightSucc left right 

plusCommutative :: SNat left -> SNat right -> ((left + right) :~: (right + left))
plusCommutative SZ right = plusZeroRightNeutral right
plusCommutative (SS k) right = case plusCommutative k right of Refl -> sym (plusSuccRightSucc right k)
