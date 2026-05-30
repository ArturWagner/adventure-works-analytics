import os
import pytest

REQUIRED_SECTIONS_README = [
    "Pré-requisitos",
    "Criar Data Sources",
    "Criar Relatório",
    "Configurar Painéis",
    "Configurar Filtros",
    "Compartilhar",
]

REQUIRED_VIEWS = [
    "vw_vendas_por_categoria",
    "vw_vendas_por_regiao",
    "vw_evolucao_vendas",
    "vw_impacto_promocoes",
]


def test_readme_exists():
    assert os.path.exists("docs/dashboards/README.md"), "README.md not found"


def test_readme_has_required_sections():
    if not os.path.exists("docs/dashboards/README.md"):
        pytest.skip("file not created yet")
    content = open("docs/dashboards/README.md").read()
    for section in REQUIRED_SECTIONS_README:
        assert section in content, f"Missing section: {section}"


def test_data_source_config_exists():
    assert os.path.exists("docs/dashboards/data-source-config.md")


def test_data_source_config_has_all_views():
    if not os.path.exists("docs/dashboards/data-source-config.md"):
        pytest.skip("file not created yet")
    content = open("docs/dashboards/data-source-config.md").read()
    for view in REQUIRED_VIEWS:
        assert view in content, f"Missing view mapping: {view}"


def test_no_credentials_in_docs():
    for path in ["docs/dashboards/README.md", "docs/dashboards/data-source-config.md"]:
        if os.path.exists(path):
            content = open(path).read().lower()
            for term in ["password", "secret", "api_key", "private_key", "token ="]:
                assert term not in content, f"Possible credential in {path}: {term}"


def test_screenshot_exists():
    """Advisory — must be captured manually after Looker Studio configuration."""
    path = "docs/dashboards/screenshot-painel-analise.png"
    if not os.path.exists(path):
        pytest.skip(
            f"Screenshot not yet captured. Follow docs/dashboards/README.md "
            f"to configure the Looker Studio report, then save the screenshot to {path}"
        )
    size = os.path.getsize(path)
    assert size > 10_000, f"Screenshot seems too small ({size} bytes) — may be invalid"
