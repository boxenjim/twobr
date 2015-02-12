//
//  ImageDetailViewController.swift
//  Twobr
//
//  Created by Jim Schultz on 2/12/15.
//  Copyright (c) 2015 Blue Boxen, LLC. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL: NSURL? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if imageURL != nil {
            if let imageData = NSData(contentsOfURL: imageURL!) {
                imageView.image = UIImage(data: imageData)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
