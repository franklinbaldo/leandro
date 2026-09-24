import LeanDRO.Audit.Command
import LeanDRO.Law.BR.LINDB.Art2

open LeanDRO.Law.BR.LINDB.Art2

/-! Portão de dependências da LINDB, art. 2º, § 3º. -/

/--
info: LeanDRO.Law.BR.LINDB.Art2.stays_revoked_after_revoker_lapses depende de:
[interpretive/experimental] LeanDRO.Law.BR.LINDB.Art2.Interpretive.adopt_express_restoration_only
-/
#guard_msgs in
#premises stays_revoked_after_revoker_lapses against ledger

/--
info: LeanDRO.Law.BR.LINDB.Art2.stays_revoked_given não depende de axioma algum
-/
#guard_msgs in
#premises stays_revoked_given against ledger

#guard ledger.all (fun r => !r.sources.isEmpty)
#guard par3.origin.isFixture
