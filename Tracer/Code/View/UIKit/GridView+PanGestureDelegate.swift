//
//  GridView+PanGestureDelegate.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/5/24.
//

import Foundation

protocol PanGestureDelegate {
    func tileSelectedAsDelegate(forPixelLoc pixelLoc: CGPoint, viaGesture gesture: Gesture)
}

extension GridView: PanGestureDelegate {
    func tileSelectedAsDelegate(forPixelLoc pixelLoc: CGPoint, viaGesture gesture: Gesture) {
        tileSelected(forPixelLoc: pixelLoc, viaGesture: gesture)
    }
}
