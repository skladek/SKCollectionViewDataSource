import UIKit

class TextCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 10.0
    }
}
