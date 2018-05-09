{-# LANGUAGE TemplateHaskell
      , KindSignatures
      , DataKinds
      , GADTs
      , PolyKinds
      , TypeInType -- needed for SVect
      , TypeOperators 
      , TypeFamilies
      , StandaloneDeriving
      , UndecidableInstances 
      , ScopedTypeVariables
      , TypeSynonymInstances
      , Rank2Types
#-}

module Data.Vect where
import Data.Nat
import Data.Singletons

{-
Review concepts∷
 Vect
 SomeVect 
 runtime use of staticially typed Vect
-}


data Vect (n :: Nat) a where
     VNil :: Vect 'Z a
     (:::) :: a -> Vect n a -> Vect ('S n) a
infixr 5 :::

vlength :: Vect n a -> SNat n  
vlength VNil = SZ
vlength (x ::: xs) = SS (vlength xs)

deriving instance Show a => Show (Vect n a)
deriving instance Eq a => Eq (Vect n a)

data SomeVect a where
   SomeVect :: {- Sing n -> -} Vect n a -> SomeVect a

deriving instance Show a => Show (SomeVect a)

withSomeVect :: SomeVect a -> (forall n. Vect n a -> r) -> r
withSomeVect (SomeVect vec) f = f vec

listToSomeVect :: [a] -> SomeVect a
listToSomeVect [] = SomeVect VNil
listToSomeVect (x : xs) 
      = case listToSomeVect xs of SomeVect rr -> SomeVect (x ::: rr) 

vectToList :: Vect n a -> [a]
vectToList VNil = []
vectToList (x ::: xs) = x : vectToList xs


listWithVect :: [a] -> (forall n. Vect n a -> b) -> b
listWithVect xs f = case listToSomeVect xs of
      SomeVect vxs -> f vxs 


data SVect (v :: Vect n k) where
  SVNil :: SVect  'VNil
  SVCons :: Sing a -> SVect xs -> SVect (a '::: xs)
infixr 5 `SVCons`

sVectToVect :: forall a (n :: Nat) (xs :: Vect n a) . SingKind a => SVect xs -> Vect n (Demote a)
sVectToVect SVNil = VNil
sVectToVect (SVCons sa sxs) = (fromSing sa) ::: sVectToVect sxs


data SomeKnownSizeVect (n:: Nat) k where
   MkSomeKnownSizeVect :: SNat n -> SVect (v :: Vect n k) -> SomeKnownSizeVect n k


vectToSomeKnownSizeVect :: SingKind k => Vect n (Demote k) -> SomeKnownSizeVect n k
vectToSomeKnownSizeVect VNil = MkSomeKnownSizeVect SZ SVNil
vectToSomeKnownSizeVect (x ::: xs) = case toSing x of
                 SomeSing sx -> case vectToSomeKnownSizeVect xs of
                  MkSomeKnownSizeVect k sxs -> MkSomeKnownSizeVect (SS k) (SVCons sx sxs)

someKnownSizeVectToVect :: SingKind k => SomeKnownSizeVect n k -> Vect n (Demote k)
someKnownSizeVectToVect ksv = case ksv of MkSomeKnownSizeVect _ sv -> sVectToVect sv


type family VOneElem (x :: a) :: Vect (S Z) a where
  VOneElem x = x '::: 'VNil

sVOneElem :: Sing x -> SVect (x '::: 'VNil)
sVOneElem x = SVCons x SVNil

type family VAppend (v1 :: Vect n a) (v2 :: Vect m a) :: Vect (Plus n m) a where
  VAppend 'VNil xs = xs
  VAppend (y '::: ys) xs = y '::: VAppend ys xs

sVAppend :: SVect v1 -> SVect v2 -> SVect (VAppend v1 v2)
sVAppend SVNil xs = xs
sVAppend (SVCons y ys) xs = SVCons y (sVAppend ys xs)
