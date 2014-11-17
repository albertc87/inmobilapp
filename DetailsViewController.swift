//
//  DetailsViewController.swift
//  inmobilapp
//
//  Created by BYRON on 17/11/14.
//  Copyright (c) 2014 Alberto Castro. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var currentInmueble : Inmueble!
    @IBOutlet var titleInmueble: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleInmueble.text = currentInmueble.title
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
