---
type: Guia
title: Prior art
description: Trabalhos anteriores em formalização jurídica, identidade e temporalidade de normas, lógica deôntica e argumentação, e o que o LeanDRO aproveita ou não reivindica.
timestamp: 2026-09-24T18:00:00-04:00
---

# Prior art

Levantamento inicial, feito em 2026-09-24 por busca web: toda referência abaixo tem URL consultada. Não é revisão sistemática. "Não localizado" quer dizer que a busca não achou, não que não exista.

## Posicionamento, como hipótese

Nenhum eixo isolado do LeanDRO é inédito: lógica deôntica em assistente de prova, direito em Lean 4, lei como código verificável, Hohfeld computacional, interpretação explícita em padrão de marcação e modelo temporal por dispositivo da própria CF/88 já existem. A contribuição pretendida é mais estreita e é tratada como hipótese de posicionamento, não como afirmação demonstrada: **uma biblioteca formal, temporal, provenance-aware e interpretativamente explícita do direito brasileiro em Lean 4, integrada a fontes públicas auditáveis.** Até onde verificamos, não encontramos essa combinação. Nenhuma afirmação de pioneirismo ("primeira formalização jurídica em Lean", "primeira Constituição em theorem prover") é feita aqui.

## Formalização em assistentes de prova

