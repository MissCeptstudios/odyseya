#!/bin/bash
# UX Compliance Watcher for Odyseya
# Run this script to monitor ./lib for UX compliance issues with auto-fix enabled

echo "🚀 Starting UX Compliance Watcher..."
echo "📁 Monitoring: ./lib"
echo "🔧 Auto-fix: enabled"
echo ""
echo "Press Ctrl+C to stop"
echo ""

cd /workspace
python3 ux_compliance_checker.py ./lib --watch --auto-fix
