import Foundation
import CoreML

class AIService: ObservableObject {
    @Published var isAnalyzing = false
    @Published var suggestions: [AISuggestion] = []
    private let openAIService = OpenAIService()
    private let subscriptionService: SubscriptionService
    
    init(subscriptionService: SubscriptionService) {
        self.subscriptionService = subscriptionService
    }
    
    func analyzeDailySchedule(events: [Event]) async throws -> [AISuggestion] {
        guard subscriptionService.checkAISuggestionAvailability() else {
            throw AIError.suggestionLimitReached
        }
        
        isAnalyzing = true
        defer { 
            isAnalyzing = false
            subscriptionService.useAISuggestion()
        }
        
        let prompt = generateAnalysisPrompt(from: events)
        let analysis = try await openAIService.getCompletion(prompt: prompt)
        return parseAISuggestions(from: analysis)
    }
    
    func analyzeProductivityPatterns(events: [Event]) async throws -> ProductivityInsights {
        let workEvents = events.filter { $0.category == .work }
        let completedTasks = workEvents.filter { $0.endDate < Date() }
        
        return ProductivityInsights(
            mostProductiveTimeOfDay: calculateMostProductiveTime(from: completedTasks),
            averageFocusTime: calculateAverageFocusTime(from: completedTasks),
            suggestedBreaks: generateBreakSuggestions(from: workEvents),
            energyLevelPrediction: predictEnergyLevels(for: Date())
        )
    }
    
    private func generateAnalysisPrompt(from events: [Event]) -> String {
        """
        Analiza el siguiente horario y proporciona sugerencias para optimizar la productividad y el bienestar:
        
        Eventos:
        \(events.map { "- \($0.title) (\($0.startDate.formatted()) - \($0.endDate.formatted()))" }.joined(separator: "\n"))
        
        Considera:
        1. Patrones de tiempo entre reuniones
        2. Balance entre trabajo y descanso
        3. Momentos óptimos para actividades de alta concentración
        4. Sugerencias para actividades físicas o pausas
        5. Optimización de horarios según el tipo de tarea
        """
    }
    
    private func predictEnergyLevels(for date: Date) -> [EnergyLevel] {
        // Implementar modelo de ML para predecir niveles de energía
        return []
    }
    
    func generateSmartReminders(for event: Event) async throws -> [Reminder] {
        // Implementar lógica de IA para generar recordatorios inteligentes
        return []
    }
    
    enum AIError: Error {
        case suggestionLimitReached
        case analysisFailure
    }
}

struct AISuggestion: Identifiable {
    let id = UUID()
    let type: SuggestionType
    let description: String
    let confidence: Double
    
    enum SuggestionType {
        case timeOptimization
        case breakSuggestion
        case focusTime
        case healthReminder
        case socialBalance
    }
}

struct ProductivityInsights {
    let mostProductiveTimeOfDay: DateInterval
    let averageFocusTime: TimeInterval
    let suggestedBreaks: [BreakSuggestion]
    let energyLevelPrediction: [EnergyLevel]
}

struct EnergyLevel {
    let time: Date
    let level: Int // 1-5
    let suggestedActivityType: ActivityType
    
    enum ActivityType {
        case highFocus
        case creative
        case routine
        case social
        case rest
    }
} 