**Legalean** — [github.com/mehdievaltimes/legalean](https://github.com/mehdievaltimes/legalean) (MIT). Codifica trechos de lei como regras deônticas (Allowed, Prohibited, Required) e usa o kernel do Lean 4 para provar conflitos entre elas; corpus de legislação dos EUA. O próprio projeto afirma que o Lean verifica a inconsistência das regras formalizadas, nunca a fidelidade da formalização à lei. *Aproveitamos* a mesma separação entre derivação e fidelidade. *Não reivindicamos* lógica deôntica jurídica em Lean 4.

**LegalLean** — não localizado como projeto de formalização jurídica. O único resultado com esse nome é uma consultoria sem relação com o tema. Registrado porque o handoff de criação o citava; a grafia próxima de Legalean sugere confusão entre os dois.

**LogiKEy** — Benzmüller, Farjami, Fuenmayor, Meder, Parent, Steen, van der Torre, Zahoransky; [arXiv:1903.10187](https://arxiv.org/abs/1903.10187); dataset em [Data in Brief (2020)](https://www.sciencedirect.com/science/article/pii/S2352340920312919). Workbench em Isabelle/HOL que embute várias lógicas deônticas usando HOL como metalógica. *Aproveitamos* a tese de que problemas diferentes pedem lógicas diferentes, e daí `Logic/` modular sem ontologia única. *Não reivindicamos* formalização normativa verificada por máquina.

**Value-Oriented Legal Argumentation in Isabelle/HOL** — Benzmüller, Fuenmayor; ITP 2021, [LIPIcs.ITP.2021.7](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ITP.2021.7). Ponderação de valores com Nitpick e Sledgehammer. Mostra que assistentes de prova não se limitam a subproblemas matemáticos do direito.

**Direito em Lean 4, 2026** — Koomullil, análise de patentes com tipos dependentes em Lean 4, [arXiv:2604.18882](https://arxiv.org/abs/2604.18882); Heydari e Leowald, lei formalmente verificada como sinal de recompensa, estendendo Catala, [arXiv:2606.23913](https://arxiv.org/abs/2606.23913). Confirmam que "direito em Lean" não é novidade.

## Lei como código

**Catala** — Merigoux, Chataing, Protzenko; ICFP 2021, [doi:10.1145/3473582](https://dl.acm.org/doi/10.1145/3473582), [arXiv:2103.03198](https://arxiv.org/abs/2103.03198). DSL que traduz lei de natureza computacional (tributos, benefícios) em especificação executável, com exceções por defeito e fidelidade artigo por artigo. *Aproveitamos* o ideal de proximidade com o texto. *Diferença:* Catala computa resultados; o LeanDRO prova consequências sob premissas e expõe essas premissas.

## Identidade, estrutura e tempo das normas

**LexML Brasil** — [projeto.lexml.gov.br](https://projeto.lexml.gov.br/documentacao/Parte-2-LexML-URN.pdf). Define a URN LEX e o esquema XML de normas brasileiras. *Adotamos* a URN LEX como identidade (`DeviceId`); não recriamos identificador.

**Akoma Ntoso / LegalDocML** — OASIS Standard 1.0 (2018), [akn-core-v1.0](https://docs.oasis-open.org/legaldocml/akn-core/v1.0/akn-core-v1.0-part1-vocabulary.html). XML de documentos legislativos com modelo FRBR (Work/Expression) e ciclo de vida de versões. *Referência* para a distinção obra × expressão que `DeviceId` × `Version` imita. Não inventamos versionamento de normas.

**LegalRuleML Core 1.0** — OASIS Standard (2021), [spec](https://docs.oasis-open.org/legalruleml/legalruleml-core-spec/v1.0/legalruleml-core-spec-v1.0.html); interpretações alternativas em [CEUR Vol-1296](https://ceur-ws.org/Vol-1296/paper2.pdf). Marca deôntica, derrotabilidade, autoridade, jurisdição, tempo e interpretações alternativas. *A explicitude interpretativa já tem precedente em padrão.* Mapear o vocabulário de metadados antes de estender `PremiseRecord`.

**Hudson de Martim (Senado Federal)** — "Modeling the Diachronic Evolution of Legal Norms: An LRMoo-Based, Component-Level, Event-Centric Approach to Legal Knowledge Graphs", [arXiv:2506.07853](https://arxiv.org/abs/2506.07853) (v1 2025, v5 2026); na mesma linha, [arXiv:2505.00039](https://arxiv.org/abs/2505.00039) e [arXiv:2510.06002](https://arxiv.org/abs/2510.06002). Versionamento por dispositivo com eventos legislativos reificados, reconstrução do texto em qualquer data, **usando a Constituição brasileira como estudo de caso**. *É o prior art mais próximo.* O LeanDRO não reivindica modelo temporal da CF/88; deve alinhar-se a ele (Work/Expression, eventos de emenda) quando a camada temporal crescer. Diferença: lá, ontologia e grafo; aqui, teoria formal com prova e auditoria de premissas.

## Posições jurídicas e argumentação

**Hohfeld computacional** — Allen e Saxon, A-Hohfeld (1993), [repositório UMich](https://repository.law.umich.edu/cgi/viewcontent.cgi?article=1364&context=book_chapters); Sergot, "A computational theory of normative positions", ACM TOCL 2(4), 2001, [PDF](https://www.doc.ic.ac.uk/~mjs/publications/TOCLNormPos.pdf); Markovich, Studia Logica 2020, [doi:10.1007/s11225-019-09870-5](https://link.springer.com/article/10.1007/s11225-019-09870-5). `Logic/Hohfeld`, se nascer, cita essa linhagem.

**Argumentação derrotável** — Modgil e Prakken, ASPIC+ (Argument & Computation, 2014), [doi:10.1080/19462166.2013.869766](https://journals.sagepub.com/doi/10.1080/19462166.2013.869766); Gordon, Prakken e Walton, Carneades (Artificial Intelligence, 2007), [link](https://www.sciencedirect.com/science/article/pii/S0004370207000677). Se o LeanDRO modelar derrotabilidade, mapeia um desses em vez de reinventar.

## Brasil

Além do LexML e de De Martim, a busca achou sobretudo literatura teórica: Guaraty sobre linguagem jurídica e lógica deôntica ([FDRP-USP](https://www.direitorp.usp.br/wp-content/uploads/2019/06/IInovacao-Linguagem-Guaraty.pdf)); a coletânea *Direito e Inteligência Artificial* ([repositório UnB](https://repositorio.unb.br/bitstream/10482/43421/1/LIVRO_DireitoInteligenciaArtificial.pdf)). Não localizamos formalização da Constituição brasileira em Lean, Coq/Rocq ou Isabelle, o que não prova que não exista.

## Dentro do próprio ecossistema

O programa de pesquisa em `franklinbaldo/papers` (pipeline Argdown → Lean → revisão substantiva) e a skill `legal-argument-lean` já usam `#print axioms` como livro-razão de premissas. O `#premises` do LeanDRO é uma versão verificável dessa prática, não uma ideia nova.
