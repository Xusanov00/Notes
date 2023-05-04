//
//  CollectionViewCell.swift
//  Notes
//
//  Created by Ali on 19/04/23.
//

import UIKit
import SnapKit

class TaskCollectionViewCell: UICollectionViewCell {
    static let id = "TaskCollectionViewCell"
    
    //background view for note sort cell
    let backView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = ((UIScreen.main.bounds.width/4)-30)/2.9
        return view
    }()
    
    let cellTitleName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "All"
        label.isHidden = true
        label.font = UIFont(name: "ChalkboardSE-bold", size: 17)
        return label
    }()
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backView.layer.borderWidth = 5
                UIView.animate(withDuration: 0.1, delay: 0) {
                    self.backView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }
            } else {
                backView.layer.borderWidth = 1.5
                UIView.animate(withDuration: 0.1, delay: 0) {
                    self.backView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    
    ///Setting collView Layout Constraints
    func setUpLayoutConstraints() {
        contentView.addSubview(backView)
        backView.addSubview(cellTitleName)
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }
        
        cellTitleName.snp.makeConstraints({$0.edges.equalTo(3)})
    }
    
    
    ///Updates collView cell's items value
    func updateCell(cell: UIColor) {
        backView.backgroundColor = cell
    }
    
    
}


