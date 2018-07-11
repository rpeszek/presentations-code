# Precise Types: The Good, The Bad, and The Scary

This talk is really an introduction to dependently typed programming.  The core of this talk is comparison between
`List a` (`[a]`) type and fixed size list `Vect n a`.

Presented at Boulder-Haskell-Programmers meetup.

https://www.meetup.com/Boulder-Haskell-Programmers/events/250637537/?rv=ea1&_xtd=gatlbWFpbF9jbGlja9oAJDAzZDcwNTZmLWFiMjUtNDFhNS05M2VjLTc1MTA0YTg4Y2U3YQ (cancelled)

https://www.meetup.com/Boulder-Haskell-Programmers/events/252332358/?refund_policy=true&rv=ea1_v2&_xtd=gatlbWFpbF9jbGlja9oAJGFiNjU3ZWM2LWQwOGItNDcyNy1hMzdlLTkyYjczOWRiNjAyMA&_af=event&_af_eid=252332358


Abstract
--------
This talk is related to Kris's "Type Driven Development" presentation and to Isaac's "Nifty Patterns with DataKinds".

I will talk about 2 dependently typed approaches that make it harder to write incorrect code: making types more precise and pattern matching on views.
We will explore the differences between `1+2 = 2 + 1` vs `n+m = m + n`, `~` vs `:~:`, and play with other cool type level stuff.

The increased type safety comes with some cost and we have to help out the type checker by providing propositional proofs of type equality.
This yields an interesting tradeoff: a programming nirvana where a program cannot go wrong but we need to write type level code. Such programming can feel brittle and uses concepts like propositional proofs that are not part of software engineer toolbox. Good topics to discuss!

This will be mostly a live coding presentation with lots of REPL time. I will use Haskell with a touch of Idris. I will try to keep things intuitive (assuming no prior knowledge of dependent types or Idris) and I will focus on simple code examples around the list (`[a]`) and its fixed size sibling `Vect (n :: Nat) a`

Extended Into
-------------
[Goals](src/Present/P0_Goals.md)
