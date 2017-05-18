//
//  Top25TableViewController.swift
//  Mike Sample
//
//  Created by Chandan Brown on 3/17/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//
import Foundation

class FetchDataDelegate {
    
    var songsURL = "https://itunes.apple.com/search?term=Michael+jackson"
    var songs: [SongModel]?    
    var callback: (([SongModel]) -> ())? // optional
    
    func getSongData() {
        
        let request = URLRequest(url: URL(string: songsURL)!)
        
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            // Parse JSON Data
            if let data = data {
                self.songs = self.parseJSONData(data: data)
                
                // TODO: - Where to reload data? in view controller?
                if let callback = self.callback {
                    if let apps = self.songs {
                        callback(apps)
                    }
                }
            }
        })
        task.resume()
    }
    
    func parseJSONData(data: Data) -> [SongModel] {
        
        var songsArray = [SongModel]()
        
        do {
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            // Parse the result
            let jsonFeed = jsonResult?["results"] as! [AnyObject]
            
            
            for jsonSong in jsonFeed {
                let song = SongModel()
                
                // title
                let title = jsonSong["trackName"] as! String
                song.title = title
                
                // Release date
                let date = jsonSong["releaseDate"] as! String
                song.releaseDate = date
            
                
                // image url
                let image = jsonSong["artworkUrl100"] as! String
                song.appImageURLString = image
                
                
                let preview = jsonSong["previewUrl"] as! String
                song.previewLink = preview
                
                songsArray.append(song)
            }
        } catch {
            print(error)
        }
        return songsArray
    }
}
