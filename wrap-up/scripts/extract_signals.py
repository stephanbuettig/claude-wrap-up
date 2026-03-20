#!/usr/bin/env python3
"""
OPTIONAL CLI ACCELERATOR — extract_signals.py

This script is an OPTIONAL performance booster for CLI users.
The wrap-up skill works fully without it. Claude performs signal
extraction natively during Phase 1 CAPTURE.

This script provides automated pre-extraction from JSONL transcripts
as a convenience tool to speed up the process.

Reads a JSONL transcript file and extracts:
- Corrections (pattern: "no,", "wrong", "not like that", "instead")
- Repetitions (same instruction given twice)
- Preferences ("always", "never")
- Successes ("perfect", "exactly", "great")

Output is JSON with signals grouped by type and confidence score.
Handles both English and German patterns.

Requirements: Python 3.8+ (no additional packages needed)
"""

import json
import os
import sys
import re
from pathlib import Path
from typing import Dict, List, Any, Optional
from dataclasses import dataclass, asdict
from enum import Enum


class SignalType(Enum):
    """Types of extractable signals from conversations."""
    CORRECTION = "correction"
    REPETITION = "repetition"
    PREFERENCE = "preference"
    SUCCESS = "success"


@dataclass
class Signal:
    """A single extracted signal from the conversation."""
    type: str
    text: str
    confidence: float  # 0.0 to 1.0
    turn_number: int
    context: str = ""
    language: str = "en"  # 'en' or 'de'

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


