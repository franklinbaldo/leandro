# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Portões locais do LeanDRO: o mesmo comando antes de todo push.

Uso:  uv run scripts/verify.py          (ou: python scripts/verify.py)

Não há CI hospedada como caminho único de validação. Se um dia houver,
ela chama este script e nada além dele.

Portões, na ordem:
  1. lake build --wfail   compila biblioteca e testes; aviso reprova
                          (inclusive "declaration uses 'sorry'") e os
                          testes #guard_msgs fixam as dependências.
  2. sorry/admit          busca textual fora de comentários e strings,
                          redundante com (1) de propósito: pega o arquivo
                          que ninguém importou.
  3. imports              todo .lean de LeanDRO/ é alcançável por LeanDRO.lean.
  4. axiomas              todo `axiom` fica sob um segmento de categoria.
  5. hashes               textHash de cada fixture confere com o texto.
  6. OKF                  okf-parser check na versão fixada.
"""

from __future__ import annotations

import hashlib
import re
import shutil
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
OKF_PARSER = "okf-parser==0.45.10"
CATEGORIAS = {"Textual", "Semantic", "Interpretive", "Precedent", "Fact", "Institutional", "Assumption"}
FONTES = ["LeanDRO", "LeanDROTest"]


def arquivos_lean() -> list[Path]:
    return sorted(p for d in FONTES for p in (RAIZ / d).rglob("*.lean"))


def sem_comentarios_nem_strings(src: str) -> str:
    """Remove comentários (inclusive aninhados) e literais de string."""
    out, i, prof = [], 0, 0
    while i < len(src):
        if src.startswith("/-", i):
            prof, i = prof + 1, i + 2
        elif prof and src.startswith("-/", i):
            prof, i = prof - 1, i + 2
        elif prof:
            i += 1
        elif src.startswith("--", i):
            i = src.find("\n", i) if "\n" in src[i:] else len(src)
        elif src[i] == '"':
            j = i + 1
            while j < len(src) and src[j] != '"':
                j += 2 if src[j] == "\\" else 1
            i = j + 1
        else:
            out.append(src[i])
            i += 1
    return "".join(out)


def portao_build() -> list[str]:
    r = subprocess.run(["lake", "build", "--wfail"], cwd=RAIZ, capture_output=True, text=True)
    if r.returncode != 0:
        return ["lake build --wfail falhou:\n" + (r.stdout + r.stderr)[-4000:]]
    return []


def portao_sorry() -> list[str]:
    erros = []
    for p in arquivos_lean():
        codigo = sem_comentarios_nem_strings(p.read_text(encoding="utf-8"))
        for m in re.finditer(r"\b(sorry|admit)\b", codigo):
            erros.append(f"{p.relative_to(RAIZ)}: `{m.group(1)}` no código")
    return erros


def portao_imports() -> list[str]:
    alcancados, fila = set(), ["LeanDRO"]
    while fila:
        mod = fila.pop()
        if mod in alcancados:
            continue
        alcancados.add(mod)
        caminho = RAIZ / (mod.replace(".", "/") + ".lean")
        if caminho.exists():
            for m in re.finditer(r"^import\s+(LeanDRO\S*)", caminho.read_text(encoding="utf-8"), re.M):
                fila.append(m.group(1))
    erros = []
    for p in sorted((RAIZ / "LeanDRO").rglob("*.lean")):
        mod = ".".join(p.relative_to(RAIZ).with_suffix("").parts)
        if mod not in alcancados:
            erros.append(f"{mod}: não é importado por LeanDRO.lean")
    return erros


def portao_axiomas() -> list[str]:
    erros = []
    for p in sorted((RAIZ / "LeanDRO").rglob("*.lean")):
        codigo = sem_comentarios_nem_strings(p.read_text(encoding="utf-8"))
        for m in re.finditer(r"^\s*axiom\s+([\w.]+)", codigo, re.M):
            partes = m.group(1).split(".")
            if len(partes) < 2 or partes[-2] not in CATEGORIAS:
                erros.append(f"{p.relative_to(RAIZ)}: axioma `{m.group(1)}` sem segmento de categoria")
    return erros


def portao_hashes() -> list[str]:
    erros = []
    padrao = re.compile(r'text := "((?:[^"\\]|\\.)*)"\s*\n\s*textHash := "sha256:([0-9a-f]{64})"')
    for p in sorted((RAIZ / "LeanDRO").rglob("*.lean")):
        for m in padrao.finditer(p.read_text(encoding="utf-8")):
            texto = m.group(1).encode("utf-8").decode("unicode_escape").encode("latin-1").decode("utf-8")
            calculado = hashlib.sha256(texto.encode("utf-8")).hexdigest()
            if calculado != m.group(2):
                erros.append(f"{p.relative_to(RAIZ)}: textHash não confere com o texto ({texto[:40]}...)")
    return erros


def portao_okf() -> list[str]:
    if shutil.which("uvx") is None:
        return ["uvx não encontrado: instale uv para validar o OKF"]
    r = subprocess.run(["uvx", OKF_PARSER, "check", ".", "--normative-spec"], cwd=RAIZ, capture_output=True, text=True)
    if r.returncode != 0:
        return ["okf-parser check falhou:\n" + (r.stdout + r.stderr)[-4000:]]
    return []


PORTOES = [
    ("lake build --wfail", portao_build),
    ("sem sorry/admit", portao_sorry),
    ("imports", portao_imports),
    ("axiomas categorizados", portao_axiomas),
    ("hashes das fixtures", portao_hashes),
    ("OKF", portao_okf),
]


def main() -> int:
    falhou = False
    for nome, portao in PORTOES:
        erros = portao()
        print(f"{'ok  ' if not erros else 'FALHA'} {nome}")
        for e in erros:
            print(f"      {e}")
        falhou |= bool(erros)
    return 1 if falhou else 0


if __name__ == "__main__":
    sys.exit(main())
