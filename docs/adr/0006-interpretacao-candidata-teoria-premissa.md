---
type: ADR
title: ADR-0006 — Interpretação sobe em três degraus - leitura candidata, teoria nomeada, premissa versionada
date: 2026-09-24
status: Aceito
---

# ADR-0006 — Interpretação sobe em três degraus: leitura candidata, teoria nomeada, premissa versionada

## Contexto

O achado 0001 teve duas partes. Na primeira, a leitura adotada para a LINDB, art. 2º, § 3º, tornava ociosa a condição do texto. Na segunda, a correção separou o núcleo textual, mas afirmou por `axiom` que "havendo disposição em contrário, a lei revogada se restaura". Isso não decorre do texto. "Salvo disposição em contrário" pode apenas retirar a vedação naquele caso; transformar a exceção em restauração positiva é leitura jurídica adicional. Um `axiom` global faz dessa leitura uma verdade da biblioteca para todo módulo que a importe.

A ADR-0004 dizia que a leitura adotada é afirmada por `axiom` em `Interpretive`. Esta ADR refina esse ponto.

## Decisão

Uma proposição interpretativa passa por três degraus, e só o último usa `axiom`:

1. **Leitura candidata.** Uma `def ... : Prop` com nome e docstring. Declarar não afirma. Leituras rivais convivem.
2. **Teoria nomeada.** Uma `structure <Tema>Theory : Prop` reúne os compromissos interpretativos que completam o núcleo textual. Teoremas que dependem dela a recebem como hipótese (`(T : RepristinationTheory)`). Assim, consequências de teorias diferentes ficam comparáveis, e o `#premises` não mostra premissa interpretativa escondida.
3. **Premissa versionada.** Só quando se publica deliberadamente uma versão da teoria jurídica: `axiom` sob `<módulo>.Interpretive.<Tema>.V<n>.<nome>`, com `PremiseRecord` (`experimental` ou `contested`), fonte e revisão que a sustentam. O axioma significa "esta teoria formal adota esta premissa", não "o dispositivo sozinho provou isso".

Premissas `Textual` continuam como `axiom` direto: elas afirmam o que o texto diz, e é isso que a auditoria jurídica confere.

## Consequências

- A LINDB, art. 2º, § 3º, já está no degrau 2: `RepristinationTheory`, sem `axiom` interpretativo vigente. O teste fixa isso: nenhuma premissa `Interpretive` não obsoleta no `ledger` do módulo.
- `kindOfName` e `scripts/verify.py` reconhecem a forma versionada (`...Interpretive.<Tema>.V<n>.nome`).
- O art. 60 ainda afirma `Interpretive.adopt_total_membership` por `axiom` direto, anterior a esta ADR. A migração (deprecar e passar ao degrau 2 ou 3) fica para a issue de revisão jurídica, sem mutação silenciosa.
- Os critérios de promoção entre degraus (quem decide, com que evidência, quando uma leitura vira `stable`) são o próximo trabalho da issue de revisão jurídica.
- A formulação obsoleta do achado 0001 continua afirmada por `axiom` `deprecated`, porque o teste de regressão depende dela.
