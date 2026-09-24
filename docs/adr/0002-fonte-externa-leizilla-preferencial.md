---
type: ADR
title: ADR-0002 — Fonte normativa é externa; Leizilla é o irmão legislativo preferencial
date: 2026-09-24
status: Aceito
---

# ADR-0002 — Fonte normativa é externa; Leizilla é o irmão legislativo preferencial

## Contexto

O Leizilla modela a lei como árvore de dispositivos, cada um com linha do tempo de redações, e publica `versoes.parquet` em releases imutáveis. Em 2026-09-24 o dataset cobre só Rondônia; o federal, CF/88 inclusive, está planejado para 2027. O caminho de dispositivo do Leizilla usa hífen (`art-60-par-2`), e a URN LEX usa `art60_par2`.

## Decisão

- Identidade de dispositivo é a URN LEX (`DeviceId`), na grafia LexML.
- Redação e vigência (`Version`) espelham o grão `lei × dispositivo × versão` do Leizilla, com o mesmo `hash_texto` (`sha256:` sobre o texto bruto).
- O LeanDRO consome só a superfície pública do Leizilla (release imutável de `versoes.parquet`, `law.xml`); não depende de DuckDB local, layout raw nem `parsed_meta.json`.
- Enquanto o Leizilla não cobrir uma norma, o slice usa fixture transcrita da fonte oficial, marcada `Origin.fixture`, com hash conferido por `scripts/verify.py`.
- A tradução de caminho hífen → LexML mora num adaptador de importação, não no código jurídico.

## Consequências

- As fixtures do art. 60 e da LINDB viram testes de regressão quando o Leizilla publicar o federal.
- O adaptador é trabalho futuro (issue "fronteira de proveniência com o Leizilla").
