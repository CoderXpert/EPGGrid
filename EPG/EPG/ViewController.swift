//
//  ViewController.swift
//  EPG
//
//  Created by Adnan Aftab on 2/14/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    let cellIdentifier = "EPGCollectionViewCell"
    var channels:[Channel]?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.channels = Channel.channels()
    }
}
extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let ch = channels
        {
            return ch.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if (cell == nil)
        {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: identifier)
        }
        let channel = self.channels![indexPath.row]
        cell?.textLabel?.text = channel.channelName
        cell?.detailTextLabel?.text = channel.channelNumber
        return cell!
    }
}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        if let ch = channels
        {
            return ch.count
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let chs = channels
        {
            let ch = chs[section]
            if let programs = ch.programs
            {
                return programs.count
            }
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! EPGCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        if let chs = channels
        {
            let channel = chs[indexPath.section]
            if let programs = channel.programs
            {
                let program = programs[indexPath.row]
                cell.programName.text = "\(channel.channelName!) \(program.name!)"
                cell.programTIme.text = program.timeString
            }
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let ch = channels![indexPath.section]
        let program = ch.programs![indexPath.row]
        let message = "\(ch.channelName!) - \(program.name!)"
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle:.Alert)
        let alertAction = UIAlertAction(title: "Ok", style: .Default) {  (alert:UIAlertAction) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(alertAction)
        self .presentViewController(alert, animated: true, completion: nil)
    }
}
extension ViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (scrollView == tableView)
        {
            collectionView.contentOffset = CGPointMake(collectionView.contentOffset.x, tableView.contentOffset.y)
        }
        else
        {
            tableView.contentOffset = CGPointMake(tableView.contentOffset.x, collectionView.contentOffset.y)
        }
    }
}
