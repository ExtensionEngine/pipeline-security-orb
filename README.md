# Security Orb [![CircleCI Build Status](https://circleci.com/gh/ExtensionEngine/pipeline-security-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/ExtensionEngine/pipeline-security-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/studion/security.svg)](https://circleci.com/developer/orbs/orb/studion/security) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/ExtensionEngine/pipeline-security-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

An orb to facilitate security work within Studion CircleCI pipelines. Inspired by [ASH](https://github.com/awslabs/automated-security-helper).\
\
Key features:

- Audit dependencies for vulnerabilities, supports npm or pnpm
- The default value of the package manager is picked from the environment
- Detect secret leaks on the changeset or target a directory
- Run a diff-aware static analysis tool to detect vulnerabilities
- Opt for a full scan of the codebase when needed
- Scan Dockerfiles for configuration issues
- Check Docker images for vulnerabilities and secrets
- Generate Software Bill of Materials (SBOM) from Docker images

### Scanner summary

- General
  - Scan code for vulnerabilities (SAST) - [Semgrep](https://github.com/semgrep/semgrep)
  - Scan code for hard-coded secrets - [Gitlekas](https://github.com/gitleaks/gitleaks)
- JavaScript, Typescript
  - Scan dependencies for vulnerabilities
    - [npm-audit](https://docs.npmjs.com/cli/commands/npm-audit)
    - [pnpm-audit](https://pnpm.io/cli/audit)
- Docker
  - Scan Dockerfiles for misconfigurations - [Trivy](https://github.com/aquasecurity/trivy)
  - Scan Docker images for hard-coded secrets - [Trivy](https://github.com/aquasecurity/trivy)
  - Scan Docker images for vulnerabilities - [Grype](https://github.com/anchore/grype)
  - Generate Software Bill of Materials (SBOM) from Docker images - [Syft](https://github.com/anchore/syft)

## Usage

See [the official registry page](https://circleci.com/developer/orbs/orb/studion/security) of this orb for guidelines and examples.
