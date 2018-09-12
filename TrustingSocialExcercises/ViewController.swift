//
//  ViewController.swift
//  TrustingSocialExcercises
//
//  Created by Hung Nguyen Thanh on 9/10/18.
//  Copyright © 2018 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class ViewController: UIViewController {

    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankLogoImageView: UIImageView!
    @IBOutlet weak var loanInformationLabel: UILabel!
    
    var cellTypes: [InformationType]!
    var provinces: TSProvinces?
    var loanProvider: TSLoanProvider? {
        didSet {
            self.bindBankInfo()
        }
    }
    let loan = TSLoan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Gửi", style: .done, target: self, action: #selector(saveAction(_:)))
        
        self.cellTypes = [.phone, .fullname, .id, .address, .income]
        TSNetwork.sharred.getProvinces { (provinces) in
            if let provinces = provinces {
                self.provinces = provinces
            } else {
                self.showError(message: "Không thể tải được danh sách tỉnh", complete: {
                    
                })
            }
        }
        
        TSNetwork.sharred.getLoanProvider { (result) in
            if let loanProvider = result {
                self.loanProvider = loanProvider
            } else {
                self.showError(message: "Không thể tải được thông tin ngân hàng", complete: {
                    
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    
    func bindBankInfo() {
        self.bankNameLabel.text = self.loanProvider?.bank?.name
        if let loanProvider = self.loanProvider {
            if let bank = loanProvider.bank, let logoUrl = bank.logo, let url = URL(string: logoUrl) {
                TSNetwork.sharred.loadBankLogo(url: url) { (image) in
                    self.bankLogoImageView.image = image
                }
            }
            
            let fontSize: CGFloat = 14.0
            let loanInfoAttributed = NSMutableAttributedString()
            let addString = { (text: String, font: UIFont) in
                loanInfoAttributed.append(NSAttributedString(string: text, attributes: [NSAttributedStringKey.font : font]))
            }
            
            addString("Hạn mức", UIFont.boldSystemFont(ofSize: fontSize))
            addString(": \(loanProvider.minAmount!.toString(groupingSeparator: ",")) VNĐ / \(loanProvider.maxAmount!.toString(groupingSeparator: ",")) VNĐ\n", UIFont.systemFont(ofSize: fontSize))
            addString("Thời hạn", UIFont.boldSystemFont(ofSize: fontSize))
            addString(": \(loanProvider.minTenor!) - \(loanProvider.maxTenor!) tháng\n", UIFont.systemFont(ofSize: fontSize))
            addString("Lãi suất", UIFont.boldSystemFont(ofSize: fontSize))
            addString(": \(loanProvider.interestRate!)%/năm", UIFont.systemFont(ofSize: fontSize))
            
            self.loanInformationLabel.attributedText = loanInfoAttributed
        }
    }
    
    func showError(title: String = "Thông báo", message: String, complete: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Đã hiểu", style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
            complete()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validate() -> (success: Bool, errorOfType: InformationType?, errorMessage: String?) {
        var success: Bool = true
        var errorOfType: InformationType? = nil
        var errorMessage: String? = nil
        
        for type in self.cellTypes {
            switch type {
            case .phone:
                if loan.phoneNumber == nil || !loan.phoneNumber!.validate(type: .phone) {
                    success = false
                    errorOfType = .phone
                    errorMessage = "Vui lòng nhập số điện thoại của bạn"
                }
            case .fullname:
                if loan.fullName == nil || loan.fullName!.count == 0 {
                    success = false
                    errorOfType = .fullname
                    errorMessage = "Vui lòng nhập tên đầy đủ của bạn"
                }
            case .id:
                if let id = loan.nationalIDNumber, !id.validate(type: .id) {
                    success = false
                    errorOfType = .id
                    errorMessage = "Vui lòng nhập chính xác số CMND của bạn"
                }
            case .address:
                if self.loan.province == nil ||
                    (self.provinces == nil || self.provinces!.provincesList == nil || !self.provinces!.provincesList!.contains(self.loan.province!)) {
                    success = false
                    errorOfType = .address
                    errorMessage = "Vui lòng chọn tỉnh của bạn từ danh sách đưa ra"
                }
            case .income:
                if self.loan.income == nil || self.loan.income! < 3000000 {
                    success = false
                    errorOfType = .income
                    errorMessage = "Thu nhập một tháng tối thiểu phải 3 triệu"
                }
            }
            if success == false {
                break
            }
        }
        
        return (success, errorOfType, errorMessage)
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        self.tableView.endEditing(true)
        let validateResult = self.validate()
        if !validateResult.success {
            self.showError(message: validateResult.errorMessage!) {
                DispatchQueue.main.async {
                    if let index = self.cellTypes.index(of: validateResult.errorOfType!),
                        let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TSInforTableViewCell {
                        cell.textField.becomeFirstResponder()
                    }
                }
            }
        }
        
        TSNetwork.sharred.makeLoan(loan: self.loan) { (loan) in
            if let loan = loan {
                self.showError(title: "Thông báo", message: "Đã gửi request thành công, id của bạn là \(loan.id!)", complete: {
                    
                })
            } else {
                self.showError(title: "Thông báo", message: "Đã gửi request không thành công, vui lòng thử lại", complete: {
                    
                })
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TSInforTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TSInforTableViewCell", for: indexPath) as! TSInforTableViewCell
        cell.delegate = self
        cell.dataSource = self
        cell.configCell(type: self.cellTypes[indexPath.row], loan: self.loan)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController: TSInforTableViewCellDelegate {
    func infoCellDidEndEdit(cell: TSInforTableViewCell, text: String?) {
        
        let text = text ?? ""
        switch cell.type! {
        case .phone:
            loan.phoneNumber = text
        case .fullname:
            loan.fullName = text
        case .id:
            loan.nationalIDNumber = text
        case .address:
            loan.province = text
        case .income:
            loan.income = Int(text)
        }
    }
}

extension ViewController: TSInforTableViewCellDataSource {
    func infoCellNumberOfRowForPicker(cell: TSInforTableViewCell) -> Int {
        if let provinces = self.provinces, let provinceList = provinces.provincesList {
            return provinceList.count
        } else {
            return 0
        }
    }
    
    func infoCellPickerTitleOfRow(cell: TSInforTableViewCell, row: Int) -> String {
        if let provinces = self.provinces, let title = provinces[row] {
            return title
        } else {
            return ""
        }
    }
}
