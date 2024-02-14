//
//  GridView+Interactivity.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/24/20.
//

import UIKit

extension GridView {
    func enableUserInteraction() {
        isUserInteractionEnabled = true
    }
    
    func disableUserInteraction() {
        isUserInteractionEnabled = false
    }

    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(from:)))
        addGestureRecognizer(tapGesture)
        
        let panGesture = PanGestureRecognizerWithInitialLocation(target: self, action: #selector(handlePan(from:)))
        panGesture.panGestureDelegate = self
        addGestureRecognizer(panGesture)
        
        gestureRecognizersSetup = true
    }

    @objc func handleSingleTap(from recognizer: UITapGestureRecognizer?) {
        tileSelected(forPixelLoc: recognizer?.location(in: self) ?? CGPoint.zero, viaGesture: .tap)
    }

    @objc func handlePan(from recognizer: PanGestureRecognizerWithInitialLocation?) {
        tileSelected(forPixelLoc: recognizer?.location(in: self) ?? CGPoint.zero, viaGesture: .pan)
    }
    
    func tileSelected(forPixelLoc pixelLoc: CGPoint, viaGesture gesture: Gesture) {
        if let gridLoc = gridLoc(forPixelLoc: pixelLoc) {
            if gridLoc != mostRecentSelectedGridLoc {
                mostRecentSelectedGridLoc = gridLoc
                mostRecentGesture = gesture
                activateTile(
                    forGridLoc: gridLoc,
                    afterDelay: 0,
                    withSound: true,
                    fromUserInput: true,
                    fromIdle: false
                )
            }
        }
    }
}

