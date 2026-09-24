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
- alimentar a pesquisa em `franklinbaldo/papers`.

O que o LeanDRO **não** é: crawler, banco de legislação, sistema processual, busca jurídica, gerador de peças, gerenciador de pesquisa. Esses domínios têm dono no ecossistema; ver [docs/ecosystem.md](docs/ecosystem.md).

## Estado

Bootstrap. Dois vertical slices, pequenos de propósito: eles existem para exercitar a cadeia fonte → dispositivo → vigência → proposição → premissas → teorema → auditoria, não para "formalizar muito direito". Tudo está marcado `experimental`.

- [`Law/BR/Constitution/Art60.lean`](LeanDRO/Law/BR/Constitution/Art60.lean): quórum de aprovação de emenda (CF/88, art. 60, § 2º).
- [`Law/BR/LINDB/Art2.lean`](LeanDRO/Law/BR/LINDB/Art2.lean): vedação da repristinação tácita (LINDB, art. 2º, § 3º). A LINDB é a norma sobre vigência e revogação das normas, e por isso é a base jurídica da camada `Temporal`. Neste slice, a formalização expõe que a leitura adotada torna ociosa a condição textual "por ter a lei revogadora perdido a vigência".

A base textual dos slices é uma **fixture** transcrita do portal do Planalto, declarada como tal no tipo (`Origin.fixture`): o Leizilla ainda não cobre a legislação federal.

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

O teorema diz: **se** o § 2º diz o que `par2_sufficiency` afirma, **se** "votos dos respectivos membros" se lê como fração da composição da Casa, **se** a Câmara tem no máximo 513 cadeiras e o Senado 81, então 308 votos em cada turno na Câmara e 49 em cada turno no Senado aprovam a proposta. Cada "se" é um objeto de auditoria jurídica, com fonte registrada em `ledger`. O Lean não diz que esses "se" são verdadeiros.

## Uso

Requer [elan](https://github.com/leanprover/elan). A toolchain está fixada em `lean-toolchain` (Lean 4.34.0); não há dependências externas.

```bash
lake build                 # biblioteca + testes de auditoria
uv run scripts/verify.py   # todos os portões locais (build --wfail, sorry, imports, axiomas, hashes, OKF)
```

## Documentação

- [docs/architecture.md](docs/architecture.md) — camadas e as quatro superfícies de auditoria
- [docs/ecosystem.md](docs/ecosystem.md) — fronteiras com Leizilla, CausaGanha, Papers e Skills
- [docs/prior-art.md](docs/prior-art.md) — trabalhos anteriores e o que não reivindicamos
- [docs/adr/](docs/adr/) — decisões que sustentam o desenho

## Licença

MIT, como Leizilla e CausaGanha. Ver [LICENSE](LICENSE). Textos normativos transcritos são atos oficiais (Lei 9.610/1998, art. 8º, IV).
