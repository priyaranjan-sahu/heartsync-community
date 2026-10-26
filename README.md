# HeartSync - Public CI/CD Runner Bridge

Automated GitHub Actions runner environment engineered to execute continuous integration testing, quality validation, and builds for the private **HeartSync** platform using GitHub's unlimited public runner compute.

---

## ⚡ How It Works

```
┌─────────────────────────────────┐           ┌────────────────────────────────────────┐
│  Private Repo (heartsync)       │           │  Public Runner (heartsync-runner)      │
│  - Proprietary source code      │           │  - Zero proprietary code stored       │
│  - Push / PR triggers webhook   │───POST───▶│  - Free unlimited GitHub runner       │
└─────────────────────────────────┘           │  - Fetches private code with PAT       │
                                              │  - Runs tests, builds, and wipes disk  │
                                              └────────────────────────────────────────┘
```

1. **Zero Code Stored**: This public repository contains **no application code**—only the workflow orchestration files.
2. **Secure Ephemeral Clone**: The runner uses an encrypted GitHub Secret (`PRIVATE_REPO_TOKEN`) to pull private code into memory/disk.
3. **Execution**: The runner executes backend unit tests, frontend builds, and Docker validation.
4. **Immediate Cleanup**: The cloned workspace is forcefully wiped (`rm -rf ./workspace`) at the end of every run to guarantee zero code leakage.

---

## 🔐 Required Secret Setup (One-Time)

To allow this public runner to pull and execute your private code:

1. **Generate a GitHub Personal Access Token (PAT)**:
   - Go to [GitHub Token Settings](https://github.com/settings/tokens?type=beta) (Fine-grained tokens recommended) or [Classic Tokens](https://github.com/settings/tokens).
   - If using **Fine-Grained PAT**:
     - **Repository access**: *Only select repositories* ➔ `priyaranjan-sahu/heartsync`.
     - **Repository permissions**: `Contents` ➔ **Read-only**.
   - If using **Classic PAT**:
     - Scopes: Select `repo` (Full control of private repositories).
   - Click **Generate token** and copy it.

2. **Add Secret to this Public Repository**:
   - In this repository, go to **Settings** ➔ **Secrets and variables** ➔ **Actions**.
   - Click **New repository secret**.
   - Name: `PRIVATE_REPO_TOKEN`.
   - Secret: Paste your token from step 1.
   - Click **Add secret**.

---

## 🚀 How to Run

### Option 1: Manual Run via GitHub UI
1. Navigate to the **Actions** tab in this repository.
2. Select **Run Private Pipeline on Public Runner**.
3. Click **Run workflow**, choose your branch (default: `main`), and toggle options (e.g., `run_tests`, `build_web`).
4. Click the green **Run workflow** button.

### Option 2: Automatic Trigger from Private Repo (Webhook)
Whenever you push code to your private `priyaranjan-sahu/heartsync` repository, it can automatically trigger this public runner via GitHub's `repository_dispatch` API.
See `.github/workflows/dispatch-public-runner.yml` in your private repository for the trigger workflow.
