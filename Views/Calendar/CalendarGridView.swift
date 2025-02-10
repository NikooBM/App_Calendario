import SwiftUI

struct CalendarGridView: View {
    let mode: CalendarMode
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            if mode == .week {
                WeekView(selectedDate: $selectedDate)
            } else {
                MonthView(selectedDate: $selectedDate)
            }
        }
    }
}

struct WeekView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            // Implementación temporal para visualización
            Text("Vista Semanal")
                .font(.title2)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<7) { day in
                    VStack {
                        Text("\(day + 1)")
                            .padding()
                        
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
    }
}

struct MonthView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            // Implementación temporal para visualización
            Text("Vista Mensual")
                .font(.title2)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<31) { day in
                    Text("\(day + 1)")
                        .padding()
                }
            }
        }
    }
} 