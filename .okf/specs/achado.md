---
type: Spec
title: SPEC — Achado
description: Achado de auditoria da formalização — o ponto em que a prova mostrou que o modelo dizia mais, menos ou outra coisa que a fonte.
timestamp: 2026-09-24T21:00:00-04:00
---

# SPEC — `Achado`

O produto mais característico do LeanDRO não é o teorema: é o momento em que a verificação expõe uma decisão de modelagem que o texto jurídico não sustenta. Cada ocorrência vira um conceito deste tipo, para que o padrão seja consultável e reaproveitado como teste.

## Nome do arquivo

`docs/findings/NNNN-slug-em-kebab.md`. Número sequencial, nunca reaproveitado.

## Frontmatter

```yaml
---
type: Achado
title: Achado NNNN — <nome>
date: <YYYY-MM-DD>
status: <Aberto | Resolvido>
modulo: <módulo Lean afetado>
detector: <o que revelou: hipótese ociosa, dependência inesperada, ...>
---
```

## Corpo

`## O que a fonte diz`, `## O que o modelo dizia`, `## Como apareceu`, `## Resolução`, `## Lição`. O achado resolvido continua no acervo, e a formulação antiga continua no código como `deprecated`, com teste de regressão.
