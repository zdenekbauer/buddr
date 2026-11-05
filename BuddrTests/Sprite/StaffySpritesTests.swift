import Testing

@testable import Buddr

struct StaffySpritesTests {
    @Test func gridsAreValid() {
        for (name, rows) in StaffySprites.allGrids {
            #expect(PixelSprite.problems(rows: rows, palette: StaffySprites.palette) == [], "\(name)")
        }
    }

    @Test func effectGridsAreValid() {
        for (name, rows) in StaffySprites.allEffectGrids {
            #expect(PixelSprite.problems(rows: rows, palette: SheepSprites.palette) == [], "\(name)")
        }
    }

    @Test func bodyVariantsShareTheirSize() {
        typealias Grid = StaffySprites.Grid
        let bodies = [Grid.bodyStand, Grid.bodyTrotA, Grid.bodyTrotB, Grid.bodyGallop, Grid.bodyJump, Grid.bodyLying]
        #expect(Set(bodies.map(\.count)).count == 1)
        #expect(Set(bodies.flatMap { $0.map(\.count) }).count == 1)
    }

    @Test func headVariantsShareTheirSize() {
        typealias Grid = StaffySprites.Grid
        let heads = [
            Grid.headNormal, Grid.headBlink, Grid.headLook, Grid.headBark, Grid.headContent, Grid.headYawn,
            Grid.headAsleep,
        ]
        #expect(Set(heads.map(\.count)).count == 1)
        #expect(Set(heads.flatMap { $0.map(\.count) }).count == 1)
    }

    /// The eye must stand out from the black coat around it.
    @Test func eyeContrastsWithTheCoat() throws {
        let eye = try #require(StaffySprites.palette["e"])
        let coatColor = try #require(StaffySprites.palette["B"])
        #expect(abs(Self.luminance(eye) - Self.luminance(coatColor)) > 0.15)
    }

    /// The dog's head is high on the canvas, so the effects are placed around it: none may cover the head, or "!",
    /// "?" and the hearts would hide its face.
    @Test func effectsDoNotCoverTheHead() {
        for (name, clip) in StaffySprites.sprites.allClips {
            for frame in clip.frames {
                // The first two layers are the body and the head.
                let head = frame.sprite.layers[1]
                for effect in frame.sprite.layers.dropFirst(2) {
                    #expect(!Self.overlap(head, effect), "\(name): effect at (\(effect.x), \(effect.y))")
                }
            }
        }
    }

    /// Whether an opaque pixel of `a` lies on an opaque pixel of `b`.
    private static func overlap(_ a: SpriteLayer, _ b: SpriteLayer) -> Bool {
        (0..<a.sprite.height).contains { y in
            (0..<a.sprite.width).contains { x in
                a.sprite.color(x: x, y: y) != nil && b.sprite.color(x: a.x + x - b.x, y: a.y + y - b.y) != nil
            }
        }
    }

    private static func luminance(_ color: PixelColor) -> Double {
        (0.2126 * Double(color.red) + 0.7152 * Double(color.green) + 0.0722 * Double(color.blue)) / 255
    }
}
