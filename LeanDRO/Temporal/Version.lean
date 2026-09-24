import LeanDRO.Temporal.Date
import LeanDRO.Source.Citation
import LeanDRO.Source.Witness

/-!
# Redação de dispositivo e vigência

Espelha o grão `lei × dispositivo × versão` do Leizilla: um dispositivo tem
uma linha do tempo de redações, e cada redação vale num intervalo
semiaberto `[start, stop)`. `stop = none` significa vigente sem termo
conhecido.

`textHash` segue a convenção do Leizilla (`"sha256:" ++ hex`, calculado
sobre o texto UTF-8 **não normalizado**), para que a mesma redação tenha o
mesmo hash dos dois lados da fronteira.

Estabilidade: experimental
-/

namespace LeanDRO.Temporal

open LeanDRO.Source

/-- O termo final, se houver, ainda não chegou em `d`. -/
def BeforeStop : Option Date → Date → Prop
  | none, _ => True
  | some e, d => d < e

instance : (s : Option Date) → (d : Date) → Decidable (BeforeStop s d)
  | none, _ => isTrue trivial
  | some e, d => inferInstanceAs (Decidable (d < e))

/-- Uma redação de um dispositivo, com proveniência. -/
structure Version where
  device : DeviceId
  /-- Texto da redação, literal. -/
  text : String
  /-- `sha256:<hex>` do texto UTF-8, convenção do Leizilla. -/
  textHash : String
  start : Date
  stop : Option Date
  witnesses : List Witness
  origin : Origin
deriving Repr

/-- A redação está em vigor na data `d`. -/
def Version.InForceAt (v : Version) (d : Date) : Prop :=
  v.start ≤ d ∧ BeforeStop v.stop d

instance (v : Version) (d : Date) : Decidable (v.InForceAt d) :=
  inferInstanceAs (Decidable (_ ∧ _))

end LeanDRO.Temporal
