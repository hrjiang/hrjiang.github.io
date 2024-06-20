---
title: Graph Algorithms

semester: Fall 

year: 2022
lastmod: 2022-12-31T18:00:00+08:00
---

## Course Info
### Abstract
In this course, we introduce basic concepts in graph theory and complexity theory, then study graph algorithms with a focus on matching and network flows.
### Time
**Tue and Thu, 15:20 - 16:55**, Sep. 13 to Dec. 8, 2022
### Classroom
Room 1118 | Zoom: 242 742 6089, pw: BIMSA
### TA
Chuqi Cao
### References
1. Pearls in Graph Theory, by Nora Hartsfield and Gerhard Ringel.
2. Introduction to Graph Theory, by Douglas B. West.
3. Modern Graph Theory, by Bela Bollobas.
4. The Design and Analysis of Algorithms, by Dexter Kozen.

## Upcoming Topics

### [12/29] Hidden subgroup problem (HSP), GI, quantum computing
- HSP definition
- Instantiations: graph isomorphism, Duetsch's problem, Simon's problem, order finding (and factoring)
- Reading: 
  - [lecture notes](https://www.cs.cmu.edu/~odonnell/quantum15/lecture10.pdf) on HSP by Ryan O'Donnell and John Wright, and 
  - [lecture notes](https://cs.uwaterloo.ca/~watrous/QC-notes/) 4-11 by John Watrous

###	[11/29] Flow: max flow algorithms
- Fibonacci heap, continued
- Applications of max flow min cut: Menger's theorem, the Konig-Egervary theorem, Hall's theorem, Dilworth's theorem
- Reading: 
  - [slides](https://home.cc.umanitoba.ca/~borgerse/Presentations/GS-05R-1.pdf) by Borgersen

### [11/22] Flow: max flow algorithms
- Edmonds and Karp's 2nd heuristic
- [MPM algorithm](https://eprints.utas.edu.au/160/1/iplFlow.pdf) and Fibonacci heap
- Reading: Lecture 8 and 9 of Reference 4


### [11/15] Flow: Max Flow - Min Cut theorem
- Flow, cut, and MFMC theorem
- Max flow algorithms: Edmonds and Karp's two heuristics
- Reading: Lecture 16-18 of Reference 4

### [11/08] Matching: parallel algorithm
- Boolean circuits, Nick's Class (NC)
- Algebraic Branching Programs
- [Combinatorial characterization of determinant](http://cjtcs.cs.uchicago.edu/articles/1997/5/cj97-05.pdf) by Mahajan and Vinay, 1997.
- Reading: Lecture 28-30, Reference 4

### [11/01] Matching: primal-dual, algebraic algorithms
- Primal-dual algorithm
- Algebraic algorithms

### [10/25] Matching: min-cost prefect matching
- Iterative min-cost augmenting paths
- LP relaxation, duality


### [10/18] Matching: non-bipartite maximum matching
- Hall's marriage theorem
- Edmonds' blossom algorithm
- Tutte-Berge formula
- Reading: [Edmonds' paper](https://math.nist.gov/~JBernal/p_t_f.pdf)


### [10/11] Matching: bipartite maximum matching
- Bitartite maximum matching and Kőnig's theorem
- Naïve algorithm
- The Hopcroft-Karp algorithm
- Reading: Lecture 19-20, Reference 4

### [09/27] GI, continued.
- Outline:
  - Color refinement review
  - 2-dimensional Weisfeiler-Leman (WL) algorithm
  - k-dimensional WL algorithm, k-variable language with counting, and Ehrenfeucht–Fraïssé game (back-and-forth games)
  - For any $k$, there is non-isomorphism $G_k$ and  $H_k$ such that k-WL cannot distinguish them
- Reading:
  - [The CFI paper](https://doi.org/10.1007/BF01305232)
  - [Power and limits of the WL algorithm](https://publications.rwth-aachen.de/record/785831/files/785831.pdf), by Kiefer


### [09/20] GI, continued.
- Outline:
  - GI as a complexity class
  - GI $\in$ co-AM
  - GI $\le_p$ Bipartite Graph Isomorphism
  - GI $\le_p$ Regular Graph Isomorphism
	([Booth's construction](https://doi.org/10.1137/0207023), [Miller's construction](https://doi.org/10.1145/800105.803404))
  - GI $\le_p$ Self-complementary Graph Isomorphism ([M. J. Colbourn and C. J. Colbourn. 1978.](https://doi.org/10.1145/1008605.1008608)) 
- Reading:
  - [Problems Polynomially Equivalent to Graph Isomorphism](https://cs.uwaterloo.ca/research/tr/1977/CS-77-04.pdf), by Booth and Colbourn
  - Chapter 4, [Graph isomorphism problem](https://doi.org/10.1007/BF02104746), by Zemlyachenko, Korneenko and Tyshkevich</a>

### [09/13] The graph isomorphism (GI) problem.
- Outline:
  - Graph definitions, notations
  - Graph isomorphism background and application						
  - Degree sequence and color-refinement (1-d Weisfeiler-Leman algorithm)
  - Karp-reduction, P/NP, NPC, Cook-Levin theorem
  - Universality of GI
- Reading:
  - Chapter 1, Reference 1; [review artical by Grohe, Schweitzer. 2020.](https://cacm.acm.org/magazines/2020/11/248220-the-graph-isomorphism-problem/fulltext) in CACM
  - P = NP iff NPI (NP-Intermediate, i.e., NP - P - NPC) is empty ([Ladner. 1975.](https://doi.org/10.1145/321864.321877))
  - Another problem that is in NP-Intermediate status is factoring, which has polynomial quantum algorithm ([Shor. 1994.](https://doi.org/10.1109/SFCS.1994.365700))
  - State-of-the-art algorithm: quasi-polynomial ([Babai. 2015](https://doi.org/10.48550/arXiv.1512.03547))
  - GI is hard to solve with quite limited memory ([Toran. 2004](https://doi.org/10.1137/S009753970241096X))
  - GI is easy for almost all graphs ([Babai, Erdos, Selkow. 1980.](https://doi.org/10.1137/0209047), [Babai, Kucera. 1979.](https://doi.org/10.1109/SFCS.1979.8)) 
  - GI has short zero-knowledge proof ([Goldreich, Micali, Wigderson. 1986.](https://doi.org/10.1007/3-540-47721-7_11))
  - GI is universal ([Miller. 1977.](https://doi.org/10.1145/800105.803404))
  - CFI-construction ([Cai, Furer, Immerman. 1992.](https://doi.org/10.1007/BF01305232))


