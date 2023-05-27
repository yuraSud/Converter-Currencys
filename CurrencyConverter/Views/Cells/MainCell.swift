

import UIKit

class MainCell: UITableViewCell {
    
    var currency: Currency?
    let currencyTextField = UITextField()
    var stack = UIStackView()
    
    let currencyLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.frame = CGRect(x: 10, y: 8, width: contentView.frame.width - 20, height: contentView.frame.height - 16)
    }
    
    func setLabel(sell: Bool, nbu: Bool, valueFromTF: Double){
        guard let currency = currency else {return}
        currencyLabel.setLabelRightIcon(text: currency.currency, rightIcon: UIImage(systemName: "chevron.right"))
        contentView.isUserInteractionEnabled = true
        currencyTextField.notLayerTF()
        
        if let value = currency.textFieldDoubleValue {
            currencyTextField.text = "\(Double(value))"
            return
        }
       
        guard currency.currency != "UAH" else {
            currencyTextField.text = String(format: "%.2f", valueFromTF)
            return}
        
        if sell && nbu {
            currencyTextField.text = conversionValue(valueCurrency: currency.saleRateNB, valueTF: valueFromTF)
        } else if sell && !nbu {
            currencyTextField.text = conversionValue(valueCurrency: currency.saleRate, valueTF: valueFromTF)
        } else if !sell && nbu {
            currencyTextField.text = conversionValue(valueCurrency: currency.purchaseRateNB, valueTF: valueFromTF)
        } else if !sell && !nbu {
            currencyTextField.text = conversionValue(valueCurrency: currency.purchaseRate, valueTF: valueFromTF)
        }
    }
    
    private func setupStackView(){
        currencyTextField.setContentHuggingPriority(.init(200), for: .horizontal)
        stack = UIStackView(arrangedSubviews: [currencyLabel,currencyTextField])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 30
        addSubview(stack)
    }
    
    private func setupTextField(){
        currencyTextField.borderStyle = .roundedRect
        currencyTextField.backgroundColor = .secondarySystemBackground
        currencyTextField.keyboardType = .numberPad
        currencyTextField.returnKeyType = .done
        currencyTextField.clearButtonMode = .whileEditing
        currencyTextField.addDoneButtonToKeyboard(myAction: #selector(currencyTextField.resignFirstResponder))
    }
    
    private func conversionValue(valueCurrency: Double?, valueTF: Double) -> String {
        guard let value = valueCurrency else {return "Value not received"}
        return String(format: "%.2f", (valueTF / value))
    }
    
}

