"""Count file tokens and enforce a supplied budget using o200k_base."""

import argparse
from pathlib import Path

import tiktoken


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", type=Path)
    parser.add_argument("--max", type=int, required=True, dest="limit")
    args = parser.parse_args()
    if args.limit < 0:
        parser.error("--max must be non-negative")
    source = args.path.read_text(encoding="utf-8")
    count = len(tiktoken.get_encoding("o200k_base").encode(source, disallowed_special=()))
    print(f"{args.path}: {count} tokens; limit {args.limit} (o200k_base)")
    return 0 if count <= args.limit else 1


if __name__ == "__main__":
    raise SystemExit(main())
