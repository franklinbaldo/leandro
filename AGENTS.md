# AGENTS.md

Instruções para agentes e pessoas que trabalham no LeanDRO. Fonte única: não criar CLAUDE.md paralelo.

## Idioma

Documentação, commits, PRs e issues em português. Identificadores Lean em inglês (API da biblioteca); texto normativo sempre literal, em português.

## Comandos

```bash
lake build                 # biblioteca + testes de auditoria (#guard_msgs)
uv run scripts/verify.py   # todos os portões; rodar antes de todo push
```

Não há CI hospedada como caminho único. Se houver, ela chama `scripts/verify.py`.

## Regras que quebram o build ou a revisão

1. Sem `sorry`/`admit` em `main`.
2. Todo `axiom` fica sob segmento de categoria (`Textual`, `Semantic`, `Interpretive`, `Precedent`, `Fact`, `Institutional`, `Assumption`) e tem `PremiseRecord` no `ledger` do módulo.
3. Todo teorema demonstrativo tem teste `#premises ... against ledger` com `#guard_msgs`. Mudou a saída: diga na PR se a mudança de premissa é material (ADR-0004).
4. Todo `theorem` em `LeanDRO/Law/` tem `#hypotheses_consumed` com `#guard_msgs` num teste. Hipótese ociosa não se cala com `_`: ou a prova a consome, ou o teorema está afirmando mais do que as premissas (ver `docs/findings/`).
5. Fato de caso concreto é hipótese de teorema, nunca `axiom`.
6. Escolha interpretativa é `Prop` com nome, nunca embutida no corpo de uma `def`. Ela é recebida como hipótese (teoria nomeada); `axiom` interpretativo só em `Interpretive.<Tema>.V<n>`, quando se publica deliberadamente uma versão (ADR-0006).
7. Redação normativa entra como `Version` com texto literal, `textHash` (`sha256:` do UTF-8) e testemunha. Sem Leizilla, marcar `Origin.fixture`.
8. Mudança material de sentido gera declaração nova; a antiga vira `deprecated` (ADR-0004).
9. Não afirmar que compilar prova correção jurídica. Não afirmar pioneirismo (ver `docs/prior-art.md`).
10. Não construir aqui o que é de Leizilla, CausaGanha, Papers ou Skills (ADR-0001, `docs/ecosystem.md`).

## Fluxo

Commits convencionais. Depois do bootstrap, toda mudança entra por PR contra `main`, com `scripts/verify.py` verde localmente.
