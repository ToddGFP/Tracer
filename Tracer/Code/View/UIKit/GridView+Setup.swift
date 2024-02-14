//
//  GridView+TileSetup.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/24/20.
//

import UIKit

extension GridView {
    func configure(frameSize: CGSize, tileSize: CGFloat) {
        if frameSize != previousFrameSize {
            previousFrameSize = frameSize
            self.tileSize = tileSize
            setNeedsLayout()
        }
    }

    func tileView(forGridLoc gridLoc: GridLoc) -> TileView {
        return tiles[((gridLoc.y - 1) * DesignConstants.gridWidth) + gridLoc.x - 1]
    }
    
    func removeTiles() {
        for tile in tiles {
            tile.removeFromSuperview()
        }
        tiles = [TileView]()
    }
    
    func layoutTiles() {
        let size = CGSize(width: tileSize, height: tileSize)
        
        for y in 1...DesignConstants.gridHeight {
            for x in 1...DesignConstants.gridWidth {
                layoutTile(forGridLoc: GridLoc(x: x, y: y), size: size)
            }
        }
    }
    
    private func layoutTile(forGridLoc gridLoc: GridLoc, size: CGSize) {
        let origin = CGPoint(
            x: DesignConstants.gutterSize + (CGFloat(gridLoc.x - 1) * (tileSize + DesignConstants.gutterSize)),
            y: DesignConstants.gutterSize + (CGFloat(gridLoc.y - 1) * (tileSize + DesignConstants.gutterSize))
        )
        
        let tileView = TileView(
            frame: CGRect(origin: origin, size: size)
        )
        
        tileView.gridViewDelegate = gridViewDelegate
        tileView.backgroundColor = .black
        tileView.hilightColor = foregroundColor(forLevel: 1)
        tileView.isUserInteractionEnabled = true
        tileView.gridLoc = gridLoc
        tileView.setupAudioPlayers()
        
        tiles.append(tileView)
        addSubview(tileView)
    }
}
