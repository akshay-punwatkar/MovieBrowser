//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Akshay on 22/05/20.
//  Copyright © 2020 Akshay. All rights reserved.
//


import UIKit
import AFNetworking
import MBProgressHUD
import Alamofire
import SwiftyJSON
class PosterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var endpoint: String!
    var window: UIWindow?
    lazy var refreshControl = UIRefreshControl()
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkErrorView: UIView!
    
  


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.white
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = self.refreshControl
        networkErrorView.isHidden = true
        
        
        
        loadDataFromNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadDataFromNetwork()
        refreshControl.endRefreshing()
    }
  
    
    func loadDataFromNetwork() {
        let apiKey = "2b784b6fea333e24b8c111b4f58369e2"
        print(self.endpoint as Any)
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print(dataDictionary)
                    self.networkErrorView.isHidden = true
                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    self.filteredMovies = self.movies
                    self.collectionView.reloadData()
                }
            }
            if error != nil {
                self.networkErrorView.isHidden = false
                /*
                let alertController = UIAlertController(title: "Error", message:
                    error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                */
                //print (error.debugDescription)
                //print (error?.localizedDescription as Any)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        }
        else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = filteredMovies![indexPath.row]
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let originalBase = "https://image.tmdb.org/t/p/original"

        let imageUrl = URL(string: baseUrl + posterPath)
        let originalUrl = URL(string: originalBase + posterPath)

        let imageRequest = URLRequest(url: imageUrl!)
        let originalRequest = URLRequest(url: originalUrl!)

        //cell.posterView.setImageWith(imageUrl!)

        cell.posterView.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: {
                (imageRequest, imageResponse, image) -> Void in
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        //print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animate(withDuration: 0.3, animations: {
                            () -> Void in
                                cell.posterView.alpha = 1.0
                        }, completion: { (sucess) -> Void in
                            cell.posterView.setImageWith(
                                originalRequest,
                                placeholderImage: image,
                                success: { (originalImageRequest, originalImageResponse, originalImage) -> Void in
                                    
                                    cell.posterView.image = originalImage;
                                    
                            },
                                failure: { (request, response, error) -> Void in
                            })
                        })
                    }
                    else {
                        cell.posterView.image = image
                    }
            },

            failure: { (imageRequest, imageResponse, error) -> Void in
            
            }
        )
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 224/255.0, green: 215/255.0, blue: 247/255.0, alpha: 1.00)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        collectionView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let detailViewController = segue.destination as? DetailViewController {
            let cell = sender as! PosterCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie = filteredMovies![(indexPath?.row)!]

            detailViewController.movie = movie
            
            detailViewController.image = cell.posterView
        }
        else if let tableViewController = segue.destination as? MovieViewController {
            tableViewController.endpoint = endpoint
        }
    }

}
