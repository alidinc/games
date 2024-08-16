//
//  SegmentedView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 09/01/2024.
//

import SwiftUI

import SwiftUI

struct SegmentedView<SegmentItem: Hashable, SegmentContent: View>: View {
    
    @Binding var selectedSegment: SegmentItem
    var segments: [SegmentItem]
    var segmentContent: (SegmentItem) -> SegmentContent
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                SegmentItemView(
                    segment: segment,
                    selectedSegment: $selectedSegment,
                    animation: animation
                ) {
                    segmentContent(segment)
                }
            }
        }
        .background(Color.segmentUnSelectedBackground, in: .capsule)
        .padding(.horizontal, 20)
    }
}

private struct SegmentItemView<SegmentItem: Hashable, SegmentContent: View>: View {
    
    let segment: SegmentItem
    @Binding var selectedSegment: SegmentItem
    let animation: Namespace.ID
    let content: () -> SegmentContent
    
    @AppStorage("colorScheme") var scheme: SchemeType = .system

    var body: some View {
        content()
            .hSpacing()
            .tag(segment)
            .font(.system(size: 14, weight: .semibold))
            .padding(.vertical, 10)
            .background {
                if selectedSegment == segment {
                    Capsule()
                        .fill(Color.segmentSelectedBackground)
                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                }
            }
            .contentShape(.capsule)
            .onTapGesture {
                withAnimation(.snappy) {
                    selectedSegment = segment
                }
            }
    }
}
