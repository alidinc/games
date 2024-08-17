//
//  MarqueeView.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI


extension View {

    func measureWidth(_ onChange: @escaping (CGFloat) -> ()) -> some View {
        background {
            GeometryReader { proxy in
                let width = proxy.size.width
                Color.clear
                    .onAppear(perform: {
                        onChange(width)
                    }).onChange(of: width) {
                        onChange($0)
                    }
            }
        }
    }
}

class MarqueeModel {
    var contentWidth: CGFloat? = nil
    var offset: CGFloat = 0
    var dragStartOffset: CGFloat? = nil
    var dragTranslation: CGFloat = 0
    var currentVelocity: CGFloat = 0

    var previousTick: Date = .now
    var targetVelocity: Double
    var spacing: CGFloat
    init(targetVelocity: Double, spacing: CGFloat) {
        self.targetVelocity = targetVelocity
        self.spacing = spacing
    }

    func tick(at time: Date) {
        let delta = time.timeIntervalSince(previousTick)
        defer { previousTick = time }
        currentVelocity += (targetVelocity - currentVelocity) * delta * 3
        if let dragStartOffset {
            offset = dragStartOffset + dragTranslation
        } else {
            offset -= delta * currentVelocity
        }
        if let c = contentWidth {
            offset.formTruncatingRemainder(dividingBy: c + spacing)
            while offset > 0 {
                offset -= c + spacing
            }

        }
    }

    func dragChanged(_ value: DragGesture.Value) {
        if dragStartOffset == nil {
            dragStartOffset = offset
        }
        dragTranslation = value.translation.width
    }

    func dragEnded(_ value: DragGesture.Value) {
        offset = dragStartOffset! + value.translation.width
        dragStartOffset = nil
        currentVelocity = -value.velocity.width
    }

}

struct Repeat<Content: View>: View {
    var count: Int
    var content: Content

    var body: some View {
        if count >= 5 {
            content; content; content; content; content
            Repeat(count: count-5, content: content)
        } else if count == 4 {
            content; content; content; content
        } else if count == 3 {
            content; content; content
        } else if count == 2 {
            content; content
        } else if count == 1 {
            content
        }
    }
}

struct Marquee<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var containerWidth: CGFloat? = nil
    @State private var model: MarqueeModel
    private var targetVelocity: Double
    private var spacing: CGFloat

    init(targetVelocity: Double, spacing: CGFloat = 10, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._model = .init(wrappedValue: MarqueeModel(targetVelocity: targetVelocity, spacing: spacing))
        self.targetVelocity = targetVelocity
        self.spacing = spacing
    }

    var extraContentInstances: Int {
        let contentPlusSpacing = ((model.contentWidth ?? 0) + model.spacing)
        guard contentPlusSpacing != 0 else { return 1 }
        return Int(((containerWidth ?? 0) / contentPlusSpacing).rounded(.up))
    }

    var body: some View {
        TimelineView(.animation) { context in
            let _ = model.tick(at: context.date)
            HStack(spacing: model.spacing) {
                HStack(spacing: model.spacing) {
                    content
                }
                .measureWidth { model.contentWidth = $0 }
                Repeat(count: extraContentInstances, content: content)
//                ForEach(Array(0..<extraContentInstances), id: \.self) { _ in
//                    content
//                }
            }
            .offset(x: model.offset)
            .fixedSize()
        }
        .gesture(dragGesture)
        .onAppear { model.previousTick = .now }
        .onChange(of: targetVelocity) { _, newValue in
            model.targetVelocity = newValue
        }
        .onChange(of: spacing) { _, newValue in
            model.spacing = newValue
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .measureWidth { containerWidth = $0 }
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                model.dragChanged(value)
            }.onEnded { value in
                model.dragEnded(value)
            }
    }
}
