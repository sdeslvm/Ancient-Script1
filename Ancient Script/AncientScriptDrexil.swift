import Foundation
import SwiftUI

struct AncientScriptEntryScreen: View {
    @StateObject private var loader: AncientScriptWebLoader

    init(loader: AncientScriptWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            AncientScriptWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                AncientScriptProgressIndicator(value: percent)
            case .failure(let err):
                AncientScriptErrorIndicator(err: err)  // err теперь String
            case .noConnection:
                AncientScriptOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct AncientScriptProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            AncientScriptLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct AncientScriptErrorIndicator: View {
    let err: String  // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct AncientScriptOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
