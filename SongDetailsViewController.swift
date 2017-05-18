//
//  songDetailsViewController.swift
//  Mike Sample
//
//  Created by Chandan Brown on 3/17/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
import AVFoundation

class SongDetailsViewController: UIViewController {
    
    var song: SongModel?
    var songLink: String!
    var imageURL : String?
    var songManager : FetchDataDelegate? = nil
    
    lazy var playerQueue : AVQueuePlayer = {
        return AVQueuePlayer()
    }()

    
    // MARK: -IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumImageView.layer.masksToBounds = true
        albumImageView.layer.cornerRadius = 5
        
        if song != nil  {
            songLink = song?.linkToiTunes
            songTitleLabel.text = song?.title
            imageURL = song?.appImageURLString
            loadImage(urlString: (imageURL!))
        } else {
            print("song does not exist")
        }
    }
    
    @IBAction func viewCurrentsongOnItunes(_ sender: Any) {
        let url = URL(string: songLink!)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
    @IBAction func readMoreAboutMike(_ sender: Any) {
        let url = URL(string: "https://en.wikipedia.org/wiki/Michael_Jackson")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
    func loadImage(urlString: String) {
        let imgURL = URL(string: urlString)
        let request = URLRequest(url: imgURL!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                self.imageView.image = UIImage(data: data)
                self.albumImageView.image = UIImage(data: data)
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.imageView.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.imageView.addSubview(blurEffectView)
            }
        })
        task.resume()
    }
    
    @IBAction func playSong(_ sender: Any) {
        let urlstring = song?.previewLink
        let url = NSURL(string: urlstring!)
        let playerItem = AVPlayerItem.init(url: url! as URL)
        self.playerQueue.insert(playerItem, after: nil)
        self.playerQueue.play()
        print ("Playing song")
    }
}
