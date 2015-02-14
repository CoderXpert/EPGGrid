//
//  EpgGridLayout.swift
//  EPG
//
//  Created by Adnan Aftab on 2/14/15.
//  Copyright (c) 2015 CX. All rights reserved.
//

import UIKit

class EpgGridLayout: UICollectionViewLayout
{
    let cellIdentifier = "EPGCollectionViewCell"
    let RELATIVE_HOUR : NSTimeInterval = (240.0)
    let ACTUAL_HOUR : NSTimeInterval = 3600.0

    var epgStartTime : NSDate!
    var epgEndTime : NSDate!
    var xPos:CGFloat = 0
    var yPos:CGFloat = 0
    var layoutInfo : NSMutableDictionary?
    var framesInfo : NSMutableDictionary?
    
    let weekTimeInterval : NSTimeInterval = (60 * 60 * 24 * 7)
    let TILE_WIDTH : CGFloat = 200
    let TILE_HEIGHT : CGFloat = 70
    
    var channels : [Channel]?
    
    override init()
    {
        super.init()
        setup()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    func setup()
    {
        var cal = NSCalendar.currentCalendar()
        var date = NSDate()
        date = cal.startOfDayForDate(date)
        date = cal.dateByAddingUnit(.DayCalendarUnit, value: -1, toDate: date, options: nil)!
        epgStartTime = date
        epgEndTime = epgStartTime.dateByAddingTimeInterval(weekTimeInterval)
        layoutInfo = NSMutableDictionary()
        framesInfo = NSMutableDictionary()
        channels = Channel.channels()
    }
    override func prepareLayout()
    {
        calculateFramesForAllPrograms()

        var newLayoutInfo = NSMutableDictionary()
        var cellLayoutInfo = NSMutableDictionary()
        if let chs = channels
        {
            var sections = chs.count
            for section in 0..<sections
            {
                var ch = chs[section]
                if let programs = ch.programs
                {
                    var numberOfItems = programs.count
                    for index in 0..<numberOfItems
                    {
                        var indexPath = NSIndexPath(forItem: index, inSection: section)
                        var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                        itemAttributes.frame = frameForItemAtIndexPath(indexPath)
                        cellLayoutInfo[indexPath] = itemAttributes
                    }
                }
                
            }
            newLayoutInfo[cellIdentifier] = cellLayoutInfo
            layoutInfo = newLayoutInfo
        }
        
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]?
    {
        var layoutAttributes  = NSMutableArray()
        layoutInfo?.enumerateKeysAndObjectsUsingBlock({ (object: AnyObject!, elementInfo: AnyObject!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            var infoDic = elementInfo as NSDictionary!
            infoDic.enumerateKeysAndObjectsUsingBlock( { (object: AnyObject!, attributes: AnyObject!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                var attr = attributes as UICollectionViewLayoutAttributes!
                if (CGRectIntersectsRect(rect, attributes.frame))
                {
                    layoutAttributes.addObject(attributes)
                }
                
            })
        })

        return layoutAttributes
    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes!
    {
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = self.frameForItemAtIndexPath(indexPath);
        return attributes
    }

    func sizeForProgramTile(program : Program) -> CGSize
    {
        var duartionFactor = program.duration / ACTUAL_HOUR
        var width :CGFloat = CGFloat(duartionFactor * RELATIVE_HOUR)
        return CGSizeMake(width, TILE_HEIGHT)
    }
    func calculateFramesForAllPrograms()
    {
        if let chs = channels
        {
            for i in 0..<chs.count
            {
                xPos = 0
                var ch = chs[i]
                if let programs = ch.programs
                {
                    for index in 0..<programs.count
                    {
                        var program = programs[index]
                        var tileSize = sizeForProgramTile(program)
                        var frame = CGRectMake(xPos, yPos, tileSize.width, tileSize.height)
                        var rectString = NSStringFromCGRect(frame)
                        var indexPath = NSIndexPath(forItem: index, inSection: i)
                        framesInfo![indexPath] = rectString
                        xPos = xPos+tileSize.width
                    }
                }
                yPos += TILE_HEIGHT
            }
        }
    }
    func frameForItemAtIndexPath(indexPath : NSIndexPath) -> CGRect
    {
        if let infoDic = framesInfo
        {
            var rectString = infoDic[indexPath] as String
            return CGRectFromString(rectString)
        }
        return CGRectZero
    }
    
    override func collectionViewContentSize() -> CGSize
    {
        if let chs = channels
        {
            var intervals = epgEndTime.timeIntervalSinceDate(epgStartTime)
            var numberOfHours = CGFloat(intervals / 3600)
            var width = numberOfHours * TILE_WIDTH
            var height = CGFloat(chs.count) * TILE_HEIGHT
            
            return CGSize(width: width, height: height)
            
        }
        return CGSizeZero
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool
    {
        if let colView = collectionView
        {
            if (!CGRectEqualToRect(colView.bounds, newBounds))
            {
                return true
            }
        }
        return false
    }
    override func invalidateLayout()
    {
        xPos = 0
        yPos = 0
        super.invalidateLayout()
    }
}
