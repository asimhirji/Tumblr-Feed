//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Asim Hirji on 12/25/18.
//  Copyright © 2018 Jesus perez. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var detailPhoto: UIImageView!
    var imageUrl: String!
    var date: String!
    var captionString: String!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var caption: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: imageUrl)
        
        detailPhoto.af_setImage(withURL: url!)
        dateLabel.text = date
        let captionCut = captionString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        caption.text = captionCut

        // Do any additional setup after loading the view.
        dateLabel.layer.cornerRadius = 4.0
        dateLabel.layer.masksToBounds = true
        caption.layer.cornerRadius = 4.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
