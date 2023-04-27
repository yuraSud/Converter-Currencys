

import UIKit

class MainCell: UITableViewCell {
    
    
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
       // currencyTextField.text = "Yura dfgdf"
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 30
        
        addSubview(stack)
    }
    
    func setLabel(currency: Currency, sell: Bool = true, nbu: Bool = false){
        currencyLabel.text = currency.currency + "  👉"
        if sell && nbu {
            currencyTextField.text = "\(currency.saleRateNB ?? 0)"
        } else if sell && !nbu {
            currencyTextField.text = "\(currency.saleRate ?? 0)"
        } else if !sell && nbu {
            currencyTextField.text = "\(currency.purchaseRateNB ?? 0)"
        } else if !sell && !nbu {
            currencyTextField.text = "\(currency.purchaseRate ?? 0)"
        }
    }
}
