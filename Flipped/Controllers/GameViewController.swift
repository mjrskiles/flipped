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
        animator = Animator(forSize: gameView.bounds.size)
        gameView.touchListener = self.handleTouch(start:end:)
        let width = gameView.bounds.size.width
        let tileSize: CGFloat = width / 9
        gameView.gameBoard = animator.drawBoard(from: game.gameBoard, tileSize: tileSize)
        gameView.setNeedsDisplay()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissScreen(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func update() {
        
    }
    
    func handleTouch(start: CGPoint, end: CGPoint) {
        let gridTop = animator.gridOffset
        let gridBottom = (animator.gridOffset + gameView.bounds.size.width)
        if end.y > gridTop && end.y < gridBottom {
            let yOffsetIntoGrid = Double(end.y - gridTop)
            let xOffsetIntoGrid = Double(end.x)
            let tileSize = Double(animator.tileSize)
            let y = Int((yOffsetIntoGrid / tileSize).rounded(.towardZero))
            let x = Int((xOffsetIntoGrid / tileSize).rounded(.towardZero))
            
            let accepted = game.acceptTile(kind: .Color_A, at: Coordinate(x, y))
            if accepted {
                gameView.gameBoard = animator.drawBoard(from: game.gameBoard, tileSize: CGFloat(tileSize))
                gameView.setNeedsDisplay()
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
