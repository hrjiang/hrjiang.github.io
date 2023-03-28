---
title: "Formal Semantics of Programming Languages"
semester: "Spring 2023"
institute: "BIMSA"
math: true
date: 2023-03-09T16:04:18+08:00
draft: false
---

## Course Info

### Abstract

   In this course we study methods to define behaviors of programs, and methods to reason about properties of programs. We also practice building verified programs using Coq.

### Time  

   Every **Tuesday, 13:30pm - 16:55pm**, starting from Mar 14

### Classroom

   Room 1137 |  **[Zoom](https://us02web.zoom.us/j/5371925549)**: 537 192 5549 (pw: BIMSA)

<!-- ---

## Intended Syllabus
* $\lambda$-calculus and Curry Howard Isomorphism
* An Imperative Language (IMP) and Operational Semantics
* Denotational Semantics
* Hoare Logic
* Separation Logic
* Concurrency and Concurrent Separation Logic
* Categorical Semantics for Quantum Programs -->

---

## Lecture Notes

### [Mar 14] $\lambda$-calculus

   - **why learn $\lambda$-calculus?** 
      - practically relevant: foundations of functional programing (Lisp, ML, Haskell)
      - core language to study language theories (type, scope, binding, higher-order function, ...)
      - historically import (in logic): source of the first undecidable problem
      (given $\lambda$-terms $M$ and $N$, determine whether $M=N$)

   - **origin of the $\lambda$ notation**:  
   $\lambda$-calculus, ~1930, Alonzo Church introduced notation $\lambda x.e$. function that maps "$x$" to "$e$".  
   Initially a _logic_, evolved into the first functional programming language.  
   Useful to clarify the way we (mathematicians?) talk about func.  
   "The function $x^2$" ---> $x\mapsto x^2$ (Bourbaki) or $\lambda x. x^2$  
   More examples: $x^2 + y^2$, "the family of functions $cx^2$" 

   - **why "$\lambda$"?**:  
      Initially $\hat{x}e$ (as in Russell & Whitehead's _Principia Mathematica_). Progressively simplified by Church.
      $$ \hat{x}e \longrightarrow  \Lambda x e \longrightarrow  \lambda x e \longrightarrow \lambda x[e] \longrightarrow \lambda x. e $$

   - **two main computation rules**:
      - _$\alpha$-conversion_: 
         $\lambda x. M =_\alpha \lambda y. M[y/x]$

      - _$\beta$-reduction_:
         $(\lambda x. M) N =_\beta M[N/x]$ 

         "Consider $f(x)=x^2$. We have $f(2)=4$." --->
         $f(2) = (\lambda x. x^2)(2) =_\beta 2^2 = 4$

   
   - **initial $\lambda$-calculus**:
      inconsistent (Kleene-Rosser paradox 1935, Curry's paradox 1942).

   - **pure $\lambda$-calculus**: (Alonzo Church, Stephen C. Kleene, John Barkley Rosser)
      - _PL and model of computation_:  
         A notion of computation: $M \to_\beta M_1 \to_\beta M_2 \to_\beta ... \to_\beta N \not\to_\beta$  
         First undecidability results (Church 1936): whether a term $M$ has a normal form is undecidable.  
         Hilbert's decision problem (Entscheidungsproblem) has no solution.  

         Equivalence between: (Kleene 1935, Turing 1937)  
         - general recursive functions (Herbrand, Gödel, Kleene)  
         - functions computable by Turing machine  
         - $\lambda$-definable functions (via Church's encoding 1933)

         Functional langauge = pure $\lambda$-calculus + reduction strategy + data types + type system

      - _Syntax_:
         $$ \text{(Term)} \ M, N ::= x \ |\  \lambda x. M \ |\  M\ N  $$
         
         - Convention:
            - $\lambda$ body extends as far to the right as possible:
            $\lambda x. M\ N\ = \lambda x. (M\ N)$
            - $\lambda$ application is left associative:
            $M\ N \ P = (M \ N )\ P$

         - Free variable ($fv(M)$):
            - $fv(x) ::= x$
            - $fv(\lambda x. M) ::= fv(M)\ \{x\}$
            - $fv(M\ N) ::= fv(M) \cup fv(N)$

         - Bound variable can be renamed: $\lambda x. (x + y) =_\alpha \lambda z. (z + y)$

      - _Reduction rules_:
         - Substitution $M[N/x]$ (replace $x$ by $N$ in $M$):
            - $x[N/x] := N$
            - $y[N/x] := y$
            - $(M\ P)[N/x] := M[N/x]\ P[N/x]$
            - $(\lambda y. M)[N/x] := \lambda y. M[N/x]$ if $y\not\in fv(N)$
            - $(\lambda y. M)[N/x] := \lambda z. M[z/y][N/x]$ if $y\in fv(N)$ and $z$ fresh
            - Other solutions to avoid name capturing: Barendregt's convension, DeBruijn representation

         - Rules:
            $$\frac{\ }{(\lambda x. M) N \to M[N/x]}(\beta)
            \qquad \frac{M\to M'}{M\ N\to M'\ N}
            \qquad \frac{N\to N'}{M\ N\to M \ N'}
            \qquad \frac{M\to M'}{\lambda x. M\to \lambda x. M'}$$

      - _Church-Rosser property (confluence)_:
         $$\forall M, M_1, M_2\ldotp M \to^* M_1 \land M\to^* M_2 \implies 
         \exists M'\ldotp M_1\to^* M'\land M_2\to^* M'.$$
         - Corollary: every term has at most one normal form
            - $\beta$-redex: reducible expression
            - $\beta$-normal form: term containing no $\beta$-redex

      - _Reduction strategies and evaluation strategies_:
         - Normal order reduction: left-most, outer-most redex
         - Applicative-order reduction: left-omst, inner-most redex
         - Evaluation: only evaluate closed terms, don't reduce under $\lambda$
            - Normal order eval.:
               $$\frac{\ }{(\lambda x. M) N \to M[N/x]}(\beta)
               \qquad \frac{M\to M'}{M\ N\to M'\ N}$$
            - Eager eval.:
               $$\frac{\ }{(\lambda x. M) (\lambda y. N) \to M[(\lambda y. N)/x]}(\beta)
               \qquad \frac{M\to M'}{M\ N\to M'\ N}
               \qquad \frac{N\to N'}{(\lambda x. M)\ N\to (\lambda x. M)\ N}$$
         - Exercise: evaluate the following terms using the above reduction/evaluation strategies
            - $(\lambda x.\lambda y. x\ y)(\lambda x. x)$
            - $(\lambda x. \lambda y. x\ x)(\lambda x. x \ x)$
            - $(\lambda x. x \ x)(\lambda x. x \ x)$
      - _Programming with $\lambda$-calculus_:
         - $\mathbb{B}$:
            - $True := \lambda x. \lambda y. x$
            - $False := \lambda x. \lambda y. y$
            - $not := \lambda b. b\ y\ x$
            - $and := \lambda b. \lambda b'. b \ b' \ False$
            - $or := \lambda b. \lambda b'. b \ True \ b'$
            - $ b ?  M : N := b\ M\ N$
         - $\mathbb{N}$:
            - $0 := \lambda f. \lambda x. x$
            - $succ := \lambda n. \lambda f. \lambda x. f (n\ f\ x)$
            - $iszero := \lambda n. \lambda x.\lambda y. n\ (\lambda z. y) x$
            - $add := \lambda n. \lambda m. \lambda f. \lambda x. n\ f\ (m\ f\ x)$ 
            - $sub := ...$
            - $mult := ...$
         - Tuple:
            - $(M_1, ..., M_n) := \lambda f. f\ M_1\ ...\ M_n$
            - $\pi_i := \lambda p. p\ (\lambda x_1.\ ...\lambda x_n. x_i)$
         - Recursive function:
            - E.g. $fact = \lambda n. (iszero\ n)\ ?\ 1 : (mult\ n\ (fact(n-1))) = F\ fact$,  
            where $F = \lambda f. (iszero\ n)\ ?\ 1 : (mult\ n\ (f(n-1)))$.  
            I.e., $fact$ is a **fixpoint** of $F$.
            - A _fixpoint combinator_ is a higher-order function $h$ s.t. 
            $\forall f. f\ (h\ f) = h\ f$
               - Turing's $\Theta = A\ A$, where $A = \lambda x.\lambda y. y\ (x\ x\ y)$
               - Church's $\mathbf{Y}= \lambda f.(\lambda x. f\ (x\ x))\ (\lambda x. f\ (x\ x))$
               - Excercise: show that $\Theta$ and $\mathbf{Y}$ are fixpoint combinators.
            - Every $\lambda$-term has a fixpoint.


### [Mar 21] STLC

   - Introducing _types_:
      - Type checking catches "simple" mistakes early
      - (Type safety) Well-typed programs never go wrong
      - Type information makes it easier to analyze/optimize a program
      - (Cons) Impose constraints on programmers, safe programs can be rejected

   - STLC with product and sum type

      - Types
      $$(\text{Type}) \quad \sigma, \tau ::= T ~|~ \sigma \to \tau ~|~ \sigma\times\tau ~|~ \sigma + \tau $$
         - $T$: base type, e.g., $\texttt{int}$ or $\texttt{bool}$
         - $\sigma \to \tau$: function type, for a function that accepts an argument of type $\sigma$, and returns a value of type $\tau$.  
         $\to$ is right associative: $\sigma \to \sigma' \to \sigma''$ means
         $\sigma \to (\sigma' \to \sigma'')$
         - $\sigma \times \tau$: product type, a pair consisting of two values of type $\sigma$ and $\tau$, respectively.
         - $\sigma + \tau$: sum type, either a value of type $\sigma$, or a value of type $\tau$

      - Terms
      $$(\text{Term}) \quad M, N ::= x ~|~ \lambda x:\tau.M ~|~ M\ N ~|~ 
      \langle M, N \rangle ~|~ \pi_1\ M ~|~ \pi_2\ M ~|~ \mathbf{left}\ M ~|~ \mathbf{right}\ M ~|~ \mathbf{case}\ M\ \mathbf{do}\ M_1\ M_2 $$
         - $\langle M, N \rangle$: a pair consisting of $M$ and $N$
         - $\pi_i\ M$: projection, to get $M$'s i-th element
         - $\mathbf{left}\ M$ and $\mathbf{right}\ N$: construction of a sum term.
           (Think about unions in C)
         - $\mathbf{case}\ M \ \mathbf{do}\ M_1\ M_2$: conditioning on the value of a sum-type term

      - Reduction rules (rules for subterms are omitted)
      $$
         \frac{}{(\lambda x: \tau. M)\ N \to M[N/x]}(\beta)\qquad
         % \frac{M\to M'}{\lambda x: \tau. M \to \lambda x: \tau. M'}\qquad
         % \frac{M\to M'}{M\ N \to M'\ N}\qquad
         % \frac{N\to N'}{M\ N \to M \ N'}
      $$
      $$
         \frac{}{\pi_1 \ \langle M, N \rangle \to M}\qquad
         \frac{}{\pi_2 \ \langle M, N \rangle \to N}\qquad
         % \frac{M\to M'}{\langle M, N \rangle \to \langle M', N \rangle}\qquad
         % \frac{N\to N'}{\langle M, N \rangle \to \langle M, N' \rangle}\qquad
      $$
      $$
         \frac{}{\mathbf{case}\ (\mathbf{left}\ M)\ \mathbf{do}\ M_1\ M_2
         \to M_1\ M}\qquad
         \frac{}{\mathbf{case}\ (\mathbf{right}\ M)\ \mathbf{do}\ M_1\ M_2
         \to M_2\ M}\qquad
      $$

      - Typing rules
      $$(\text{Typing Context})\ \Gamma ::= \cdot ~|~ \Gamma, x:\tau$$
      $$
         \frac{}{\Gamma, x:\tau \vdash x:\tau}(\text{var})\quad
         \frac{\Gamma,x:\sigma\vdash M: \tau}{\Gamma\vdash (\lambda x:\sigma.M): \sigma\to\tau}(\text{abs})\quad
         \frac{\Gamma\vdash M:\sigma\to\tau\quad \Gamma\vdash N:\sigma}{\Gamma \vdash (M\ N) :\tau}(\text{app})
      $$
      $$
         \frac{\Gamma\vdash M:\sigma\quad \Gamma\vdash N:\tau}{\Gamma\vdash \langle M, N \rangle : \sigma\times \tau}(\text{pair})\quad
         \frac{\Gamma\vdash M: \sigma\times\tau}{\Gamma\vdash (\pi_1\ M):\sigma}(\text{proj1})\quad
         \frac{\Gamma\vdash M: \sigma\times\tau}{\Gamma\vdash (\pi_2\ M):\tau}(\text{proj2})
      $$
      $$
         \frac{\Gamma\vdash M:\sigma}{\Gamma\vdash \mathbf{left}\ M: \sigma + \tau}(\text{left})\quad
         \frac{\Gamma\vdash M:\tau}{\Gamma\vdash \mathbf{right}\ M: \sigma + \tau}(\text{right})
      $$
      $$
         \frac{\Gamma\vdash M:\sigma + \tau \quad \Gamma\vdash M_1:\sigma\to\rho \quad \Gamma\vdash M_2: \tau\to\rho}{\Gamma\vdash\mathbf{case}\ M\ \mathbf{do}\ M_1\ M_2 : \rho}(\text{case})
      $$

      - Soundness (Type safety)
      $$(\text{Values})\  v ::= \lambda x. M ~|~ \langle v_1, v_2 \rangle ~|~ \mathbf{left}\ v ~|~ \mathbf{right}\ v$$
      **Theorem**(Type-Safety):  
      If $\cdot \vdash M:\tau$ and $M\to^* M'$, then  
      (i) $\cdot \vdash M':\tau$, and  
      (ii) either $M'\in\text{Values}$ or 
      $\exists M''. M'\to M''$.  
      **Proof**. Follows from two key lemmas below. $\square$  
      **Lemma**(Preservation):
      Well-typed terms reduces only to well-defined terms of the same type.
      I.e.,  
      $$ (\cdot\vdash M:\tau \land M\to M')\implies (\cdot\vdash M': \tau).$$
      **Lemma**(Progress):
      A well-typed term is either a value or can be reduced.
      I.e.,
      $$(\cdot\vdash M:\tau)\implies (M\in\text{Values})\lor(\exists M'. M\to M').$$

      - Curry-Howard isomorphism
         - **PaT** principle:
         **P**ropositions **a**re **T**ypes,
         **P**roofs **a**re **T**erms

         - Propositional logic (natural deduction)
         $$(\text{Prop})\ p, q ::= B ~|~ p \Rightarrow q ~|~ p\land q ~|~ p\lor q$$
         $$(\text{Ctxt})\ \Gamma ::= \cdot ~|~ \Gamma,p$$
         $$
         \frac{}{\Gamma,p\vdash p}(\text{axiom})\quad
         \frac{\Gamma,p\vdash q}{\Gamma\vdash p\Rightarrow q}(\Rightarrow\text{-intro})\quad
         \frac{\Gamma\vdash p\Rightarrow q \quad \Gamma\vdash p}{\Gamma \vdash q}(\Rightarrow\text{-elim})
         $$
         $$
         \frac{\Gamma\vdash p \quad \Gamma \vdash q}{\Gamma \vdash p\land q}(\land\text{-intro})\quad
         \frac{\Gamma\vdash p\land q}{\Gamma \vdash p}(\land\text{-elim-l})\quad
         \frac{\Gamma\vdash p\land q}{\Gamma \vdash q}(\land\text{-elim-l})
         $$
         $$
         \frac{\Gamma\vdash p}{\Gamma\vdash p\lor q}(\lor\text{-intro-l})\quad
         \frac{\Gamma\vdash q}{\Gamma\vdash p\lor q}(\lor\text{-intro-r})\quad
         $$
         $$
         \frac{\Gamma\vdash p\lor q\quad \Gamma\vdash p\Rightarrow r \quad \Gamma\vdash q \Rightarrow r}{\Gamma\vdash r}(\lor\text{-elim})
         $$
         Convince yourself that propositional logic and STLC are isomorphic!

         - Can form the basis for automated theorem provers.
         - Every logic has a corresponding typed system

### [Mar 28] STLC cont': Strong Normalization; System F
   - Strong Normalization ([Coq demo](./stlc_norm_demo.v))  
      To install Coq and IDE:

      - [Official website](https://coq.inria.fr/download) for official CoqIDE, or
      - [Proof General](https://proofgeneral.github.io) for Emacs users, or
      - [VsCoq](https://github.com/coq-community/vscoq) for VS Code users.  

      **Definition**(Halts)
      A term $M$ halts ($\textsf{halts}(M)$) if there is $v\in\text{Value}$ such that $M\to^* v$.  

      **Theorem** STLC is strong normalizing. That is, for any term $M$ and type $\tau$,
      $$ \cdot\vdash M:\tau \implies \textsf{halts}(M)$$

   - System F



---

## References

1. Robert Harper. [Practical Foundations for Programming Languages](http://www.cs.cmu.edu/~rwh/pfpl).

2. Benjamin C. Pierce. [Types and Programming Languages](https://www.cis.upenn.edu/~bcpierce/tapl/).

3. John C. Reynolds. Theories of ProgrammingLanguages.

4. Xavier Leroy's [lecture notes](https://xavierleroy.org/CdF/2018-2019/) on Curry-Howard correspondence.

