# CertiEdu Digital — Blockchain con Smart Contracts

Práctica 07 · Tecnologías de Información · UNSA 2026A
Integrantes:
- Cari Lipe, Paul Andree
- Quispe Arratea, Alexandra Raquel

## Descripción
Prototipo funcional de validación de certificados digitales
usando Ethereum y Solidity. Resuelve el problema de falsificación
de certificados en CertiEdu Digital.

## Actores
| Actor | Rol |
|-------|-----|
| Emisor | Institución que registra certificados (owner del contrato) |
| Titular | Estudiante/profesional que recibe el certificado |
| Verificadora | Empresa que valida autenticidad sin intermediarios |

## Contrato desplegado
- **Red:** Remix VM (Cancun) / Sepolia Testnet
- **Dirección:** `0x...` ← pegas la dirección real después del deploy
- **Compilador:** Solidity ^0.8.0

## Estructura
certiedu-blockchain/

├── contracts/Certificados.sol

├── screenshots/

└── docs/

## Cómo probar en Remix IDE
1. Ir a https://remix.ethereum.org
2. Cargar `contracts/Certificados.sol`
3. Compilar con versión 0.8.x
4. Deploy en Remix VM (Cancun)
5. Ejecutar pruebas funcionales (ver `/screenshots`)

## Pruebas realizadas
| Función | Input | Resultado |
|---------|-------|-----------|
| `registrar()` | `"CERT-001", "Ana Torres"` |  OK |
| `verificar()` | `"CERT-001"` | `true`  |
| `revocar()` | `"CERT-001"` |  OK |
| `verificar()` post-revocación | `"CERT-001"` | `false`  |
| Código duplicado | `"CERT-001"` |  Revert esperado  |
| Acceso no autorizado | otra cuenta |  Revert esperado  |
| `registrar()` duplicado  | `"CERT-004", "otro"` | ❌ Revert: "Codigo ya registrado"        |
| `registrar()` no-owner   | cuenta distinta       | ❌ Revert: "Solo el emisor autorizado…"  |

## Tecnologías
- Solidity ^0.8.0
- Remix IDE
- Ethereum (Remix VM / Sepolia Testnet)
- MetaMask (opcional para testnet)
