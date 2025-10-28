import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Расширенная структура загрузки

struct AncientScriptLoadingOverlay: View, ProgressDisplayable {
    let progress: Double
    @State private var angle: Double = 0
    @State private var glow: Bool = false
    var progressPercentage: Int { Int(progress * 100) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Animated gradient background (no images)
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#0B1020"),
                        Color(hex: "#0E1B2C"),
                        Color(hex: "#12233A"),
                        Color(hex: "#0B1020"),
                    ]),
                    center: .center,
                    angle: .degrees(angle)
                )
                .ignoresSafeArea()
                .animation(.linear(duration: 12).repeatForever(autoreverses: false), value: angle)
                .onAppear { angle = 360 }

                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.12),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 600
                )
                .blendMode(.overlay)
                .allowsHitTesting(false)

                VStack(spacing: 28) {
                    // Circular spinner
                    AncientScriptCircularSpinner(progress: progress)
                        .frame(width: min(geo.size.width, geo.size.height) * 0.32,
                               height: min(geo.size.width, geo.size.height) * 0.32)
                        .shadow(color: Color.white.opacity(glow ? 0.35 : 0.1), radius: glow ? 24 : 8)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: glow)
                        .onAppear { glow = true }

                    // English text only
                    VStack(spacing: 8) {
                        Text("Loading...")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)

                        Text("\(progressPercentage)%")
                            .font(.system(.title3, design: .rounded).monospacedDigit())
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 14)
                    .background(
                        Color.white.opacity(0.06)
                            .blur(radius: 0)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.35),
                                        Color.white.opacity(0.05)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1
                            )
                    )
                    .cornerRadius(14)
                }
            }
        }
    }
}

// MARK: - Фоновые представления

struct AncientScriptBackground: View, BackgroundProviding {
    func makeBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#0B0F1A"),
                Color(hex: "#0F172A"),
                Color(hex: "#111827"),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }

    var body: some View {
        makeBackground()
    }
}

// MARK: - Circular Spinner

private struct AncientScriptCircularSpinner: View {
    let progress: Double
    @State private var rotation: Double = 0
    @State private var orbitRotation: Double = 0
    @State private var pulse: Bool = false

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 10)

            // Progress ring
            Circle()
                .trim(from: 0, to: max(0.02, min(1.0, progress)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#22D3EE"),
                            Color(hex: "#6366F1"),
                            Color(hex: "#A855F7"),
                            Color(hex: "#F472B6"),
                        ]),
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color(hex: "#22D3EE").opacity(0.4), radius: 10)
                .animation(.easeInOut(duration: 0.25), value: progress)

            // Rotating highlight arc
            Circle()
                .trim(from: 0.0, to: 0.14)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
                .rotationEffect(.degrees(-90))
                .blendMode(.screen)

            // Counter-rotating dashed orbit
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 6]))
                .foregroundColor(Color.white.opacity(0.35))
                .rotationEffect(.degrees(-orbitRotation))
                .blur(radius: 0.2)

            // Pulsing core
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 22
                    )
                )
                .frame(width: 12, height: 12)
                .scaleEffect(pulse ? 1.0 : 0.85)
                .opacity(0.9)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulse)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                orbitRotation = 360
            }
            pulse = true
        }
    }
}

// MARK: - Previews

#if canImport(SwiftUI)
import SwiftUI
#endif

// Use availability to keep using the modern #Preview API on iOS 17+ and provide a fallback for older versions
@available(iOS 17.0, *)
#Preview("Vertical") {
    AncientScriptLoadingOverlay(progress: 0.2)
}

@available(iOS 17.0, *)
#Preview("Horizontal", traits: .landscapeRight) {
    AncientScriptLoadingOverlay(progress: 0.2)
}

// Fallback previews for iOS < 17
struct AncientScriptLoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AncientScriptLoadingOverlay(progress: 0.2)
                .previewDisplayName("Vertical (Legacy)")

            AncientScriptLoadingOverlay(progress: 0.2)
                .previewDisplayName("Horizontal (Legacy)")
                .previewLayout(.fixed(width: 812, height: 375)) // Simulate landscape on older previews
        }
    }
}
