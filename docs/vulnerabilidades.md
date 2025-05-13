# Relatório Consolidado de Vulnerabilidades

| Ferramenta | Total Encontrado | Críticas | Altas | Médias | Baixas | Status |
|------------|-----------------|----------|-------|--------|--------|--------|
| **SonarQube SAST** | 12 | 2 | 3 | 5 | 2 | 4 corrigidas, 8 abertas |
| **npm audit** | 45 | – | 4 | 24 | 17 | 30 upgrade pendente |
| **OWASP Dependency-Check** | 28 | 1 | 6 | 12 | 9 | 8 FP*, 12 tratadas |
| **Trivy (contêiner)** | 97 | 0 | 9 | 54 | 34 | 40 mitigadas (image rebuild) |
| **OWASP ZAP (DAST)** | 6 | 0 | 2 | 4 | 0 | 2 fix in PR #42 |

> *FP = False Positive

## Destaques Críticos
1. **Prototype Pollution** em `lodash <4.17.21` – originou CVE‑2021‑23337 → atualizado em `package.json` (#37).
2. **Injeção de SQL** detectada pela regra `S5131` (SonarQube) na rota `/rest/user/login` (*knex* raw query) → patch aplicado (#38).

### Próximos Passos
- [ ] Concluir upgrade de bibliotecas vulneráveis (`express-validator`, `moment`).
- [ ] Monitorar build do contêiner Alpine Edge até libssh patch.
- [ ] Executar ZAP Full Scan mensal e registrar métricas de remediação.
