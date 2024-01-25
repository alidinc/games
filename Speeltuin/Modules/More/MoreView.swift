//
//  SettingsView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI


struct MoreView: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint") var appTint: Color = .white
    @AppStorage("viewType") private var viewType: ViewType = .list
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .system
    
    @Environment(\.openURL) var openURL
    @State private var email = SupportEmail(toAddress: "alidinc.uk@outlook.com",
                                            subject: "Support Email",
                                            messageHeader: "Please describe your issue below.")
    
    @State private var showMailApp = false
    @State private var showAbout = false
    @State private var showIcons = false
    @State private var showSendEmail = false
    @State private var showAppStore = false
    @State private var showStyleSelections = false
    @State private var showAlertNoDefaulEmailFound = false
    
    var body: some View {
        NavigationStack {
            Form {
                SettingsSection
                FeedbackSection
                AboutSection
            }
            .scrollContentBackground(.hidden)
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
        }
    }
    
    private var Header: some View {
        HStack(spacing: 8) {
            Text("More")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.primary)
                .shadow(radius: 10)
                .hSpacing(.leading)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private var SettingsSection: some View {
        Section("Settings") {
            ShowIconsSection
            ViewTypeSection
            HapticsSection
            ColorPicker(selection: $appTint, supportsOpacity: false, label: {
                MoreRowView(imageName: "swatchpalette.fill", text: "Tint color")
            })
        }
    }
    
    private var FeedbackSection: some View {
        Section("Feedback") {
            ForEach(Feedback.allCases, id: \.id) { feedback in
                switch feedback {
                case .rate:
                    Button(action: {
                        showAppStore = true
                    }, label: {
                       MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    })
                case .email:
                    Button(action: {
                        showSendEmail = true
                    }, label: {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    })
                case .share:
                    ShareLink(item: Constants.AppStoreURL) {
                        MoreRowView(imageName: feedback.imageName, text: feedback.title)
                    }
                }
            }
        }
    }
    
    private var AboutSection: some View {
        Section("About") {
            Button {
                self.showAbout.toggle()
            } label: {
                MoreRowView(imageName: "info.circle.fill", text: "About")
            }
        }
    }
    
    private var ShowIconsSection: some View {
        Button {
            self.showIcons.toggle()
        } label: {
            HStack {
                MoreRowView(imageName: "apps.iphone", text: " App icon")
                Spacer()
                Text(selectedAppIcon.title)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
        }
    }
    
    private var ViewTypeSection: some View {
        Button {
            showStyleSelections = true
        } label: {
            HStack {
                MoreRowView(imageName: "rectangle.grid.1x2.fill", text: "View style")
                Spacer()
                
                Text(viewType.rawValue.capitalized)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
        }
    }
    
    private var HapticsSection: some View {
        Button {
            hapticsEnabled.toggle()
            if hapticsEnabled {
                HapticsManager.shared.vibrate(type: .success)
            }
        } label: {
            HStack {
                MoreRowView(imageName: "hand.tap.fill", text: "Haptics")
                Spacer()
                Toggle(isOn: $hapticsEnabled, label: {
                })
                .tint(.green)
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
