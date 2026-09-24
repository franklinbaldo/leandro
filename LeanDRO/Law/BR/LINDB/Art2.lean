import LeanDRO.Audit.Premise
import LeanDRO.Law.BR.Sources

/-!
# LINDB, art. 2º, § 3º — vedação da repristinação tácita

A LINDB é norma sobre normas: diz quando uma lei entra em vigor, quando sai
e se volta. Por isso é a base jurídica da camada `Temporal`, que sem ela só
tem datas e intervalos. Este é o primeiro slice dela, e o menor que toca
vigência diretamente.

## O que está formalizado

A consequência central do § 3º: revogada a lei `a` pela lei `b`, `a` não
volta a vigorar sem ato expresso de restauração. Fora do escopo: vacatio
legis (art. 1º; exige aritmética de dias sobre `Date`), critérios de
revogação tácita (art. 2º, § 1º), convivência de leis (§ 2º), direito
intertemporal (art. 6º), e o efeito repristinatório em controle de
constitucionalidade (exceção a formalizar com fonte, não de memória).

## O achado que a formalização expõe

O texto diz que a lei revogada não se restaura *por ter a lei revogadora
perdido a vigência*. A leitura adotada (`ExpressRestorationOnlyReading`) é
mais forte: nada restaura sem ato expresso. Sob ela, a perda de vigência da
revogadora deixa de ser premissa: o teorema `stays_revoked_after_revoker_lapses`
recebe essa hipótese e não a usa. O Lean não decide se a leitura forte é
correta. Ele mostra que ela torna a condição do texto logicamente ociosa,
e isso é exatamente o que a revisão jurídica precisa examinar.

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

/-- O ato `r` restaura expressamente `a` com efeito na data `d`. -/
opaque ExpressRestoration : Law → Law → Date → Prop

/-! ## Leitura adotada, com nome -/

/-- Depois de revogada, a lei só volta a vigorar por restauração expressa
com efeito entre a revogação e a data considerada. -/
def ExpressRestorationOnlyReading : Prop :=
  ∀ a b d₀ d, RevokedBy a b d₀ → d₀ ≤ d → InForce a d →
    ∃ r dᵣ, ExpressRestoration r a dᵣ ∧ d₀ ≤ dᵣ ∧ dᵣ ≤ d

/-! ## Premissa material -/

/-- "Salvo disposição em contrário, a lei revogada não se restaura...",
lido como: só disposição expressa restaura. -/
axiom Interpretive.adopt_express_restoration_only : ExpressRestorationOnlyReading

def ledger : List PremiseRecord := [
  { name := ``Interpretive.adopt_express_restoration_only, kind := .interpretive,
    stability := .experimental, sources := [par3],
    rationale := "Generaliza 'não se restaura por ter a lei revogadora perdido a vigência' para 'não se restaura sem disposição expressa'. Rival: ler o § 3º como vedando só essa causa de restauração." }
]

/-! ## Consequências -/

/-- Forma condicional: a leitura entra como hipótese. -/
theorem stays_revoked_given (hRead : ExpressRestorationOnlyReading)
    (a b : Law) (d₀ d : Date) (hRev : RevokedBy a b d₀) (hLe : d₀ ≤ d)
    (hNone : ∀ r dᵣ, ExpressRestoration r a dᵣ → d₀ ≤ dᵣ → ¬ dᵣ ≤ d) :
    ¬ InForce a d := by
  intro hIn
  obtain ⟨r, dᵣ, hR, h₀, h₁⟩ := hRead a b d₀ d hRev hLe hIn
  exact hNone r dᵣ hR h₀ h₁

/-- Teorema demonstrativo, com o § 3º em mente: revogada `a` por `b`, e
perdida a vigência de `b`, `a` continua fora de vigor sem restauração
expressa. A hipótese `_hLapse` não é usada, e esse é o achado. -/
theorem stays_revoked_after_revoker_lapses
    (a b : Law) (d₀ d₁ d : Date) (hRev : RevokedBy a b d₀)
    (_hLapse : LapsesAt b d₁) (hLe : d₀ ≤ d)
    (hNone : ∀ r dᵣ, ExpressRestoration r a dᵣ → d₀ ≤ dᵣ → ¬ dᵣ ≤ d) :
    ¬ InForce a d :=
  stays_revoked_given Interpretive.adopt_express_restoration_only a b d₀ d hRev hLe hNone

end LeanDRO.Law.BR.LINDB.Art2
