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
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let channels = channels else { return 0}
        return channels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        let channel = self.channels![indexPath.row]
        cell?.textLabel?.text = channel.channelName
        cell?.detailTextLabel?.text = channel.channelNumber
        return cell!
    }
}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let channels = channels else { return 0}
        return channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let channel = channels?[section], let programs = channel.programs else { return 0 }
        return programs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EPGCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        guard let channel = channels?[indexPath.section], let programs = channel.programs else { return cell }
        
        let program = programs[indexPath.row]
        cell.programName.text = "\(channel.channelName!) \(program.name!)"
        cell.programTIme.text = program.timeString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ch = channels![indexPath.section]
        let program = ch.programs![indexPath.row]
        let message = "\(ch.channelName!) - \(program.name!)"
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle:.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) {  (alert:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        self .present(alert, animated: true, completion: nil)
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == tableView) {
            collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: tableView.contentOffset.y)
        }
        else {
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: collectionView.contentOffset.y)
        }
    }
}
