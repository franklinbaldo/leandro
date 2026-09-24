/-!
# Datas civis

Representação mínima de data para vigência. Não valida calendário
(31 de fevereiro é representável): a validade da data é responsabilidade
de quem a fornece (Leizilla ou fixture), e o LeanDRO não reimplementa
calendário para não virar dono de um dado que não é seu.

A ordem é a lexicográfica (ano, mês, dia), calculada por uma chave
numérica. Ela só é fiel com `month < 100` e `day < 100`, o que qualquer
data real satisfaz.

Estabilidade: experimental
-/

namespace LeanDRO.Temporal

/-- Data civil (ano, mês, dia), sem fuso nem hora. -/
structure Date where
  year : Nat
  month : Nat
  day : Nat
deriving Repr, DecidableEq

namespace Date

/-- Chave ordinal `AAAAMMDD`; comparar chaves compara datas. -/
def key (d : Date) : Nat := d.year * 10000 + d.month * 100 + d.day

instance : LE Date := ⟨fun a b => a.key ≤ b.key⟩
instance : LT Date := ⟨fun a b => a.key < b.key⟩

instance (a b : Date) : Decidable (a ≤ b) := inferInstanceAs (Decidable (a.key ≤ b.key))
instance (a b : Date) : Decidable (a < b) := inferInstanceAs (Decidable (a.key < b.key))

end Date

end LeanDRO.Temporal
