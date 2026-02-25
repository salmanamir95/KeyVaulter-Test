#!/bin/bash

# KeyVaulter DevSecOps Preflight Checker
# Checks if all required tools are installed on Ubuntu

echo "🚀 KeyVaulter DevSecOps Environment Checker"

# List of tools to check
declare -A tools
tools=(
  ["Git"]="git --version"
  ["Docker"]="docker --version"
  ["kubectl"]="kubectl version --client --short"
  ["Helm"]="helm version --short"
  ["Terraform"]="terraform -version"
  [".NET SDK"]="dotnet --version"
  ["Node.js"]="node -v"
  ["npm"]="npm -v"
  ["Trivy"]="trivy --version"
  ["Semgrep"]="semgrep --version"
  ["Snyk"]="snyk --version"
  ["GitLeaks"]="gitleaks --version"
  ["Python3"]="python3 --version"
  ["pip3"]="pip3 --version"
)

missing=()

# Check each tool
for tool in "${!tools[@]}"; do
  if ${tools[$tool]} >/dev/null 2>&1; then
    echo "✅ $tool found"
  else
    echo "❌ $tool NOT found"
    missing+=("$tool")
  fi
done

# Summary
echo ""
if [ ${#missing[@]} -eq 0 ]; then
  echo "🎉 All required tools are installed!"
else
  echo "⚠️ Missing tools:"
  for t in "${missing[@]}"; do
    echo "   - $t"
  done
  echo "Please install the missing tools before proceeding."
fi