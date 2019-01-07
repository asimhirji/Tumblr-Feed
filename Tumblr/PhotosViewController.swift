//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Jesus perez on 1/31/18.
//  Copyright © 2018 Jesus perez. All rights reserved.
//

import UIKit
import AlamofireImage
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var PhotoTableView: UITableView!
    var posts: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
        PhotoTableView.insertSubview(refreshControl, at: 0)
        PhotoTableView.delegate = self
        PhotoTableView.dataSource = self

        // Do any additional setup after loading the view.
        // Network request snippet
        fetchPhotos()
        
    }
    
    func fetchPhotos() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                self.PhotoTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchPhotos()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ PhotoTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ PhotoTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PhotoTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as! PhotoTableViewCell
        // Configure YourCustomCell using the outlets that you've defined.
        let post = posts[indexPath.section]
        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            
            cell.photo.af_setImage(withURL: url!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add a uilabel for the date
        let post = posts[section]
        let date = post["date"] as! String
        let dateLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 260, height: 30))
        dateLabel.text = date
        dateLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        headerView.addSubview(dateLabel)
        
        return headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = PhotoTableView.indexPath(for: cell) {
            let photos = posts[indexPath.section]
            let vc = segue.destination as! PhotoDetailsViewController
            let picutre = photos["photos"] as! [[String: Any]]
            let photo = picutre[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let caption = photos["caption"] as! String
            let date = photos["date"] as! String
            vc.captionString = caption
            vc.imageUrl = urlString
            vc.date = date
            
        }
    }

    func tableView(_ PhotoTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PhotoTableView.deselectRow(at: indexPath, animated: true)
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
