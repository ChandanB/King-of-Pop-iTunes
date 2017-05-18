//
//  Top25TableViewController.swift
//  Mike Sample
//
//  Created by Chandan Brown on 3/17/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.layer.borderWidth = 1
        coverImageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                DispatchQueue.main.async {
                self.coverImageView.image = UIImage(data: data)
                }
            }
        })
        task.resume()
    }

}
