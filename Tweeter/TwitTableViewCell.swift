//
//  TwitTableViewCell.swift
//  Tweeter
//
//  Created by Andrew James on 2/13/15.
//  Copyright (c) 2015 Andrew James. All rights reserved.
//

import UIKit

class TwitTableViewCell: UITableViewCell
{
    @IBOutlet var twitTextLabel: UILabel!
    @IBOutlet var twitDateLabel: UILabel!
    @IBOutlet var twitBackground: UIView!

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib()
    {
        twitBackground.layer.cornerRadius = 5
        twitBackground.layer.masksToBounds = true
    }

}
