/-!
# Identidade de dispositivo

A identidade normativa não é inventada aqui: ela é a URN LEX do LexML
Brasil (obra) mais o componente de dispositivo. O LeanDRO **consome** essa
identidade; quem a atribui a partir das fontes é o Leizilla.

Divergência conhecida: o Leizilla grava o caminho com hífen
(`art-60-par-2`), enquanto a URN LEX usa `art60_par2`. Este módulo adota a
grafia LexML; a tradução fica no adaptador de importação (ADR-0002), não
espalhada pelo código jurídico.

Estabilidade: experimental
-/

namespace LeanDRO.Source

/-- Dispositivo normativo identificado por URN LEX da obra e caminho LexML. -/
structure DeviceId where
  /-- URN LEX da norma, p. ex. `urn:lex:br:federal:constituicao:1988-10-05;1988`. -/
  work : String
  /-- Componente de dispositivo em sintaxe LexML, p. ex. `art60_par2`. -/
  path : String
deriving Repr, DecidableEq

/-- URN LEX completa do dispositivo (`obra!dispositivo`). -/
def DeviceId.urn (d : DeviceId) : String := d.work ++ "!" ++ d.path

end LeanDRO.Source
