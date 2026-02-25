#!/bin/bash

# ==================================================
# KeyVaulter DevSecOps Download & Setup Script
# Downloads tools and stores binaries in ~/develop/bin
# Temporary downloaded files stay in ~/develop/tmp
# ==================================================

set -e

BASE_DIR="$HOME/develop"
BIN_DIR="$BASE_DIR/bin"
TMP_DIR="$BASE_DIR/tmp"

mkdir -p "$BIN_DIR"
mkdir -p "$TMP_DIR"
export PATH="$BIN_DIR:$PATH"

echo "🚀 KeyVaulter DevSecOps Download & Setup"
echo "Binaries will be in: $BIN_DIR"
echo "Temporary downloads in: $TMP_DIR"

# ------------------------------
# Helper function to download binaries
# ------------------------------
download_binary() {
    local url=$1
    local name=$2
    local dest="$BIN_DIR/$name"
    echo "⬇️ Downloading $name..."
    curl -L "$url" -o "$TMP_DIR/$name"
    chmod +x "$TMP_DIR/$name"
    mv "$TMP_DIR/$name" "$dest"
    echo "✅ $name installed at $dest"
}

# ------------------------------
# kubectl
# ------------------------------
if ! command -v kubectl >/dev/null 2>&1; then
    K8S_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    download_binary "https://dl.k8s.io/release/$K8S_VERSION/bin/linux/amd64/kubectl" "kubectl"
else
    echo "✅ kubectl already installed"
fi

# ------------------------------
# Terraform
# ------------------------------
if ! command -v terraform >/dev/null 2>&1; then
    TERRAFORM_VERSION="1.7.6"
    TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    TERRAFORM_URL="https://releases.hashicorp.com/terraform/1.15.0-alpha20260218/terraform_1.15.0-alpha20260218_linux_amd64.zip"

    echo "⬇️ Downloading Terraform $TERRAFORM_VERSION..."
    curl -fSL "$TERRAFORM_URL" -o "$TMP_DIR/$TERRAFORM_ZIP"

    if unzip -t "$TMP_DIR/$TERRAFORM_ZIP" >/dev/null 2>&1; then
        unzip -o "$TMP_DIR/$TERRAFORM_ZIP" -d "$BIN_DIR"
        echo "✅ Terraform installed at $BIN_DIR/terraform"
        rm "$TMP_DIR/$TERRAFORM_ZIP"
    else
        echo "❌ Terraform zip download corrupted. Please check network or URL."
        exit 1
    fi
else
    echo "✅ Terraform already installed"
fi
# ------------------------------
# Helm
# ------------------------------
if ! command -v helm >/dev/null 2>&1; then
    HELM_VERSION="v3.17.0"
    HELM_TAR="helm-${HELM_VERSION}-linux-amd64.tar.gz"
    echo "⬇️ Downloading Helm..."
    curl -L -o "$TMP_DIR/$HELM_TAR" "https://get.helm.sh/${HELM_TAR}"
    tar -xzf "$TMP_DIR/$HELM_TAR" -C "$TMP_DIR"
    mv "$TMP_DIR/linux-amd64/helm" "$BIN_DIR/helm"
    rm -rf "$TMP_DIR/linux-amd64" "$TMP_DIR/$HELM_TAR"
    echo "✅ Helm installed at $BIN_DIR/helm"
else
    echo "✅ Helm already installed"
fi

# ------------------------------
# Semgrep
# ------------------------------
if ! command -v semgrep >/dev/null 2>&1; then
    echo "⬇️ Installing Semgrep via pip..."
    pip3 install --user semgrep
    export PATH="$HOME/.local/bin:$PATH"
    echo "✅ Semgrep installed"
else
    echo "✅ Semgrep already installed"
fi

# ------------------------------
# GitLeaks
# ------------------------------
if ! command -v gitleaks >/dev/null 2>&1; then
    download_binary "https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-linux-amd64" "gitleaks"
else
    echo "✅ GitLeaks already installed"
fi

# ------------------------------
# Summary & PATH instructions
# ------------------------------
echo ""
echo "🎉 All tools downloaded. Add this to your PATH if not already:"
echo "export PATH=\"$BIN_DIR:\$PATH\""
echo "Temporary files remain in $TMP_DIR if needed for inspection."