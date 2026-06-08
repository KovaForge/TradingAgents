#!/usr/bin/env python3
"""
Ultra-minimal Minimax test (Fundamentals only + direct decision).
Bypasses full multi-agent debate to avoid timeouts.
"""

import os
from tradingagents.graph.trading_graph import TradingAgentsGraph
from tradingagents.default_config import DEFAULT_CONFIG


def main():
    os.environ["TRADINGAGENTS_MAX_DEBATE_ROUNDS"] = "0"
    os.environ["TRADINGAGENTS_LLM_PROVIDER"] = "minimax"
    os.environ["TRADINGAGENTS_DEEP_THINK_LLM"] = "minimax-text-01"
    os.environ["TRADINGAGENTS_QUICK_THINK_LLM"] = "minimax-text-01"

    config = DEFAULT_CONFIG.copy()
    # Minimal agent set
    config["max_debate_rounds"] = 0

    ta = TradingAgentsGraph(debug=False, config=config)

    print("Ultra-minimal Minimax test (Fundamentals only)...")
    _, decision = ta.propagate("TSLA", "2025-06-09")

    print("\n=== DECISION ===")
    print(decision)


if __name__ == "__main__":
    main()