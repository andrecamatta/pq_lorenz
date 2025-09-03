using GLMakie
using DifferentialEquations
using Colors
using ColorSchemes
using LinearAlgebra

println("🌀 ANIMAÇÃO ESTENDIDA DO ATRATOR DE LORENZ")
println("   Demonstração completa do caos determinístico")

# Parâmetros do sistema
const sigma = 10.0
const rho = 28.0  
const beta = 8.0/3.0

# Condições iniciais
const u0_1 = [0.1, 0.0, 0.0]
const u0_2 = [0.100001, 0.0, 0.0]

# Parâmetros da animação ESTENDIDA
const DURATION = 60.0  # 1 minuto completo para ver evolução total
const FPS = 50         # FPS otimizado
const N_FRAMES = Int(DURATION * FPS)

println("   Configuração: $(DURATION)s, $(FPS) FPS, $(N_FRAMES) frames")

# Sistema de Lorenz
function lorenz!(du, u, p, t)
    du[1] = sigma * (u[2] - u[1])
    du[2] = u[1] * (rho - u[3]) - u[2]
    du[3] = u[1] * u[2] - beta * u[3]
end

println("📊 Calculando trajetórias estendidas...")

# Resolver EDOs com alta precisão
tspan = (0.0, DURATION)
dt = DURATION / N_FRAMES

prob1 = ODEProblem(lorenz!, u0_1, tspan)
prob2 = ODEProblem(lorenz!, u0_2, tspan)

sol1 = solve(prob1, Vern7(), saveat=dt, reltol=1e-10, abstol=1e-12)
sol2 = solve(prob2, Vern7(), saveat=dt, reltol=1e-10, abstol=1e-12)

println("   $(length(sol1)) pontos calculados por trajetória")

# Verificar range completo
x_range = extrema([sol1[i][1] for i in 1:length(sol1)])
y_range = extrema([sol1[i][2] for i in 1:length(sol1)])
z_range = extrema([sol1[i][3] for i in 1:length(sol1)])
println("   Range completo - X: $(round.(x_range, digits=1)), Y: $(round.(y_range, digits=1)), Z: $(round.(z_range, digits=1))")

# Calcular estatísticas de divergência ao longo do tempo
divergences = [norm(sol1[i] - sol2[i]) for i in 1:length(sol1)]
max_div = maximum(divergences)
final_div = divergences[end]

println("   Divergência máxima durante simulação: $(round(max_div, digits=4))")
println("   Amplificação máxima: $(round(Int, max_div / 0.000001))x")

println("🎨 Criando visualização estendida...")

# Criar figura em alta resolução
GLMakie.activate!()
fig = Figure(size=(1920, 1080), backgroundcolor=:black)

# Eixo 3D principal
ax = Axis3(fig[1, 1],
           limits=(-22, 22, -28, 28, 0, 52),
           aspect=:data,
           backgroundcolor=RGBAf(0.02, 0.02, 0.12, 1),
           # Visual limpo
           xgridvisible=false, ygridvisible=false, zgridvisible=false,
           xticksvisible=false, yticksvisible=false, zticksvisible=false,
           xlabelvisible=false, ylabelvisible=false, zlabelvisible=false,
           # Posição inicial otimizada
           azimuth=0.7, elevation=0.5)

# Observables
frame = Observable(1)
pos1 = Observable(Point3f[])
pos2 = Observable(Point3f[])
col1 = Observable(RGBAf[])
col2 = Observable(RGBAf[])
current1 = Observable(Point3f(u0_1))
current2 = Observable(Point3f(u0_2))

# Grid de referência mais elegante
grid_alpha = 0.12
for x in -20:10:20
    lines!(ax, [x, x], [-25, 25], [8, 8], 
           color=RGBAf(0.3, 0.4, 0.6, grid_alpha), linewidth=0.6)
end
for y in -20:10:20
    lines!(ax, [-20, 20], [y, y], [8, 8], 
           color=RGBAf(0.3, 0.4, 0.6, grid_alpha), linewidth=0.6)
end

# Círculos de referência nos lóbulos
θ = 0:0.1:2π
for radius in [8, 12, 16]
    x_circle = radius * cos.(θ)
    y_circle = radius * sin.(θ)
    z_circle = fill(25.0, length(θ))
    lines!(ax, x_circle, y_circle, z_circle,
           color=RGBAf(0.4, 0.4, 0.7, 0.08), linewidth=0.8)
end

# Trajetórias principais
lines!(ax, pos1, color=col1, linewidth=5)
lines!(ax, pos2, color=col2, linewidth=5)

