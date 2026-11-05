import SwiftUI

/// Root view of the sheep panel.
struct SheepView: View {
    let animation: SheepAnimationDriver
    let scale: Int

    var body: some View {
        let frame = animation.sprite
        SpriteCanvas(frame: frame, scale: BuddySprites.pixelSize(canvasWidth: frame.canvasWidth, scale: scale))
    }

    /// The same for every character: its canvas fills the panel (`BuddySprites.pixelSize(canvasWidth:scale:)`).
    static func size(scale: Int) -> CGSize {
        SpriteCanvas.size(gridWidth: BuddySprites.panelWidth, gridHeight: BuddySprites.panelHeight, scale: scale)
    }
}
