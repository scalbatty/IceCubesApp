import UIKit
import SwiftUI
import DesignSystem

extension ButtonStyle where Self == StatusActionButtonStyle {
  static func statusAction(isOn: Bool = false, tintColor: Color? = nil) -> Self {
    StatusActionButtonStyle(isOn: isOn, tintColor: tintColor)
  }
}

/// A toggle button that bounces and sends particle on activation,
/// changing its foreground color to `tintColor` when toggled on
struct StatusActionButtonStyle: ButtonStyle {
  var isOn: Bool
  var tintColor: Color?

  @State var sparklesCounter: Float = 0

  private static let cellCount = 12

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(isOn ? tintColor : Color(UIColor.secondaryLabel))
      .animation(nil, value: isOn)
      .brightness(brightness(configuration: configuration))
      .animation(colorAnimation(configuration: configuration), value: isOn)
      .scaleEffect(configuration.isPressed && !isOn ? 0.6 : 1.0)
      .animation(scaleAnimation(configuration: configuration), value: isOn)
      .overlay {
        if let tint = tintColor {
          SparklesView(counter: sparklesCounter, tint: tint, size: 5, velocity: 30)
        }
      }
      .onChange(of: configuration.isPressed) { isPressed in
        guard tintColor != nil && !isPressed && !isOn else { return }

        withAnimation(.spring(response: 1, dampingFraction: 1)) {
            sparklesCounter += 1
        }
      }
  }

  func brightness(configuration: Configuration) -> Double {
    switch (configuration.isPressed, isOn) {
    case (true, true): return 0.6
    default: return 0
    }
  }

  func colorAnimation(configuration: Configuration) -> Animation? {
    if configuration.isPressed {
      return nil
    } else {
      return .default
    }
  }

  func scaleAnimation(configuration: Configuration) -> Animation? {
    switch (configuration.isPressed, isOn) {
    case (true, _): return nil
    case (false, false):
      return .default
    case (false, true):
      return .spring(response: 0.2, dampingFraction: 0.3)
    }
  }

  struct SparklesView: View, Animatable {
    var counter: Float
    var tint: Color
    var size: CGFloat = 10
    var velocity: CGFloat = 100

    var animatableData: Float {
      get { counter }
      set { counter = newValue }
    }

    struct Cell: Identifiable {
      var id: Int
      var angle: CGFloat
      var velocity: CGFloat
      var scale: CGFloat
      var alpha: CGFloat
    }
    var cells = [
      Cell(id: 0, angle: 2.35619, velocity: 0.898427, scale: 0.898427, alpha: 0.898427),
      Cell(id: 1, angle: 4.9348, velocity: 0.865051, scale: 0.865051, alpha: 0.865051),
      Cell(id: 2, angle: 1.0821, velocity: 0.889322, scale: 0.889322, alpha: 0.889322),
      Cell(id: 3, angle: 3.79424, velocity: 0.939859, scale: 0.939859, alpha: 0.939859),
      Cell(id: 4, angle: 5.39779, velocity: 0.832469, scale: 0.832469, alpha: 0.832469),
      Cell(id: 5, angle: 3.08923, velocity: 0.835527, scale: 0.835527, alpha: 0.835527),
      Cell(id: 6, angle: 0.767945, velocity: 0.918567, scale: 0.918567, alpha: 0.918567),
      Cell(id: 7, angle: 1.58825, velocity: 0.851531, scale: 0.851531, alpha: 0.851531),
      Cell(id: 8, angle: 6.02139, velocity: 0.960249, scale: 0.960249, alpha: 0.960249),
      Cell(id: 9, angle: 3.60209, velocity: 0.886542, scale: 0.886542, alpha: 0.886542),
      Cell(id: 10, angle: 1.11701, velocity: 0.819084, scale: 0.819084, alpha: 0.819084),
      Cell(id: 11, angle: 5.11178, velocity: 0.918002, scale: 0.918002, alpha: 0.918002),
    ]

    var progress: CGFloat {
      CGFloat(counter - counter.rounded(.down))
    }

    public var body: some View {
      if progress > 0.0 {
        ZStack(alignment: .center) {
          ForEach(cells) { cell in
            Circle()
              .frame(width: size, height: size)
              .foregroundColor(tint)
              .opacity(cell.alpha - (progress * cell.alpha) / 2)
              .scaleEffect(cell.scale - progress * cell.scale)
              .offset(
                x: cos(cell.angle) * progress * cell.velocity * velocity,
                y: sin(cell.angle) * progress * cell.velocity * velocity
              )
          }
        }
      }

    }
  }
}


