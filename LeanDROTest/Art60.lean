import LeanDRO.Audit.Command
import LeanDRO.Law.BR.Constitution.Art60

open LeanDRO.Law.BR.Constitution.Art60

/-! Portão de dependências do art. 60. Mudou a saída, mudou a premissa:
atualize o esperado só depois de revisar a mudança jurídica. -/

/--
info: LeanDRO.Law.BR.Constitution.Art60.approved_of_tallies depende de:
[institutional/experimental] LeanDRO.Law.BR.Constitution.Art60.Institutional.senado_seats
[interpretive/experimental] LeanDRO.Law.BR.Constitution.Art60.Interpretive.adopt_total_membership
[textual/experimental] LeanDRO.Law.BR.Constitution.Art60.Textual.camara_seat_cap
[textual/experimental] LeanDRO.Law.BR.Constitution.Art60.Textual.par2_sufficiency
[builtin] Quot.sound
[builtin] propext
-/
#guard_msgs in
#premises approved_of_tallies against ledger

/-! A forma condicional não depende de premissa material alguma. -/

/--
info: LeanDRO.Law.BR.Constitution.Art60.approved_of_tallies_given depende de:
[builtin] Quot.sound
[builtin] propext
-/
#guard_msgs in
#premises approved_of_tallies_given against ledger

/--
info: LeanDRO.Law.BR.Constitution.Art60.camara_threshold não depende de axioma algum
-/
#guard_msgs in
#premises camara_threshold against ledger

/-! ## O portão reprova o que deve reprovar -/

namespace Negative

axiom Textual.unregistered : 1 = 1
theorem usesUnregistered : 1 = 1 := Textual.unregistered

axiom Fact.misfiled : 2 = 2
theorem usesMisfiled : 2 = 2 := Fact.misfiled

def emptyLedger : List LeanDRO.Audit.PremiseRecord := []

def wrongKindLedger : List LeanDRO.Audit.PremiseRecord :=
  [{ name := ``Fact.misfiled, kind := .textual, stability := .experimental,
     sources := [], rationale := "teste" }]

end Negative

/--
error: Negative.usesUnregistered: dependências não auditáveis
Negative.Textual.unregistered: axioma material fora do registro
-/
#guard_msgs in
#premises Negative.usesUnregistered against Negative.emptyLedger

/--
error: Negative.usesMisfiled: dependências não auditáveis
Negative.Fact.misfiled: registro diz textual, namespace diz fact
-/
#guard_msgs in
#premises Negative.usesMisfiled against Negative.wrongKindLedger

#guard !(LeanDRO.Audit.describe [] ``sorryAx).toBool

/-! ## Proveniência -/

#guard ledger.all (fun r => !r.sources.isEmpty)
#guard par2.origin.isFixture
#guard par2.device.urn == "urn:lex:br:federal:constituicao:1988-10-05;1988!art60_par2"
