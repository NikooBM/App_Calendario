import SwiftUI

struct AISuggestionsView: View {
    @StateObject private var aiService = AIService()
    @State private var showingAnalysis = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Resumen de productividad
                    ProductivitySummaryCard()
                    
                    // Sugerencias de IA
                    LazyVStack(spacing: 16) {
                        ForEach(aiService.suggestions) { suggestion in
                            SuggestionCard(suggestion: suggestion)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Sugerencias IA")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: startAnalysis) {
                        Image(systemName: "wand.and.stars")
                    }
                }
            }
            .overlay {
                if aiService.isAnalyzing {
                    ProgressView("Analizando tu calendario...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private func startAnalysis() {
        Task {
            aiService.isAnalyzing = true
            do {
                aiService.suggestions = try await aiService.analyzeDailySchedule()
            } catch {
                print("Error analyzing schedule: \(error)")
            }
            aiService.isAnalyzing = false
        }
    }
}

struct ProductivitySummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resumen de Productividad")
                .font(.headline)
            
            HStack {
                ProductivityMetric(
                    value: "85%",
                    label: "Eficiencia",
                    icon: "chart.line.uptrend.xyaxis"
                )
                Divider()
                ProductivityMetric(
                    value: "6.5h",
                    label: "Tiempo Enfocado",
                    icon: "timer"
                )
                Divider()
                ProductivityMetric(
                    value: "12",
                    label: "Tareas Completadas",
                    icon: "checkmark.circle"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

struct ProductivityMetric: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
            Text(value)
                .font(.title2)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SuggestionCard: View {
    let suggestion: AISuggestion
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconForType(suggestion.type))
                    .foregroundColor(colorForType(suggestion.type))
                Text(titleForType(suggestion.type))
                    .font(.headline)
                Spacer()
                Text("\(Int(suggestion.confidence * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(suggestion.description)
                .font(.subheadline)
            
            HStack {
                Button("Aplicar") {
                    // Implementar acción
                }
                .buttonStyle(.borderedProminent)
                
                Button("Más tarde") {
                    // Implementar acción
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func iconForType(_ type: AISuggestion.SuggestionType) -> String {
        switch type {
        case .timeOptimization: return "clock.arrow.circlepath"
        case .breakSuggestion: return "cup.and.saucer.fill"
        case .focusTime: return "brain.head.profile"
        case .healthReminder: return "heart.fill"
        case .socialBalance: return "person.2.fill"
        }
    }
    
    private func colorForType(_ type: AISuggestion.SuggestionType) -> Color {
        switch type {
        case .timeOptimization: return .blue
        case .breakSuggestion: return .orange
        case .focusTime: return .purple
        case .healthReminder: return .red
        case .socialBalance: return .green
        }
    }
    
    private func titleForType(_ type: AISuggestion.SuggestionType) -> String {
        switch type {
        case .timeOptimization: return "Optimización de Tiempo"
        case .breakSuggestion: return "Sugerencia de Descanso"
        case .focusTime: return "Tiempo de Enfoque"
        case .healthReminder: return "Recordatorio de Salud"
        case .socialBalance: return "Balance Social"
        }
    }
} 