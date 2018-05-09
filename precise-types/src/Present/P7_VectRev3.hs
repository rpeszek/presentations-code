{-# LANGUAGE 
   TypeOperators
   , GADTs
   , TypeFamilies
   , DataKinds
   , PolyKinds
   , ScopedTypeVariables 
   , TypeInType
#-}
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

module Present.P7_VectRev3 where
import Data.Type.Equality
import Data.Nat 
import Data.Vect
import Data.Singletons
import Data.Theorems (plusCommutative)

{- 
 We will go MORE type level 
  - things will change 
  - this extends to Lists
-}

--- (1) SnocVect View of Vector ---
--    What is Sing x ?  

data SnocVect (v :: Vect n a) where
   EmptyV :: SnocVect 'VNil
   SnocV :: forall (xs :: Vect n a) (x :: a). 
                 SnocVect xs -> Sing x -> SnocVect (VAppend xs (VOneElem x))

--- (2) I will need some theorems ----
-- th1 :: (VAppend v 'VNil) :~: v
-- th2 :: VAppend l (VAppend c r) :~~: VAppend (VAppend l c) r
-- 
-- Can I do it?

--- (3) will use :~~: instead ---
--   What is :~~: ?
--   What is SVect v ? (example)

vappendVNilRightNeutral :: forall (v :: Vect n a) . SVect v -> (VAppend v 'VNil) :~~: v
vappendVNilRightNeutral SVNil = HRefl
vappendVNilRightNeutral (SVCons x xs) = case vappendVNilRightNeutral xs of HRefl -> HRefl

vappendAssociative ::  forall (l :: Vect n a) (c :: Vect m a) (r :: Vect k a) .
      SVect l -> SVect c -> SVect r -> VAppend l (VAppend c r) :~~: VAppend (VAppend l c) r
vappendAssociative SVNil c r = HRefl
vappendAssociative (SVCons x xs) c r = case vappendAssociative xs c r of HRefl -> HRefl

-- Problem: this is not a linear cost :( 
--   even if proofs do not cost anything, maintaing input (snocVectHelp) has computational cost
--   Idris version has linear cost, Idris can infer SVect input in snocVectHelp
snocVect :: forall (xs :: Vect n a). SVect xs -> SnocVect xs
snocVect xs = snocVectHelp SVNil EmptyV xs

snocVectHelp :: forall (input :: Vect n a) (rest :: Vect m a) . 
                 SVect input -> SnocVect input -> SVect rest -> SnocVect (VAppend input rest)
snocVectHelp input snoc SVNil = case hsym (vappendVNilRightNeutral input) of HRefl -> snoc
snocVectHelp input snoc (SVCons x xs) 
      = case hsym (vappendAssociative input (sVOneElem x) xs) of
           HRefl -> snocVectHelp (sVAppend input (sVOneElem x)) (SnocV snoc x) xs 

-- Missing in Data.Type.Equality 
hsym :: (a :~~: b) -> (b :~~: a)
hsym HRefl = HRefl



--- (4) myReverse that uses the SnocVect view ---


-- SomeKnownSizeVect moves a from type level Vectors to regular type 
myReverseHelper :: forall (v :: Vect n a) . SnocVect v -> SomeKnownSizeVect n a
myReverseHelper EmptyV = MkSomeKnownSizeVect SZ SVNil 
myReverseHelper (SnocV sxs x) = case myReverseHelper sxs of
         MkSomeKnownSizeVect k sv -> case plusCommutative k s1 of Refl -> MkSomeKnownSizeVect (SS k) (SVCons x sv)


-- ground all this work on earth: 
myReverse :: (SingKind k) => Vect n (Demote k) -> Vect n (Demote k)
myReverse v = case vectToSomeKnownSizeVect v of 
                   MkSomeKnownSizeVect n xs -> someKnownSizeVectToVect . myReverseHelper . snocVect $ xs 


testMyReverseWithIntList :: [Integer] -> [Integer]
testMyReverseWithIntList l = map natToInteger $ withSomeVect (listToSomeVect . map integerToNat $ l) (vectToList . myReverse) 
{-| ghci: 
*Part2.Sez10_2aVect> testMyReverseWithIntList [1..9]
[9,8,7,6,5,4,3,2,1]
 -}


-- Talking points 
--     quadratic cost (or maybe I am missing something)
--     lifting up to type level changes theorems
--     :~: vs :~~: 
