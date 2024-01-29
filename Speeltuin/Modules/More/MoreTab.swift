//
//  SettingsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct MoreTab: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("viewType") var viewType: ViewType = .list
    @AppStorage("selectedIcon") var selectedAppIcon: DeviceAppIcon = .system
    @AppStorage("colorScheme") var scheme: SchemeType = .system
    @Environment(\.openURL) var openURL

    @State var showMailApp = false
    @State var showAbout = false
    @State var showIcons = false
    @State var showSendEmail = false
    @State var showAppStore = false
    @State var showStyleSelections = false
    @State var showColorSchemeSelections = false
    @State var showAlertNoDefaulEmailFound = false
    @State var email = SupportEmail(toAddress: "alidinc.uk@outlook.com",
                                    subject: "Support Email",
                                    messageHeader: "Please describe your issue below.")
    
    var body: some View {
        NavigationStack {
            Form {
                SettingsSection
                FeedbackSection
                AboutSection
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .background(.gray.opacity(0.15))
            .confirmationDialog("Rate us", isPresented: $showAppStore, titleVisibility: .visible, actions: {
                Button {
                    self.rateApp()
                } label: {
                    Text("Go to AppStore")
                }
            })
            .confirmationDialog("Send an email", isPresented: $showSendEmail, titleVisibility: .visible, actions: {
                Button {
                    self.email.send(openURL: self.openURL) { didSend in
                        showAlertNoDefaulEmailFound = !didSend
                    }
                } label: {
                    Text("Default email app")
                }
                
                if MailView.canSendMail {
                    Button {
                        self.showMailApp = true
                    } label: {
                        Text("iOS email app")
                    }
                } else {
                    
                }
            })
            .alert("No default email app found", isPresented: $showAlertNoDefaulEmailFound, actions: {
                Button {
                    addToClipboardWithHaptics(with: "brendan.koeleman@outlook.com")
                } label: {
                    Text("Copy our support email here.")
                }
                
                Button {} label: {
                    Text("OK")
                }
            })
            .sheet(isPresented: $showMailApp, content: {
                MailView(supportEmail: $email) { result in
                    switch result {
                    case .success:
                        print("Email sent")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
            .sheet(isPresented: $showIcons, content: {
                IconSelectionView()
                    .presentationDetents([.medium, .large])
            })
            .sheet(isPresented: $showAbout, content: {
                AboutView()
                    .presentationDetents([.medium])
            })
            .sheet(isPresented: $showStyleSelections) {
                ViewTypeSelections()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showColorSchemeSelections, content: {
                ColorSchemeSelections()
                    .presentationDetents([.medium])
            })
            .onChange(of: appTint) { oldValue, newValue in
                if hapticsEnabled && newValue != oldValue {
                    HapticsManager.shared.vibrateForSelection()
                }
            }
            .onChange(of: selectedAppIcon) { oldValue, newValue in
                if hapticsEnabled && newValue != oldValue {
                    HapticsManager.shared.vibrateForSelection()
                }
            }
            .onChange(of: viewType) { oldValue, newValue in
                if hapticsEnabled && newValue != oldValue {
                    HapticsManager.shared.vibrateForSelection()
                }
            }
            .onChange(of: scheme) { oldValue, newValue in
                if hapticsEnabled && newValue != oldValue {
                    HapticsManager.shared.vibrateForSelection()
                }
            }
        }
    }
    
    func rateApp() {
        let urlStr = "\(Constants.AppStoreURL)?action=write-review"
        
        guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
