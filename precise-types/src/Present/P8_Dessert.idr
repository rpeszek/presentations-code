{- 
 Functor Laws!
 (Redefined from Idris' Interfaces.Verified)
-}

module Present.P8_Dessert
import Data.Vect 

interface Functor f => VerifiedFunctor (f : Type -> Type) where
  identityLaw : (x : f a) -> map Basics.id x = Basics.id x
  distLaw : (x : f a) ->
        (g : b -> c) -> (h : a -> b) -> map (g . h) x = (map g) . (map h) $ x


VerifiedFunctor List where
  identityLaw [] = Refl
  identityLaw (x::xs) = let ih = (identityLaw xs) in cong ih

  distLaw [] _ _ = Refl
  distLaw (x::xs) g h  = let ih = (distLaw xs g h) in cong ih


VerifiedFunctor (Vect n) where
  identityLaw [] = Refl
  identityLaw (x::xs) = let ih = (identityLaw xs) in cong ih

  distLaw [] _ _ = Refl
  distLaw (x::xs) g h  = let ih = (distLaw xs g h) in cong ih

{- 
 Talking points
   - List is a precise type too!
   - FYI, distLaw is redundant 
       https://www.schoolofhaskell.com/user/edwardk/snippets/fmap
-}
