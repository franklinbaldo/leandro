import Lean
import LeanDRO.Temporal.Version

/-!
# Premissas materiais: categoria, estabilidade, fonte

Formalização jurídica tem premissas externas, e elas entram como `axiom`.
O LeanDRO não proíbe `axiom`: exige que todo axioma material seja
**classificável** e **registrado**.

* **Categoria** vem do segmento de namespace imediatamente acima do nome
  (`...Art60.Textual.par2_sufficiency` é `textual`). Assim a categoria
  aparece na saída crua de `#print axioms`, sem ferramenta nenhuma.
* **Registro** (`PremiseRecord`) liga o nome do axioma às redações
  (`Version`) de onde ele foi extraído e declara sua estabilidade.
  O nome é escrito com ``` ``nome ```, que o elaborador resolve: registro de
  axioma inexistente não compila.

A lista de categorias é provisória (ADR-0003). Ela deriva das camadas da
skill `legal-argument-lean` e do programa de pesquisa em `papers`, e deve
mudar se o uso mostrar que corta mal.

Estabilidade: experimental
-/

namespace LeanDRO.Audit

open LeanDRO.Temporal

/-- Categoria de premissa material. Provisória; não é ontologia jurídica. -/
inductive PremiseKind
  /-- O que o texto normativo diz, lido de perto. -/
  | textual
  /-- Significado atribuído a um termo (embedding semântico). -/
  | semantic
  /-- Escolha interpretativa entre leituras viáveis. -/
  | interpretive
  /-- Proposição atribuída a um precedente. -/
  | precedent
  /-- Fato documental ou do caso. -/
  | fact
  /-- Fato institucional (composição de órgão, estado de coisas oficial). -/
  | institutional
  /-- Suposição de trabalho, sem fonte ainda. -/
  | assumption
deriving Repr, DecidableEq

/-- Segmento de namespace que marca a categoria. -/
def PremiseKind.segment : PremiseKind → String
  | .textual => "Textual"
  | .semantic => "Semantic"
  | .interpretive => "Interpretive"
  | .precedent => "Precedent"
  | .fact => "Fact"
  | .institutional => "Institutional"
  | .assumption => "Assumption"

def PremiseKind.all : List PremiseKind :=
  [.textual, .semantic, .interpretive, .precedent, .fact, .institutional, .assumption]

/-- Postura epistêmica do projeto sobre a declaração — não a força
vinculante da fonte. Mesmo vocabulário de `legal-argument-lean`. -/
inductive Stability
  | stable
  | contested
  | experimental
  | deprecated
deriving Repr, DecidableEq

/-- Registro auditável de um axioma material. -/
structure PremiseRecord where
  name : Lean.Name
  kind : PremiseKind
  stability : Stability
  /-- Redações de onde a premissa foi extraída; vazia só para `assumption`. -/
  sources : List Version
  /-- Por que a premissa diz o que diz, em uma ou duas frases. -/
  rationale : String

/-- Categoria lida do segmento de namespace pai do nome. -/
def kindOfName (n : Lean.Name) : Option PremiseKind :=
  match n with
  | .str parent _ =>
    match parent with
    | .str _ seg => PremiseKind.all.find? (·.segment == seg)
    | _ => none
  | _ => none

end LeanDRO.Audit
