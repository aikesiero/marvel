//
//  CharactersListItemCell.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import UIKit

final class CharactersListItemCell: UITableViewCell {
    static let reuseIdentifier = String(describing: CharactersListItemCell.self)
    static let height = CGFloat(80)

    @IBOutlet private var nameLabel: UILabel!

    private var viewModel: CharactersListItemViewModel!

    func fill(with viewModel: CharactersListItemViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
    }

}
