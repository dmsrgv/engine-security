#!/bin/bash

# Script para executar testes com cobertura de código
# Uso: ./scripts/test_coverage.sh

set -e

echo "🧪 Executando testes com cobertura..."

echo "🧹 Limpando arquivos de cobertura anteriores..."
rm -rf coverage/ test/coverage/ || true

echo "📦 Instalando dependências..."
flutter pub get

echo "🚀 Executando testes com cobertura..."
flutter test --coverage

if [ $? -ne 0 ]; then
    echo "❌ Testes falharam!"
    exit 1
fi

echo "📊 Verificando arquivo de cobertura..."
if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ Arquivo de cobertura não encontrado!"
    exit 1
fi

echo "📈 Gerando relatório HTML..."
if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html --quiet
    echo "✅ Relatório HTML gerado: coverage/html/index.html"
else
    echo "⚠️  genhtml não encontrado. Instale lcov: brew install lcov"
fi

echo "📊 Analisando cobertura..."
lines_found=$(grep -c "^LF:" coverage/lcov.info || echo "0")
lines_hit=$(grep "^LH:" coverage/lcov.info | cut -d: -f2 | awk '{sum+=$1} END {print sum}')
total_lines=$(grep "^LF:" coverage/lcov.info | cut -d: -f2 | awk '{sum+=$1} END {print sum}')

if [ "$lines_hit" = "" ]; then lines_hit=0; fi
if [ "$total_lines" = "" ]; then total_lines=0; fi

if [ "$total_lines" -gt 0 ]; then
    coverage_percent=$(awk "BEGIN {printf \"%.1f\", ($lines_hit/$total_lines)*100}")
else
    coverage_percent="0.0"
fi

echo "📈 Cobertura de linhas: ${lines_hit}/${total_lines} (${coverage_percent}%)"

minimum_coverage=95
if (( $(echo "$coverage_percent < $minimum_coverage" | bc -l) )); then
    echo "⚠️  Cobertura abaixo do mínimo: ${coverage_percent}% < ${minimum_coverage}%"
    echo "   Considere adicionar mais testes!"
else
    echo "✅ Cobertura adequada: ${coverage_percent}% >= ${minimum_coverage}%"
fi

echo ""
echo "📋 Resumo:"
echo "   - Testes executados: ✅"
echo "   - Linhas testadas: ${lines_hit}/${total_lines}"
echo "   - Cobertura: ${coverage_percent}%"
echo "   - Arquivo LCOV: coverage/lcov.info"
if command -v genhtml &> /dev/null; then
    echo "   - Relatório HTML: coverage/html/index.html"
fi
echo ""
echo "🎉 Análise de cobertura concluída!"

# Abrir relatório HTML se disponível
if [[ -f "coverage/html/index.html" ]]; then
  echo ""
  read -p "🌐 Deseja abrir o relatório HTML? (y/n): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v open &> /dev/null; then
      open coverage/html/index.html
    elif command -v xdg-open &> /dev/null; then
      xdg-open coverage/html/index.html
    else
      echo "🌐 Abra manualmente: coverage/html/index.html"
    fi
  fi
fi

echo ""
echo "🎉 Script de cobertura concluído!" 