//
//  TileView.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/15/20.
//
//  The tiles make up the squares of the GridView.
//

import UIKit
import AVFoundation

/**
 The UIView subclass that represents one tile on the GridView.
 
 Each TileView handles its own light-up-and-fade-out animation and sound playback.
 */
class TileView: UIView {
    var gridLoc: GridLoc?
    var gridViewDelegate: GridViewDelegate?
    var audioPlayers = [AVAudioPlayer]()
    var playerLoc = 0
    var hilightColor = UIColor.red
    
    var soundFilename: String? {
        gridLoc == nil ? nil : gridLoc?.soundFilename
    }

    /**
     Create multiple AVAudioPlyer(s) for the TileView.
     
     The use of multiple players for each tile ensures enough polyphony that even wild use of jam mode will not result in  sounds getting cut short.  The drawback is that the creation of all these audio players slows the initial creation of the grid considerably.  This was the inspiration for creating the introductory animation, to gloss over this delay.
     */
    func setupAudioPlayers() {
        //debug("TileView: setupAudioPlayers(\(gridLoc?.asString) (\(soundFilename))", 0, .controlFlow)
        
        for _ in 1...DesignConstants.audioPlayersPerTile {
            do {
                guard let soundFile = soundFilename,
                      let soundPath = Bundle.main.path(forResource: soundFile, ofType: "m4a") else {
                    return
                }
                
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
                player.prepareToPlay()
                audioPlayers.append(player)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
        
    /// Light the tile up quickly, then fade it out slowly.
    func lightUpAndFadeOut(_ fadeOut: Bool, afterDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.backgroundColor = self.hilightColor
            guard fadeOut == true else {
                return
            }
            UIView.animate(
                withDuration: DesignConstants.squareFadeDuration,
                delay: delay,
                options: .curveEaseIn,
                animations: {
                    self.backgroundColor = UIColor.black
                }
            )
        }
    }
    
    func playSound(afterDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.audioPlayers.count - 1 >= self.playerLoc else {
                return
            }
            self.audioPlayers[self.playerLoc].play()
            self.playerLoc = self.playerLoc == DesignConstants.audioPlayersPerTile - 1 ? 0 : self.playerLoc + 1
        }
    }
}
