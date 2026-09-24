import LeanDRO.Audit.Premise
import LeanDRO.Law.BR.Sources

/-!
# CF/88, art. 60, § 2º — quórum de aprovação de emenda

Primeiro vertical slice. O objetivo não é formalizar muito direito: é
exercitar a cadeia inteira

```
fonte (Planalto) → dispositivo (URN LEX) → redação/vigência (Version)
  → proposição Lean → premissas declaradas → teorema → auditoria (#premises)
```

## O que está formalizado

Só a suficiência do § 2º: a proposta que obtém três quintos dos votos dos
membros de cada Casa, nos dois turnos, considera-se aprovada. Fora do
escopo: iniciativa (caput), limitações circunstanciais (§ 1º), promulgação
(§ 3º), cláusulas pétreas (§ 4º), irrepetibilidade (§ 5º), controle
judicial.

## O que é premissa, e de que tipo

* `Textual.par2_sufficiency` — o que o § 2º diz (direção "se", não "só se").
* `Interpretive.adopt_total_membership` — "três quintos dos votos dos
  respectivos membros" tem por base a composição da Casa, não os presentes.
  É escolha interpretativa, e por isso está exposta como `Prop` com nome
  (`TotalMembershipReading`), não embutida na definição de quórum.
* `Textual.camara_seat_cap` — LC 78/1993, art. 1º: no máximo 513 deputados.
* `Institutional.senado_seats` — 81 senadores: três por Estado e pelo DF
  (art. 46, § 1º) vezes 27 unidades. O número de unidades é fato
  institucional, não texto do § 1º.

Os votos de uma proposta concreta são **fatos** e entram como hipóteses
dos teoremas, nunca como axiomas.

## Base textual

Fixture: transcrição manual do portal do Planalto em 2026-09-24. O
Leizilla ainda não cobre a CF/88 nem a legislação federal; quando cobrir,
as `Version` abaixo passam a vir de `versoes.parquet` e esta fixture vira
teste de regressão (ADR-0002).

Estabilidade: experimental
-/

namespace LeanDRO.Law.BR.Constitution.Art60

open LeanDRO.Temporal LeanDRO.Source LeanDRO.Audit LeanDRO.Law.BR

/-! ## Fontes -/

/-- CF/88, art. 60, § 2º, redação original (sem alteração por emenda). -/
def par2 : Version where
  device := ⟨cf88, "art60_par2"⟩
  text := "§ 2º A proposta será discutida e votada em cada Casa do Congresso Nacional, em dois turnos, considerando-se aprovada se obtiver, em ambos, três quintos dos votos dos respectivos membros."
  textHash := "sha256:8f8db5c92bfa6c9903ed05f979dc25b7f6d8aa3049291c8ce751fd0a97a52371"
  start := ⟨1988, 10, 5⟩
  stop := none
  witnesses := [planalto "https://www.planalto.gov.br/ccivil_03/constituicao/constituicao.htm"]
  origin := fixtureOrigin

/-- CF/88, art. 46, § 1º, redação original. -/
def art46par1 : Version where
  device := ⟨cf88, "art46_par1"⟩
  text := "§ 1º Cada Estado e o Distrito Federal elegerão três Senadores, com mandato de oito anos."
  textHash := "sha256:cb35d74fc32cf31b8c8a3aab302266794163253aac84d23467ae9d0f70dee44a"
  start := ⟨1988, 10, 5⟩
  stop := none
  witnesses := [planalto "https://www.planalto.gov.br/ccivil_03/constituicao/constituicao.htm"]
  origin := fixtureOrigin

/-- LC 78/1993, art. 1º, caput. -/
def lc78art1 : Version where
  device := ⟨lc78, "art1"⟩
  text := "Art. 1º Proporcional à população dos Estados e do Distrito Federal, o número de deputados federais não ultrapassará quinhentos e treze representantes, fornecida, pela Fundação Instituto Brasileiro de Geografia e Estatística, no ano anterior às eleições, a atualização estatística demográfica das unidades da Federação."
  textHash := "sha256:8c1cbcdab854391ae0ef005a82fefe69ac2d2ef21544ac805978c97d35437293"
  start := ⟨1993, 12, 30⟩
  stop := none
  witnesses := [planalto "https://www.planalto.gov.br/ccivil_03/leis/lcp/lcp78.htm"]
  origin := fixtureOrigin

/-- A redação do § 2º usada aqui está em vigor na data da transcrição. -/
theorem par2_in_force_at_retrieval : par2.InForceAt ⟨2026, 9, 24⟩ := by decide

/-! ## Vocabulário -/

inductive House
  | camara
  | senado
deriving Repr, DecidableEq

inductive Round
  | first
  | second
deriving Repr, DecidableEq

/-- Proposta de emenda, identificada externamente (p. ex. "PEC 45/2019"). -/
structure Proposal where
  id : String
deriving Repr, DecidableEq

/-- Número de membros (cadeiras) da Casa. Opaco: seu valor vem de premissa. -/
opaque members : House → Nat

/-- Votos favoráveis obtidos pela proposta na Casa e turno. Fato do mundo. -/
opaque yesVotes : Proposal → House → Round → Nat

/-- A proposta obteve, na Casa e turno, o quórum do § 2º. Conceito jurídico. -/
opaque ReachesQuorum : Proposal → House → Round → Prop

/-- A proposta considera-se aprovada nos termos do § 2º. Conceito jurídico. -/
opaque Approved : Proposal → Prop

