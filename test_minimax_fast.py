#!/usr/bin/env python3
"""
Fast Minimax test script (single round to avoid timeouts).

Usage:
    ./run_minimax_test.sh
"""

from tradingagents.graph.trading_graph import TradingAgentsGraph
from tradingagents.default_config import DEFAULT_CONFIG
import os


def main():
    # Force ultra-fast test settings
    os.environ.setdefault("TRADINGAGENTS_MAX_DEBATE_ROUNDS", "0")
    os.environ.setdefault("TRADINGAGENTS_LLM_PROVIDER", "minimax")
    os.environ.setdefault("TRADINGAGENTS_DEEP_THINK_LLM", "minimax-text-01")
    os.environ.setdefault("TRADINGAGENTS_QUICK_THINK_LLM", "minimax-text-01")

    config = DEFAULT_CONFIG.copy()
    ta = TradingAgentsGraph(debug=False, config=config)

    print("Running fast Minimax test (0 rounds)...")
    _, decision = ta.propagate("TSLA", "2025-06-09")

    print("\n=== DECISION ===")
    print(decision)


if __name__ == "__main__":
    main()