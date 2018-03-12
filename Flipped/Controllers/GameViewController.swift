//
//  GameViewController.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, Observer {
    var game: Game!
    var animator: Animator!
    
    //Outlets
    @IBOutlet weak var gameView: GameView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if game == nil {
            game =  Game(levelName: "level_1-1")
        }
        game.addObserver(self)
        
        // Register a listener to get intermediate states that are dispatched asynchronously
        animator = Animator(forBoard: game.gameBoard, forViewSize: gameView.bounds.size)
        animator.animationListener = self.displayIntermediateState(frame:)
        animator.completionListener = self.finishedAnimatingTurn
        
        gameView.touchListener = self.handleTouch(start:end:)
        gameView.display = animator.drawBoard(from: game.gameBoard)
        gameView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // For Observer protocol
    func update() {
        if let turn = game.dequeueTurn() {
            animator.animateTurn(turn)
        }
        else {
            displayCurrentGameState()
        }
    }
    
    // This method is registered as a callback in the animator
    func displayIntermediateState(frame: [Drawable]) {
        gameView.display = frame
        gameView.setNeedsDisplay()
    }
    
    func finishedAnimatingTurn() {
        displayCurrentGameState()
    }
    
    func displayCurrentGameState() {
        gameView.display = animator.drawBoard(from: game.gameBoard)
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
            
            let kind: TileKind = start.y < end.y ? .Color_A : .Color_B //Temporary to drop pink from above, purple from bottom
            let accepted = game.acceptTile(kind: kind, at: Coordinate(x, y))
            if accepted {
                print("Tile accepted at \(x), \(y)")
            }
        }
    }
    
    @IBAction func undoPressed(_ sender: UIButton) {
        game.undoTurn()
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
