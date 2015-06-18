//
//  RankingCellTableViewCell.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/18/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {
    
    
    @IBOutlet weak var statePosition: UILabel!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var stateScore: UILabel!
    @IBOutlet weak var championStateIndicator: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupRankingCell(stateName: String, stateScore: String, isChampion: Bool, statePosition: String){
        
        self.stateName.text = stateName
        self.statePosition.text = statePosition
        self.stateScore.text = stateScore
        self.championStateIndicator.hidden = isChampion
        
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
