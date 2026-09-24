import Lean
import LeanDRO.Audit.Premise

/-!
# `#premises`: de que esta conclusão depende?

`#print axioms` responde com nomes. `#premises thm against ledger` responde
com a pergunta jurídica: cada dependência sai com categoria e estabilidade,
e o comando **falha** quando

* a dependência é `sorryAx` (prova incompleta);
* a dependência não é axioma lógico embutido nem está no registro;
* a categoria do registro diverge da categoria do namespace.

Falhar é o ponto: fixado com `#guard_msgs` num arquivo de teste, o comando
transforma "de que esta conclusão depende" em portão de build. Premissa
nova, removida ou reclassificada quebra a compilação até alguém olhar.

Estabilidade: experimental
-/

namespace LeanDRO.Audit

open Lean Elab Command

/-- Axiomas do núcleo lógico do Lean; não são premissas jurídicas. -/
def builtinAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

private def kindLabel : PremiseKind → String
  | .textual => "textual"
  | .semantic => "semantic"
  | .interpretive => "interpretive"
  | .precedent => "precedent"
  | .fact => "fact"
  | .institutional => "institutional"
  | .assumption => "assumption"

private def stabilityLabel : Stability → String
  | .stable => "stable"
  | .contested => "contested"
  | .experimental => "experimental"
  | .deprecated => "deprecated"

/-- Uma linha do relatório, ou o motivo de reprovação. -/
def describe (ledger : List PremiseRecord) (ax : Name) : Except String String :=
  if ax == ``sorryAx then
    .error s!"{ax}: prova incompleta (sorry)"
  else if builtinAxioms.contains ax then
    .ok s!"[builtin] {ax}"
  else
    match ledger.find? (·.name == ax), kindOfName ax with
    | none, _ => .error s!"{ax}: axioma material fora do registro"
    | some _, none => .error s!"{ax}: nome sem segmento de categoria"
    | some r, some k =>
      if r.kind != k then
        .error s!"{ax}: registro diz {kindLabel r.kind}, namespace diz {kindLabel k}"
      else
        .ok s!"[{kindLabel k}/{stabilityLabel r.stability}] {ax}"

syntax (name := premisesCmd) "#premises " ident " against " ident : command

private unsafe def evalLedgerUnsafe (n : Name) : CommandElabM (List PremiseRecord) := do
  let info ← getConstInfo n
  unless info.type == mkApp (mkConst ``List [0]) (mkConst ``PremiseRecord) do
    throwError m!"{n} deve ter tipo `List PremiseRecord`"
  liftCoreM <| evalConst (List PremiseRecord) n

@[implemented_by evalLedgerUnsafe]
private opaque evalLedger (n : Name) : CommandElabM (List PremiseRecord)

@[command_elab premisesCmd]
def elabPremises : CommandElab := fun stx => do
  let thm ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo stx[1]
  let ledgerName ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo stx[3]
  let ledger ← evalLedger ledgerName
  let axs ← liftCoreM <| collectAxioms thm
  let sorted := axs.qsort (fun a b => a.toString < b.toString)
  let results := sorted.toList.map (describe ledger)
  let errors := results.filterMap fun | .error e => some e | .ok _ => none
  unless errors.isEmpty do
    throwError m!"{thm}: dependências não auditáveis\n{String.intercalate "\n" errors}"
  let lines := results.filterMap fun | .ok l => some l | .error _ => none
  if lines.isEmpty then
    logInfo m!"{thm} não depende de axioma algum"
  else
    logInfo m!"{thm} depende de:\n{String.intercalate "\n" lines}"

end LeanDRO.Audit
