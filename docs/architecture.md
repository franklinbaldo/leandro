---
type: Guia
title: Arquitetura do LeanDRO
description: Camadas da biblioteca, as quatro superfícies de auditoria e a cadeia de proveniência que toda conclusão material precisa preservar.
timestamp: 2026-09-24T18:00:00-04:00
---

# Arquitetura

## A cadeia

```text
fonte documental            Witness (Planalto, item do Leizilla)
      ↓
identidade do dispositivo   DeviceId (URN LEX + caminho LexML)
      ↓
redação e vigência          Version (texto, hash, [start, stop), Origin)
      ↓
lógica normativa/relacional Logic.* (só o necessário a cada slice)
      ↓
teoria interpretativa       leituras como Prop com nome; a adotada é axiom Interpretive
      ↓
fatos / evidência           hipóteses do teorema; nunca axioma silencioso
      ↓
teorema Lean
      ↓
auditoria de dependências   #premises thm against ledger → PremiseRecord → Version → Witness
```

Toda conclusão material precisa permitir o caminho de volta: conclusão → premissas formais → interpretação usada → dispositivo e redação → fonte. No slice do art. 60 esse caminho é mecânico: `#premises` lista os axiomas, `ledger` liga cada axioma às `Version` de onde foi extraído, e cada `Version` carrega testemunha, hash e origem.

## Quatro superfícies de auditoria, que não se confundem

| Superfície | Pergunta | Quem responde |
| --- | --- | --- |
| validade formal | a conclusão decorre das premissas declaradas? | kernel do Lean |
| adequação jurídica | as premissas representam fielmente o direito aplicável? | revisão jurídica humana |
| verdade documental | a fonte diz mesmo isso, nessa redação, nessa data? | testemunha + hash; Leizilla/CausaGanha |
| escolha interpretativa | por que esta leitura e não a rival? | leitura nomeada, estabilidade, justificativa no `ledger` |

Formulação herdada do programa de pesquisa mantido separadamente (Papers, ainda sem publicação): Lean verifica consequência sob premissas; a auditoria jurídica audita as premissas. Compilação é necessária para afirmar uma derivação formal, nunca suficiente para afirmar uma conclusão jurídica.

## Regras de projeto

1. **Lean prova consequência, não autoridade.** Nenhum texto do projeto diz "o Lean demonstrou que X é o direito".
2. **Interpretação visível.** Escolha interpretativa disputável não entra no corpo de uma `def`. Ela vira `Prop` com nome, e a adotada é afirmada por um `axiom` em `Interpretive`. A rival fica declarada (sem afirmação) para que a escolha seja contestável. No art. 60: `TotalMembershipReading` (adotada) e `PresentMembersReading` (rival).
3. **Proveniência até a conclusão.** Todo `axiom` material tem `PremiseRecord` com `sources` não vazio, exceto `Assumption`.
4. **Sem mutação silenciosa.** Mudança material de sentido gera nova declaração (`_v2`) ou novo módulo; a antiga vai para `deprecated` apontando a substituta (ADR-0004).
5. **Sem `sorry` em `main`.** `lake build --wfail` e `scripts/verify.py` reprovam.
6. **Hipótese declarada é hipótese consumida.** `#hypotheses_consumed` reprova teorema cuja prova não usa uma das hipóteses proposicionais; `scripts/verify.py` exige que todo teorema de `LeanDRO/Law/` passe por ele. Hipótese ociosa é sinal de sobreformalização (achado 0001). O teste é estrutural: acha o que sobra, não prova que o resto é indispensável.
7. **Axioma é suspeito por padrão.** Permitido, mas precisa de segmento de categoria no namespace e de registro. `#premises` reprova axioma fora do registro ou com categoria divergente.

## Como a categoria de uma premissa é lida

Pelo segmento de namespace imediatamente acima do nome: `...Art60.Textual.par2_sufficiency` é `textual`. A escolha é deliberada: a categoria aparece na saída crua de `#print axioms`, sem depender de ferramenta. Na skill `legal-argument-lean`, a categoria é lida por prefixo de nome (`STEEL_`, `art_`, `caso_`...) e por heurística. Namespace troca a heurística por regra verificável.

Categorias atuais (provisórias, ADR-0003): `Textual`, `Semantic`, `Interpretive`, `Precedent`, `Fact`, `Institutional`, `Assumption`. Axiomas do núcleo lógico (`propext`, `Quot.sound`, `Classical.choice`) saem como `builtin`.

## Lógicas: modulares, e só quando um slice pedir

Não há ontologia deôntica universal. A direção, sem compromisso de implementar:

```text
LeanDRO.Logic
├── Core          conectivos e utilidades comuns
├── Deontic       embeddings deônticos (linhagem LogiKEy)
├── Hohfeld       posições jurídicas relacionais
├── Defeasible    derrotabilidade (mapear ASPIC+/Carneades, não reinventar)
├── Temporal      invariantes de vigência entre versões
└── Competence    poder normativo e competência
```

O slice do art. 60 não precisou de nenhum: quórum é aritmética mais uma regra de suficiência. `Logic/` só nasce quando um slice real exigir.

## Árvore atual

```text
LeanDRO/
├── Temporal/Date.lean, Version.lean        data, redação, vigência
├── Source/Citation.lean, Witness.lean      URN LEX, testemunha, origem (fixture | leizilla)
├── Audit/Premise.lean, Command.lean        categorias, estabilidade, ledger, #premises
├── Audit/Consumption.lean                  #hypotheses_consumed (hipótese ociosa)
└── Law/BR/
    ├── Sources.lean                        URNs LEX federais, testemunha Planalto, origem fixture
    ├── Constitution/Art60.lean             slice: quórum de emenda
    └── LINDB/Art2.lean                     slice: repristinação (base jurídica de Temporal)
LeanDROTest/Art60.lean, LINDB.lean          #guard_msgs das dependências e do consumo + testes negativos
docs/findings/                              achados de auditoria da formalização
scripts/verify.py                           portões locais
```

## LINDB como fundamento de `Temporal`

`Temporal/` hoje só sabe comparar datas e dizer se uma redação cobre uma data. Quando uma norma entra em vigor, quando sai e se volta são perguntas que o direito positivo responde na LINDB (arts. 1º, 2º e 6º). A direção é que as regras de `Temporal` sobre transição entre versões sejam derivadas de premissas extraídas da LINDB, e não embutidas como convenção de engenharia. O primeiro passo é o slice do art. 2º, § 3º, que já rendeu o achado 0001: a primeira versão embutia uma leitura mais forte que o texto. Ele separa núcleo textual e leitura interpretativa, e é o caso-guia para a issue temporal.

## O que fica para depois

- LINDB, art. 1º (vacatio legis de 45 dias; exige aritmética de dias sobre `Date`) e art. 2º, § 1º (critérios de revogação).
- Invariantes temporais entre versões de um mesmo dispositivo (sem sobreposição, sem lacuna não declarada).
- Indexar regras por data (a regra vale *enquanto* a redação vale), em vez de só registrar a `Version` no `ledger`.
- Adaptador de importação do Leizilla (ver [ecosystem.md](ecosystem.md)).
- Fronteira de promoção de evidência do CausaGanha.