class SignalExtractor:
    """Extracts signals from conversation transcripts."""

    # English patterns
    CORRECTION_PATTERNS_EN = [
        r'\bno[,\.]\s',
        r'\bwrong',
        r'\bnot like that',
        r'\binstead',
        r'\byou should',
        r'\bthat\'s not',
        r'\bdon\'t',
    ]

    PREFERENCE_PATTERNS_EN = [
        r'\balways\b',
        r'\bnever\b',
        r'\bprefer',
        r'\blike it when',
        r'\bdislike',
    ]

    SUCCESS_PATTERNS_EN = [
        r'\bperfect',
        r'\bexactly',
        r'\bgreat',
        r'\bexcellent',
        r'\bthat\'s it',
        r'\bprecisely',
        r'\bon point',
    ]

    # German patterns
    CORRECTION_PATTERNS_DE = [
        r'\bnein[,\.]\s',
        r'\bfalsch',
        r'\bnicht so',
        r'\bstattdessen',
        r'\bdu solltest',
        r'\bdas ist nicht',
        r'\bkeine',
    ]

    PREFERENCE_PATTERNS_DE = [
        r'\bimmer\b',
        r'\bnie\b',
        r'\bbevorzuge',
        r'\bich mag es wenn',
        r'\bmag ich nicht',
    ]

    SUCCESS_PATTERNS_DE = [
        r'\bperfekt',
        r'\bgenau',
        r'\bhervorragend',
        r'\bexakt',
        r'\bdas ist es',
        r'\bpräzise',
        r'\bauf den punkt',
    ]

    def __init__(self):
        self.signals: List[Signal] = []
        self.seen_instructions: Dict[str, int] = {}

    def detect_language(self, text: str) -> str:
        """Simple heuristic to detect English vs German."""
        german_words = [
            'der', 'die', 'das', 'und', 'ist', 'in', 'zu', 'ich',
            'du', 'mir', 'mich', 'einem', 'einer', 'einen'
        ]
        german_count = sum(1 for word in german_words if f' {word} ' in f' {text} ')
        return 'de' if german_count > 2 else 'en'

    def extract_corrections(self, text: str, turn: int, language: str) -> None:
        """Extract correction signals."""
        patterns = (self.CORRECTION_PATTERNS_DE
                   if language == 'de'
                   else self.CORRECTION_PATTERNS_EN)

        for pattern in patterns:
            matches = list(re.finditer(pattern, text, re.IGNORECASE))
            for match in matches:
                confidence = 0.8
                signal = Signal(
                    type=SignalType.CORRECTION.value,
                    text=text[:100],  # First 100 chars
                    confidence=confidence,
                    turn_number=turn,
                    context=text[max(0, match.start()-30):match.end()+30],
                    language=language
                )
                self.signals.append(signal)

    def extract_preferences(self, text: str, turn: int, language: str) -> None:
        """Extract preference signals."""
        patterns = (self.PREFERENCE_PATTERNS_DE
                   if language == 'de'
                   else self.PREFERENCE_PATTERNS_EN)

        for pattern in patterns:
            if re.search(pattern, text, re.IGNORECASE):
                confidence = 0.75
                signal = Signal(
                    type=SignalType.PREFERENCE.value,
                    text=text[:100],
                    confidence=confidence,
                    turn_number=turn,
                    context=text,
                    language=language
                )
                self.signals.append(signal)

    def extract_successes(self, text: str, turn: int, language: str) -> None:
        """Extract success/positive feedback signals."""
        patterns = (self.SUCCESS_PATTERNS_DE
                   if language == 'de'
                   else self.SUCCESS_PATTERNS_EN)

        for pattern in patterns:
            if re.search(pattern, text, re.IGNORECASE):
                confidence = 0.85
                signal = Signal(
                    type=SignalType.SUCCESS.value,
                    text=text[:100],
                    confidence=confidence,
                    turn_number=turn,
                    context=text,
                    language=language
                )
                self.signals.append(signal)

    def detect_repetitions(self, instruction: str, turn: int) -> None:
        """Detect if an instruction appears multiple times."""
        # Normalize instruction for comparison
        normalized = re.sub(r'\s+', ' ', instruction.lower().strip())

        if normalized in self.seen_instructions:
            prev_turn = self.seen_instructions[normalized]
            confidence = 0.7 if (turn - prev_turn) < 5 else 0.5
            signal = Signal(
                type=SignalType.REPETITION.value,
                text=instruction[:100],
                confidence=confidence,
                turn_number=turn,
                context=f"Previously seen at turn {prev_turn}",
                language=self.detect_language(instruction)
            )
            self.signals.append(signal)
        else:
            self.seen_instructions[normalized] = turn

    def process_transcript(self, transcript_path: str) -> List[Signal]:
        """
        Process a JSONL transcript file and extract signals.

        Expected format: JSONL with objects containing 'role' and 'content' fields.
        """
        transcript_file = Path(transcript_path)

        if not transcript_file.exists():
            raise FileNotFoundError(f"Transcript file not found: {transcript_path}")

        turn_number = 0

        try:
            with open(transcript_file, 'r', encoding='utf-8') as f:
                for line in f:
                    if not line.strip():
                        continue

                    try:
                        entry = json.loads(line)
                    except json.JSONDecodeError:
                        continue

                    turn_number += 1
                    content = entry.get('content', '')
                    role = entry.get('role', '')

                    if not content:
                        continue

                    # Detect language
                    language = self.detect_language(content)

                    # Extract signals for user messages and assistant corrections
                    if role in ('user', 'assistant'):
                        self.extract_corrections(content, turn_number, language)
                        self.extract_preferences(content, turn_number, language)
                        self.extract_successes(content, turn_number, language)

                    # Detect repetitions for user instructions
                    if role == 'user':
                        self.detect_repetitions(content, turn_number)

        except IOError as e:
            raise IOError(f"Error reading transcript file: {e}")

        return self.signals

    def group_signals(self) -> Dict[str, List[Signal]]:
        """Group signals by type."""
        grouped: Dict[str, List[Signal]] = {}

        for signal in self.signals:
            signal_type = signal.type
            if signal_type not in grouped:
                grouped[signal_type] = []
            grouped[signal_type].append(signal)

        return grouped

    def to_json(self) -> str:
        """Convert extracted signals to JSON."""
        grouped = self.group_signals()

        output = {
            "total_signals": len(self.signals),
            "by_type": {
                signal_type: [sig.to_dict() for sig in signals]
                for signal_type, signals in grouped.items()
            },
            "summary": {
                "corrections": len(grouped.get(SignalType.CORRECTION.value, [])),
                "repetitions": len(grouped.get(SignalType.REPETITION.value, [])),
                "preferences": len(grouped.get(SignalType.PREFERENCE.value, [])),
                "successes": len(grouped.get(SignalType.SUCCESS.value, [])),
            }
        }

        return json.dumps(output, indent=2, ensure_ascii=False)


def main():
    """Main entry point for the script."""
    # Get transcript path from environment or command line
    transcript_path = None

    if len(sys.argv) > 1:
        transcript_path = sys.argv[1]
    else:
        transcript_path = os.environ.get('TRANSCRIPT_PATH')

    if not transcript_path:
        print("Usage: extract_signals.py <transcript_path>", file=sys.stderr)
        print("Or set TRANSCRIPT_PATH environment variable", file=sys.stderr)
        sys.exit(1)

    try:
        extractor = SignalExtractor()
        signals = extractor.process_transcript(transcript_path)

        # Output JSON
        print(extractor.to_json())

    except FileNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
