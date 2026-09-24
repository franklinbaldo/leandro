import LeanDRO.Temporal.Version

/-!
# Fontes federais usadas pelos slices

URNs LEX conferidas contra o resolvedor do LexML em 2026-09-24. Enquanto o
Leizilla não cobrir a legislação federal, as redações vêm de transcrição
manual do portal do Planalto, declarada como `Origin.fixture`.

Estabilidade: experimental
-/

namespace LeanDRO.Law.BR

open LeanDRO.Temporal LeanDRO.Source

def cf88 : String := "urn:lex:br:federal:constituicao:1988-10-05;1988"
def lc78 : String := "urn:lex:br:federal:lei.complementar:1993-12-30;78"
def lindb : String := "urn:lex:br:federal:decreto.lei:1942-09-04;4657"

/-- Testemunha: portal do Planalto, consultado em 2026-09-24. -/
def planalto (url : String) : Witness :=
  { kind := .officialPortal, locator := url, retrievedOn := ⟨2026, 9, 24⟩ }

def fixtureOrigin : Origin :=
  .fixture "Leizilla ainda não cobre legislação federal (previsto para 2027)"

end LeanDRO.Law.BR
