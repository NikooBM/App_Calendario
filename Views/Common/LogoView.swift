import SwiftUI

struct LogoView: View {
    var size: CGFloat = 100
    var showText: Bool = true
    
    var body: some View {
        VStack(spacing: 10) {
            // Icono
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: size, height: size)
                
                Circle()
                    .stroke(Color.accentColor, lineWidth: 3)
                    .frame(width: size * 0.8, height: size * 0.8)
                
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.accentColor)
            }
            
            // Texto del logo
            if showText {
                Text("SmartCal")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
            }
        }
    }
} 