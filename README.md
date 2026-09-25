# LeanDRO

**Lean para Direito Racional e Organizado.**

LeanDRO é uma biblioteca aberta em Lean 4 para formalização auditável do direito brasileiro.

LeanDRO não trata compilação em Lean como prova automática de correção jurídica. O kernel verifica consequência formal sob premissas declaradas; fidelidade da representação, autoridade das fontes e escolhas interpretativas permanecem objetos independentes de auditoria.

## Objetivos iniciais

- representar consequências jurídicas de premissas explícitas;
- preservar proveniência, da conclusão até o dispositivo e a fonte documental;
- representar a evolução temporal das normas (redação e vigência);
- tornar visíveis as escolhas interpretativas, em vez de escondê-las em definições;
- permitir auditoria das dependências de cada conclusão (`#premises`);
- integrar-se ao [Leizilla](https://github.com/franklinbaldo/leizilla) (legislação) e ao [CausaGanha](https://github.com/franklinbaldo/causaganha) (evidência jurisprudencial e processual);
- servir de biblioteca formal para os workflows de [`franklinbaldo/skills`](https://github.com/franklinbaldo/skills), em especial `legal-argument-lean`;
- alimentar um programa de pesquisa mantido separadamente (ainda sem publicação; quando houver conteúdo publicável, o resumo público será apontado aqui).

O que o LeanDRO **não** é: crawler, banco de legislação, sistema processual, busca jurídica, gerador de peças, gerenciador de pesquisa. Esses domínios têm dono no ecossistema; ver [docs/ecosystem.md](docs/ecosystem.md).

## Estado

Bootstrap. Dois vertical slices, pequenos de propósito: eles existem para exercitar a cadeia fonte → dispositivo → vigência → proposição → premissas → teorema → auditoria, não para "formalizar muito direito". Tudo está marcado `experimental`.

- [`Law/BR/Constitution/Art60.lean`](LeanDRO/Law/BR/Constitution/Art60.lean): quórum de aprovação de emenda (CF/88, art. 60, § 2º).
- [`Law/BR/LINDB/Art2.lean`](LeanDRO/Law/BR/LINDB/Art2.lean): vedação da repristinação tácita (LINDB, art. 2º, § 3º). A LINDB é a norma sobre vigência e revogação das normas, e por isso é a base jurídica da camada `Temporal`. O slice afirma só o núcleo textual (`Textual.par3_core`). A leitura de que a "disposição em contrário" restaura a lei revogada vive numa teoria nomeada (`RepristinationTheory`), que os teoremas recebem como hipótese; nenhum `axiom` a afirma (ADR-0006).

A base textual dos slices é uma **fixture** transcrita do portal do Planalto, declarada como tal no tipo (`Origin.fixture`): o Leizilla ainda não cobre a legislação federal.

## Primeiro achado: a formalização dizia mais do que a fonte

Na primeira versão do slice da LINDB, o teorema concluía que a lei revogada continuava fora de vigor **sem usar** a hipótese de a revogadora ter perdido a vigência — que é justamente a condição do § 3º. A leitura adotada era mais forte que o texto. O kernel não decidiu o direito: mostrou que o modelo afirmava mais do que a fonte. Ver [achado 0001](docs/findings/0001-lindb-repristination-overformalization.md).

Desde então, `#hypotheses_consumed` reprova teorema com hipótese que a prova não consome, e `scripts/verify.py` exige que todo teorema de `LeanDRO/Law/` passe por ele.

## O que o Lean prova aqui, e o que não prova

```text
$ lake build        # LeanDROTest/Art60.lean fixa esta saída com #guard_msgs

LeanDRO.Law.BR.Constitution.Art60.approved_of_tallies depende de:
[institutional/experimental] ...Art60.Institutional.senado_seats
[interpretive/experimental]  ...Art60.Interpretive.adopt_total_membership
[textual/experimental]       ...Art60.Textual.camara_seat_cap
[textual/experimental]       ...Art60.Textual.par2_sufficiency
[builtin] Quot.sound
[builtin] propext
```

O teorema diz: **se** o § 2º diz o que `par2_sufficiency` afirma, **se** "votos dos respectivos membros" se lê como fração da composição da Casa, **se** a Câmara tem no máximo 513 cadeiras (a LC 78/1993 fixa um teto, não um número exato, e 308 votos bastam para qualquer composição até esse teto) e o Senado 81, então 308 votos em cada turno na Câmara e 49 em cada turno no Senado aprovam a proposta. Cada "se" é um objeto de auditoria jurídica, com fonte registrada em `ledger`. O Lean não diz que esses "se" são verdadeiros.

## Uso

Requer [elan](https://github.com/leanprover/elan). A toolchain está fixada em `lean-toolchain` (Lean 4.34.0); não há dependências externas.

```bash
lake build                 # biblioteca + testes de auditoria
uv run scripts/verify.py   # todos os portões locais (build --wfail, sorry, imports, axiomas, hashes, consumo de hipóteses, OKF)
```

## Documentação

- [docs/architecture.md](docs/architecture.md) — camadas e as quatro superfícies de auditoria
- [docs/ecosystem.md](docs/ecosystem.md) — fronteiras com Leizilla, CausaGanha, Papers e Skills
- [docs/prior-art.md](docs/prior-art.md) — trabalhos anteriores e o que não reivindicamos
- [docs/findings/](docs/findings/) — achados de auditoria da formalização
- [docs/adr/](docs/adr/) — decisões que sustentam o desenho (ADR-0006: leitura candidata → teoria nomeada → premissa versionada)

## Licença

MIT, como Leizilla e CausaGanha. Ver [LICENSE](LICENSE). Textos normativos transcritos são atos oficiais (Lei 9.610/1998, art. 8º, IV).
