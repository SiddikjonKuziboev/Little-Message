//
//  MessageTVC.swift
//  LittleMessenger
//
//  Created by Kuziboev Siddikjon on 2/11/22.
//

import UIKit



class MessageTVC: UITableViewCell {

    static let identifier = "MessageTVC"
    static func unib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    
    @IBOutlet weak var checkImg: UIImageView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var textLbl: UILabel!
    
    
    
    var trailingConst : NSLayoutConstraint!
    var leadingConst: NSLayoutConstraint!

    
    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConst.isActive = false
        trailingConst.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.bounds.height * 0.15
        textLbl.textColor = .black
        timeLbl.textColor = .lightGray
        containerView.addShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor, offSet: CGSize(width: 0.0, height: 2.0), radius: 0)
    }
    
  
    func updateCell(message: MessageRealmData){
        
        trailingConst = containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        leadingConst = containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        textLbl.text = message.text
        timeLbl.text = GetDate.dateToString(date: message.created_at , format: "HH:mm")
        
        if message.user == Keys.first {
            
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner]
            checkImg.isHidden = false
            trailingConst.isActive = true
            textLbl.textAlignment = .right
            containerView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            
        }else if message.user == Keys.third {
            containerView.backgroundColor = .white
            checkImg.isHidden = true
            leadingConst.isActive = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            textLbl.textAlignment = .left
        }
        else{
            
            containerView.backgroundColor = .white
            checkImg.isHidden = true
            leadingConst.isActive = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            textLbl.textAlignment = .left

        }
    }
    
    
    
}
