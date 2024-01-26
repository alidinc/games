//
//  NavigatableTabView.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI
import Combine

private struct DidReselectTabKey: EnvironmentKey {
    static let defaultValue: AnyPublisher<Tab, Never> = Just(.games).eraseToAnyPublisher()
}

private struct CurrentTabSelection: EnvironmentKey {
    static let defaultValue: Binding<Tab> = .constant(.games)
}

private extension EnvironmentValues {
    var tabSelection: Binding<Tab> {
        get {
            return self[CurrentTabSelection.self]
        }
        set {
            self[CurrentTabSelection.self] = newValue
        }
    }

    var didReselectTab: AnyPublisher<Tab, Never> {
        get {
            return self[DidReselectTabKey.self]
        }
        set {
            self[DidReselectTabKey.self] = newValue
        }
    }
}

private struct ReselectTabViewModifier: ViewModifier {
    @Environment(\.didReselectTab) private var didReselectTab

    @State var isVisible = false
    
    let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
        
    func body(content: Content) -> some View {
        content
            .onAppear {
                self.isVisible = true
            }.onDisappear {
                self.isVisible = false
            }.onReceive(didReselectTab) { _ in
                if let action = self.action {
                    action()
                }
            }
    }
}


extension View {
    public func onReselect(perform action: (() -> Void)? = nil) -> some View {
        return self.modifier(ReselectTabViewModifier(perform: action))
    }
}

struct NavigableTabViewItem<Content: View>: View {
    @Environment(\.didReselectTab) var didReselectTab

    let tabSelection: Tab
    let imageName: String
    let content: Content
    
    init(tabSelection: Tab, imageName: String, @ViewBuilder content: () -> Content) {
        self.tabSelection = tabSelection
        self.imageName = imageName
        self.content = content()
    }

    var body: some View {
        let didReselectThisTab = didReselectTab.filter( { $0 == tabSelection }).eraseToAnyPublisher()

        NavigationStack {
            self.content
               
        }.tabItem {
            Image(systemName: imageName)
            Text(tabSelection.rawValue)
        }
        .tag(tabSelection)
        .navigationViewStyle(StackNavigationViewStyle())
     //   .keyboardShortcut(tabSelection.keyboardShortcut)
        .environment(\.didReselectTab, didReselectThisTab)
    }
}

struct NavigableTabView<Content: View>: View {
    @State private var didReselectTab = PassthroughSubject<Tab, Never>()
    @State private var _selection: Tab = .games

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        let selection = Binding(get: { self._selection },
                                set: {
                                    if self._selection == $0 {
                                        didReselectTab.send($0)
                                    }
                                    self._selection = $0
                                })

        TabView(selection: selection) {
            self.content
                .environment(\.tabSelection, selection)
                .environment(\.didReselectTab, didReselectTab.eraseToAnyPublisher())
        }
    }
}
