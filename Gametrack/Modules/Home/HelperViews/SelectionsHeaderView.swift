//
//  HeaderView.swift
//  Cards
//
//  Created by Ali Dinç on 19/12/2023.
//

import SwiftUI

enum SegmentType: String, CaseIterable, Identifiable {
    case category
    case platform
    case genre
    
    var id: String {
        switch self {
        default:
            UUID().uuidString
        }
    }
}

struct SelectionsHeaderView: View {
    
    @Binding var vm: HomeViewModel
    @State private var showSelection = false
    @State private var selectedSegment: SegmentType = .platform
    
    var body: some View {
        PlatformButton
        .hSpacing(.leading)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .sheet(isPresented: $showSelection, content: {
            SelectionsView(vm: vm, selectedSegment: $selectedSegment)
                .presentationDetents([.medium, .large])
        })
    }
    
    private var PlatformButton: some View {
        HStack {
            Button {
                showSelection = true
                selectedSegment = .platform
            } label: {
                Text(vm.fetchTaskToken.platforms.isEmpty ? "Platforms" : "\(vm.fetchTaskToken.platforms.map({$0.title}).joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .underline()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            Text(",")
                .font(.subheadline)
                .foregroundStyle(.primary)
            
            Button {
                showSelection = true
                selectedSegment = .genre
            } label: {
                Text(vm.fetchTaskToken.genres.isEmpty ? "Genre" : "\(vm.fetchTaskToken.genres.map({$0.title}).joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .underline()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
