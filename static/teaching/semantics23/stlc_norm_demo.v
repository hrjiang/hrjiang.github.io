From Coq Require Import List String Logic.FunctionalExtensionality.

(** * STLC *)

(** ** Syntax *)

Inductive typ: Type :=
| Typ_unit                  (* unit type *)
| Typ_arrow (σ τ: typ)      (* arrow type σ → τ *)
.

Notation "σ '→' τ" := (Typ_arrow σ τ) (at level 20).

Inductive term: Type :=
| Tm_var (x: string)
| Tm_app (M N: term)
| Tm_abs (x: string) (τ: typ) (M: term).

Coercion Tm_var: string >-> term.

Notation "\ x : t , M" :=
  (Tm_abs x t M)
    (at level 90,
      x at level 99,
      t at level 99,
      M at level 99,
      left associativity).

Infix "@@" := Tm_app (at level 30).

(** ** Substitution *)

(* substitute x by N in M: M[N/x] *)
Reserved Notation "'[' x ':=' N ']'" (at level 20, x constr).

Fixpoint subst (x: string) (N M: term) : term :=
  match M with
  | Tm_var y => if String.eqb x y then N else M
  (* here we need not worry about name captureing because 
     we are only interested in closed terms *)
  | \ y : τ, M' => if String.eqb x y then M else \y : τ, ([x:=N] M')
  | Tm_app M' N' => Tm_app ([x:=N] M') ([x:=N] N')
  end
where "'[' x ':=' N ']' " := (subst x N).


(** ** Reduction *)
(* cbn, normal order evaluation *)

Inductive value : term -> Prop :=
| v_abs x τ M: value (\x : τ, M).

Reserved Notation "t ⟶ t' " (at level 40).

Inductive step : term -> term -> Prop :=
(* beta reduction: (λx.M) v → M[v/x] *)
| Beta x τ M v:
  value v ->
  ((\x: τ, M) @@ v) ⟶ [x:=v] M