/-- Aritmética pura, sem conteúdo jurídico: `votes ≥ 3/5 · base`. -/
def threeFifths (base votes : Nat) : Prop := 3 * base ≤ 5 * votes

instance (b v : Nat) : Decidable (threeFifths b v) :=
  inferInstanceAs (Decidable (3 * b ≤ 5 * v))

/-! ## Leituras interpretativas, com nome

Uma leitura é uma `Prop`. Declará-la não a afirma; afirmá-la é um axioma
de categoria `Interpretive`, e só a leitura adotada é afirmada. -/

/-- Base do quórum é a composição da Casa. -/
def TotalMembershipReading : Prop :=
  ∀ p h r, threeFifths (members h) (yesVotes p h r) → ReachesQuorum p h r

/-- Leitura rival, não adotada: base é o número de presentes na sessão.
Fica registrada para que a escolha seja visível e contestável. -/
def PresentMembersReading (present : Proposal → House → Round → Nat) : Prop :=
  ∀ p h r, threeFifths (present p h r) (yesVotes p h r) → ReachesQuorum p h r

/-- O que o § 2º diz, na direção da suficiência. -/
def ParTwoSufficiency : Prop :=
  ∀ p, (∀ h r, ReachesQuorum p h r) → Approved p

/-! ## Premissas materiais -/

/-- § 2º: "considerando-se aprovada se obtiver, em ambos, três quintos...". -/
axiom Textual.par2_sufficiency : ParTwoSufficiency

/-- LC 78/1993, art. 1º: "não ultrapassará quinhentos e treze". -/
axiom Textual.camara_seat_cap : members .camara ≤ 513

/-- 3 senadores (art. 46, § 1º) × 27 unidades (26 Estados + DF). -/
axiom Institutional.senado_seats : members .senado = 81

/-- Adota a leitura da composição total para "votos dos respectivos membros". -/
axiom Interpretive.adopt_total_membership : TotalMembershipReading

/-- Registro auditável das premissas deste módulo. -/
def ledger : List PremiseRecord := [
  { name := ``Textual.par2_sufficiency, kind := .textual, stability := .experimental,
    sources := [par2],
    rationale := "Leitura literal da oração 'considerando-se aprovada se obtiver, em ambos, três quintos'; só a suficiência." },
  { name := ``Textual.camara_seat_cap, kind := .textual, stability := .experimental,
    sources := [lc78art1],
    rationale := "Teto legal de cadeiras; basta o teto, não a composição exata, para a conclusão." },
  { name := ``Institutional.senado_seats, kind := .institutional, stability := .experimental,
    sources := [art46par1],
    rationale := "Três por unidade (texto) vezes 27 unidades (fato institucional fora do § 1º)." },
  { name := ``Interpretive.adopt_total_membership, kind := .interpretive, stability := .experimental,
    sources := [par2],
    rationale := "'Votos dos respectivos membros' lido como fração da composição da Casa; rival: PresentMembersReading." }
]

/-! ## Aritmética (sem premissa jurídica) -/

theorem threeFifths_iff_min (b v : Nat) : threeFifths b v ↔ (3 * b + 4) / 5 ≤ v := by
  unfold threeFifths; omega

theorem threeFifths_mono {b v w : Nat} (h : threeFifths b v) (hvw : v ≤ w) : threeFifths b w := by
  unfold threeFifths at *; omega

theorem threeFifths_antitone_base {b c v : Nat} (h : threeFifths b v) (hcb : c ≤ b) :
    threeFifths c v := by
  unfold threeFifths at *; omega

/-- 308 é o mínimo sobre 513 cadeiras. -/
theorem camara_threshold : threeFifths 513 308 ∧ ¬ threeFifths 513 307 := by decide

/-- 49 é o mínimo sobre 81 cadeiras. -/
theorem senado_threshold : threeFifths 81 49 ∧ ¬ threeFifths 81 48 := by decide

/-! ## Consequência jurídica condicional -/

/-- Forma condicional: toda premissa jurídica é hipótese explícita.
Não depende de axioma material algum. -/
theorem approved_of_tallies_given
    (hRule : ParTwoSufficiency) (hRead : TotalMembershipReading)
    (hCap : members .camara ≤ 513) (hSen : members .senado = 81)
    (p : Proposal)
    (hCamara : ∀ r, 308 ≤ yesVotes p .camara r)
    (hSenado : ∀ r, 49 ≤ yesVotes p .senado r) :
    Approved p := by
  apply hRule
  intro h r
  apply hRead
  cases h with
  | camara =>
    have := hCamara r
    unfold threeFifths; omega
  | senado =>
    have := hSenado r
    unfold threeFifths; omega

/-- Teorema demonstrativo: sob as premissas registradas, 308 votos em cada
turno na Câmara e 49 em cada turno no Senado bastam para aprovar a emenda.
Os votos são fatos hipotéticos; `#premises` mostra o resto. -/
theorem approved_of_tallies (p : Proposal)
    (hCamara : ∀ r, 308 ≤ yesVotes p .camara r)
    (hSenado : ∀ r, 49 ≤ yesVotes p .senado r) :
    Approved p :=
  approved_of_tallies_given Textual.par2_sufficiency Interpretive.adopt_total_membership
    Textual.camara_seat_cap Institutional.senado_seats p hCamara hSenado

end LeanDRO.Law.BR.Constitution.Art60
