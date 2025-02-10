import Foundation

class AnalyticsService {
    func generateWeeklyReport(events: [Event]) -> ProductivityReport {
        let totalEvents = events.count
        let completedEvents = events.filter { $0.endDate < Date() }.count
        let categories = Dictionary(grouping: events, by: { $0.category })
            .mapValues { $0.count }
        
        let timeSpentByCategory = Dictionary(grouping: events) { $0.category }
            .mapValues { events in
                events.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            }
        
        return ProductivityReport(
            period: .week,
            totalEvents: totalEvents,
            completedEvents: completedEvents,
            eventsByCategory: categories,
            timeSpentByCategory: timeSpentByCategory,
            productivityScore: calculateProductivityScore(events: events)
        )
    }
    
    private func calculateProductivityScore(events: [Event]) -> Double {
        // Implementar algoritmo de puntuación basado en múltiples factores
        return 0.85
    }
}

struct ProductivityReport {
    enum Period {
        case day, week, month
    }
    
    let period: Period
    let totalEvents: Int
    let completedEvents: Int
    let eventsByCategory: [Event.EventCategory: Int]
    let timeSpentByCategory: [Event.EventCategory: TimeInterval]
    let productivityScore: Double
} 