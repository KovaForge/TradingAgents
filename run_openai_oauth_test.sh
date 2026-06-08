#!/usr/bin/env bash
#
# Launcher for OpenAI OAuth test in TradingAgents.
# Fetches the token from BSM at runtime so it works in any context
# (including agent tool sandboxes).
#
# Usage:
#   ./run_openai_oauth_test.sh
#

set -euo pipefail

ENV_LOCAL="/Users/mike/Projects/KovaForge/openclaw-doctor/.env.local"
BWS="/Users/mike/.hermes/profiles/aoife/bin/bws"
PROJECT_ID="1df965c2-4642-4e08-b5a9-3c1def0fce25"
TOKEN_KEY="OPENAI_OAUTH_TOKEN"

# 1. Try loading from .env.local first (preferred long-term location)
if [ -f "$ENV_LOCAL" ]; then
  OPENAI_OAUTH_TOKEN=$(grep -E '^OPENAI_OAUTH_TOKEN=' "$ENV_LOCAL" | head -1 | cut -d= -f2- | tr -d '"' | tr -d "'")
fi

# 2. If still not set, fetch from BSM
if [ -z "${OPENAI_OAUTH_TOKEN:-}" ]; then
  echo "Fetching ${TOKEN_KEY} from BSM..."
  OPENAI_OAUTH_TOKEN=$($BWS secret list "$PROJECT_ID" \
    | jq -r '.[] | select(.key=="'"$TOKEN_KEY"'") | .id' \
    | xargs -I {} $BWS secret get {} | jq -r .value)
fi

if [ -z "${OPENAI_OAUTH_TOKEN:-}" ]; then
  echo "ERROR: Could not retrieve ${TOKEN_KEY} (checked .env.local and BSM)"
  exit 1
fi

export OPENAI_OAUTH_TOKEN
export TRADINGAGENTS_LLM_PROVIDER=openai-oauth
export TRADINGAGENTS_DEEP_THINK_LLM=gpt-5.5
export TRADINGAGENTS_QUICK_THINK_LLM=gpt-5.4-mini
export TRADINGAGENTS_MAX_DEBATE_ROUNDS=1

echo "Running test with openai-oauth..."
cd "$(dirname "$0")"
source .venv/bin/activate
python test_openai_oauth.py