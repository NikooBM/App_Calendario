import WidgetKit
import SwiftUI

struct CalendarWidget: Widget {
    private let kind = "CalendarWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarTimelineProvider()) { entry in
            CalendarWidgetView(entry: entry)
        }
        .configurationDisplayName("Calendario Inteligente")
        .description("Muestra tus próximos eventos y sugerencias.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CalendarWidgetView: View {
    let entry: CalendarTimelineEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Próximos Eventos")
                .font(.headline)
            
            ForEach(entry.events.prefix(3)) { event in
                HStack {
                    Circle()
                        .fill(categoryColor(for: event.category))
                        .frame(width: 8, height: 8)
                    
                    Text(event.title)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(event.startDate, style: .time)
                        .font(.caption)
                }
            }
        }
        .padding()
    }
    
    private func categoryColor(for category: Event.EventCategory) -> Color {
        switch category {
        case .work: return .blue
        case .personal: return .green
        case .health: return .red
        case .social: return .purple
        case .study: return .orange
        }
    }
} 