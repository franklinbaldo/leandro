---
type: Spec
title: SPEC — Spec
description: Tipo das próprias especificações. A spec de um tipo vive em .okf/specs/{slug}.md, com slug derivado do nome do tipo em kebab-case.
timestamp: 2026-09-24T18:00:00-04:00
---

# SPEC — `Spec`

Um conceito deste tipo especifica um tipo OKF do LeanDRO: o que ele registra, onde mora e que campos tem. O caminho se calcula a partir do nome do tipo (`ADR` → `adr.md`, `Guia` → `guia.md`); nenhum conceito aponta para sua spec por frontmatter.

O LeanDRO usa OKF só para governança (ADR-0005). Tipo novo entra quando existir conceito real que precise dele, e antes de criá-lo verifica-se se ele não pertence ao Papers ou ao ecossistema OKF geral.
