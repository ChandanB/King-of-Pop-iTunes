//
//  SongsTableViewController.swift
//  Songs Sample
//
//  Created by Chandan Brown on 3/17/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

class SongsTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    var songs = [SongModel]()
    var imageURL : String?
    var songURL = "https://itunes.apple.com/search?term=Michael+jackson"
    var songManager = FetchDataDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songManager.callback = { songs in
            self.songs = songs
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        songManager.getSongData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        cell.titleLabel.text = songs[indexPath.row].title
        
        imageURL = self.songs[indexPath.row].appImageURLString
        
        DispatchQueue.main.async {
           cell.loadImage(urlString: self.imageURL!)
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "detailViewSegue" == segue.identifier {
            let detailDestination = segue.destination as! SongDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailDestination.song = songs[indexPath.row]
                detailDestination.songManager = self.songManager
            }
        }
    }
}
