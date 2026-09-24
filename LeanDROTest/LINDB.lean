import LeanDRO.Audit.Command
import LeanDRO.Audit.Consumption
import LeanDRO.Law.BR.LINDB.Art2

open LeanDRO.Law.BR.LINDB.Art2

/-! # Portões da LINDB, art. 2º, § 3º -/

/-! ## Dependências -/

/--
info: LeanDRO.Law.BR.LINDB.Art2.not_restored_by_lapse depende de:
[textual/experimental] LeanDRO.Law.BR.LINDB.Art2.Textual.par3_core
-/
#guard_msgs in
#premises not_restored_by_lapse against ledger
/--
info: LeanDRO.Law.BR.LINDB.Art2.restored_by_lapse_of_contrary depende de:
[interpretive/experimental] LeanDRO.Law.BR.LINDB.Art2.Interpretive.contrary_provision_restores
-/
#guard_msgs in
#premises restored_by_lapse_of_contrary against ledger
/--
info: LeanDRO.Law.BR.LINDB.Art2.restored_by_lapse_iff_contrary depende de:
[builtin] Classical.choice
[interpretive/experimental] LeanDRO.Law.BR.LINDB.Art2.Interpretive.contrary_provision_restores
[textual/experimental] LeanDRO.Law.BR.LINDB.Art2.Textual.par3_core
[builtin] Quot.sound
[builtin] propext
-/
#guard_msgs in
#premises restored_by_lapse_iff_contrary against ledger
/--
info: LeanDRO.Law.BR.LINDB.Art2.not_restored_by_lapse_given não depende de axioma algum
-/
#guard_msgs in
#premises not_restored_by_lapse_given against ledger
/--
info: LeanDRO.Law.BR.LINDB.Art2.stays_revoked_after_revoker_lapses depende de:
[interpretive/deprecated] LeanDRO.Law.BR.LINDB.Art2.Interpretive.adopt_express_restoration_only
-/
#guard_msgs in
#premises stays_revoked_after_revoker_lapses against ledger

/-! ## Consumo de hipóteses -/

/--
info: LeanDRO.Law.BR.LINDB.Art2.not_restored_by_lapse_given consome todas as hipóteses proposicionais
-/
#guard_msgs in
#hypotheses_consumed not_restored_by_lapse_given
/--
info: LeanDRO.Law.BR.LINDB.Art2.not_restored_by_lapse consome todas as hipóteses proposicionais
-/
#guard_msgs in
#hypotheses_consumed not_restored_by_lapse
/--
info: LeanDRO.Law.BR.LINDB.Art2.restored_by_lapse_of_contrary consome todas as hipóteses proposicionais
-/
#guard_msgs in
#hypotheses_consumed restored_by_lapse_of_contrary
/--
info: LeanDRO.Law.BR.LINDB.Art2.restored_by_lapse_iff_contrary consome todas as hipóteses proposicionais
-/
#guard_msgs in
#hypotheses_consumed restored_by_lapse_iff_contrary
/--
info: LeanDRO.Law.BR.LINDB.Art2.stays_revoked_given consome todas as hipóteses proposicionais
-/
#guard_msgs in
#hypotheses_consumed stays_revoked_given

/-! ## Achado 0001, como teste de regressão

A formulação obsoleta tem de continuar reprovando: se um dia ela passar,
ou o detector quebrou ou alguém mudou o obsoleto em silêncio. -/

/--
error: LeanDRO.Law.BR.LINDB.Art2.stays_revoked_after_revoker_lapses: hipóteses não consumidas pela prova
_hLapse : LapsesAt b d₁
-/
#guard_msgs in
#hypotheses_consumed stays_revoked_after_revoker_lapses

#guard ledger.all (fun r => !r.sources.isEmpty)
#guard par3.origin.isFixture
