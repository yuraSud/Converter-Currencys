
import UIKit

class CurrencyView: UIView {

    private var exchangeRateSegmentedControl = UISegmentedControl()
    let addCurrencyButton = UIButton(type: .system)
    let shareButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Functions:
    
    @objc func segmentAction(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
           
        } else if sender.selectedSegmentIndex == 1 {
            
        }
    }
    
    private func configureView(){
        setSettingsView()
        configExchangeRateSegmentedControl()
        configAddCurrencyButton()
        configShareButton()
        setUpView()
        setConstraints()
    }
    
    private func  setSettingsView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .init(width: 0, height: 5)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    private func setUpView() {
        addSubview(exchangeRateSegmentedControl)
        addSubview(addCurrencyButton)
        addSubview(shareButton)
    }
    
    private func configExchangeRateSegmentedControl() {
        exchangeRateSegmentedControl = UISegmentedControl(items: ["Sell", "Buy"])
        exchangeRateSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        exchangeRateSegmentedControl.backgroundColor = .white
        exchangeRateSegmentedControl.selectedSegmentTintColor = .systemBlue
        exchangeRateSegmentedControl.layer.cornerRadius = 10
        exchangeRateSegmentedControl.selectedSegmentIndex = 0
        exchangeRateSegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        exchangeRateSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        exchangeRateSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
    }
    
    private func configAddCurrencyButton() {
        addCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        addCurrencyButton.setTitle("Add Currency", for: .normal)
        addCurrencyButton.setImage(UIImage(named: "blue_plus"), for: .normal)
        addCurrencyButton.setTitleColor(UIColor.systemBlue, for: .normal)
        addCurrencyButton.titleLabel?.font = .systemFont(ofSize: 14)
       
//        addCurrencyButton.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    private func configShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setBackgroundImage(UIImage(named: "square.and.arrow.up"), for: .normal)
       
//        shareButton.addTarget(self, action: #selector(), for: .touchUpInside)
    }

//MARK: - Constraints:
    private func setConstraints() {
        NSLayoutConstraint.activate([
            exchangeRateSegmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            exchangeRateSegmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            exchangeRateSegmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            exchangeRateSegmentedControl.heightAnchor.constraint(equalToConstant: 40),

            addCurrencyButton.heightAnchor.constraint(equalToConstant: 35),
            addCurrencyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            //addCurrencyButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            addCurrencyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            
            shareButton.heightAnchor.constraint(equalToConstant: 25),
            shareButton.widthAnchor.constraint(equalToConstant: 20),
            shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            shareButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    
}
