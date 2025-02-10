import SwiftUI

struct CalendarMainView: View {
    @State private var calendarMode: CalendarMode = .week
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Selector de modo calendario
                    Picker("Modo", selection: $calendarMode) {
                        Text("Semana").tag(CalendarMode.week)
                        Text("Mes").tag(CalendarMode.month)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    // Vista del calendario
                    CalendarGridView(mode: calendarMode)
                    
                    Spacer()
                }
                
                // Botón flotante para añadir eventos
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { /* Acción para añadir evento */ }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Calendario")
        }
    }
}

enum CalendarMode {
    case week, month
} 