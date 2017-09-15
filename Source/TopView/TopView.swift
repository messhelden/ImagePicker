import UIKit

protocol TopViewDelegate: class {

  func flashButtonDidPress(_ title: String)
  func rotateDeviceDidPress()
}

public enum CameraStage: String {
  case front = "Front-face",
  top = "Top-face",
  side = "Side-face",
  bottom = "Bottom-face",
  any = ""
}

class TopView: UIView {

  struct Dimensions {
    static let leftOffset: CGFloat = 11
    static let rightOffset: CGFloat = 7
    static let height: CGFloat = 34
  }

  var configuration = Configuration()

  var currentFlashIndex = 1
  let flashButtonTitles = ["AUTO", "ON", "OFF"]

  lazy var flashButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.setImage(AssetManager.getImage("ON"), for: UIControlState())
    button.setTitle("ON", for: UIControlState())
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    button.setTitleColor(UIColor.white, for: UIControlState())
    button.setTitleColor(UIColor.white, for: .highlighted)
    button.titleLabel?.font = self.configuration.flashButton
    button.addTarget(self, action: #selector(flashButtonDidPress(_:)), for: .touchUpInside)
    button.contentHorizontalAlignment = .left
    button.isEnabled = false
    
    return button
    }()

  lazy var stageLabel: UILabel = { [unowned self] in
    let label = UILabel()
    label.text = self.configuration.cameraStage.rawValue
    label.font = self.configuration.settingsFont
    label.textColor = .white
    
    return label
  }()
  
  lazy var rotateCamera: UIButton = { [unowned self] in
    let button = UIButton()
    button.setImage(AssetManager.getImage("cameraIcon"), for: UIControlState())
    button.addTarget(self, action: #selector(rotateCameraButtonDidPress(_:)), for: .touchUpInside)
    button.imageView?.contentMode = .center

    return button
    }()

  weak var delegate: TopViewDelegate?

  // MARK: - Initializers

  public init(configuration: Configuration? = nil) {
    if let configuration = configuration {
      self.configuration = configuration
    }
    super.init(frame: .zero)
    configure()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    var views: [UIView] = [flashButton, stageLabel]

    if configuration.canRotateCamera {
      views.append(rotateCamera)
    }

    for view in views {
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOpacity = 0.5
      view.layer.shadowOffset = CGSize(width: 0, height: 1)
      view.layer.shadowRadius = 1
      view.translatesAutoresizingMaskIntoConstraints = false
      addSubview(view)
    }

    setupConstraints()
  }

  // MARK: - Action methods

  func flashButtonDidPress(_ button: UIButton) {
    currentFlashIndex += 1
    currentFlashIndex = currentFlashIndex % flashButtonTitles.count

    switch currentFlashIndex {
    case 1:
      button.setTitleColor(UIColor(red: 0.98, green: 0.98, blue: 0.45, alpha: 1), for: UIControlState())
      button.setTitleColor(UIColor(red: 0.52, green: 0.52, blue: 0.24, alpha: 1), for: .highlighted)
    default:
      button.setTitleColor(UIColor.white, for: UIControlState())
      button.setTitleColor(UIColor.white, for: .highlighted)
    }

    let newTitle = flashButtonTitles[currentFlashIndex]

    button.setImage(AssetManager.getImage(newTitle), for: UIControlState())
    button.setTitle(newTitle, for: UIControlState())

    delegate?.flashButtonDidPress(newTitle)
  }

  func rotateCameraButtonDidPress(_ button: UIButton) {
    delegate?.rotateDeviceDidPress()
  }
}

extension TopView: ImagePickerCameraStageDelegate {
    func didTakePhoto(newStage: CameraStage) {
    stageLabel.text = newStage.rawValue
  }
}
