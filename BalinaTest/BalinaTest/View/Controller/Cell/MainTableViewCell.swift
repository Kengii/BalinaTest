//
//  MainTableViewCell.swift
//  BalinaTest
//
//  Created by Владимир Данилович on 25.09.23.
//

import UIKit

final class MainTableViewCell: UITableViewCell {

  @IBOutlet weak var photo: UIImageView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
