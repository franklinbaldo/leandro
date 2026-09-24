---
type: ADR
title: ADR-0003 — Derivabilidade formal e adequação jurídica são superfícies de auditoria distintas
date: 2026-09-24
status: Aceito
---

# ADR-0003 — Derivabilidade formal e adequação jurídica são superfícies de auditoria distintas

## Contexto

O programa de pesquisa em `papers` separa estrutura dialética, consequência formal e adequação jurídica das premissas: Lean verifica consequência sob premissas; a auditoria jurídica audita as premissas. A skill `legal-argument-lean` classifica axiomas por prefixo de nome, lido por heurística.

## Decisão

- Premissa material é `axiom` sob um segmento de namespace de categoria: `Textual`, `Semantic`, `Interpretive`, `Precedent`, `Fact`, `Institutional`, `Assumption`. A lista é provisória.
- Todo axioma material tem `PremiseRecord` (categoria, estabilidade, redações-fonte, justificativa) no `ledger` do módulo.
- `#premises thm against ledger` lista as dependências com categoria e estabilidade e reprova `sorryAx`, axioma fora do registro e categoria divergente. Os testes fixam essa saída com `#guard_msgs`, de modo que mudança de premissa quebra o build até ser revisada.
- Fatos de um caso concreto entram como hipóteses do teorema, não como axiomas.
- Todo teorema demonstrativo tem uma forma condicional (`..._given`), com as premissas jurídicas como hipóteses, que não depende de axioma material.
- Nenhum texto do projeto apresenta compilação como correção jurídica.

## Consequências

- A categoria aparece na saída crua de `#print axioms`.
- A classificação diverge da convenção de prefixos da skill; a extração de módulos de lá traduz prefixo → namespace.
