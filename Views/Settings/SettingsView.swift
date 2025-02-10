import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var subscriptionService: SubscriptionService
    
    var body: some View {
        NavigationStack {
            List {
                Section("Cuenta") {
                    NavigationLink("Perfil") {
                        Text("Perfil del Usuario")
                    }
                    
                    NavigationLink("Suscripción") {
                        SubscriptionView()
                    }
                }
                
                Section("Calendario") {
                    NavigationLink("Calendarios Conectados") {
                        Text("Gestionar Calendarios")
                    }
                    
                    NavigationLink("Notificaciones") {
                        Text("Configurar Notificaciones")
                    }
                }
                
                Section("Aplicación") {
                    NavigationLink("Tema") {
                        Text("Personalizar Tema")
                    }
                    
                    NavigationLink("Privacidad") {
                        Text("Ajustes de Privacidad")
                    }
                }
                
                Section {
                    Button("Cerrar Sesión", role: .destructive) {
                        // Implementar cierre de sesión
                    }
                }
            }
            .navigationTitle("Ajustes")
        }
    }
} 