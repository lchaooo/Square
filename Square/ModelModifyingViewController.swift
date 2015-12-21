//
//  ModelModifyingViewController.swift
//  Square
//
//  Created by Bers on 15/12/13.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

class ModelModifyingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var dataManager : ProjectionDataManager?
    var modelIdentifier = "" {
        didSet{
            self.loadModelWithIdentifier(self.modelIdentifier)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func loadModelWithIdentifier(identifier: String) {
        let model = self.dataManager.projectionLocalModelWithIdentifier(identifier)
        self.titleLabel.text = model.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
