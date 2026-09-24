import LeanDRO.Audit.Premise
import LeanDRO.Law.BR.Sources

/-!
# LINDB, art. 2º, § 3º — vedação da repristinação tácita

A LINDB é norma sobre normas: diz quando uma lei entra em vigor, quando sai
e se volta. Por isso é a base jurídica da camada `Temporal`. Este é o
primeiro slice dela.

## Histórico: achado 0001 (sobreformalização)

A primeira versão deste módulo adotava `ExpressRestorationOnlyReading`
("nada restaura a lei revogada sem ato expresso") e provava que a lei
continuava revogada **sem usar** a hipótese de a revogadora ter perdido a
vigência. A hipótese ociosa era a própria condição do texto: o modelo dizia
mais do que a fonte. Ver `docs/findings/0001-lindb-repristination-overformalization.md`.

Aquelas declarações ficam abaixo, `deprecated`, para reproduzir o achado
(ADR-0004). As atuais separam:

* **núcleo textual** (`ParThreeCore`): revogada `a` por `b`, perdida a
  vigência de `b`, e sem disposição em contrário, `a` não se restaura por
  isso. Nada além.
* **regra interpretativa** (`ContraryProvisionRestoresReading`): havendo
  disposição em contrário, `a` se restaura. O texto abre a exceção, mas não
  diz a forma, a suficiência nem os efeitos da disposição repristinatória;
  dizer que ela basta é interpretação.

## O que continua fora

Vacatio legis (art. 1º), critérios de revogação (art. 2º, § 1º),
convivência de leis (§ 2º), direito intertemporal (art. 6º), efeito
repristinatório no controle de constitucionalidade.

Estabilidade: experimental
-/

namespace LeanDRO.Law.BR.LINDB.Art2

open LeanDRO.Temporal LeanDRO.Source LeanDRO.Audit LeanDRO.Law.BR

/-! ## Fonte -/

/-- LINDB, art. 2º, § 3º, redação original. O Planalto grafa o ordinal como
`3o`; a transcrição normaliza para `3º`. -/
def par3 : Version where
  device := ⟨lindb, "art2_par3"⟩
  text := "§ 3º Salvo disposição em contrário, a lei revogada não se restaura por ter a lei revogadora perdido a vigência."
  textHash := "sha256:bb07291a5dcff3d37b1b0b8b5c5f4599a1190fc40cc37703539c2085e7956eef"
  start := ⟨1942, 9, 4⟩
  stop := none
  witnesses := [planalto "https://www.planalto.gov.br/ccivil_03/decreto-lei/del4657compilado.htm"]
  origin := fixtureOrigin

/-! ## Vocabulário -/

/-- Lei, identificada pela URN LEX da obra. -/
structure Law where
  urn : String
deriving Repr, DecidableEq

/-- `a` está em vigor na data `d`. Conceito jurídico. -/
opaque InForce : Law → Date → Prop

/-- `a` foi revogada por `b` com efeito na data `d`. Fato normativo. -/
opaque RevokedBy : Law → Law → Date → Prop

/-- `b` perdeu a vigência na data `d`. Fato normativo. -/
opaque LapsesAt : Law → Date → Prop

/-- Há "disposição em contrário" quanto à restauração de `a` quando `b`
perde a vigência. Onde ela mora, que forma tem e o que basta: em aberto. -/
opaque ContraryProvision : Law → Law → Prop

