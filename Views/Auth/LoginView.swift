import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var isLoading = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Iniciar Sesión")
                .font(.title)
                .bold()
            
            VStack(spacing: 15) {
                Button {
                    loginWithApple()
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Continuar con Apple")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                Button {
                    loginWithGoogle()
                } label: {
                    HStack {
                        Image(systemName: "g.circle.fill")
                        Text("Continuar con Google")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Botón temporal para desarrollo
                Button("Continuar sin cuenta (Demo)") {
                    hasCompletedOnboarding = true
                }
                .padding()
            }
            .padding(.horizontal)
        }
        .overlay {
            if isLoading {
                ProgressView()
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
        }
    }
    
    private func loginWithApple() {
        // Implementar autenticación con Apple
    }
    
    private func loginWithGoogle() {
        // Implementar autenticación con Google
    }
} 