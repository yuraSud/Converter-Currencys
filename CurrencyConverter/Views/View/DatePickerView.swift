
import UIKit

class DatePickerView: UIView {

    let view = UIView()
    let titleLabel = UILabel()
    let datePicker = UIDatePicker()
    let okButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    var minimumDate: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setBlurEffect()
        setUpView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setUpView() {
        addSubview(view)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(okButton)
        view.addSubview(cancelButton)
    }
    
    fileprivate func configureTitleLabel() {
        titleLabel.text = "Select date to search for the National Bank exchange rate"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .link
    }
    
    func configureView(){
        view.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        configureTitleLabel()
        configureDatePicker()
        configureButtons()
        setSettingsShadowView()
    }
    
    func configureButtons(){
        okButton.setTitle("OK", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        let buttons = [okButton,cancelButton]
        buttons.forEach { button in
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 15
            button.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    
    func setBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight )
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.95
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    private func  setSettingsShadowView() {
        self.backgroundColor = .secondaryLabel
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .init(width: 2, height: 5)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
    }
    
    func configureDatePicker(){
        configureMinimumDate()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.minimumDate = minimumDate
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "uk")
        
    }
    
//    func formateDate() -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//        return dateFormatter.string(from: datePicker.date)
//    }
    
    func configureMinimumDate(){
        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 1
        dateComponents.day = 1
        let userCalendar = Calendar.current
        minimumDate = userCalendar.date(from: dateComponents)
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            //view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 35),
            
            okButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -15),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            okButton.heightAnchor.constraint(equalToConstant: 35),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(lessThanOrEqualTo: okButton.topAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor)
        ])
    }
}