/-- `a` se restaura *por ter* `b` perdido a vigência. O nexo causal ("por
ter") é do texto e fica no predicado, em vez de virar "`a` volta a vigorar"
sem qualificação. -/
opaque RestoredByLapse : Law → Law → Prop

/-! ## Núcleo textual e regra interpretativa, com nome -/

/-- O que o § 3º diz, e só isso. -/
def ParThreeCore : Prop :=
  ∀ a b d₀ d₁, RevokedBy a b d₀ → LapsesAt b d₁ → ¬ ContraryProvision a b →
    ¬ RestoredByLapse a b

/-- Leitura da exceção: a disposição em contrário basta para restaurar. -/
def ContraryProvisionRestoresReading : Prop :=
  ∀ a b d₀ d₁, RevokedBy a b d₀ → LapsesAt b d₁ → ContraryProvision a b →
    RestoredByLapse a b

/-- § 3º, núcleo: "Salvo disposição em contrário, a lei revogada não se
restaura por ter a lei revogadora perdido a vigência." -/
axiom Textual.par3_core : ParThreeCore

/-- A exceção "salvo disposição em contrário" lida como suficiente para
restaurar. Interpretação, não texto. -/
axiom Interpretive.contrary_provision_restores : ContraryProvisionRestoresReading

/-! ## Consequências -/

/-- Forma condicional do núcleo: toda premissa é hipótese. -/
theorem not_restored_by_lapse_given (hCore : ParThreeCore)
    (a b : Law) (d₀ d₁ : Date) (hRev : RevokedBy a b d₀) (hLapse : LapsesAt b d₁)
    (hNo : ¬ ContraryProvision a b) :
    ¬ RestoredByLapse a b :=
  hCore a b d₀ d₁ hRev hLapse hNo

/-- Teorema demonstrativo do núcleo textual. Consome a perda de vigência da
revogadora; depende só de premissa `Textual`. -/
theorem not_restored_by_lapse
    (a b : Law) (d₀ d₁ : Date) (hRev : RevokedBy a b d₀) (hLapse : LapsesAt b d₁)
    (hNo : ¬ ContraryProvision a b) :
    ¬ RestoredByLapse a b :=
  not_restored_by_lapse_given Textual.par3_core a b d₀ d₁ hRev hLapse hNo

/-- A exceção, sob a leitura interpretativa; depende só dela. -/
theorem restored_by_lapse_of_contrary
    (a b : Law) (d₀ d₁ : Date) (hRev : RevokedBy a b d₀) (hLapse : LapsesAt b d₁)
    (hYes : ContraryProvision a b) :
    RestoredByLapse a b :=
  Interpretive.contrary_provision_restores a b d₀ d₁ hRev hLapse hYes

/-- Juntos, texto e leitura dão uma equivalência: revogada `a` por `b` e
perdida a vigência de `b`, `a` se restaura por isso se, e somente se, há
disposição em contrário. A ida precisa de lógica clássica, e o `#premises`
mostra isso. -/
theorem restored_by_lapse_iff_contrary
    (a b : Law) (d₀ d₁ : Date) (hRev : RevokedBy a b d₀) (hLapse : LapsesAt b d₁) :
    RestoredByLapse a b ↔ ContraryProvision a b := by
  constructor
  · intro hRestored
    exact Classical.byContradiction fun hNo =>
      not_restored_by_lapse a b d₀ d₁ hRev hLapse hNo hRestored
  · exact restored_by_lapse_of_contrary a b d₀ d₁ hRev hLapse

/-! ## Obsoleto: formulação do achado 0001

Mantido, com os mesmos nomes e o mesmo sentido, para reproduzir o achado
(ADR-0004). Não usar em conclusão nova. -/

/-- O ato `r` restaura expressamente `a` com efeito na data `d`. -/
opaque ExpressRestoration : Law → Law → Date → Prop

/-- **Obsoleto** (achado 0001): leitura mais forte que o texto. Depois de
revogada, a lei só volta a vigorar por restauração expressa com efeito
entre a revogação e a data considerada. -/
def ExpressRestorationOnlyReading : Prop :=
  ∀ a b d₀ d, RevokedBy a b d₀ → d₀ ≤ d → InForce a d →
    ∃ r dᵣ, ExpressRestoration r a dᵣ ∧ d₀ ≤ dᵣ ∧ dᵣ ≤ d

/-- **Obsoleto** (achado 0001). Substituído por `Textual.par3_core` e
`Interpretive.contrary_provision_restores`. -/
axiom Interpretive.adopt_express_restoration_only : ExpressRestorationOnlyReading

/-- **Obsoleto** (achado 0001). Forma condicional. -/
theorem stays_revoked_given (hRead : ExpressRestorationOnlyReading)
    (a b : Law) (d₀ d : Date) (hRev : RevokedBy a b d₀) (hLe : d₀ ≤ d)
    (hNone : ∀ r dᵣ, ExpressRestoration r a dᵣ → d₀ ≤ dᵣ → ¬ dᵣ ≤ d) :
    ¬ InForce a d := by
  intro hIn
  obtain ⟨r, dᵣ, hR, h₀, h₁⟩ := hRead a b d₀ d hRev hLe hIn
  exact hNone r dᵣ hR h₀ h₁

/-- **Obsoleto** (achado 0001). A hipótese `_hLapse`, que é a condição do
texto, não é consumida pela prova, e o `_` calava o linter. Mantido
idêntico como evidência; `#hypotheses_consumed` o reprova no teste. -/
theorem stays_revoked_after_revoker_lapses
    (a b : Law) (d₀ d₁ d : Date) (hRev : RevokedBy a b d₀)
    (_hLapse : LapsesAt b d₁) (hLe : d₀ ≤ d)
    (hNone : ∀ r dᵣ, ExpressRestoration r a dᵣ → d₀ ≤ dᵣ → ¬ dᵣ ≤ d) :
    ¬ InForce a d :=
  stays_revoked_given Interpretive.adopt_express_restoration_only a b d₀ d hRev hLe hNone

/-! ## Registro -/

def ledger : List PremiseRecord := [
  { name := ``Textual.par3_core, kind := .textual, stability := .experimental,
    sources := [par3],
    rationale := "Só o que o § 3º diz: sem disposição em contrário, a perda de vigência da revogadora não restaura a revogada." },
  { name := ``Interpretive.contrary_provision_restores, kind := .interpretive,
    stability := .experimental, sources := [par3],
    rationale := "A exceção 'salvo disposição em contrário' lida como suficiente para restaurar; o texto não fixa forma, suficiência nem efeitos." },
  { name := ``Interpretive.adopt_express_restoration_only, kind := .interpretive,
    stability := .deprecated, sources := [par3],
    rationale := "Obsoleto pelo achado 0001: leitura mais forte que o texto, que tornava ociosa a condição da perda de vigência. Substituído por Textual.par3_core + Interpretive.contrary_provision_restores." }
]

end LeanDRO.Law.BR.LINDB.Art2
