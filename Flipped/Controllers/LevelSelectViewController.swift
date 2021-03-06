//
//  SecondViewController.swift
//  Flipped
//
//  Created by Michael Skiles on 2/27/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import UIKit

class LevelSelectViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return LevelBuilder.levelList.worlds.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LevelBuilder.levelList.worlds[section].levels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        cell.textLabel?.text = "Level " + LevelBuilder.levelList.worlds[section].levels[row]
        return cell
     }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return LevelBuilder.levelList.worlds[section].title
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Start the game with the selected level
        guard let vc = segue.destination as? GameViewController else {
            return
        }
        guard let indexPath = table.indexPathForSelectedRow else {
            return
        }
        let section = indexPath.section
        let row = indexPath.row
        if section < LevelBuilder.levelList.worlds.count && row < LevelBuilder.levelList.worlds[section].levels.count {
            let level = "level_" + LevelBuilder.levelList.worlds[section].levels[row]
            vc.game = Game(levelName: level)
        }
    }
 
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
 
}

