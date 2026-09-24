---
type: ADR
title: ADR-0005 — Estado de pesquisa vive no OKF do Papers, não em prompts
date: 2026-09-24
status: Aceito
---

# ADR-0005 — Estado de pesquisa vive no OKF do Papers, não em prompts

## Contexto

`franklinbaldo/papers` mantém um DAG de frentes de pesquisa em OKF (`research/research-fronts.md`), com linhagem por `parents`, `children` derivados e `next_action` obrigatória em frente viva. Duplicar backlog científico aqui criaria duas verdades.

## Decisão

- Perguntas de pesquisa, estado e evidência do LeanDRO vivem como frentes no Papers.
- O LeanDRO guarda em OKF só o conhecimento de governança do próprio repositório: ADRs e guias (`docs/`), com specs em `.okf/specs/`.
- Arquivos `.lean` são a verdade formal; OKF não duplica o grafo de teoremas.
- Backlog operacional de engenharia fica em issues do GitHub.
- Estado transitório não fica escrito em prompt, README ou AGENTS.md.

## Consequências

- A frente `constitutional-formalization` é proposta ao Papers por PR, conforme as regras daquele repositório.
