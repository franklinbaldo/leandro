import LeanDRO.Temporal.Date

/-!
# Testemunhas documentais e origem da representação

Duas perguntas distintas, que não se fundem:

* **Testemunha** (`Witness`): onde o texto foi visto. É evidência documental.
* **Origem** (`Origin`): de onde veio a *representação* que o LeanDRO usa —
  uma linha de dataset do Leizilla ou uma fixture transcrita à mão.

Uma fixture é declarada como fixture no próprio tipo, para que nenhuma
conclusão esconda que sua base textual ainda não passou pelo pipeline do
Leizilla.

Estabilidade: experimental
-/

namespace LeanDRO.Source

open LeanDRO.Temporal

/-- Natureza do lugar onde o texto foi visto. -/
inductive WitnessKind
  /-- Publicação oficial consultada diretamente (p. ex. portal do Planalto). -/
  | officialPortal
  /-- Item de testemunha preservado pelo Leizilla (`<fonte ia-id=...>`). -/
  | leizillaSource
deriving Repr, DecidableEq

/-- Um lugar onde o texto foi visto, e quando. -/
structure Witness where
  kind : WitnessKind
  /-- URL ou identificador estável da testemunha. -/
  locator : String
  /-- Data em que a testemunha foi consultada. -/
  retrievedOn : Date
deriving Repr

/-- De onde veio a representação textual usada pelo LeanDRO. -/
inductive Origin
  /-- Transcrição manual, pendente de substituição por dado do Leizilla. -/
  | fixture (reason : String)
  /-- Linha `versoes` de uma release imutável do Leizilla. -/
  | leizilla (release : String) (versaoId : String)
deriving Repr

/-- A representação ainda é fixture? -/
def Origin.isFixture : Origin → Bool
  | .fixture _ => true
  | .leizilla _ _ => false

end LeanDRO.Source
