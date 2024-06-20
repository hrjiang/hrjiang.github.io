---
title: Foundations of Programming Languages
semester: Fall
year: 2021
lastmod: 2021-12-31T18:00:00+08:00
---

## Course Information
### Abstract
In this course we study concepts of programming languages, develop better programming skills, and learn to design your own languages.

### Time
**Tuesday and Thursday, 15:20 - 16:55**, starting from Sep. 14

### Classroom
Room 1118 | **Zoom**: 361 038 6975, pw: BIMSA

### TA
Meng Cao and Pipi Hu

## Schedule and Notes
We borrow courseware of CS242@Stanford. Below are local copies of lecture notes, given for your convenience.

{{< bootstrap-table "table table-striped text-nowrap" >}}
| Date    | Topic                                                                         | Reading                               |
|:--------|:------------------------------------------------------------------------------|:--------------------------------------|
| Sep. 14 | [Course overview](./00_Introduction.pdf) and [Haskell](./01_HaskellIntro.pdf) | Chap. 5                               |
| Sep. 16 | [Foundations](./02_fund.pdf)                                                  | Ref. 2                                |
| Sep. 21 | Mid-Autumn holiday                                                            |                                       |
| Sep. 23 | Foundations, continued: operational semantics.                                |                                       |
| Sep. 26 | [Scopes](./03_scope.pdf)                                                      |                                       |
| Sep. 28 | [Types](./04_types.pdf)                                                       | Chap. 6                               |
| Sep. 30 | [Type Classes](./05_TypeClasses.pdf)                                          | Chap. 7                               |
| Oct. 05 | Holiday                                                                       |                                       |
| Oct. 07 | Holiday                                                                       |                                       |
| Oct. 12 | Type Classes, continued                                                       |                                       |
| Oct. 14 | [IO Monad](./06_ioMonad.pdf)                                                  | Chap. 1-2 of Ref.7, Chap. 7 of Ref. 3 |
| Oct. 19 | [Exceptions and Continuations](./07_control.pdf); Garbage collection          | Chap. 8, 3. Sec. 7.3 of Ref. 4        |
| Oct. 21 | Memory management and garbage collection                                      | Ref. 5                                |
| Oct. 26 | [Computability and Modularity](./08_computabilityandmodularity.pdf)           | Chap. 2, 9                            |
| Oct. 28 | [Object-Oriented Languages](./09_objects-1.pdf)                               | Chap. 10-13                           |
| Nov. 02 | [C++ and Java](./10_objects-2.pdf)                                            |                                       |
| Nov. 04 | [Subtyping](./11_object-types-subtyping.pdf)                                  |                                       |
| Nov. 09 | [Java implementation](./12_object-implementation.pdf)                         |                                       |
| Nov. 11 | [Templates and Generics](./13_templates-generics.pdf)                         | Ref. 8, 9, 10                         |
| Nov. 16 | Concurrency, [notes](./concurrency.pdf) from Herlihy and Shavit. )            |                                       |
| Nov. 18 | Concurrency: Linearizability                                                  |                                       |
| Nov. 23 | Concurrency: List algorithms                                                  |                                       |
| Nov. 25 | Concurrency: List algorithms, continued                                       |                                       |
| Nov. 30 | Relaxed memory model                                                          | Ref. 6                                |
| Dec. 02 | Relaxed memory model, continued                                               |                                       |
{{< /bootstrap-table >}}


## References
1. Textbook: Concepts in Programming Languages by John C. Mitchell.
2. [Lecture Notes on the Lambda Calculus by Peter Selinger](https://arxiv.org/abs/0804.3434).
3. [Real-World Haskell](http://book.realworldhaskell.org/)
4. [Exception Handling in the I/O Monad](http://www.haskell.org/onlinereport/io-13.html)
5. [Java Garbage Collection handbook](https://plumbr.io/java-garbage-collection-handbook)
6. [WMC Course by Ori Lahav and Viktor Vafeiadis](https://people.mpi-sws.org/~viktor/wmc/)
7. [Tackling the Awkward Squad](./awkwardSquad.pdf)
8. [Meta-programming in C++](./MetaprogrammingCpp.pdf)
9. [Java Generics](./generics-tutorial.pdf)
10. [F-Bounded Polymorphism](./CookFBound89.pdf)
