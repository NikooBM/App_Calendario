import SwiftUI
import Charts

struct ProductivityInsightsView: View {
    @StateObject private var aiService = AIService()
    @State private var insights: ProductivityInsights?
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange {
        case day, week, month
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Selector de rango de tiempo
                Picker("Rango", selection: $selectedTimeRange) {
                    Text("Día").tag(TimeRange.day)
                    Text("Semana").tag(TimeRange.week)
                    Text("Mes").tag(TimeRange.month)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Gráfico de energía
                EnergyLevelChart(levels: insights?.energyLevelPrediction ?? [])
                    .frame(height: 200)
                    .padding()
                
                // Mejores momentos para diferentes actividades
                OptimalTimesCard(insights: insights)
                
                // Estadísticas de productividad
                ProductivityStatsGrid(insights: insights)
                
                // Sugerencias personalizadas
                PersonalizedTipsCard()
            }
            .padding()
        }
        .navigationTitle("Insights de Productividad")
        .task {
            do {
                insights = try await aiService.analyzeProductivityPatterns(events: [])
            } catch {
                print("Error loading insights: \(error)")
            }
        }
    }
}

struct EnergyLevelChart: View {
    let levels: [EnergyLevel]
    
    var body: some View {
        Chart(levels, id: \.time) { level in
            LineMark(
                x: .value("Hora", level.time),
                y: .value("Energía", level.level)
            )
            .foregroundStyle(Color.accentColor)
            
            AreaMark(
                x: .value("Hora", level.time),
                y: .value("Energía", level.level)
            )
            .foregroundStyle(Color.accentColor.opacity(0.1))
        }
    }
} 