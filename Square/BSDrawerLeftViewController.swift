//
//  BSDrawerLeftViewController.swift
//  BSDrawerController
//
//  Created by Bers on 15/12/4.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

protocol BSDrawerSelectionDelegate {
    func didSelectedItemAtIndex(index: Int);
}


class BSDrawerLeftViewController: UIViewController {
    
    var tableView : UITableView!
    var topView : UIView!
    var tableViewWidth = UIScreen.mainScreen().bounds.size.width
    var menuItemTitles : [String]!
    var cellHeight = CGFloat(80);
    var cellIdentifier = "MenuItem"
    var cellFontSize = CGFloat(18);
    var tableViewTopInset = CGFloat(150)
    var currentSelection = 0
    var delegate : BSDrawerSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.menuItemTitles == nil {
            self.menuItemTitles = [String]();
        }
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height));
        self.tableView.delegate = self;
        self.tableView.showsHorizontalScrollIndicator = false;
        self.tableView.showsVerticalScrollIndicator = false;
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.contentInset = UIEdgeInsetsMake(self.tableViewTopInset, 0, 0, 0)
        self.tableView.backgroundColor = BSDrawerMajorColor
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        if topView != nil {
            topView.center = CGPointMake(self.tableViewWidth/2, self.tableViewTopInset/2)
            self.view.addSubview(topView)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: self.currentSelection, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension BSDrawerLeftViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemTitles.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        assert(cell != nil)
        cell!.textLabel?.text = self.menuItemTitles[indexPath.row]
        cell!.textLabel?.font = UIFont.systemFontOfSize(self.cellFontSize)
        cell!.contentView.backgroundColor = indexPath.row == currentSelection ? BSDrawerHighlightedColor : BSDrawerMajorColor;
        cell!.textLabel?.textColor = indexPath.row == currentSelection ? UIColor.whiteColor() : BSDrawerTextColor
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentSelection = indexPath.row
        self.delegate?.didSelectedItemAtIndex(indexPath.row)
    }
}