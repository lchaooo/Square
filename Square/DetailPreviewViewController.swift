//
//  DetailPreviewViewController.swift
//  Square
//
//  Created by Bers on 15/12/13.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

class DetailPreviewViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var dataManager : ProjectionDataManager?
    var modelIdentifier = "" {
        didSet{
            self.loadModelWithIdentifier(modelIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func loadModelWithIdentifier (identifier: String) {
        let model = self.dataManager?.projectionLocalModelWithIdentifier(identifier)
        self.titleLabel.text = model?.title
        self.descriptionTextView.text = model?.detailDescription
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func projectButtonPressed(sender: AnyObject) {

    }

}
