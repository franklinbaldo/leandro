import Lean

/-!
# `#hypotheses_consumed`: a prova usa o que o teorema pede?

Uma hipótese proposicional que o termo de prova não usa é sinal de falsa
precisão: o teorema anuncia depender de uma condição (muitas vezes a
condição que o texto normativo põe) e a conclusão sai sem ela. Foi assim
que apareceu o primeiro achado do LeanDRO (`docs/findings/0001`).

O linter `unusedVariables` do Lean já vê isso, mas cala diante de nome com
`_` e pode ser desligado; este comando não cala. Ele reprova quando alguma
hipótese do tipo do teorema não ocorre no termo de prova.

Limite honesto: o teste é estrutural. "Ocorre no termo" não quer dizer
"é necessária": táticas como `omega` podem capturar hipóteses que não
precisariam. O comando acha hipótese ociosa; não prova que as demais são
indispensáveis.

Estabilidade: experimental
-/

namespace LeanDRO.Audit

open Lean Meta Elab Command

/-- Hipóteses proposicionais do tipo de `thm` ausentes do termo de prova. -/
def unusedHypotheses (thm : Name) : MetaM (List MessageData) := do
  let info ← getConstInfo thm
  let some value := info.value? (allowOpaque := true)
    | throwError m!"{thm} não tem termo de prova inspecionável"
  forallTelescope info.type fun xs _ => do
    let body := (mkAppN value xs).headBeta
    let mut out : List MessageData := []
    for x in xs do
      let ty ← inferType x
      if ← isProp ty then
        unless body.containsFVar x.fvarId! do
          out := out ++ [m!"{← x.fvarId!.getUserName} : {← ppExpr ty}"]
    return out

syntax (name := consumedCmd) "#hypotheses_consumed " ident : command

@[command_elab consumedCmd]
def elabConsumed : CommandElab := fun stx => do
  let thm ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo stx[1]
  let unused ← liftTermElabM <| unusedHypotheses thm
  if unused.isEmpty then
    logInfo m!"{thm} consome todas as hipóteses proposicionais"
  else
    throwError m!"{thm}: hipóteses não consumidas pela prova\n{MessageData.joinSep unused "\n"}"

end LeanDRO.Audit
