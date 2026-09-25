---
type: Achado
title: Achado 0001 — LINDB repristination overformalization
date: 2026-09-24
status: Resolvido
modulo: LeanDRO.Law.BR.LINDB.Art2
detector: hipótese ociosa (condição textual não consumida pela prova)
---

# Achado 0001 — LINDB repristination overformalization

Sobreformalização da vedação da repristinação tácita: o modelo afirmava mais do que a fonte.

## O que a fonte diz

LINDB (Decreto-Lei 4.657/1942), art. 2º, § 3º, conforme o portal do Planalto consultado em 2026-09-24:

> § 3º Salvo disposição em contrário, a lei revogada não se restaura por ter a lei revogadora perdido a vigência.

O texto tem uma condição (a revogadora perdeu a vigência), um nexo causal ("por ter"), uma consequência negativa (não se restaura) e uma exceção aberta ("salvo disposição em contrário").

## O que o modelo dizia

A primeira versão (commit `11e149e`, PR #1) adotou `ExpressRestorationOnlyReading`: depois de revogada, a lei só volta a vigorar por ato expresso de restauração. O teorema demonstrativo:

```lean
theorem stays_revoked_after_revoker_lapses
    (a b : Law) (d₀ d₁ d : Date) (hRev : RevokedBy a b d₀)
    (_hLapse : LapsesAt b d₁) (hLe : d₀ ≤ d)
    (hNone : ∀ r dᵣ, ExpressRestoration r a dᵣ → d₀ ≤ dᵣ → ¬ dᵣ ≤ d) :
    ¬ InForce a d
```

compilava sem usar `_hLapse`, ou seja, sem a condição do texto. A leitura adotada era uma tese sobre qualquer restauração, não sobre a restauração causada pela perda de vigência da revogadora; e ainda fixava forma e suficiência da "disposição em contrário" (ato expresso com efeito numa data), que o texto não fixa.

## Como apareceu

A hipótese não usada foi o detector. O linter `unusedVariables` do Lean a teria apontado, mas o `_` do nome o calava, e isso foi feito de propósito, porque na época a hipótese ociosa foi lida como curiosidade e não como defeito. A revisão humana (2026-09-24) leu o mesmo sinal como falsa precisão: se a conclusão sai sem a condição que o texto põe, o modelo formalizou uma tese mais forte que o texto.

## Resolução

Nada foi apagado nem reescrito em silêncio (ADR-0004):

- **Núcleo textual:** `Textual.par3_core : ParThreeCore`. Revogada `a` por `b`, perdida a vigência de `b` e sem disposição em contrário, `a` não se restaura *por isso* (`RestoredByLapse`, que preserva o nexo causal). O teorema `not_restored_by_lapse` consome a condição e depende só dessa premissa textual.
- **Teoria interpretativa, separada e não afirmada:** `RepristinationTheory`, com o campo `contraryProvisionRestores`: havendo disposição em contrário, `a` se restaura. Os teoremas a recebem como hipótese. Ver a segunda parte, abaixo.
- **O que o texto dá sozinho:** `contrary_of_restored_by_lapse` (se a lei se restaurou pela perda de vigência, havia disposição em contrário). A volta só sai com uma teoria: `restored_by_lapse_iff_contrary (T : RepristinationTheory)`.
- **A formulação antiga** fica no código com os mesmos nomes e o mesmo sentido, marcada `deprecated` no `ledger`.
- **Detector permanente:** `#hypotheses_consumed` reprova teorema com hipótese proposicional não consumida, sem se calar com `_`. `LeanDROTest/LINDB.lean` fixa que o teorema obsoleto continua reprovando: se passar, ou o detector quebrou ou o obsoleto mudou. `scripts/verify.py` exige que todo teorema de `LeanDRO/Law/` passe pelo detector.

## Segunda parte: não corrigir exagerando para o outro lado

A primeira correção (PR #8) afirmou a regra da exceção por `axiom` (`Interpretive.contrary_provision_restores`): havendo disposição em contrário, a lei se restaura. A revisão apontou que isso também não decorre do texto. "Salvo disposição em contrário" pode apenas retirar a vedação naquele caso; restauração positiva é leitura adicional. Um `axiom` global a promovia a verdade da biblioteca.

Resolução (ADR-0006): o axioma saiu. Removê-lo não muda o sentido de nada em silêncio, porque qualquer uso quebraria a compilação. A leitura virou candidata com nome (`ContraryProvisionRestores`) e campo de uma teoria (`RepristinationTheory`), recebida como hipótese. O teste fixa que nenhuma premissa `Interpretive` vigente é afirmada no módulo.

## Lição

O kernel não decidiu o direito. Ele mostrou que o modelo estava dizendo mais do que a fonte. A hipótese ociosa é o sinal mecânico mais barato de sobreformalização: a premissa que o texto põe e a prova dispensa aponta uma escolha interpretativa embutida em outro lugar. Ela é necessária para detectar o problema, mas não suficiente para resolvê-lo: dizer qual leitura é a correta continua sendo trabalho de revisão jurídica. E a correção corre o mesmo risco do erro: ao consertar uma sobreformalização, é fácil introduzir do outro lado uma consequência interpretativa forte demais. O remédio é não afirmar a interpretação: declará-la como teoria e deixar que cada teorema diga qual teoria assume.
