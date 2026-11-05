/// Everything one character (`Buddy`) shows: the clips of the state machine, the escape clips and the petting
/// reaction, on the character's own canvas.
///
/// The panel has the same size for every character, so switching them never moves or resizes it: `panelWidth` ×
/// `panelHeight` units of the panel's scale. A character's canvas fills it with pixels of
/// `pixelSize(canvasWidth:scale:)` points – the sheep's canvas is the panel (one pixel per unit), the dog's has finer
/// pixels. Every frame carries its canvas, so a frame of the previous character is still drawn right.
struct BuddySprites: Sendable {
    static let panelWidth = 22
    static let panelHeight = 20
    /// Opacity of the whole picture while the state is unknown.
    static let unknownOpacity = 0.45

    /// Clips of leaving the screen and coming back, played by `SheepEscape`. The character faces left; moving right
    /// uses the mirrored frames.
    struct Escape: Sendable {
        /// A startled hop before running away from a fullscreen window.
        let startle: AnimationClip
        /// A slow yawn before wandering off bored (hiding).
        let yawn: AnimationClip
        /// Standing still for a moment, shown mirrored when the character turns around.
        let turn: AnimationClip
        /// Running, looped while the panel moves.
        let run: AnimationClip
        /// A slow walk, looped while the panel moves.
        let walk: AnimationClip
        /// Catching breath after coming back.
        let arrive: AnimationClip
    }

    /// Size of the canvas in the character's pixels: the character plus room for effects above and behind it.
    let canvasWidth: Int
    let canvasHeight: Int
    private let clips: [SheepClipID: AnimationClip]
    let escape: Escape
    /// The reaction to a click, played by the driver as an interjection, outside the state machine.
    let petted: AnimationClip

    init(
        canvasWidth: Int, canvasHeight: Int, clip: (SheepClipID) -> AnimationClip, escape: Escape,
        petted: AnimationClip
    ) {
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        clips = Dictionary(uniqueKeysWithValues: SheepClipID.allCases.map { ($0, clip($0)) })
        self.escape = escape
        self.petted = petted
    }

    /// Points per pixel of a canvas `canvasWidth` pixels wide that fills the panel drawn at `scale`. Whole for every
    /// character at the default scale (checked by tests).
    static func pixelSize(canvasWidth: Int, scale: Int) -> Int {
        scale * panelWidth / canvasWidth
    }

    func clip(_ id: SheepClipID) -> AnimationClip {
        clips[id]!
    }

    /// Every clip with a name: the state machine's, the escape's and the petting reaction.
    var allClips: [(name: String, clip: AnimationClip)] {
        SheepClipID.allCases.map { ("\($0)", clip($0)) } + [
            ("escapeStartle", escape.startle),
            ("escapeYawn", escape.yawn),
            ("escapeTurn", escape.turn),
            ("escapeRun", escape.run),
            ("escapeWalk", escape.walk),
            ("escapeArrive", escape.arrive),
            ("petted", petted),
        ]
    }
}

/// The character in the corner, chosen in the menu bar (`Preferences.buddy`).
enum Buddy: String, CaseIterable, Sendable {
    case sheep
    case staffy

    var sprites: BuddySprites {
        switch self {
        case .sheep: SheepSprites.sprites
        case .staffy: StaffySprites.sprites
        }
    }

    /// What the character is called in the menu bar: the choice, and "Show Sheep".
    var name: String {
        switch self {
        case .sheep: "Sheep"
        case .staffy: "Staffy"
        }
    }
}
