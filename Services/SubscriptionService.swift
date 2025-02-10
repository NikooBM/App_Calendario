import StoreKit
import Foundation

class SubscriptionService: ObservableObject {
    @Published private(set) var currentPlan: SubscriptionPlan = .free
    @Published private(set) var weeklyAISuggestionsRemaining: Int = 1
    private let storeKit = StoreKitService()
    
    enum SubscriptionPlan: String {
        case free
        case premium
        
        var aiSuggestionsLimit: Int? {
            switch self {
            case .free:
                return 1 // 1 sugerencia por semana
            case .premium:
                return nil // ilimitado
            }
        }
        
        var features: [PlanFeature] {
            switch self {
            case .free:
                return [
                    .init(name: "Calendario Básico", included: true),
                    .init(name: "Sincronización con Apple Calendar", included: true),
                    .init(name: "1 Sugerencia IA por semana", included: true),
                    .init(name: "Análisis de productividad básico", included: true),
                    .init(name: "Sugerencias IA ilimitadas", included: false),
                    .init(name: "Análisis avanzado de productividad", included: false),
                    .init(name: "Prioridad en soporte", included: false)
                ]
            case .premium:
                return [
                    .init(name: "Calendario Básico", included: true),
                    .init(name: "Sincronización con Apple Calendar", included: true),
                    .init(name: "Sugerencias IA ilimitadas", included: true),
                    .init(name: "Análisis de productividad avanzado", included: true),
                    .init(name: "Prioridad en soporte", included: true),
                    .init(name: "Widgets personalizados", included: true),
                    .init(name: "Exportación de datos", included: true)
                ]
            }
        }
    }
    
    struct PlanFeature: Identifiable {
        let id = UUID()
        let name: String
        let included: Bool
    }
    
    func checkAISuggestionAvailability() -> Bool {
        guard let limit = currentPlan.aiSuggestionsLimit else {
            return true // Plan premium: sin límite
        }
        return weeklyAISuggestionsRemaining > 0
    }
    
    func useAISuggestion() {
        if let _ = currentPlan.aiSuggestionsLimit {
            weeklyAISuggestionsRemaining -= 1
        }
    }
    
    func resetWeeklySuggestions() {
        if case .free = currentPlan {
            weeklyAISuggestionsRemaining = 1
        }
    }
    
    func upgradeToPremium() async throws {
        try await storeKit.purchaseSubscription()
        currentPlan = .premium
    }
} 