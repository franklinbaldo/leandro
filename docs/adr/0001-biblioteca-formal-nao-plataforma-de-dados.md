---
type: ADR
title: ADR-0001 — LeanDRO é biblioteca formal, não plataforma de dados jurídicos
date: 2026-09-24
status: Aceito
---

# ADR-0001 — LeanDRO é biblioteca formal, não plataforma de dados jurídicos

## Contexto

O ecossistema já tem dono para coleta de legislação (Leizilla), para evidência processual e jurisprudencial (CausaGanha), para pesquisa (Papers) e para workflow de agentes (Skills). Um projeto de formalização atrai funcionalidades vizinhas: crawler "só para a CF", banco próprio, busca, MCP, geração de peça.

## Decisão

O LeanDRO contém teoria formal e prova: tipos, proposições, premissas registradas, teoremas e a auditoria de dependências. Não contém crawler, OCR, parser de lei, DuckDB ou Parquet de legislação, armazenamento no Internet Archive, busca, MCP, frontend, Argdown, gerenciador de DAG, scheduler ou agente.

## Consequências

- Dado textual que falta entra como fixture declarada (`Origin.fixture`), nunca por coleta própria.
- Quando um irmão não oferece o que o LeanDRO precisa, a demanda vira issue no irmão.
- A árvore do repositório fica pequena, e isso é critério de revisão.
