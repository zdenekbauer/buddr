/// A sprite placed at a pixel offset within the sprite canvas.
struct SpriteLayer: Hashable, Sendable {
    let sprite: PixelSprite
    let x: Int
    let y: Int
}

/// One rendered picture: layers drawn bottom to top on a canvas of `canvasWidth` × `canvasHeight` pixels, with an
/// overall opacity. The frame carries its canvas because characters differ in it (`BuddySprites`).
struct SpriteFrame: Hashable, Sendable {
    var layers: [SpriteLayer]
    let canvasWidth: Int
    let canvasHeight: Int
    var opacity: Double = 1

    /// The frame flipped horizontally within its canvas.
    func mirrored() -> SpriteFrame {
        let flipped = layers.map { layer in
            SpriteLayer(sprite: layer.sprite.mirrored(), x: canvasWidth - layer.x - layer.sprite.width, y: layer.y)
        }
        return SpriteFrame(layers: flipped, canvasWidth: canvasWidth, canvasHeight: canvasHeight, opacity: opacity)
    }
}
