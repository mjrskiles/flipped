//
//  GameViewController.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, Observer {
    private var game: Game = Game(name: "level_1-2")
    var animator: Animator!
    
    //Outlets
    @IBOutlet weak var gameView: GameView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.addObserver(self)
        animator = Animator(forSize: gameView.bounds.size)
        gameView.touchListener = self.handleTouch(start:end:)
        gameView.gameBoard = animator.drawBoard(from: game.gameBoard)
        gameView.setNeedsDisplay()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For Observer protocol
    func update() {
        gameView.gameBoard = animator.drawBoard(from: game.gameBoard)
        gameView.setNeedsDisplay()
    }
    
    // This method is registered as the touchListener in gameView
    func handleTouch(start: CGPoint, end: CGPoint) {
        let gridTop = animator.gridOffset
        let gridBottom = (animator.gridOffset + gameView.bounds.size.width)
        if end.y > gridTop && end.y < gridBottom {
            let yOffsetIntoGrid = Double(end.y - gridTop)
            let xOffsetIntoGrid = Double(end.x)
            let tileSize = Double(animator.tileSize)
            let y = Int((yOffsetIntoGrid / tileSize).rounded(.towardZero))
            let x = Int((xOffsetIntoGrid / tileSize).rounded(.towardZero))
            
            let kind: TileKind = start.y < gridBottom ? .Color_A : .Color_B //Temporary to drop pink from above, purple from bottom
            let accepted = game.acceptTile(kind: kind, at: Coordinate(x, y))
            if accepted {
                print("Tile accepted at \(x), \(y)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