(*   M --> M'
  --------------
   M N --> M' N  *)
| App1 M N M':
  M ⟶ M' ->
  M @@ N ⟶ M' @@ N
(*   N --> N'
   --------------
   M N --> M N'  *)
| App2 x τ M N N':
  N ⟶ N' ->
  (\x: τ,M) @@ N ⟶ (\x: τ,M) @@ N'
         
where "t ⟶ t' " := (step t t').

(** Normal form *)
Definition normal_form {X: Type} (R: X -> X -> Prop) (x: X) : Prop :=
  ~ exists x', R x x'.

Lemma value_is_nf:
  forall v, value v -> normal_form step v.
Proof.
  induction v.
Admitted.

Lemma step_deterministic:
  forall M M1 M2, M ⟶ M1 -> M ⟶ M2 -> M1 = M2.
Proof with eauto.
  intros M M1 M2 R1 R2.
  generalize dependent M2.
  induction R1.

Admitted.


(** Multiple steps *)
Inductive multi {X: Type} (R: X -> X -> Prop) : X -> X -> Prop :=
| multi_refl x: multi R x x
| multi_step x y z: R x y -> multi R y z -> multi R x z.

Infix "⟶*" := (multi step) (at level 40).

Lemma multistep_trans: forall M M' M'',
    M ⟶* M' -> M' ⟶* M'' -> M ⟶* M''.
Proof.
  induction 1; auto.
  intros. econstructor; eauto.
Qed.

Lemma multistep_App2: forall v M M',
    value v -> (M ⟶* M') -> Tm_app v M ⟶* Tm_app v M'.
Proof.
  induction 2; econstructor; try exact IHmulti.
  inversion H. eauto using App2.
Qed.

(** ** Typing *)

(** Context Γ : Var ⇀ Type *)
Definition context := string -> option typ.

(** Empty context *)
Notation "⋅" := (fun _: string => None) (at level 0).

(** Updating a context *)
Definition update (x: string) (τ: typ) (Γ: context) : context :=
  fun y => if String.eqb x y then Some τ else Γ y.

Notation "x '↦' τ ';' Γ" := (update x τ Γ) (at level 40).

(** Context inclusion *)
Definition includedin (Γ Γ': context) : Prop :=
  forall x τ, Γ x = Some τ -> Γ' x = Some τ.

Notation "Γ '⊆' Γ'" := (includedin Γ Γ') (at level 40).

(** Handy tactic for case studies in update*)
Ltac var_cases :=
  unfold update;
  repeat match goal with
         | |- context[(?a =? ?a)%string] =>
             rewrite eqb_refl; simpl; eauto
         | |- context[(?a =? ?b)%string] =>
             destruct (eqb_spec a b);
             simpl; unfold update; eauto; try congruence
         | H: context[(?a =? ?b)%string] |- _ =>
             destruct (eqb_spec a b);
             simpl; eauto; try congruence                               
         end.

(** Basic properties of update *)
Lemma update_shadow: forall x τ τ' Γ,
    (x ↦ τ'; (x ↦ τ; Γ)) = (x ↦ τ'; Γ).
Proof.
  intros. apply functional_extensionality. intro y.
  unfold update.
Admitted.

Lemma update_commute: forall x τ y τ' Γ,
    x <> y ->
    (x ↦ τ; (y ↦ τ'; Γ)) = (y ↦ τ'; (x ↦ τ; Γ)).
Proof.
  intros. apply functional_extensionality. intro z.
Admitted.

Lemma includedin_update:
  forall x τ Γ Γ',
    Γ ⊆ Γ' ->
    (x ↦ τ; Γ) ⊆ (x ↦ τ; Γ').
Proof. unfold includedin, update; intros. var_cases. Qed.

(** Typing Rules *)
Reserved Notation "Γ '|-' M '∈' T" (at level 40, T at level 0).

Inductive has_type : context -> term -> typ -> Prop :=
| T_Var Γ x τ:
  Γ x = Some τ ->
  Γ |- x ∈ τ
        
| T_Abs Γ x σ τ M:
  ((x ↦ σ ; Γ) |- M ∈ τ) ->
  Γ |- (\x:σ, M) ∈ (σ → τ)
                
| T_App Γ σ τ M N:
  (Γ |- M ∈ (σ → τ)) ->
  (Γ |- N ∈ σ ) ->
  Γ |- (Tm_app M N) ∈ τ
        
where "Γ '|-' M '∈' T" := (has_type Γ M T).

#[local]
Hint Constructors has_type: core.

(** ** Weakening *)
Lemma weakening: forall Γ Γ' M τ,
    Γ ⊆ Γ' ->
    (Γ |- M ∈ τ) ->
    (Γ' |- M ∈ τ).
Proof.
  intros Γ Γ' M τ H HM.
  generalize dependent Γ'.
  induction HM; eauto using includedin_update.
Qed.
  
Lemma weakening_empty: forall Γ M τ,
    (⋅ |- M ∈ τ) ->
    (Γ |- M ∈ τ).
Proof.
  intros; eapply weakening; try eassumption.
  discriminate.
Qed.

(** ** Preservation *)

Lemma subst_preserves_typing:
  forall Γ x σ M v τ,
    ((x ↦ σ ; Γ) |- M ∈ τ) ->
    (⋅ |- v ∈ σ) ->
    Γ |- [x := v]M ∈ τ.
Proof.
  intros Γ x σ M v τ HM Hv.
  generalize dependent Γ.
  generalize dependent τ.
  induction M.
Admitted.

Theorem preservation:
  forall M τ M',
    (⋅ |- M ∈ τ) ->
    M ⟶ M' ->
    (⋅ |- M' ∈ τ).
Proof.
  intros M τ M' H R.
  generalize dependent M'.
  remember ⋅ as Γ.
  induction H.
Admitted.

(** ** Free variables and closed terms *)
Inductive appears_free_in: string -> term -> Prop :=
| afi_var (x: string): appears_free_in x x
| afi_app1 x M1 M2:
  appears_free_in x M1 -> appears_free_in x (Tm_app M1 M2)
| afi_app2 x M1 M2:
  appears_free_in x M2 -> appears_free_in x (Tm_app M1 M2)
| afi_abs x y τ M:
  y <> x ->
  appears_free_in x M -> appears_free_in x (\y : τ, M).
#[local]
Hint Constructors appears_free_in: core.

Definition closed (M: term) : Prop := forall x, ~ appears_free_in x M.

Lemma vacuous_substitution {M x}:
  ~ appears_free_in x M -> forall N, [x:=N] M = M.
Proof.
  induction M; simpl; intros.
  - var_cases. exfalso. subst. eauto.
  - rewrite IHM1, IHM2; auto.
  - var_cases. rewrite IHM; auto.
Qed.
  
Lemma subst_closed: forall M x N, closed M -> [x:=N]M = M.
Proof. auto using vacuous_substitution. Qed.

Lemma free_in_context {x M τ Γ}:
  appears_free_in x M ->
  (Γ |- M ∈ τ) ->
  exists σ, Γ x = Some σ.
Proof.
  induction 2; inversion H; eauto.
  subst. destruct (IHhas_type H6) as [σ' HT].
  exists σ'. unfold update in HT. var_cases.
Qed.

Lemma typable_empty_closed {M τ}:
  (⋅ |- M ∈ τ) -> closed M.
Proof.
  unfold closed; intros H x C.
  eapply free_in_context in C; eauto.
  destruct C. discriminate.
Qed.

Lemma context_invariance:
  forall Γ Γ' M τ,
    (Γ |- M ∈ τ) ->
    (forall x, appears_free_in x M -> Γ x = Γ' x) ->
    (Γ' |- M ∈ τ).
Proof.
  intros; generalize dependent Γ'.
  induction H; intros; eauto 8.
  - (* var *)
    constructor; inversion H. rewrite <- H0; auto.
  - (* abs *)
    econstructor. apply IHhas_type. intros y Hyfree.
    unfold update; var_cases.
Qed.

Lemma duplicate_subst: forall M' x M v,
    closed v ->
    [x:=M]([x:=v]M') = [x:=v]M'.
Proof.
  intros. eapply vacuous_substitution.
  clear -H. induction M'; simpl.
  - var_cases. intro C. inversion C. congruence.
  - intro C. inversion C; subst; eauto.
  - intro C. var_cases; inversion C; subst; eauto. 
Qed.
    
Lemma swap_subst: forall M x y v v',
    x <> y ->
    closed v ->
    closed v' ->
    [y:=v']([x:=v]M) = [x:=v]([y:=v']M).
Proof.
  induction M; simpl; intros.
  - var_cases; rewrite subst_closed; auto.
  - f_equal; auto.
  - var_cases. rewrite IHM; auto.
Qed.
    
(** * Normalization of STLC *)

Definition halts (M: term) : Prop := exists v, M ⟶* v /\ value v.

Lemma value_halts: forall v, value v -> halts v.
Proof.
  intros v H. unfold halts.
  exists v. split.
  - constructor.
  - assumption.
Qed.

Lemma step_preserves_halts: forall M M', M ⟶ M' -> (halts M <-> halts M').
Proof.
  intros. unfold halts; split.
  - (* => *)
    intros [v [R V]]. destruct R.
    + exfalso; eapply value_is_nf; eauto.
    + exists z. erewrite (step_deterministic _ _ _ H H0). intuition.
  - (* <= *)
    intros [v [R V]]; exists v. 
    intuition. econstructor; eauto.
Qed.

(** First try: induction on type derivation fails *)
Theorem strong_normalization:
  forall M τ,
    (⋅ |- M ∈ τ) -> halts M.
Proof.
  intros*.
  remember ⋅ as Γ.
  intro H. revert HeqΓ.
  induction H; intros; subst; try discriminate.
  - unfold halts. eexists. split; econstructor.
  - (* No IH for the function body of M *)
Abort.










(** Strengthening induction hypothesis: logical relation *)

(* SN effectively defines a set of terms s.t. they are strongly normalizing *)

Fixpoint SN (T: typ) (M: term) : Prop :=
  (⋅ |- M ∈ T) /\ halts M /\
    (match T with
     | Typ_unit => True
     | σ → τ =>
         (forall N, SN σ N -> SN τ (Tm_app M N))
     end).

(* Consider these two properties of SN *)

Definition welltyped_SN: Prop := forall M τ, ⋅ |- M ∈ τ -> SN τ M.

Definition SN_halts: Prop := forall τ M, SN τ M -> halts M.

(* We prove that strong normalization follows from two things: 
   - well-typed term is in SN, and
   - terms in SN halts
 *)

Lemma strong_normalization'
      (H1: welltyped_SN)
      (H2: SN_halts):
  forall M τ, (⋅ |- M ∈ τ) -> halts M.
Proof. intros. eapply H2. eapply H1. eauto. Qed.

(* SN_halts is straight-forward *)
Lemma SN_halts_proof: SN_halts.
Proof. unfold SN_halts. destruct τ; simpl; intuition. Qed.

(** Handy lemmas about SN *)

Lemma SN_unfold: forall τ M,
    SN τ M <->
    (⋅ |- M ∈ τ) /\ halts M /\
      (match τ with
       | Typ_unit => True
       | σ → τ =>
           (forall N, SN σ N -> SN τ (Tm_app M N))
       end).
Proof. destruct τ; split; auto. Qed.

Lemma SN_typable_empty:
  forall τ M, SN τ M -> ⋅ |- M ∈ τ.
Proof. destruct τ; simpl; intuition. Qed.

(* Useful lemma: SN is invariant under reduction *)
Lemma step_preserves_SN:
  forall τ M M', M ⟶ M' ->
            (SN τ M -> SN τ M').
Proof.
  induction τ; intros M M' H.
  - (* unit type *)
    unfold SN. intuition.
    eapply preservation; eauto.
    eapply step_preserves_halts in H; intuition.
  - (* arrow type *)
    intro HSN; rewrite SN_unfold in HSN.
    destruct HSN as [HM [HaltM HSN]].
    split. eapply preservation; eauto.
    split. eapply step_preserves_halts in H; intuition.
    intros. eapply IHτ2.
    eapply App1; eauto.
    apply HSN; auto.
Qed.

Lemma multistep_preserves_SN:
  forall  τ M M', M ⟶* M' ->
             (SN τ M -> SN τ M').
Proof. induction 1; eauto using step_preserves_SN. Qed.

Lemma step_preserves_SN':
  forall τ M M', ⋅ |- M ∈ τ -> M ⟶ M' -> (SN τ M' -> SN τ M).
Proof.
  induction τ; intros M M' HM Hstep HSN.
  - unfold SN in *; intuition.
    eapply step_preserves_halts; eauto.
  - unfold SN in *; fold SN in *.
    destruct HSN as [HM' [HaltM' HSN]]. intuition.
    eapply step_preserves_halts; eauto.
    eapply IHτ2; eauto.
    econstructor; eauto.
    apply SN_unfold in H. intuition.
    econstructor; eauto.
Qed.

Lemma multistep_preserve_SN':
  forall τ M M', ⋅ |- M ∈ τ -> M ⟶* M' -> (SN τ M' -> SN τ M).
Proof.
  induction 2; intros; auto.
  eapply step_preserves_SN'; eauto.
  eapply IHmulti; eauto using preservation.
Qed.

(* Now it suffices to prove [welltyped_SN]
   The main difficulty is that SN talks about closed terms,
   yet function body may contain free variable. 
   To resolve this problem we generalize the induction hypothesis
   over _closed instances_ of an open term.
 *)
  
(* list of subst: environment *)
Definition env := list (string * term).

Fixpoint multi_subst (ss: env) (M: term) : term :=
  match ss with
  | nil => M
  | (x, N) :: ss' => multi_subst ss' ([x:=N]M)
  end.

(* list of (x,τ): type assignment *)
Definition tass := list (string * typ).

Fixpoint multi_update (Γ: context) (xts: tass) : context :=
  match xts with
  | nil => Γ
  | (x, τ) :: xts' => (x ↦ τ ; (multi_update Γ xts'))
  end.

(* an instantiation combines type assignment and environment *)
Inductive instantiation: tass -> env -> Prop :=
| V_nil: instantiation nil nil
| V_cons x τ v c e:
  value v ->
  SN τ v ->
  instantiation c e ->
  instantiation ((x,τ) :: c) ((x,v) :: e).
#[local]
Hint Constructors instantiation: core.

(* Auxiliary functions for manipulating env and tass *)
Fixpoint lookup {X: Set} (k: string) (l: list (string * X)) : option X :=
  match l with
  | nil => None
  | (k', x) :: l' => if String.eqb k' k then Some x else lookup k l'
  end.

Fixpoint drop {X: Set} (k: string) (l: list (string * X)) : list (string * X) :=
  match l with
  | nil => nil
  | (k', x) :: l' => if String.eqb k' k then drop k l' else (k', x) :: (drop k l')
  end.

(** lemmas about env, tass and instantiation *)

Lemma instantiation_domains_match {c} {e}:
  instantiation c e ->
  forall {x} {τ}, lookup x c = Some τ -> exists M, lookup x e = Some M.
Proof.
  induction 1; intros x' τ' HT.
  inversion HT. simpl in *; var_cases.
Qed.

Lemma instantiation_SN {c} {e}:
  instantiation c e ->
  forall x M τ,
    lookup x c = Some τ ->
    lookup x e = Some M ->
    SN τ M.
Proof.
  induction 1; intros x' M' τ' HT HM.
  inversion HT. simpl in *. var_cases.
Qed.

Lemma instantiation_inv_drop {c e x}:
  instantiation c e ->
  instantiation (drop x c) (drop x e).
Proof.
  induction 1. constructor. simpl. var_cases.
Qed.

Lemma multi_subst_closed: forall M, closed M -> forall e, multi_subst e M = M.
Proof.
  induction e; auto.
  destruct a as [x M']. simpl.
  rewrite subst_closed; auto.
Qed.

(* Closed environments... *)
Definition closed_env (e: env) : Prop :=
  Forall (fun kt => closed (snd kt)) e.

Lemma instantiation_env_closed {c e}:
  instantiation c e -> closed_env e.
Proof.
  induction 1; constructor; auto.
  simpl. eapply typable_empty_closed.
  apply SN_unfold in H0. destruct H0. eauto.
Qed.

Lemma subst_multi_subst e:
  forall x v M,
    closed v ->
    closed_env e ->
    multi_subst e ([x:=v] M) = [x:=v](multi_subst (drop x e) M).
Proof.
  induction e; intros; auto.
  destruct a as [y N]; simpl.
  inversion H0; subst; clear H0. simpl in *.
  destruct (eqb_spec y x); subst.
  - rewrite duplicate_subst; auto.
  - simpl. rewrite swap_subst; eauto.
Qed.

Lemma multi_subst_var {e x}:
  closed_env e ->
  multi_subst e (Tm_var x) =
    match lookup x e with
    | Some M => M
    | None => x
    end.
Proof.
  induction e; auto; intros.
  destruct a as [k M]; simpl. var_cases.
  apply multi_subst_closed. inversion H; auto.
  apply IHe. inversion H; auto.
Qed.

Lemma multi_subst_app {e}:
  forall M N,
    multi_subst e (Tm_app M N) =
      Tm_app (multi_subst e M) (multi_subst e N).
Proof.
  induction e; simpl; auto.
  destruct a as [k M']; simpl; intros.
  rewrite IHe; auto.
Qed.

Lemma multi_subst_abs {e}:
  forall x τ M,
    multi_subst e (\x : τ, M) = \x : τ, (multi_subst (drop x e) M).
Proof.
  induction e; simpl; auto; intros.
  destruct a as [k v]. var_cases.
Qed.

Lemma multi_subst_preserves_typing {c e}:
  instantiation c e ->
  forall Γ M τ, ((multi_update Γ c) |- M ∈ τ) ->
           Γ |- (multi_subst e M) ∈ τ.
Proof.
  induction 1; intros Γ M τ' HT; auto.
  simpl in *. apply IHinstantiation.
  eapply subst_preserves_typing; eauto.
  auto using SN_typable_empty.
Qed.

Lemma multi_update_drop:
  forall c Γ x x', multi_update Γ (drop x c) x' =
                if (x =? x')%string then Γ x' else multi_update Γ c x'.
Proof with var_cases.
  induction c; intros; var_cases; 
    destruct a as [y σ]...
  rewrite IHc...
  all: unfold update...
  all: try rewrite IHc...
Qed.

(** Now the main lemma and final theorem *)
Lemma SN_multi_subst:
  forall c e M τ,
    ((multi_update ⋅ c) |- M ∈ τ) ->
    instantiation c e ->
    SN τ (multi_subst e M).
Proof.
  (* Reformulating our goal to obtain a stronger induction hypothesis: *)
  cut (forall Γ M τ, (Γ |- M ∈ τ) ->
                (forall c e, (forall x, Γ x = lookup x c) -> instantiation c e  ->
                        SN τ (multi_subst e M))).
  (* obviously this implies our goal *)
  intros. eapply H with (Γ := multi_update ⋅ c); eauto.
  clear. induction c; auto.
  simpl. destruct a as (k, τ). unfold update.
  intros; var_cases. 

  (* Now prove the strengthened proposition by induction on type derivation *)
  induction 1; intros c e HΓ HV.
  - (* var *)
    rewrite HΓ in H.
    destruct (instantiation_domains_match HV H) as [M HM].
    eapply instantiation_SN; eauto.
    rewrite HM. rewrite multi_subst_var, HM; auto.
    eapply instantiation_env_closed; eauto.
  - (* abs *)
    rewrite multi_subst_abs.
    rewrite SN_unfold.
    cut (⋅ |- \x : σ, multi_subst (drop x e) M ∈ (σ → τ)). intro WT.
    split. exact WT.
    split. apply value_halts. constructor.
    intros N SNN. destruct (SN_halts_proof _ _ SNN) as [v [P Q]].
    pose proof (multistep_preserves_SN _ _ _ P SNN) as SNv.
    apply multistep_preserve_SN' with (multi_subst ((x, v) :: e) M).
    econstructor; eauto using SN_typable_empty.
    eapply multistep_trans.
    eapply multistep_App2. constructor. eauto.
    simpl. rewrite subst_multi_subst.
    econstructor. eauto using Beta. constructor.
    eapply typable_empty_closed.
    rewrite SN_unfold in SNv; intuition; eauto.
    eauto using instantiation_env_closed.
    eapply IHhas_type; try econstructor; eauto.
    intros. unfold update, lookup. var_cases.
    (* typing proof *)
    constructor.
    eapply multi_subst_preserves_typing; eauto using instantiation_inv_drop.
    eapply context_invariance; eauto.
    intros y Hfreey. rewrite multi_update_drop.
    unfold update. var_cases.
    rewrite HΓ. clear - c n.
    induction c; simpl. var_cases.
    destruct a as [z τ]. unfold update. var_cases.
  - (* app *)
    specialize (IHhas_type1 _ _ HΓ HV).
    specialize (IHhas_type2 _ _ HΓ HV).
    rewrite SN_unfold in IHhas_type1.
    rewrite multi_subst_app. intuition.
Qed.

Lemma welltyped_SN_proof: welltyped_SN.
Proof.
  unfold welltyped_SN.
  intros.
  replace M with (multi_subst nil M) by reflexivity.
  apply (SN_multi_subst nil).
  simpl. assumption.
  constructor.
Qed.
  
Theorem strong_normalization:
  forall M τ, (⋅ |- M ∈ τ) -> halts M.
Proof.
  apply strong_normalization'.
  exact welltyped_SN_proof.
  exact SN_halts_proof.
Qed.
      


                       
          
            

