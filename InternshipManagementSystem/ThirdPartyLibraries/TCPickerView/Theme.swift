 



import UIKit

 

public protocol TCPickerViewInput {
    var values: [TCPickerView.Value] { set get }
    var selection: TCPickerView.Mode { set get } // none / single / multiply
    var isSearchEnabled: Bool { set get }
    var completion: TCPickerView.Completion? { set get } // use it to get result after user press Done
    var closeAction: TCPickerView.CloseAction? { set get }
    var searchResult: TCPickerView.SearchResult? { set get }
   
    var title: String { set get }
    var theme: TCPickerViewThemeType { set get }
    
    init(size: CGSize?) // desing your own picker size
    func show()
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    func dequeue(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell & TCPickerCellType
}

open class TCPickerView: UIView, UITableViewDataSource, UITableViewDelegate, TCPickerViewInput {
    
    private struct Consts {
        static let buttonsHeight: CGFloat = 50.0
        static let tableViewCellIdentifier = "TableViewCell"
    }

    public typealias Completion = ([Int]) -> Void
    public typealias CloseAction = () -> ()
    public typealias SearchResult = (String) -> ()
    
    private(set) lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Select"
        label.textAlignment = .center
        label.text = title
        return label
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            TCPickerTableViewCell.self,
            forCellReuseIdentifier: Consts.tableViewCellIdentifier
        )
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(
            top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.tintColor = .clear
        return tableView
    }()
    
    private(set) lazy var doneButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(TCPickerView.done), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private(set) lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(TCPickerView.close), for: .touchUpInside)
        button.setTitle("Close", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private(set) lazy var headerSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        searchBar.backgroundImage = .init()
        searchBar.backgroundColor = .clear
        searchBar.tintColor = theme.searchColor
        searchBar.textField?.textColor = theme.searchColor
        searchBar.textField?.leftView?.tintColor = theme.searchColor
        return searchBar
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerView,
            searchBar,
            headerSeparator,
            tableView,
            footerView
        ])
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private(set) lazy var headerView: UIView = {
        let header = UIView(frame: .zero)
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        header.addSubviewWithConstraints(stackView)
        
        return header
    }()
    
    private(set) lazy var footerView: UIView = {
        let footer = UIView(frame: .zero)
        let stackView = UIStackView(arrangedSubviews: [doneButton, closeButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        footer.addSubviewWithConstraints(stackView)
        
        return footer
    }()
    
    public var values: [Value] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    public var title: String = "Select" {
        didSet {
            titleLabel.text = self.title
        }
    }
    public var isSearchEnabled: Bool = false {
        didSet {
            searchBar.isHidden = !isSearchEnabled
        }
    }
   
    public var closeAction: CloseAction?
    public var completion: Completion?
    public var searchResult: SearchResult?
    public var selection: Mode = .multiply
    public var theme: TCPickerViewThemeType = TCPickerViewDefaultTheme() {
        didSet {
            change(theme)
        }
    }

    convenience init() {
        self.init(size: nil)
    }
    
    public required init(size: CGSize? = nil) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let frame: CGRect = CGRect(x: 0, y: 0, width: screenWidth,
            height: screenHeight)

        let width: CGFloat = screenWidth - 84
        let height: CGFloat = 400
        var containerFrame: CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        if let size = size {
            containerFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        super.init(frame: frame)
        containerView.frame = containerFrame
        setupUI()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        containerView.frame = frame
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func topWindow() -> UIWindow? {
      if let window = UIApplication.shared.windows.last(where: {
        // https://github.com/devxoul/Toaster/issues/152
        KeyboardObserver.shared.didKeyboardShow || $0.isOpaque
      }), window !== self {
        return window
      }
      return nil
    }
    

    open func show() {
       
        let window = self.topWindow() 
        
        window?.addSubview(self)
        window?.bringSubviewToFront(self)
        window?.endEditing(true)
        UIView.animate(withDuration: 0.3, delay: 0.0,
            usingSpringWithDamping: 0.7, initialSpringVelocity: 3.0,
            options: .allowAnimatedContent, animations: {
            self.containerView.center = self.center
            self.tableView.reloadData()
        }) { (isFinished) in
            self.layoutIfNeeded()
        }
    }
    
    open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    open func registerCell(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    open func dequeue(withIdentifier identifier: String,
        for indexPath: IndexPath) -> UITableViewCell & TCPickerCellType {
        return tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as! UITableViewCell & TCPickerCellType
    }
    
    @objc private func done() {
        var indexes: [Int] = []
        for i in 0..<self.values.count {
            if self.values[i].isChecked {
                indexes.append(i)
            }
        }
        self.completion?(indexes)
        self.hide()
    }
    
    @objc private func close() {
        self.hide()
        self.closeAction?()
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.7, delay: 0.0,
            usingSpringWithDamping: 1, initialSpringVelocity: 1.0,
            options: .allowAnimatedContent, animations: {
            self.containerView.center = CGPoint(x: self.center.x, y: self.center.y + self.frame.size.height)
        }) { (isFinished) in
            self.removeFromSuperview()
        }
    }
    //MARK: UITableViewDataSource methods
    
    public func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = self.values[indexPath.row]
        var cell: UITableViewCell & TCPickerCellType = tableView.dequeueReusableCell(
            withIdentifier: Consts.tableViewCellIdentifier,
            for: indexPath
        ) as! TCPickerTableViewCell
         
        cell.viewModel = TCPickerModel(
            title: value.title,
            isChecked: value.isChecked
        )
        return cell
    }
    
    //MARK: UITableViewDelegate methods
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var values = self.values
        switch self.selection {
            case .none: return
            case .single:
                for i in 0..<values.count {
                    values[i].isChecked = false
                }
                values[indexPath.row].isChecked = true
            case .multiply:
                values[indexPath.row].isChecked = !values[indexPath.row].isChecked
        }
        self.values = values
      
    }
}

