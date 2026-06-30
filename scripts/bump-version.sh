#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

GITHUB_USER="iassafe"
GITHUB_REPO="iassafe-inception-of-things"
REPO_DIR="${HOME}/${GITHUB_REPO}"

echo -e "${YELLOW}Bumping playground image to v2...${NC}"

if [ -z "$GITHUB_TOKEN" ]; then
    read -sp "Paste your GitHub token: " GITHUB_TOKEN
    echo ""
fi

cd "$REPO_DIR"
sed -i 's/playground:v1/playground:v2/' p3/confs/deployment.yaml

git add p3/confs/deployment.yaml
git commit -m "Bump playground to v2"
git push "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${GITHUB_REPO}.git" main

echo -e "${GREEN}Pushed. Watching for Argo CD to pick it up...${NC}"
kubectl get pods -n dev -w &
WATCH_PID=$!
sleep 60
kill $WATCH_PID 2>/dev/null || true

echo ""
echo "Testing app response:"
curl -s http://localhost:8888/
echo ""
