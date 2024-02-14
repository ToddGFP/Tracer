//
//  OverlayViewModifier.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/13/24.
//

import SwiftUI

struct OverlayViewModifier: ViewModifier {
    @State private var scaleEffect = 0.0

    func body(content: Content) -> some View {
        content
            .padding(40)
            .background(Color.blue.opacity(DesignConstants.overlayWindowOpacity))
            .foregroundColor(Color.white)
            .cornerRadius(DesignConstants.overlayWindowCornerRadius)
            .overlay(RoundedRectangle(cornerRadius: DesignConstants.overlayWindowCornerRadius)
                .stroke(DesignConstants.overlayWindowBorderColor, lineWidth: DesignConstants.overlayWindowBorderWidth))
            .scaleEffect(scaleEffect)
            .onAppear {
                withAnimation(.interpolatingSpring(
                    stiffness: DesignConstants.overlayIngressStiffness,
                    damping: DesignConstants.overlayIngressDamping
                )) {
                    scaleEffect = DesignConstants.overlayIngressScale
                }
                withAnimation(.interpolatingSpring(
                    stiffness: DesignConstants.overlayEgressStiffness,
                    damping: DesignConstants.overlayEgressDamping).delay(DesignConstants.overlayEgressDelay)
                ) {
                    scaleEffect = DesignConstants.overlayEgressScale
                }
            }
            .transition(.opacity)
    }
}
