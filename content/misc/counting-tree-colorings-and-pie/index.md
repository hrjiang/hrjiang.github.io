---
level: 2
math: true
title: Counting Tree Colorings and PIE
abstract: How many proper colorings are there for a connected tree?  What if we
  count up to order of colors, or up to symmetry? These questions can be
  answered using the Principle of Inclusion and Exclusion (PIE).
date: 2023-12-28T18:14:18+08:00
coverImg: cover.jpg
---
## Motivating problem

Consider a sphere ($S_2$) with $n$ disjoint circles ($S_1$) on it. 
If we are to color each connected area on the sphere in such a way that adjacent areas have different colors, how many colorings are there?
The answer seems to depend on how these circles are embedded. 
Yet, it is independent of their specific arrangement.

We can reduce the problem to a tree coloring problem,
where each embedding directly corresponds to a tree: 
connected areas represent vertices, and circles represent edges. 
This way, a desired coloring of connected regions 
corresponds precisely to a proper coloring of the corresponding tree.

{{< figure src="./cover.jpg" width="300" alt="example" class="text-center" >}}

Above is an example of 2 embeddings of 3 circles on a sphere,
and their corresponding trees.
We label each circle (and the corresponding edge) by a number ($1$, $2$, and $3$). 
Notably, each vertex has a unique identity determined by the label of edges.

Now we have an alternative formalization of the original problem:
given a (labeled unrooted) connected tree $T=(V,E)$, how many proper colorings are there?
By coloring we mean an assignment {{< math >}}$f: V \to \{ 1,...,|V| \}${{< /math >}}.

## Counting tree colorings

In general, a graph $G=(V,E)$ has a _chromatic polynomial_
$$ P_G(q) =  \sum_{A\subseteq E} (-1)^{|A|} q^{c(A)}.$$
Here $c(A)$ is the number of connected components of the subgraph $(V,A)$.
The chromatic polynomial computes the number of proper colorings of $G$ using $q$ distinguished colors.

For our problem, the chromatic polynomial of a connected tree 
$T_n$ of $n$ vertices is
$$ P_{T_n}(q) = q(q-1)^{n-1}. $$
This polynomial is irrelevant to the structure of tree $T_n$.
$P_{T_n}(q)$ can be constructed recursively:
We first choose a leaf (degree-1) vertex from $T_n$, and color it.
Obviously there are $q$ different choices of colors.
Then we color its neighbors, each neighbor thus has $q-1$ choices of colors.
Repeat this procedure we have our chromatic polynomial for a tree.

As a result, the number of proper colorings for $T_n$ is 
$$ P_{T_n}(n) = n(n-1)^{n-1}. $$


## Counting up to order of colors: PIE

We often do not care the name of each color. 
That is, instead of a coloring of a tree, 
we want a partition $V=V_1 \uplus ... \uplus V_m$ of the vertices,
such that each $V_i$ is an independent set in $G$.
Then we want to count partitions into independent sets.


**Theorem (PIE)**: Let $T_1,...,T_n$ be subsets of a finite set $S$,
then 

$$ \left\vert S - \bigcup_i T_i \right\vert 
= \sum_{J \subseteq \\{ 1, ..., n \\} } (-1)^{|J|} \left\vert \bigcap_{j\in J} T_j \right\vert.$$

## Reference

1. [Peter J. Cameron's Note on counting graph colorings](https://webspace.maths.qmul.ac.uk/p.j.cameron/csgnotes/countcols.pdf)