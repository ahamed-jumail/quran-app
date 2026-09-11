#!/bin/bash

echo "🔍 Running flutter tests with coverage..."
flutter test --coverage --test-randomize-ordering-seed random

echo "📄 Loading coverage_exclude.json..."
EXCLUDES=$(jq -r '.global_exclude[]' coverage_exclude.json)

echo "✂️ Applying exclusions..."
ARGS=""
for EXCLUDE in $EXCLUDES; do
  ARGS="$ARGS \"$EXCLUDE\""
done

# Run LCOV remove using dynamically loaded excludes
eval "lcov --remove coverage/lcov.info $ARGS -o coverage/lcov.info"

echo "🧪 Generating HTML report..."
genhtml coverage/lcov.info -o coverage/

echo "📂 Opening coverage report..."
open coverage/index.html

echo "✔ Coverage complete with exclusions!"
