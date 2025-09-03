# Animação Estendida do Atrator de Lorenz

[![GitHub](https://img.shields.io/badge/GitHub-andrecamatta%2Fpq__lorenz-blue?logo=github)](https://github.com/andrecamatta/pq_lorenz)
[![Julia](https://img.shields.io/badge/Julia-1.9%2B-9558B2?logo=julia)](https://julialang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Este projeto cria uma animação cinematográfica profissional de 60 segundos do atrator de Lorenz demonstrando o caos determinístico através de duas trajetórias com condições iniciais quase idênticas.

🔗 **Repositório:** https://github.com/andrecamatta/pq_lorenz

## 🎯 Características da Animação

- **Resolução**: 1920×1080 pixels (Full HD)
- **Taxa de quadros**: 50 FPS para MP4, 30 FPS para GIF  
- **Duração**: 60 segundos (demonstração completa)
- **Duas trajetórias simultâneas** com diferença de apenas 0.000001 nas condições iniciais
- **Gradientes de cor temporais**: hot/cool schemes evoluindo ao longo do tempo
- **Movimento cinematográfico de câmera**: 540° de rotação (1.5 voltas completas)
- **Trails luminescentes**: 1000 pontos de histórico por trajetória
- **Esferas pulsantes** que intensificam com a divergência
- **Análise em tempo real** da amplificação do caos

## 🚀 Execução

```bash
julia lorenz_extended.jl
```

## 📊 Demonstração do Caos Determinístico

A animação mostra como uma diferença microscópica inicial (0.000001) se amplifica exponencialmente:

- **Divergência máxima**: 47.3133 (amplificação de **47+ milhões de vezes**)
- **Múltiplos ciclos completos** entre lóbulos do atrator
- **Transições dramáticas** demonstrando a imprevisibilidade do sistema
- **Evolução temporal completa** de 60 segundos

## 🔧 Parâmetros do Sistema

- σ = 10.0 (parâmetro de Prandtl)
- ρ = 28.0 (parâmetro de Rayleigh)  
- β = 8.0/3.0 (parâmetro geométrico)
- Condições iniciais: [0.1, 0, 0] vs [0.100001, 0, 0]
- Solver: Vern7() com alta precisão (reltol=1e-10, abstol=1e-12)

## 📦 Arquivos Gerados

> ⚠️ **Nota:** Os arquivos de vídeo não estão incluídos no repositório devido ao tamanho (>100MB). Execute o script para gerá-los localmente.

- **`lorenz_extended.mp4`** (25 MB): Vídeo cinematográfico de 60s em alta qualidade
- **`lorenz_extended.gif`** (87 MB): GIF otimizado com 1000 frames

Para gerar os arquivos de animação:
```bash
git clone https://github.com/andrecamatta/pq_lorenz.git
cd pq_lorenz
julia lorenz_extended.jl
```

## 🎬 Cronograma da Animação (60s)

- **0-15s**: Trajetórias aparentemente idênticas, divergência sutil
- **15-35s**: Divergência exponencial dramática (até 3+ milhões de vezes)
- **35-45s**: Picos de divergência máxima (47+ milhões de vezes)
- **45-60s**: Comportamentos completamente independentes

## 🎨 Efeitos Visuais Cinematográficos

- Trails que desvanecem com gradiente alpha sofisticado
- Esferas pulsantes sincronizadas com a divergência
- Grid de referência sutil com círculos nos lóbulos
- Rotação contínua da câmera com variação de elevação
- Esquemas de cores dramáticos (hot → cool)
- Fundo escuro espacial (preto → azul marinho)

## 🖥️ Requisitos

- Julia 1.9+
- Pacotes: GLMakie, DifferentialEquations, Colors, ColorSchemes, LinearAlgebra
- GPU compatível com OpenGL (recomendado)
- Pelo menos 4GB de RAM
- FFMPEG para exportação

## 🏃‍♂️ Performance

A renderização leva aproximadamente 5-10 minutos dependendo do hardware. O progresso é exibido em tempo real durante a execução.

## 📈 Análise dos Resultados

A animação demonstra perfeitamente:
- **Sensibilidade às condições iniciais**: diferença de 10⁻⁶ se torna diferença de 10¹
- **Caos determinístico**: sistema totalmente previsível matematicamente, mas imprevisível na prática
- **Amplificação exponencial**: crescimento não-linear da divergência
- **Estrutura fractal**: padrões repetitivos em escalas diferentes