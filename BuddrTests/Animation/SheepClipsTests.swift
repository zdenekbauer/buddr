import Testing

@testable import Buddr

/// The clips of every character (`Buddy`).
struct SheepClipsTests {
    @Test(arguments: Buddy.allCases)
    func clipNamesAreUnique(buddy: Buddy) {
        let names = buddy.sprites.allClips.map(\.name)
        #expect(Set(names).count == names.count)
    }

    @Test(arguments: Buddy.allCases)
    func everyClipHasFramesWithPositiveDurations(buddy: Buddy) {
        for (name, clip) in buddy.sprites.allClips {
            #expect(!clip.frames.isEmpty, "\(name)")
            #expect(clip.frames.allSatisfy { $0.duration > .zero }, "\(name)")
        }
    }

    /// Clips play to their end before a state change shows, so they must stay short.
    @Test(arguments: Buddy.allCases)
    func clipCyclesAreShort(buddy: Buddy) {
        for (name, clip) in buddy.sprites.allClips {
            #expect(clip.cycleDuration <= .milliseconds(1_600), "\(name)")
        }
    }

    @Test(arguments: Buddy.allCases)
    func everyFrameFitsOnTheCharactersCanvas(buddy: Buddy) {
        let sprites = buddy.sprites
        for (name, clip) in sprites.allClips {
            for frame in clip.frames {
                #expect(frame.sprite.canvasWidth == sprites.canvasWidth, "\(name)")
                #expect(frame.sprite.canvasHeight == sprites.canvasHeight, "\(name)")
                for layer in frame.sprite.layers {
                    #expect(layer.x >= 0 && layer.x + layer.sprite.width <= sprites.canvasWidth, "\(name)")
                    #expect(layer.y >= 0 && layer.y + layer.sprite.height <= sprites.canvasHeight, "\(name)")
                }
            }
        }
    }

    /// The canvas fills the panel exactly with whole points per pixel, so the panel keeps its size and position when
    /// the character changes and the pixels stay sharp.
    @MainActor
    @Test(arguments: Buddy.allCases)
    func canvasFillsThePanelWithWholePixels(buddy: Buddy) {
        let sprites = buddy.sprites
        let scale = SheepPanelController.defaultScale
        let pixelSize = BuddySprites.pixelSize(canvasWidth: sprites.canvasWidth, scale: scale)
        #expect(sprites.canvasWidth * pixelSize == BuddySprites.panelWidth * scale)
        #expect(sprites.canvasHeight * pixelSize == BuddySprites.panelHeight * scale)
    }

    @Test(arguments: Buddy.allCases, SheepClipID.allCases)
    func onlyTheUnknownStateIsDimmed(buddy: Buddy, id: SheepClipID) {
        let clip = buddy.sprites.clip(id)
        let expected = [.unknown, .unknownStill].contains(id) ? BuddySprites.unknownOpacity : 1
        #expect(clip.frames.allSatisfy { $0.sprite.opacity == expected })
    }

    /// A still pose is one short frame (a state change waits for it to end) made of the pictures of its state's clip,
    /// so it shows the same sign ("!", "zzz", …).
    @Test(arguments: Buddy.allCases)
    func stillPosesAreOneShortFrameOfTheirClipsPictures(buddy: Buddy) {
        let pairs: [(still: SheepClipID, animated: SheepClipID)] = [
            (.idleStill, .idleRest), (.sleepingStill, .sleeping), (.workingStill, .working),
            (.blockedStill, .blocked), (.doneStill, .doneHold), (.unknownStill, .unknown),
        ]
        for (still, animated) in pairs {
            let frames = buddy.sprites.clip(still).frames
            #expect(frames.count == 1, "\(still)")
            #expect(frames.allSatisfy { $0.duration <= .milliseconds(500) }, "\(still)")
            let clipLayers = Set(buddy.sprites.clip(animated).frames.flatMap(\.sprite.layers))
            #expect(Set(frames.flatMap(\.sprite.layers)).isSubset(of: clipLayers), "\(still)")
        }
    }
}
