---
title: "Formal Semantics of Programming Languages"
semester: "Spring 2023"
institute: "BIMSA"
math: true
date: 2023-03-09T16:04:18+08:00
lastmod: 2023-05-08
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

### [Mar 28] STLC cont': Strong Normalization
   - Strong Normalization ([Coq demo](./stlc_norm_demo.v))  
      To install Coq and IDE:

      - [Official website](https://coq.inria.fr/download) for official CoqIDE, or
      - [Proof General](https://proofgeneral.github.io) for Emacs users, or
      - [VsCoq](https://github.com/coq-community/vscoq) for VS Code users.  

      **Definition**(Halts)
      A term $M$ halts ($\textsf{halts}(M)$) if there is $v\in\text{Value}$ such that $M\to^* v$.  

      **Theorem** STLC is strong normalizing. That is, for any term $M$ and type $\tau$,
      $$ \cdot\vdash M:\tau \implies \textsf{halts}(M)$$

### [Apr 4] System F, Existential Type

   - Contextual Semantics  
     In the study of programming languages, we often use structural operational semantics to define the meaning of programs. This involves specifying rules that describe how expressions are evaluated, or reduced, to obtain their values. These rules can be classified into two categories:
     - *Reduction rules*: These describe the actual computation that takes place. For example, in the simply typed lambda calculus (STLC), the $\beta$-rule specifies how function application is evaluated.
     - *Structural congruence rules*: These describe how the choice of redex (i.e., the part of the expression that is reduced) can affect the overall evaluation. For example, in STLC, we may have rules that allow us to evaluate arguments of a function before function application.

     One way to express structural rules more compactly is to use *evaluation contexts*. An evaluation context is a term with one hole, which can be filled with another term. For example, in call-by-name evaluation, we can define an evaluation context for STLC with product and sum types as follows:

     $$(\text{Evaluation Context})\quad \mathcal{E} ::= 
      \bullet ~|~ \mathcal{E}\ M ~|~
      \langle \mathcal{E}, M \rangle ~|~ \langle v, \mathcal{E} \rangle ~|~
      \mathbf{left}\ \mathcal{E} ~|~ \mathbf{right}\ \mathcal{E}$$

     Here, $\bullet$ represents the hole where we put a redex, and $\mathcal{E}$ specifies the context of the redex. To fill the hole with a term $M$, we simply write $\mathcal{E}[M]$. For example, $\bullet[M]$ is just $M$, and $(\mathcal{E}\ N)[M]$ is $\mathcal{E}[M]\ N$.

     Using evaluation contexts, we can compactly specify the semantics for cbn STLC:

     $$
     \frac{}{(\lambda x: \tau. M) N \to M[N/x]\}(\beta)\qquad
     \frac{M\to M'}{\mathcal{E}(M)\to \mathcal{E}(M')}(\text{Context})
     $$

     The first rule is the $\beta$-rule, which we are already familiar with. The second rule is the context rule, which says that if we have a term $M$ that reduces to $M'$, the same reduction on $M$ can be done in a context $\mathcal{E}$.

     **Exercise**: Specify the semantics of call-by-value STLC by modifying the evaluation context.

   - System F

     In the simply typed lambda calculus (STLC), we can define functions that take arguments of specific types and return values of specific types. However, we may sometimes want to define functions that can take arguments of any type. For example, we might want to define a function that takes a list and returns its length, without knowing the type of the elements in the list.

     One way to achieve this is to use a more expressive type system, such as System F. System F extends the simply typed lambda calculus with polymorphism. It introduces type variables and allows us to abstract over them using type abstractions. In System F, we can define polymorphic functions, which are functions that take a type as an argument and return a value of that type. We can do this using the universal quantifier, written $\forall$. For example, we can define a polymorphic identity function as follows:

     $$\text{id} := (\Lambda \alpha. \lambda x: \alpha. x) : \forall \alpha. \alpha \to \alpha$$

     Here, the big $\Lambda$ is a binder for the type variable $\alpha$, and the type $\forall \alpha. \alpha \to \alpha$ means "for all types $\alpha$, this function takes an argument of type $\alpha$ and returns a value of type $\alpha$". 

     To use a polymorphic function, we must first apply it to a type argument, which specializes the function to that type. For example, to apply the identity function to a boolean value, we would write:

     $$\text{id}\ \mathbb{B}\ \text{true} \to_\beta \text{true}$$

     Here, we apply the identity function to the type argument $\mathbb{B}$ and the value $\text{true}$, which reduces to $\text{true}$ of type $\mathbb{B}$.

     - Syntax
     $$(\text{Type}) \quad \sigma, \tau  ::= \alpha ~|~ \sigma\to\tau ~|~ \forall \alpha.\tau $$

     $$(\text{Term}) \quad M, N  ::=  x ~|~ \lambda x:\tau. M  ~|~ M\ N ~|~ \Lambda \alpha. M ~|~ M\langle \tau \rangle$$

     - Semantics
     $$(\text{EvalCtxt})\quad \mathcal{E} ::=
     \bullet ~|~ \mathcal{E}\ M ~|~ \mathcal{E}\langle \tau \rangle$$

     $$\frac{}{(\lambda x: \tau. M) N \to M[N/x]\}(\beta)\qquad
     \frac{}{(\Lambda \alpha. M)\langle \tau \rangle \to M[\tau / \alpha]}(\text{Inst})\qquad
     \frac{M\to M'}{\mathcal{E}(M)\to \mathcal{E}(M')}(\text{Context})$$

     - Typing ($\Delta;\Gamma\vdash M : \tau$)
       $$
         (\text{Type Context})\quad \Delta := \emptyset ~|~ \Delta, \alpha
       $$
       STLC rules
       $$
         \frac{}{\Delta;\Gamma, x:\tau \vdash x:\tau}(\text{var})\quad
         \frac{FV(\sigma)\subseteq\Delta \quad \Delta;\Gamma,x:\sigma\vdash M: \tau}{\Delta;\Gamma\vdash (\lambda x:\sigma.M): \sigma\to\tau}(\text{abs})\quad
         \frac{\Delta;\Gamma\vdash M:\sigma\to\tau\quad \Delta;\Gamma\vdash N:\sigma}{\Delta;\Gamma \vdash (M\ N) :\tau}(\text{app})
       $$
       Plus abstraction/application for type variables
       $$\frac{\Delta,\alpha;\Gamma\vdash M:\tau}{\Delta;\Gamma \vdash (\Lambda \alpha. M): \forall\alpha.\tau}(\text{T-abs})\qquad
       \frac{\Delta;\Gamma\vdash M:\forall\alpha.\tau\quad FV(\sigma)\subseteq\Delta}{\Delta;\Gamma\vdash M\langle\sigma\rangle : \tau[\sigma/\alpha]}(\text{T-app})$$

     - Examples
       - Natural numbers (Church numerals)
         $$\textsf{Nat} := \forall \alpha. (\alpha \to \alpha) \to (\alpha \to \alpha)$$

         - $0 := \Lambda \alpha. \lambda f: \alpha \to \alpha. \lambda x: \alpha. x$
         - $1 := \Lambda \alpha. \lambda f: \alpha \to \alpha. \lambda x: \alpha. f x$
         - ...

         Lets show that $1$ is of type $\textsf{Nat}$:

         $$
         \frac{
            \frac{
               \frac{}{FV(\alpha\to\alpha)\subseteq \{ \alpha \}}\quad
               \frac{
                  \frac{}{FV(\alpha)\subseteq\{\alpha\}}\quad
                  \frac{
                     \frac{}{\alpha; f:\alpha\to\alpha, x:\alpha\vdash f: \alpha \to \alpha}(\text{var})\quad
                     \frac{}{\alpha; f:\alpha\to\alpha, x:\alpha\vdash x : \alpha}(\text{var})\quad
                  }{\alpha; f:\alpha\to\alpha, x:\alpha\vdash (f x):\alpha }(\text{app})
               }{
                  \alpha;f:\alpha\to\alpha \vdash (\lambda x: \alpha. f x) : \alpha \to \alpha
               }(\text{abs})
            }{
               \alpha;\cdot\vdash (\lambda f: \alpha \to \alpha. \lambda x: \alpha. f x) : (\alpha \to \alpha) \to (\alpha \to \alpha)
            }(\text{abs})
         }{
            \emptyset; \cdot \vdash 
            (\Lambda \alpha. \lambda f: \alpha \to \alpha. \lambda x: \alpha. f x):
            \forall \alpha. (\alpha \to \alpha) \to (\alpha \to \alpha)
         }(\text{T-abs})
         $$

         **Excercise**: Define the predecessor function for $\textsf{Nat}$

       - Self-application

         Recall that in STLC, $\lambda x. x\ x$ is not typable.
         In System F, however, it is typable if we give $x$ a polymorphic type.

         $$
         \frac{
            \frac{
               \frac{
                  \frac{}{
                     \emptyset; x:\forall\alpha.\alpha\to\alpha\vdash
                     x:\forall\alpha.\alpha\to\alpha
                  }(\text{var})
                  \quad
                  \frac{}{
                     FV(\forall\alpha.\alpha\to\alpha)\subseteq\emptyset
                  }
               }{
                  \emptyset; x:\forall\alpha.\alpha\to\alpha\vdash
                  x\langle \forall \alpha.\alpha\to\alpha \rangle : 
                  (\forall\alpha.\alpha\to\alpha)\to(\forall\alpha.\alpha\to\alpha)
               }(\text{T-app})
               \quad
               \frac{}{
                  \emptyset; x:\forall\alpha.\alpha\to\alpha\vdash
                  x : \forall\alpha.\alpha\to\alpha
               }(\text{var})
            }{
               \emptyset; x:\forall\alpha.\alpha\to\alpha\vdash
               x\langle \forall \alpha.\alpha\to\alpha \rangle \ x :
               \forall \alpha.\alpha\to\alpha
            }(\text{app})
         }{
            \emptyset; \cdot \vdash \lambda (x: \forall \alpha. \alpha\to\alpha).x\langle\forall \alpha.\alpha\to\alpha\rangle\ x:
            (\forall \alpha.\alpha\to\alpha)\to(\forall \alpha.\alpha\to\alpha)
         }(\text{abs})
         $$
       - Polymorphic lists

         Suppose our programming language is equipped with a type constructor $\textsf{List}$ and term constructors for the usual list manipulation primitives, with the following types.

         - $\textsf{nil} : \forall \alpha. \textsf{List}\ \alpha$
         - $\textsf{cons} : \forall \alpha. \alpha \to \textsf{List}\ \alpha \to \textsf{List}\ \alpha$
         - $\textsf{isnil} : \forall \alpha. \textsf{List}\ \alpha\to\mathbb{B}$
         - $\textsf{head} : \forall \alpha. \textsf{List}\ \alpha \to \alpha$
         - $\textsf{tail} : \forall \alpha. \textsf{List}\ \alpha \to \textsf{List}\ \alpha$

         We can use these primitives to define our own polymorphic ops on lists. E.g.,

         $$
            \textsf{map} :=\Lambda\alpha.\Lambda\beta.\lambda f: \alpha\to\beta.
            \textsf{fix}\ 
            (\lambda m:\textsf{List}\ \alpha\to\textsf{List}\ \beta.
               \lambda l: \textsf{List}\ \alpha.
               \mathbf{if}\ \textsf{isnil}\langle \alpha\rangle\ l\ 
               \mathbf{then}\ \textsf{nil}\langle\beta\rangle\ 
               \mathbf{else}\ \textsf{cons}\langle\beta\rangle\ (f\ (\textsf{head}\langle\alpha\rangle\ l))\ (m\ \textsf{tail}\langle\alpha\rangle\ l)
            )
         $$

         The function $\textsf{map}$ has type $\forall\alpha.\forall\beta.(\alpha\to\beta)\to\textsf{List}\ \alpha\to\textsf{List}\ \beta$. It takes a function $f:\alpha\to\beta$ and a list $l:\textsf{List}\ \alpha$ as an input, and maps every element in $l$ to $f\ l$.

     - Properties
       - "Second-order $\lambda$-calculus": corresponds to second-order intuitionistic logic via Curry-Howard correspondence.
       - Preservation: if $\Delta;\Gamma\vdash M:\tau$ and $M\to M'$,
         then $\Delta;\Gamma\vdash M':\tau$
       - Progress: if $\Delta;\Gamma\vdash M:\tau$ then either $M$ is a value,
         or there exists $M'$ such that $M\to M'$
       - Normalization: well-typed System F terms are normalizing.
     
     - Type reconstruction (type inference):
        
       Type inference/reconstruction allow programmers to write code without explicitly specifying types, making it easier and faster to write correct code. This is particularly useful in functional programming languages, where the type system can be complex and explicit type annotations can clutter the code.

       - Typable terms

         Type erasure $\text{erase}(M)$:
         - $\text{erase}(x):=x$
         - $\text{erase}(\lambda x: \sigma. M):=\lambda x. \text{erase}(M)$
         - $\text{erase}(M\ N):=\text{erase}(M)\ \text{erase}(N)$
         - $\text{erase}(\Lambda \alpha. M):=\text{erase}(M)$
         - $\text{erase}(M\langle\tau\rangle):=\text{erase}(M)$

         A term $m$ in untyped $\lambda$-calculus is *typable* in System F, if
         $\text{erase}(M)=m$ and $\emptyset;\cdot\vdash M:\tau$ 
         for some well-typed term $M$ and type $\tau$.

       - Question: given a closed untyped term $m$, whether we can find a well-typed term $M$ that erases to $m$?
         
         Answer: No, the problem is undecidable for System F [Wells, 1994].

         The loss of type reconstruction is sometimes considered too heavy a price to pay for a feature whose full power is seldom used.

       - A fragment of System F: ML-style polymorphism (let-polymorphism)

         Read Chapter 22 of Ref 2.

  - Existential Types

    Read Chapter 24 of Ref 2.

### [Apr 11] Imperative Lang. and Op. Sem.

   [Notes](./operational.pdf)

### [Apr 18] Denotational Sem.

   [Notes](./denotational.pdf)

### [Apr 25] Hoare Logic 
   
   [Notes](./hoare.pdf)

### [May 9] Separation Logic
   
   [Notes](./separation.pdf)

### [May 16] Concurrency and CSL

   [Concurrency Notes](./concur.pdf),
   [CSL paper by Viktor Vafeiadis](https://people.mpi-sws.org/~viktor/papers/mfps2011-cslsound.pdf)

### [May 23] Semantics of Probabilistic Programs

   TBA..

<!--
### [May 30] Quantum

   TBA

### [Jun 6] Quantum, cont'

   TBA -->

---

## References

1. Robert Harper. [Practical Foundations for Programming Languages](http://www.cs.cmu.edu/~rwh/pfpl).

2. Benjamin C. Pierce. [Types and Programming Languages](https://www.cis.upenn.edu/~bcpierce/tapl/).

3. John C. Reynolds. Theories of ProgrammingLanguages.

4. Xavier Leroy's [lecture notes](https://xavierleroy.org/CdF/2018-2019/) on Curry-Howard correspondence.

<!-- 5. [Type System Notes](https://users.cs.northwestern.edu/~jesse/course/type-systems-wi18/type-notes/index.html) -->

