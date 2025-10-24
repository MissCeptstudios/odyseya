#!/bin/bash
# Odyseya Compliance Agent Runner

echo "🏜️ Odyseya Compliance Agent"
echo "============================"
echo ""

python3 odyseya_compliance_agent.py "$@"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ No violations found!"
else
    echo "⚠️  Violations found - check: reports/Odyseya_Compliance_Report.md"
fi

exit $EXIT_CODE
