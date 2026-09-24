---
type: Spec
title: SPEC — ADR
description: Decisão arquitetural load-bearing do LeanDRO, com status de vigência em campo fechado.
timestamp: 2026-09-24T18:00:00-04:00
---

# SPEC — `ADR`

Uma decisão que sustenta o desenho e que uma próxima sessão não deve repropor sem saber que existe. Poucas: ADR cerimonial não entra.

## Nome do arquivo

`docs/adr/NNNN-slug-em-kebab.md`. O número é sequencial e nunca reaproveitado.

## Frontmatter

```yaml
---
type: ADR
title: ADR-NNNN — <título>
date: <YYYY-MM-DD>
status: <Proposto | Aceito | Substituído | Revogado>
substituido_por: ADR-NNNN   # opcional; obrigatório se status = Substituído
---
```

## Corpo

`## Contexto`, `## Decisão`, `## Consequências`. ADR aceito não é editado em substância: decisão nova gera ADR novo que substitui o anterior.
