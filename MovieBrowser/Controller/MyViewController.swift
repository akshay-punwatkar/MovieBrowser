//
//  MyViewController.swift
//  flicks
//
//  Created by John Law on 13/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = false
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goToGitHub(_ sender: Any) {
        let url = URL(string: "https://github.com/lawchihon")

        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }

    @IBAction func goToFlicks(_ sender: Any) {
        let url = URL(string: "https://github.com/lawchihon/flicks")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