# Esferas marcadoras pulsantes
sphere_size1 = Observable(1.4)
sphere_size2 = Observable(1.4)
meshscatter!(ax, current1, markersize=sphere_size1, color=:crimson, alpha=0.9)
meshscatter!(ax, current2, markersize=sphere_size2, color=:gold, alpha=0.9)

# Função de atualização otimizada
function update!(idx)
    # História mais longa para animação estendida
    history = min(idx, 1000)  # Trail bem longo
    start = max(1, idx - history + 1)
    
    # Posições
    p1 = [Point3f(sol1[i]) for i in start:idx]
    p2 = [Point3f(sol2[i]) for i in start:idx]
    
    # Sistema de cores aprimorado
    c1 = RGBAf[]
    c2 = RGBAf[]
    
    for (i, j) in enumerate(start:idx)
        t = (j - 1) * dt
        progress = t / DURATION
        
        # Esquemas de cores mais dramáticos
        color1 = get(ColorSchemes.hot, progress)
        color2 = get(ColorSchemes.cool, progress)
        
        # Fadeout suave
        age = i / length(p1)
        alpha = age^0.5 * 0.98
        
        push!(c1, RGBAf(color1.r, color1.g, color1.b, alpha))
        push!(c2, RGBAf(color2.r, color2.g, color2.b, alpha))
    end
    
    # Atualizar visualização
    pos1[] = p1
    pos2[] = p2
    col1[] = c1
    col2[] = c2
    
    # Esferas pulsantes sincronizadas
    if idx <= length(sol1)
        current1[] = Point3f(sol1[idx])
        current2[] = Point3f(sol2[idx])
        
        # Pulsação baseada na divergência
        div = divergences[idx]
        pulse_intensity = min(div * 50, 0.6)  # Pulsa mais quando diverge mais
        
        pulse1 = 0.2 * sin(idx * 0.15) + pulse_intensity
        pulse2 = 0.2 * cos(idx * 0.15) + pulse_intensity
        
        sphere_size1[] = 1.4 + pulse1
        sphere_size2[] = 1.4 + pulse2
    end
    
    # Movimento cinematográfico estendido
    t = (idx - 1) * dt
    progress = t / DURATION
    
    # Rotação mais completa + variação de elevação mais dramática
    azimuth = 0.7 + 3 * pi * progress  # Rotação de 540° (1.5 voltas)
    elevation = 0.5 + 0.4 * sin(2 * pi * progress) + 0.2 * sin(4 * pi * progress)
    
    ax.azimuth = azimuth
    ax.elevation = elevation
end

println("🎬 Renderizando MP4 estendido...")

# Gravar MP4 com qualidade superior
record(fig, "lorenz_extended.mp4", 1:N_FRAMES; framerate=FPS) do idx
    frame[] = idx
    update!(idx)
    
    if idx % 200 == 0  # A cada 4 segundos
        prog = idx / N_FRAMES * 100
        elapsed = idx / FPS
        println("   Progresso: $(round(prog, digits=1))% ($(round(elapsed, digits=1))s)")
        
        if idx <= length(sol1)
            div = divergences[idx]
            amplif = round(Int, div / 0.000001)
            println("   Divergência: $(round(div, digits=4)) ($(amplif)x)")
        end
    end
end

println("✅ MP4: lorenz_extended.mp4")

# GIF otimizado (usando menos frames para manter tamanho razoável)
println("🌟 Renderizando GIF otimizado...")
gif_step = max(2, N_FRAMES ÷ 1000)  # Máximo 1000 frames no GIF
gif_frames = 1:gif_step:N_FRAMES
println("   Usando $(length(gif_frames)) frames para GIF")

record(fig, "lorenz_extended.gif", gif_frames; framerate=30) do idx
    frame[] = idx
    update!(idx)
end

println("✅ GIF: lorenz_extended.gif")

# Estatísticas finais detalhadas
println("\n📈 ANÁLISE COMPLETA DO CAOS:")
println("   Duração total: $(DURATION)s")
println("   Diferença inicial: 0.000001")
println("   Divergência final: $(round(final_div, digits=4))")
println("   Divergência máxima: $(round(max_div, digits=4))")
println("   Amplificação máxima: $(round(Int, max_div / 0.000001))x")

# Encontrar momentos de maior divergência
peak_indices = findall(d -> d > max_div * 0.8, divergences)
if !isempty(peak_indices)
    peak_times = [(i-1) * dt for i in peak_indices]
    println("   Picos de divergência em: $(round.(peak_times[1:min(3,end)], digits=1))s")
end

println("\n🎉 ANIMAÇÃO ESTENDIDA CONCLUÍDA!")
println("   A animação de $(DURATION)s mostra múltiplos ciclos completos")
println("   demonstrando o caos determinístico em sua totalidade!")