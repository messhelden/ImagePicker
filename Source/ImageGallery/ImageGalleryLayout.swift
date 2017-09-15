import UIKit

class ImageGalleryLayout: UICollectionViewFlowLayout {

  let configuration: Configuration

  init(configuration: Configuration) {
    self.configuration = configuration
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributes = super.layoutAttributesForElements(in: rect) else {
      return super.layoutAttributesForElements(in: rect)
    }

    var newAttributes = [UICollectionViewLayoutAttributes]()
    for attribute in attributes {
      // swiftlint:disable force_cast
      let next = attribute.copy() as! UICollectionViewLayoutAttributes
      next.transform = configuration.rotationTransform
      newAttributes.append(next)
    }

    return newAttributes
  }
}
