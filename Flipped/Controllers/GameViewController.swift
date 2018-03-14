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
    var world: Int = 1
    var level: Int = 1
    var animator: Animator!
    
    //Outlets
    @IBOutlet weak var gameView: GameView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNewGame()
    }
    
    
    @IBAction func undoPressed(_ sender: UIButton) {
        game.undoTurn()
    }
    
    func initializeNewGame() {
        if game == nil {
            game =  Game(levelName: "level_1-1")
            world = 1
            level = 1
        }
        game.addObserver(self)
        
        // Register a listener to get intermediate states that are dispatched asynchronously
        animator = Animator(forBoard: game.gameBoard, forViewSize: gameView.bounds.size)
        animator.animationListener = self.displayIntermediateState(frame:)
        animator.completionListener = self.finishedAnimatingTurn
        
        setBankTiles()
        gameView.touchListener = self.handleTouch(start:end:tileKind:)
        gameView.display = animator.drawBoard(from: game.gameBoard)
        gameView.bank = animator.describeTileBank()
        gameView.bankAmounts = game.tileBank
        gameView.setNeedsDisplay()
    }
    
    func loadNextLevel() -> Bool {
        if let (name, w, l) = LevelBuilder.getLevelNameAfter(world: world, level: level) {
            game = Game(levelName: name)
            world = w
            level = l
            initializeNewGame()
            return true
        }
        else {
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Added this override function because of an issue with iPhone 7 plus and 8 plus
    // where the gameView.bounds.size would change after the initial layout.
    override func viewDidLayoutSubviews() {
        animator.viewSizeDidChange(to: gameView.bounds.size)
        setBankTiles()
        displayCurrentGameState()
    }
    
    func setBankTiles() {
        let tiles = animator.getBankTiles()
        gameView.bankTiles = tiles
    }
    
    // Displays the game board according to the most up to date game state
    func displayCurrentGameState() {
        gameView.display = animator.drawBoard(from: game.gameBoard)
        gameView.bank = animator.describeTileBank()
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
        if game.won {
            promptLevelComplete()
        }
    }
    
    // For Observer protocol
    func update() {
        gameView.bankAmounts = game.tileBank
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
    func handleTouch(start: CGPoint, end: CGPoint, tileKind: TileKind) {
        let gridTop = animator.gridOffset
        let gridBottom = (animator.gridOffset + gameView.bounds.size.width)
        
        if end.y > gridTop && end.y < gridBottom {
            let yOffsetIntoGrid = Double(end.y - gridTop)
            let xOffsetIntoGrid = Double(end.x)
            let tileSize = Double(animator.tileSize)
            let y = Int((yOffsetIntoGrid / tileSize).rounded(.towardZero))
            let x = Int((xOffsetIntoGrid / tileSize).rounded(.towardZero))
            
            let kind = tileKind
            let accepted = game.acceptTile(kind: kind, at: Coordinate(x, y))
            if accepted {
                print("Tile accepted at \(x), \(y)")
            }
        }
    }
    
    // Displays an action sheet prompting the user to force an invalid action.
    // If the user confirms, the action is forced.
    func promptLevelComplete() {
        let title = "Level \(world)-\(level)"
        let message = "Level Complete!!"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: "OK", style: .destructive)
        
        let confirmAction = UIAlertAction(title: "Next Level", style: .default) { action in
            //Carry out the forced action
            let success = self.loadNextLevel()
            
            //Build the alert confirmation
            if !success {
                let okayController = UIAlertController(title: "Wait a second!", message: "There is no next level!\nCongrats?", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                okayController.addAction(okayAction)
                self.present(okayController, animated: true, completion: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
}
