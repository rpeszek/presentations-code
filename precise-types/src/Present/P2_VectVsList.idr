
module Persent.P2_VectVsList
import Data.Vect

{-
  Precise types reduce program solution space
  find simplest implementations:
-}

namespace List 
  map : (a -> b) -> List a -> List b

  append : List a -> List a -> List a


namespace Vect
  map : (a -> b) -> Vect n a -> Vect n b

  append : Vect n a -> Vect m a -> Vect (n + m) a



-- Talking points
--    is there a nontrivial 
--       rearrange :: forall a. Vect n a -> Vect n a ?
--       does myMapV type enforce functor laws?
--    CT vs TT
--    Vect part of a bigger pattern