extension TCPickerView {
    fileprivate func setupUI() {
        addSubview(containerView)
        containerView.center = CGPoint(
            x: self.center.x,
            y: self.center.y + self.frame.size.height
        )
        containerView.addSubviewWithConstraints(containerStackView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(
            equalToConstant: theme.headerHeight,
            identifier: .height
        ).isActive = true
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.heightAnchor.constraint(
            equalToConstant: 50.0,
            identifier: .height
        ).isActive = true
        
        searchBar.isHidden = !isSearchEnabled
        change(theme)
    }
}

extension TCPickerView: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult?(searchText)
    }
}

fileprivate extension UIView {
    func addSubviewWithConstraints(_ view: UIView,
                                   leading: CGFloat = 0.0,
                                   trailing: CGFloat = 0.0,
                                   top: CGFloat = 0.0,
                                   bottom: CGFloat = 0.0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom).isActive = true
    }
}

extension UISearchBar {
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        }

        guard let firstSubview = subviews.first else {
            return nil
        }

        for view in firstSubview.subviews {
            if let textView = view as? UITextField {
                return textView
            }
        }

        return nil
    }
}



 


public protocol TCPickerViewThemeType {
    var doneText: String { get }
    var closeText: String { get }
    
    var backgroundColor: UIColor { get }
    var titleColor: UIColor { get }
    var doneTextColor: UIColor { get }
    var closeTextColor: UIColor { get }
    var headerBackgroundColor: UIColor { get }
    var doneBackgroundColor: UIColor { get }
    var closeBackgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    
    var buttonsFont: UIFont { get }
    var titleFont: UIFont { get }
    
    var rowHeight: CGFloat { get }
    var headerHeight: CGFloat { get }
    var cornerRadius: CGFloat { get }
    
    var searchColor: UIColor {  get }
    init()
}

public final class TCPickerViewDefaultTheme: TCPickerViewThemeType {
    public required init() {}
}

extension TCPickerViewThemeType {
    public var doneText: String {
        return "Done"
    }
    
    public var closeText: String {
        return "Close"
    }
    
    public var backgroundColor: UIColor {
        return .white
    }
    
    public var titleColor: UIColor {
        return .white
    }
    
    public var doneTextColor: UIColor {
        return .white
    }
    
    public var closeTextColor: UIColor {
        return .white
    }
    
    public var headerBackgroundColor: UIColor {
        return UIColor(red: 75/255, green: 178/255, blue: 218/255, alpha: 1)
    }
    
    public var doneBackgroundColor: UIColor {
        return UIColor(red: 75/255, green: 178/255, blue: 218/255, alpha: 1)
    }
    
    public var closeBackgroundColor: UIColor {
        return UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
    }
    
    public var separatorColor: UIColor {
        return .white
    }
    
    public var buttonsFont: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    
    public var titleFont: UIFont{
        return UIFont.boldSystemFont(ofSize: 18)
    }
    
    public var rowHeight: CGFloat {
        return 50
    }
    
    public var headerHeight: CGFloat {
        return 60
    }
    
    public var cornerRadius: CGFloat {
        return 15.0
    }
    
    public var searchColor: UIColor {
        return .black
    }
}


 

