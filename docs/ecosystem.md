---
type: Guia
title: Ecossistema e fronteiras
description: O papel do LeanDRO entre Leizilla, CausaGanha, Papers e Skills, o que cada irmão possui, e os contratos de importação previstos.
timestamp: 2026-09-24T18:00:00-04:00
---

# Ecossistema

```text
                     papers
             pesquisa / DAG / papers
                       │
                       ▼
Leizilla ───────────► LeanDRO ◄────────── CausaGanha
legislação             │                   decisões/processos
texto/versionamento    │                   evidência pública
                       ▼
                     skills
              workflows de uso jurídico
```

```text
Leizilla    → lei
CausaGanha  → evidência jurídica observada
LeanDRO     → teoria formal + prova
Papers      → pesquisa
Skills      → uso operacional por agentes
```

A fronteira é load-bearing: nada que pertença claramente a um irmão é construído aqui.

## Leizilla — legislação

**Possui:** coleta das fontes oficiais, PDFs, OCR, parser, identidade normativa, linha do tempo de redações, armazenamento no Internet Archive.

**Princípio herdado:** dispositivo é a unidade; lei é árvore de dispositivos; dispositivo tem linha do tempo de redações. `LeanDRO.Temporal.Version` espelha o grão `lei × dispositivo × versão`.

**Contrato previsto** (lado Leizilla, público e estável): `versoes.parquet` da release imutável `leizilla-dataset-{ente}-v0-{timestamp}` e, por lei, `law.xml` validável pelo XSD v0.1. Mapeamento:

| Leizilla (`versoes`) | LeanDRO |
| --- | --- |
| `urn_lex_lei` | `DeviceId.work` |
| `dispositivo_path` (`art-60-par-2`) | `DeviceId.path` (`art60_par2`) — traduzir no adaptador |
| `em` / `ate` | `Version.start` / `Version.stop` |
| `texto` | `Version.text` |
| `hash_texto` (`sha256:` sobre texto bruto) | `Version.textHash` (mesma convenção) |
| `fontes[].ia_id` | `Witness` com `kind := .leizillaSource` |
| release + `versao_id` | `Origin.leizilla release versaoId` |

**Não depender de:** DuckDB local, layout dos itens raw (mudou duas vezes), `parsed_meta.json`, coluna `quality`.

**Estado real que condiciona o LeanDRO hoje:**

- O dataset publicado cobre só Rondônia; o federal (inclusive a CF/88) está planejado para 2027. Por isso o slice do art. 60 usa fixture declarada.
- O parser atual gera um retrato do texto compilado (uma versão por dispositivo); a linha do tempo completa existe no schema e nas fixtures de teste, não nos dados. Não contar com histórico real ainda.
- O caminho do dispositivo usa hífen (`!art-5-par-2`); a URN LEX usa `!art5_par2`. A tradução mora no adaptador, não no código jurídico.

## CausaGanha — evidência jurídica observada

**Possui:** coleta e preservação de publicações (DJEN), metadados processuais (DataJud), teor de decisões (JURIS/TJRO, STJ), o bundle OKF de contratos em `knowledge/` e as tools MCP.

**Princípio herdado:** evidências heterogêneas não se fundem. "DataJud registra X", "DJEN publicou Y" e "JURIS contém documento que afirma Z" continuam distinguíveis. O CausaGanha separa **arquivo** (o que foi preservado num snapshot), **estado** (o que a fonte oficial registra agora) e **teor** (o conteúdo efetivo do documento).

**Fronteira de promoção (a construir no LeanDRO):** texto de acórdão encontrado não vira axioma juridicamente verdadeiro. A passagem é explícita:

```text
CausaGanha: evidência (fonte, id_documento, url, natureza ∈ {arquivo, estado, teor}, consultado_em)
      ↓ promoção explícita, com revisão
LeanDRO: premissa Fact ou Precedent, com PremiseRecord apontando a evidência
```

O CausaGanha não tem noção de "promoção"; a barreira nasce aqui. Lacunas a resolver antes: não há hash por afirmação no CausaGanha (o rastro é `fonte + id_documento + url + data`), e a chave da fonte JURIS aparece como `tjro_juris` e como `juris` em contratos diferentes.

## Papers — pesquisa

Repositório privado, ainda sem publicação. Não é documentação pública do LeanDRO; quando houver conteúdo publicável, o resumo público será apontado aqui.

**Possui:** o DAG de frentes de pesquisa, os papers e o programa "raciocínio jurídico auditável" (pipeline Argdown → Lean → revisão substantiva).

O estado de pesquisa do LeanDRO vive lá, não aqui (ADR-0005). A pergunta norteadora inicial, a registrar como frente:

> Can a living constitution be represented as a temporally versioned, provenance-preserving family of formal theories such that every machine-checked constitutional conclusion exposes the textual provisions, temporal states, semantic embeddings and interpretive assumptions on which it depends?

## Skills — uso operacional

**Possui:** a skill `legal-argument-lean` (workflow Argdown → Lean → revisão → síntese, aplicado a casos concretos) e seu tooling de auditoria (`axiom_graph.py`).

```text
LeanDRO             = bibliotecas jurídicas formais reutilizáveis
legal-argument-lean = workflow que aplica essas bibliotecas a problemas concretos
```

Migração incremental, sem big-bang: módulo experimental da skill → estabilização → biblioteca no LeanDRO → a skill importa o LeanDRO. Condições observadas:

- A skill está sob licença *source-available* com uso operacional pago; o LeanDRO é MIT. Trazer módulo de lá exige relicenciamento explícito do autor, módulo a módulo.
- A skill compila com Lean 4.14 sem lakefile; o LeanDRO fixa 4.34.
- Os "tipos compartilhados" da skill (`Tipos.lean`) são redeclarados em vários módulos; só `Saidas/*`, `art_926` e `art_927` os importam de fato. Unificar é pré-requisito da extração.

## O que o LeanDRO não tem, e por quê

| Não tem | Dono |
| --- | --- |
| crawler, OCR, parser de lei, PDFs, Parquet de legislação | Leizilla |
| coleta de decisões/publicações, DuckDB de processos, MCP de consulta | CausaGanha |
| DAG de pesquisa, papers, Argdown | Papers |
| workflow de caso concreto, geração de peças, agentes | Skills (e o repositório de trabalho do usuário) |
| frontend web, scheduler, busca jurídica | nenhum irmão pediu; fora do escopo |
