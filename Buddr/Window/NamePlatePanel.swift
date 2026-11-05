import AppKit
import SwiftUI

/// The floating panel with the name plate, a child window of the sheep panel so it moves along with it. It never
/// takes the mouse: clicks go through it to whatever is below.
///
/// A text longer than the plate scrolls (`NamePlateScroller`) while the panel is shown (`setScrollingPaused(_:)`), or
/// is shortened with `…` when it must not move.
final class NamePlatePanel: FloatingPanel {
    private let hostingView: NSHostingView<SpriteCanvas>
    /// Points per plate pixel.
    let scale: Int
    /// The scrolling text, while there is one.
    private var scrolling: (text: PixelSprite, scroller: NamePlateScroller)?
    private var isScrollingPaused = true

    init(scale: Int) {
        self.scale = scale
        hostingView = NSHostingView(rootView: Self.canvas(PixelSprite(width: 0, height: 0, pixels: []), scale: scale))
        // The size follows the text and is set explicitly; SwiftUI updates shouldn't resize the window.
        hostingView.sizingOptions = []
        super.init(contentRect: .zero)
        ignoresMouseEvents = true
        contentView = hostingView
    }

    /// Shows `label` and resizes the panel to fit it, keeping its origin. A text longer than the plate scrolls when
    /// `scrolls`, otherwise it is shortened.
    func show(_ label: NamePlate.Label, scrolls: Bool) {
        scrolling?.scroller.stop()
        scrolling = nil
        let text = SheepSprites.Plate.textSprite(for: label)
        guard scrolls, text.width > SheepSprites.Plate.maxTextWidth else {
            draw(SheepSprites.Plate.sprite(for: label))
            return
        }
        let scroller = NamePlateScroller(NamePlateScroll(textWidth: text.width))
        scrolling = (text, scroller)
        draw(SheepSprites.Plate.scrollingSprite(for: text, offset: 0))
        if !isScrollingPaused {
            startScrolling()
        }
    }

    /// Stops a scrolling text while the plate isn't seen, and starts it again from its start.
    func setScrollingPaused(_ paused: Bool) {
        guard paused != isScrollingPaused else { return }
        isScrollingPaused = paused
        if paused {
            scrolling?.scroller.stop()
        } else {
            startScrolling()
        }
    }

    private func startScrolling() {
        guard let (text, scroller) = scrolling else { return }
        scroller.start { [weak self] offset in
            self?.draw(SheepSprites.Plate.scrollingSprite(for: text, offset: offset))
        }
    }

    private func draw(_ sprite: PixelSprite) {
        hostingView.rootView = Self.canvas(sprite, scale: scale)
        let size = SpriteCanvas.size(gridWidth: sprite.width, gridHeight: sprite.height, scale: scale)
        if size != frame.size {
            setFrame(NSRect(origin: frame.origin, size: size), display: true)
        }
    }

    private static func canvas(_ sprite: PixelSprite, scale: Int) -> SpriteCanvas {
        SpriteCanvas(
            frame: SpriteFrame(
                layers: [SpriteLayer(sprite: sprite, x: 0, y: 0)], canvasWidth: sprite.width,
                canvasHeight: sprite.height),
            scale: scale)
    }
}
