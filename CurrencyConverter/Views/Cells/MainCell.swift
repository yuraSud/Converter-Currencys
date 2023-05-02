

import UIKit

class MainCell: UITableViewCell {
    
    var currency: Currency?
    let currencyTextField = UITextField()
    let currencyLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    var stack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.frame = CGRect(x: 10, y: 8, width: contentView.frame.width - 20, height: contentView.frame.height - 16)
    }
    
    func setupStackView(){
        stack = UIStackView(arrangedSubviews: [currencyLabel,currencyTextField])
        stack.axis = .horizontal
        currencyTextField.setContentHuggingPriority(.init(200), for: .horizontal)
        stack.distribution = .fill
        stack.spacing = 30
        addSubview(stack)
    }
    
    func setupTextField(){
        currencyTextField.borderStyle = .roundedRect
        currencyTextField.backgroundColor = .secondarySystemBackground
        currencyTextField.keyboardType = .numberPad
        currencyTextField.returnKeyType = .done
        currencyTextField.addDoneButtonToKeyboard(myAction: #selector(currencyTextField.resignFirstResponder))
    }
    
    func setLabel(sell: Bool, nbu: Bool = false, valueFromTF: Double){
        guard let currency = currency else {return}
        //currencyLabel.text = currency.currency + "  👉"
        currencyLabel.setLabelRightIcon(text: currency.currency, rightIcon: UIImage(systemName: "chevron.right"))
        currencyTextField.notLayerTF()
        
        if let value = currency.textFieldDoubleValue {
            currencyTextField.text = "\(Double(value))"
            currencyTextField.blueLayerTF()
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
    
    func conversionValue(valueCurrency: Double?, valueTF: Double) -> String {
        guard let value = valueCurrency else {return "Value not received"}
        return String(format: "%.2f", (valueTF / value))
    }
    
}

