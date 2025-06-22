#!/bin/bash

# Script para executar análise Pana
# Uso: ./scripts/pana_analysis.sh

set -e

echo "📝 Executando análise Pana..."

echo "📦 Instalando dependências..."
dart pub get

echo "🔧 Ativando Pana..."
dart pub global activate pana

echo "📊 Executando análise..."
dart pub global run pana --json . > pana_report.json

if [ $? -ne 0 ]; then
    echo "❌ Análise Pana falhou!"
    exit 1
fi

echo "📈 Analisando resultado..."
if [ -f "pana_report.json" ]; then
    score=$(grep -o '"grantedPoints": *[0-9]*' pana_report.json | tail -1 | sed 's/.*: *//')
    max_score=$(grep -o '"maxPoints": *[0-9]*' pana_report.json | tail -1 | sed 's/.*: *//')
    
    if [ "$score" = "" ]; then score=0; fi
    if [ "$max_score" = "" ]; then max_score=160; fi
    
    percentage=$(awk "BEGIN {printf \"%.1f\", ($score/$max_score)*100}")
    
    echo "🎯 Pontuação Pana: $score/$max_score ($percentage%)"
    
    minimum_score=140
    if [ "$score" -lt "$minimum_score" ]; then
        echo "⚠️  Pontuação abaixo do mínimo: $score < $minimum_score"
        echo "   Verifique o relatório para melhorias necessárias"
    else
        echo "✅ Pontuação adequada: $score >= $minimum_score"
    fi
else
    echo "❌ Arquivo de relatório não encontrado!"
    exit 1
fi

echo ""
echo "📋 Resumo:"
echo "   - Análise executada: ✅"
echo "   - Pontuação: $score/$max_score ($percentage%)"
echo "   - Relatório JSON: pana_report.json"
echo ""
echo "🎉 Análise Pana concluída!"

echo ""
echo "📄 Principais seções:"
if command -v jq &> /dev/null; then
    jq -r '.report.sections[] | "  - \(.title): \(.grantedPoints)/\(.maxPoints) pontos (\(.status))"' pana_report.json
else
    echo "   (Instale jq para visualizar detalhes: brew install jq)"
fi 