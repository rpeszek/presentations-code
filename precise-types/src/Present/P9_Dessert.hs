{-# LANGUAGE TemplateHaskell
      , KindSignatures
      , DataKinds
      , GADTs
      , PolyKinds
      , TypeInType 
      , TypeOperators 
      , TypeFamilies
      , StandaloneDeriving
      , UndecidableInstances 
      , ScopedTypeVariables
      , LambdaCase
#-}
module Present.P9_Dessert where

import Data.Singletons.TH
import Data.Promotion.Prelude.Function
import Data.Type.Equality
-- import Data.Kind (Type)

{- 
 Ref: https://blog.jle.im/entry/verified-instances-in-haskell.html
-}

$(singletons [d|
  data List a = LNil | LCons a (List a) deriving Show
  infixr 9 `LCons`

  map :: (a -> b) -> List a -> List b
  map f LNil = LNil
  map f (LCons x xs) = LCons (f x) (map f xs)
 |])

class VerifiedFunctor f where

    type Fmap a b (g :: a ~> b) (x :: f a) :: f b

    sFmap
        :: Sing (g            :: a ~> b)
        -> Sing (x            :: f a   )
        -> Sing (Fmap a b g x :: f b   )

    -- | fmap id x == x
    fmapId
        :: Sing (x :: f a)
        -> Fmap a a IdSym0 x :~: x

    {- | fmap f (fmap g x) = fmap (f . g) x 

      Compared to idris:
      - Changed order of args for convenience

      - type (~>) a b = TyFun a b -> Type 
      - type (@@) (a :: k1 ~> k2) (b :: k1) = Apply a b :: k2
      - (:.$) :: (b ~> c) ~> ((a ~> b) ~> (a ~> c))
    -}
    fmapCompose
        :: Sing (g :: b ~> c)
        -> Sing (h :: a ~> b)
        -> Sing (x :: f a   )
        -> Fmap b c g (Fmap a b h x) :~: Fmap a c (((:.$) @@ g) @@ h) x


instance VerifiedFunctor List where

    type Fmap a b g x = Map g x

    sFmap = sMap

    fmapId = \case
      SLNil       -> Refl
      SLCons _ xs ->
        case fmapId xs of
          Refl -> Refl

    fmapCompose g h = \case
      SLNil -> Refl
      SLCons _ xs ->
        case fmapCompose g h xs of
          Refl -> Refl
  