extension TCPickerView {
    func change(_ theme: TCPickerViewThemeType) {
        titleLabel.textColor = theme.titleColor
        titleLabel.backgroundColor = theme.headerBackgroundColor
        titleLabel.font = theme.titleFont
        containerView.layer.cornerRadius = theme.cornerRadius
        containerView.backgroundColor = theme.backgroundColor
        tableView.rowHeight = theme.rowHeight
        tableView.backgroundColor = theme.backgroundColor
        doneButton.setTitleColor(theme.doneTextColor, for: .normal)
        doneButton.backgroundColor = theme.doneBackgroundColor
        doneButton.setTitle(theme.doneText, for: .normal)
        doneButton.titleLabel?.font = theme.buttonsFont
        closeButton.setTitleColor(theme.closeTextColor, for: .normal)
        closeButton.backgroundColor = theme.closeBackgroundColor
        closeButton.setTitle(theme.closeText, for: .normal)
        closeButton.titleLabel?.font = theme.buttonsFont
        headerSeparator.backgroundColor = theme.separatorColor
        headerView.constraint(withIdentifier: .height)?.constant = theme.headerHeight
        searchBar.textField?.textColor = theme.searchColor
        searchBar.textField?.leftView?.tintColor = theme.searchColor
        searchBar.tintColor = theme.searchColor
    }
}


public extension TCPickerView {
    enum Mode {
        case none
        case single
        case multiply
    }
}


public extension TCPickerView {
    struct Value {
        public let title: String
        public var isChecked: Bool
        
        public init(title: String, isChecked: Bool = false) {
            self.title = title
            self.isChecked = isChecked
        }
    }
}



public struct TCPickerModel {
    public let title: String
    public let isChecked: Bool
}

public protocol TCPickerCellType {
    var viewModel: TCPickerModel? { set get }
    func updateUI()
}

class TCPickerTableViewCell: UITableViewCell, TCPickerCellType {

    var viewModel: TCPickerModel? {
        didSet {
            self.updateUI()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUI()
    }
    
    private var checkmark: UIImage {
        var image = UIImage()
        let podBundle = Bundle(for: TCPickerView.self)
        if let url = podBundle.url(forResource: "TCPickerView", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            image = UIImage(named: "checkmark_icon", in: bundle, compatibleWith: nil)!
        } else {
            return UIImage(named: "checkmark_icon")!
        }
        return image
    }
    private var titleLabel: UILabel = UILabel(frame: CGRect.zero)
    private var checkmarkImageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    fileprivate func initialize() {
        self.checkmarkImageView.contentMode = .scaleAspectFit
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(self.checkmarkImageView)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.checkmarkImageView.addConstraint(NSLayoutConstraint(item: self.checkmarkImageView,
            attribute: .height, relatedBy: .equal, toItem: nil,
            attribute: .height, multiplier: 1.0, constant: 24))
        self.checkmarkImageView.addConstraint(NSLayoutConstraint(item: self.checkmarkImageView,
            attribute: .width, relatedBy: .equal, toItem: nil,
            attribute: .width, multiplier: 1.0, constant: 24))
        self.addConstraint(NSLayoutConstraint(item: self,
            attribute: .trailing, relatedBy: .equal, toItem: self.checkmarkImageView,
            attribute: .trailing, multiplier: 1.0, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self.checkmarkImageView,
            attribute: .centerY, relatedBy: .equal, toItem: self,
            attribute: .centerY, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel,
            attribute: .leading, relatedBy: .equal, toItem: self,
            attribute: .leading, multiplier: 1.0, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel,
            attribute: .top, relatedBy: .equal, toItem: self,
            attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel,
            attribute: .bottom, relatedBy: .equal, toItem: self,
            attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel,
            attribute: .trailing, relatedBy: .equal, toItem: imageView,
            attribute: .leading, multiplier: 1.0, constant: 8))
        self.selectionStyle = .none
    }
    
    func updateUI() {
        self.titleLabel.text = self.viewModel?.title ?? ""
        self.checkmarkImageView.image = self.viewModel?.isChecked == true ?
            self.checkmark : UIImage()
    }
}


public enum ConstraintIdentifier: String {
    case leading, trailing, top, bottom, height, width
}

public extension NSLayoutDimension {
    func constraint(equalToConstant c: CGFloat, identifier: ConstraintIdentifier) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: c)
        constraint.identifier = identifier.rawValue
        return constraint
    }
}

public extension UIView {
    func constraint(withIdentifier: ConstraintIdentifier) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == withIdentifier.rawValue }.first
    }
}
