//
//  SignleLineTextCell.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import UIKit

protocol TextFieldCellProtocol {
    func textFieldDidChangeValue(_ indexPath: IndexPath, value: String?)
}


class TextFieldCell: BaseCell {
    
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: TextFieldCellProtocol?
    
    var cellType: CellType = .email {
        didSet {
            updateInputType()
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.placeholder = nil
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setupAppearances() {
        super.setupAppearances()
        updateInputType()
    }
    
    override func prepareViews() {
        super.prepareViews()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateInputType() -> Void {
        textField.keyboardType = .default
        switch cellType {
        case .email:
            textField.isSecureTextEntry = false
            textField.keyboardType = .emailAddress
        default:
            textField.isSecureTextEntry = false
        }
    }
    

    
}
extension TextFieldCell : UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let `cellIndex` = cellIndex else {
            return
        }
        delegate?.textFieldDidChangeValue(cellIndex, value: textField.text)
    }
}
