
Goals
=====
_in italic_ - not part of this presentation

Intro to Dependent Types 
------------------------
  - what is wrong with `Eq a` typeclass?
  - some values at type level - what for?
    * increased type precision
    * fewer inhabitants <=> fewer incorrect programs
    * from inference to exference
    * _state machines, indexed monads, protocols, etc_ 
  - full value level expressions at type level - what for?
    * C-H isomorphism / program verification
       * what does type checker do with types?
  - concept unification 
    * e.g.: function, `type` synonym, type family __vs__ function
  - views - what for?
    * alternative pattern matching
    * special-cased type safety
  - _types at program level_
  - _auto proofs_

Questionable, Bad, Scary
------------------------
  - type checker may need help - type equality proofs 
     * proofs __vs__ `unsafeCoerce`/`believe_me` __vs__ ?
     * part of program __vs__ separate language semantics __vs__ ?
     * runtime cost of proofs __vs__ compilation time (how? replacement?) __vs__ ?
     * refactoring and proof maintenance cost
     * industry acceptance

  - __bleeding__ edge (... but)
