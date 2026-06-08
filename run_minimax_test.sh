#!/usr/bin/env bash
#
# Fast Minimax test launcher (prevents timeout)
#

set -euo pipefail

ENV_LOCAL="/Users/mike/Projects/KovaForge/openclaw-doctor/.env.local"
BWS="/Users/mike/.hermes/profiles/aoife/bin/bws"
PROJECT_ID="1df965c2-4642-4e08-b5a9-3c1def0fce25"

# Load token from .env.local if present
if [ -f "$ENV_LOCAL" ]; then
  MINIMAX_API_KEY=$(grep -E '^MINIMAX_API_KEY=' "$ENV_LOCAL" | head -1 | cut -d= -f2- | tr -d '"' | tr -d "'")
fi

# Fallback to BSM
if [ -z "${MINIMAX_API_KEY:-}" ]; then
  echo "Fetching MINIMAX_API_KEY from BSM..."
  MINIMAX_API_KEY=$($BWS secret list "$PROJECT_ID" \
    | jq -r '.[] | select(.key=="MINIMAX_API_KEY") | .id' \
    | xargs -I {} $BWS secret get {} | jq -r .value)
fi

if [ -z "${MINIMAX_API_KEY:-}" ]; then
  echo "ERROR: Could not retrieve MINIMAX_API_KEY"
  exit 1
fi

export MINIMAX_API_KEY
export TRADINGAGENTS_LLM_PROVIDER=minimax
export TRADINGAGENTS_DEEP_THINK_LLM=minimax-text-01
export TRADINGAGENTS_QUICK_THINK_LLM=minimax-text-01
export TRADINGAGENTS_MAX_DEBATE_ROUNDS=1   # Critical: prevents timeout

echo "Running fast Minimax test..."
cd "$(dirname "$0")"
source .venv/bin/activate
python test_minimax_fast.py