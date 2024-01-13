//
//  AddLibraryButton.swift
//  JustGames
//
//  Created by Ali Dinç on 11/01/2024.
//

import SwiftData
import SwiftUI


enum LibraryViewType: String, CaseIterable, Hashable {
    case addLibrary
    case allLibraries
    
    
    var title: String {
        switch self {
        case .addLibrary:
            return "Add library"
        case .allLibraries:
            return "All libraries"
        }
    }
}

struct LibraryView: View {
    
    @State private var libraryIcon: String?
    @State private var libraryName = ""
    @State private var selectedLibraryView: LibraryViewType = .addLibrary
    
    @State private var showMaxLibraryAlert = false
    
    @AppStorage("appTint") var appTint: Color = .white
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query var libraries: [Library]
    
    var body: some View {
        VStack {
            SegmentedView(selectedSegment: $selectedLibraryView, segments: LibraryViewType.allCases) { library in
                Text(library.title)
            }
            .padding()
            
            switch selectedLibraryView {
            case .addLibrary:
                AddLibraryView
            case .allLibraries:
                AllLibrariesView
            }
        }
    }
    
    private var AddLibraryView: some View {
        Form {
            Section("Name") {
                TextField("Library name", text: $libraryName)
                    .frame(height: 24, alignment: .leading)
                    .padding(10)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
                    .autocorrectionDisabled()
                    .onSubmit {
                        addLibrary()
                    }
            }
            
            Section("Icon") {
                ScrollView {
                    VStack {
                        ForEach(SFSections.allCases, id: \.self) { section in
                            DisclosureGroup {
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()], content: {
                                        ForEach(section.sfModels, id: \.self) { symbol in
                                            Button(action: {
                                                libraryIcon = symbol
                                            }, label: {
                                                Image(systemName: symbol)
                                                    .padding()
                                                    .imageScale(.medium)
                                                    .overlay {
                                                        if symbol == libraryIcon {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .strokeBorder(appTint, lineWidth: 2)
                                                        }
                                                    }
                                            })
                                        }
                                    })
                                }
                                .frame(height: 150)
                               
                            } label: {
                                Text(section.rawValue.capitalized)
                                    .font(.subheadline.bold())
                            }
                            .padding()
                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                            
                        }
                       
                    }
                    .scrollTargetLayout()
                }
                .frame(height: 350)
                .scrollTargetBehavior(.viewAligned)
            }
            
            Section("") {
                Button(action: {
                    addLibrary()
                }, label: {
                    Label("Add Library", systemImage: "plus")
                        .foregroundStyle(.white)
                        .bold()
                        .padding()
                        .background(.blue, in: .capsule)
                })
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .alert("You can't have more than 10 libraries.", isPresented: $showMaxLibraryAlert) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
    }
    
    private var AllLibrariesView: some View {
        ScrollView {
            VStack {
                ForEach(libraries.filter({ $0.savingId != Constants.allGamesLibraryID }), id: \.self) { library in
                    HStack {
                        Text(library.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        if let icon = library.icon {
                            Image(systemName: icon)
                                .imageScale(.medium)
                        }
                    }
                }
            }
        }
    }
    
    func addLibrary() {
        guard !libraryName.isEmpty else {
            return
        }
        
        guard libraries.count < 11 else {
            showMaxLibraryAlert = true
            return
        }
        
        
        let library = Library(title: libraryName)
        if let libraryIcon {
            library.icon = libraryIcon
        }
        context.insert(library)
        libraryName = ""
        dismiss()
    }
}
