//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by Ali on 26/04/23.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    let scWidth = UIScreen.main.bounds.width
    let scHeight = UIScreen.main.bounds.height
    
    static let id = "NotesTableViewCell"
    
    //cell background view
    lazy var cellBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.systemOrange.cgColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    //view for separator line with 1px height
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    //Title Label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-bold", size: 17)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.setLineSpacing(lineSpacing: 5, lineHeightMultiple: 5)
        return label
    }()
    
    //Title Label
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-light", size: 15)
        label.textColor = .label
        label.textAlignment = .natural
        label.setLineSpacing(lineHeightMultiple: 0.67)
        label.numberOfLines = 0
        return label
    }()
    
    //Title Label
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ChalkboardSE-regular", size: 12)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    ///Updates tableView cell's items value
    func updateCell(cell: NoteDataModel) {
        cellBackView.backgroundColor = UIColor(named: cell.color)!
        titleLabel.text = cell.title
        dateLabel.text = cell.date
        subTitleLabel.text = cell.subTitle
        if cell.subTitle == "" {
            separatorView.isHidden = true
        }else {
            separatorView.isHidden = false
        }
    }
    
    
    ///Setting tableView Layout Constraints
    func setUpLayoutConstraints() {
        
        contentView.addSubview(cellBackView)
        contentView.backgroundColor = .appColor(color: .mainBack)
        cellBackView.addSubview(dateLabel)
        cellBackView.addSubview(titleLabel)
        cellBackView.addSubview(separatorView)
        cellBackView.addSubview(subTitleLabel)
        
        
        cellBackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.left.right.equalTo(contentView).inset(15)
            make.height.equalTo(100)
        }
        
        
        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.top.equalTo(cellBackView).inset(5)
            make.right.equalTo(cellBackView).inset(10)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(cellBackView).inset(20)
            make.top.equalTo(cellBackView).inset(15)
            make.height.equalTo(30)
            make.right.equalTo(dateLabel.snp.left).offset(-5)
        }
        
        separatorView.snp.makeConstraints { make in
            make.left.right.equalTo(cellBackView).inset(15)
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.left.right.equalTo(cellBackView).inset(15)
            make.bottom.equalTo(cellBackView).inset(10)
        }
        
        
        
    }
    
}



