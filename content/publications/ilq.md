---
title: "On Incorrectness Logic for Quantum Programs"
authors: ["Peng Yan", "Hanru Jiang", "Nengkun Yu"]
proc: "OOPSLA"
date: 2022-04-10T10:44:27+08:00
draft: false
---

### Abstract

Bug-catching is important for developing quantum programs. Motivated by the incorrectness logic for classical programs, we propose an incorrectness logic towards a logical foundation for static bug-catching in quantum programming. The validity of formulas in this logic is dual to that of quantum Hoare logics. We justify the formulation of validity by an intuitive explanation from a reachability point of view and a comparison against several alternative formulations. Compared with existing works focusing on dynamic analysis, our logic provides sound and complete arguments. We further demonstrate the usefulness of the logic by reasoning several examples, including Grover's search, quantum teleportation, and a repeat-until-success program. We also automate the reasoning procedure by a prototyped static analyzer built on top of the logic rules.

### Resources

* [Draft](/publications/ilq/ilq-draft.pdf) 
* [TR](/publications/ilq/ilqTR.pdf)
* [Prototyped Impl.](https://github.com/hrjiang/ilq-impl)
* [OpenAccess @ ACM](https://doi.org/10.1145/3527316)