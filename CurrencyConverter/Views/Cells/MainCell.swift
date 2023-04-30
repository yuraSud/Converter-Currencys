

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 20, height: contentView.frame.height - 20)
    }
    
    func setupStackView(){
        stack = UIStackView(arrangedSubviews: [currencyLabel,currencyTextField])
        stack.axis = .horizontal
        currencyTextField.borderStyle = .roundedRect
        currencyTextField.backgroundColor = .secondarySystemBackground
        currencyTextField.setContentHuggingPriority(.init(200), for: .horizontal)
        stack.distribution = .fill
        stack.spacing = 30
        addSubview(stack)
    }
    
    func setLabel(currency: Currency, sell: Bool, nbu: Bool = false, valueFromTF: Double){
        currencyLabel.text = currency.currency + "  👉"
      
        if currency.currency == "UAH"{
            currencyTextField.text = "\(valueFromTF)"
        }
       
        guard currency.currency != "UAH" else {return}
        
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
        return String(format: "%.3f", (valueTF / value))
    }
    
}

