#!/usr/bin/env python3
"""
Test script for OpenAI OAuth provider in TradingAgents.

Run with:
    source .venv/bin/activate
    export TRADINGAGENTS_LLM_PROVIDER=openai-oauth
    export TRADINGAGENTS_DEEP_THINK_LLM=gpt-5.5
    export TRADINGAGENTS_QUICK_THINK_LLM=gpt-5.4-mini
    export TRADINGAGENTS_MAX_DEBATE_ROUNDS=1   # optional, for faster testing

    python test_openai_oauth.py
"""

from tradingagents.graph.trading_graph import TradingAgentsGraph
from tradingagents.default_config import DEFAULT_CONFIG


def main():
    config = DEFAULT_CONFIG.copy()
    ta = TradingAgentsGraph(debug=False, config=config)

    print("Running propagate with openai-oauth...")
    _, decision = ta.propagate("TSLA", "2026-06-09")

    print("\n=== DECISION ===")
    print(decision)


if __name__ == "__main__":
    main()