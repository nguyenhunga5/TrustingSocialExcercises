//
//  TSInforTableViewCell.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/11/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import TextFieldEffects

protocol TSInforTableViewCellDelegate: class {
    func infoCellDidEndEdit(cell: TSInforTableViewCell, text: String?)
}

protocol TSInforTableViewCellDataSource: class {
    func infoCellNumberOfRowForPicker(cell: TSInforTableViewCell) -> Int
    func infoCellPickerTitleOfRow(cell: TSInforTableViewCell, row: Int) -> String
}

class TSInforTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: JiroTextField!
    weak var delegate: TSInforTableViewCellDelegate?
    weak var dataSource: TSInforTableViewCellDataSource?
    
    var type: InformationType? {
        didSet {
            self.textField.placeholder = self.type?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(type: InformationType, loan: TSLoan) {
        self.type = type
        self.textField.inputView = nil
        switch type {
        case .phone:
            self.textField.text = loan.phoneNumber ?? ""
            self.textField.keyboardType = .numberPad
        case .fullname:
            self.textField.text = loan.fullName ?? ""
            self.textField.keyboardType = .default
        case .id:
            self.textField.text = loan.nationalIDNumber ?? ""
            self.textField.keyboardType = .numberPad
        case .address:
            self.textField.text = loan.province ?? ""
            let pickerView = UIPickerView(frame: .zero)
            pickerView.dataSource = self
            pickerView.delegate = self
            self.textField.inputView = pickerView
        case .income:
            self.textField.text = loan.monthlyIncome != nil ? String(loan.monthlyIncome!) : ""
            self.textField.keyboardType = .numberPad
        }
    }
}

extension TSInforTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.infoCellDidEndEdit(cell: self, text: textField.text)
    }
}

extension TSInforTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource?.infoCellNumberOfRowForPicker(cell: self) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSource?.infoCellPickerTitleOfRow(cell: self, row: row) ?? ""
    }
}

extension TSInforTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
    }
}
