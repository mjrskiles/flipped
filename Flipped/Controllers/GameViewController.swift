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
        
        setBankTiles()
        gameView.touchListener = self.handleTouch(start:end:)
        gameView.display = animator.drawBoard(from: game.gameBoard)
        gameView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Added this override function because of an issue with iPhone 7 plus and 8 plus
    // where the gameView.bounds.size would change after the initial layout.
    override func viewDidLayoutSubviews() {
        animator.viewSizeDidChange(to: gameView.bounds.size)
        displayCurrentGameState()
    }
    
    func setBankTiles() {
        let tiles = animator.getBankTiles()
        for rect in tiles {
            gameView.bankTiles.append(rect)
        }
    }
    
    // Displays the game board according to the most up to date game state
    func displayCurrentGameState() {
        gameView.display = animator.drawBoard(from: game.gameBoard)
        gameView.setNeedsDisplay()
    }
    
    // This method is registered as a callback in the animator
    func displayIntermediateState(frame: [Drawable]) {
        gameView.display = frame
        gameView.setNeedsDisplay()
    }
    
    // This method is registered as a callback in the animator
    func finishedAnimatingTurn() {
        print("current viewsize: \(gameView.bounds.size)")
        update()
    }
    
    // For Observer protocol
    func update() {
        if !animator.isAnimating {
            if let turn = game.dequeueTurn() {
                animator.animateTurn(turn)
            }
            else {
                displayCurrentGameState()
            }
        }
    }
    
    // This method is registered as the touchListener in gameView
    // It converts the touch input into a coordinate on the grid
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
