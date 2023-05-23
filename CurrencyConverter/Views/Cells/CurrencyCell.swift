import UIKit

class CurrencyCell: UITableViewCell {
    
    let currencyLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        currencyLabel.frame = CGRect(x: 10, y: 5, width: contentView.frame.width - 20, height: contentView.frame.height - 10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(currencyLabel)
      }
    
    func setLabel(currency: Currency){
        currencyLabel.text = currency.fullDescription
    }
}



