---
type: ADR
title: ADR-0004 — Interpretações são versionadas e nunca reescritas em silêncio
date: 2026-09-24
status: Aceito
---

# ADR-0004 — Interpretações são versionadas e nunca reescritas em silêncio

## Contexto

Uma conclusão formal publicada depende de declarações com nome. Se o sentido de uma declaração muda sem mudar o nome, a conclusão antiga continua compilando e passa a afirmar outra coisa. A skill `legal-argument-lean` já adota a política `stable | contested | experimental | deprecated`.

## Decisão

- Mesmo vocabulário de estabilidade, no tipo `Stability` e em cada `PremiseRecord`; também no cabeçalho de cada módulo. Ele descreve a postura epistêmica do projeto, não a força vinculante da fonte.
- Mudança material (antecedente, consequente, quantificação ou leitura jurídica) gera nova declaração (`_v2`) ou novo módulo; a antiga vai para `deprecated` apontando a substituta e a fonte ou revisão que motivou a mudança.
- Escolha interpretativa é `Prop` com nome; a adotada é afirmada por `axiom` em `Interpretive`; a rival fica declarada ou descrita na justificativa.
- `main` não tem `sorry`.

## Consequências

- Alias que esconde mudança de sentido é proibido.
- Revisão de PR que altera o `#guard_msgs` de dependências precisa dizer se a mudança é material.
