//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Akshay on 22/05/20.
//  Copyright © 2020 Akshay. All rights reserved.
//


import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    
    var movie: NSDictionary!
    var image: UIImageView!

    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       navigationController?.navigationBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = true
        

        
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        print (movie as Any)

        
        
        
        let title = movie["title"] as? String
        titleLabel.text = title
        let release = movie["release_date"] as? String
        releaseLabel.text = release
        let rating = movie["vote_average"] as? Double
        ratingLabel.text = String(format:"%.1f", rating!) + "/10"
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            posterView.setImageWith(imageUrl!)
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func clickForDetail(_ sender: Any) {
        let id = movie["id"]
        let url =  URL(string: "https://www.themoviedb.org/movie/\(id!)")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)

    }
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
          self.tabBarController?.tabBar.isHidden = false

          let _ = self.navigationController?.popViewController(animated: true)
      }
    
    
}
