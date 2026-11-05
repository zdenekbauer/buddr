// All pixel data of the Staffordshire Bull Terrier lives in this file: the palette, the grids, the effect
// glyphs drawn to its size, how they are composed into frames, and the frame timing of every clip.
//
// The dog has a finer canvas than the sheep (33 × 30 pixels filling the same panel, 4 points per pixel at the default
// scale instead of 6), so it can show what makes it a Staffy: the broad head with cheeks, the white blaze and muzzle,
// the grin with the tongue out, the rose ears, the white chest and socks. It is black, with white markings. It stands in
// a three-quarter view, the head turned to the viewer and the body to the right; running right uses the mirrored frames
// like the sheep's.

enum StaffySprites {
    static let canvasWidth = 33
    static let canvasHeight = 30
    static let sprites = makeSprites()

    /// Top-left corner of the body on the canvas when standing; the head is drawn on top, offset by `headX`/`headY`.
    static let bodyX = 0
    static let bodyY = 10
    static let headX = 1
    static let headY = -2

    // MARK: Palette

    static let palette: [Character: PixelColor] = [
        "O": PixelColor(red: 0x16, green: 0x12, blue: 0x1A),  // outline
        "B": PixelColor(red: 0x4A, green: 0x44, blue: 0x50),  // coat
        "b": PixelColor(red: 0x34, green: 0x30, blue: 0x3A),  // ears, belly, the far hind leg
        "L": PixelColor(red: 0xF4, green: 0xEE, blue: 0xE4),  // blaze, muzzle, chest, socks
        "K": PixelColor(red: 0x0E, green: 0x0A, blue: 0x10),  // nose, mouth
        "P": PixelColor(red: 0xE8, green: 0x70, blue: 0x7E),  // tongue
        "e": PixelColor(red: 0x0E, green: 0x0A, blue: 0x10),  // eye
        "E": PixelColor(red: 0xFF, green: 0xFF, blue: 0xFF),  // eye highlight
    ]

    // MARK: Grids

    /// Raw character grids, kept separate from the built sprites so tests can validate them.
    enum Grid {
        // The body is drawn first and the head on top of it. Body variants differ only in their legs (and lying);
        // head variants only in the eyes and the mouth. The body reaches under the head (chest), so the head can bob
        // without leaving a hole.

        static let bodyStand = [
            ".............................OBO.",
            "............................OOBO.",
            "............................OBOO.",
            "...........................OOBO..",
            "..........OOOOOOOOOOOOOOOOOOBOO..",
            ".........OOBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            "..OOOOOOOOBBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBOO...",
            "..OLLLLLLLBBBBBOOObbbOBBBBBBBO...",
            "..OBLLBBBBBBOOOO.ObbbOBBBBBBBO...",
            "..OBBBBOBBBBO....ObbbOOBBBBOOO...",
            "..OBBBBOBBBBO....ObbbOOBBBBO.....",
            "..OBBBBOBBBBO....ObbbOOBBBBO.....",
            "..OLLLLOLLLLO....OLLLOOLLLLO.....",
            "..OLLLLOLLLLO....OLLLOOLLLLO.....",
            "..OOOOOOOOOOO....OOOOOOOOOOO.....",
        ]
        /// Near front and far hind paw lifted.
        static let bodyTrotA = [
            ".............................OBO.",
            "............................OOBO.",
            "............................OBOO.",
            "...........................OOBO..",
            "..........OOOOOOOOOOOOOOOOOOBOO..",
            ".........OOBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            "..OOOOOOOOBBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBOO...",
            "..OLLLLLLLBBBBBOOObbbOBBBBBBBO...",
            "..OBLLBBBBBBOOOO.ObbbOBBBBBBBO...",
            "..OBBBBOBBBBO....ObbbOOBBBBOOO...",
            "..OBBBBOBBBBO....ObbbOOBBBBO.....",
            "..OLLLLOBBBBO....OLLLOOBBBBO.....",
            "..OLLLLOLLLLO....OLLLOOLLLLO.....",
            "..OOOOOOLLLLO....OOOOOOLLLLO.....",
            ".......OOOOOO.........OOOOOO.....",
        ]
        /// Far front and near hind paw lifted.
        static let bodyTrotB = [
            ".............................OBO.",
            "............................OOBO.",
            "............................OBOO.",
            "...........................OOBO..",
            "..........OOOOOOOOOOOOOOOOOOBOO..",
            ".........OOBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            "..OOOOOOOOBBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBOO...",
            "..OLLLLLLLBBBBBOOObbbOBBBBBBBO...",
            "..OBLLBBBBBBOOOO.ObbbOBBBBBBBO...",
            "..OBBBBOBBBBO....ObbbOOBBBBOOO...",
            "..OBBBBOBBBBO....ObbbOOBBBBO.....",
            "..OBBBBOLLLLO....ObbbOOLLLLO.....",
            "..OLLLLOLLLLO....OLLLOOLLLLO.....",
            "..OLLLLOOOOOO....OLLLOOOOOOO.....",
            "..OOOOOO.........OOOOO...........",
        ]
        /// Front legs reaching forward, hind legs pushing back, for running.
        static let bodyGallop = [
            ".............................OBO.",
            "............................OOBO.",
            "............................OBOO.",
            "...........................OOBO..",
            "..........OOOOOOOOOOOOOOOOOOBOO..",
            ".........OOBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            "..OOOOOOOOBBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBOO...",
            "..OLLLLLLLBBBBBOOOObbbBBBBBBBO...",
            ".OOBLLBBBBBBOOOO..ObbbBBBBBBBO...",
            ".OBBBBOBBBBOO.....ObbbOOBBBBOO...",
            ".OBBBBOBBBBO......ObbbOOBBBBO....",
            ".OLLLLOBBBBO......ObbbOOLLLLO....",
            ".OLLLLOLLLLO......OLLLOOLLLLO....",
            ".OOOOOOLLLLO......OLLLOOOOOOO....",
            "......OOOOOO......OOOOO..........",
        ]
        /// Legs tucked in, for jumps.
        static let bodyJump = [
            ".............................OBO.",
            "............................OOBO.",
            "............................OBOO.",
            "...........................OOBO..",
            "..........OOOOOOOOOOOOOOOOOOBOO..",
            ".........OOBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            "..OOOOOOOOBBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBOO...",
            "..OLLLLLLLBBBBBOOObbbOBBBBBBBO...",
            "..OBLLBBBBBBOOOO.ObbbOBBBBBBBO...",
            "..OBBBBOBBBBO....ObbbOOBBBBOOO...",
            "..OLLLLOLLLLO....OLLLOOLLLLO.....",
            "..OLLLLOLLLLO....OLLLOOLLLLO.....",
            "..OOOOOOOOOOO....OOOOOOOOOOO.....",
            ".................................",
            ".................................",
        ]
        /// Lying down, the front paws stretched out.
        static let bodyLying = [
            ".................................",
            ".................................",
            ".................................",
            ".................................",
            ".................................",
            ".................................",
            ".................................",
            ".................................",
            ".................................",
            "..........OOOOOOOOOOOOOOOOOOOO...",
            ".........OOBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            ".........OBBBBBBBBBBBBBBBBBBBO...",
            "..OOOOOOOOBBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBBBBBBBBBBBBBBBO...",
            "..OLLLLLLLLBBBBbbbbbbbbBBBBBBO...",
            "OOOLLLLLLLLOOOObbbbbBBBBBBBBOO...",
            "OLLLLLLLLLLO..OOOOOOBBBBBBBBOOOOO",
            "OLLLLLLLLLLO....OLLLLLBBBBBBOOBBO",
            "OOOOOOOOOOOO....OOOOOOOOOOOOOBOOO",
        ]
        /// Eyes open, the Staffy grin with the tongue out.
        static let headNormal = [
            ".OO.........OO.",
            "ObbOOOOOOOOObbO",
            "ObbBBBBLBBBBbbO",
            "OBBBBBBLBBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBeEBLLLBeEBBO",
            "OBBeeBLLLBeeBBO",
            "OBBBBLLLLLBBBBO",
            "OBBBLLKKKLLBBBO",
            "OKBBLLKKKLLBBKO",
            "OBKBLLLKLLLBKBO",
            ".OBKKKKKKKKKBO.",
            "..OOKKPPPKKOO..",
            "....OOPPPOO....",
            "......OPO......",
        ]
        /// Eyes closed.
        static let headBlink = [
            ".OO.........OO.",
            "ObbOOOOOOOOObbO",
            "ObbBBBBLBBBBbbO",
            "OBBBBBBLBBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBeeBLLLBeeBBO",
            "OBBBBLLLLLBBBBO",
            "OBBBLLKKKLLBBBO",
            "OKBBLLKKKLLBBKO",
            "OBKBLLLKLLLBKBO",
            ".OBKKKKKKKKKBO.",
            "..OOKKPPPKKOO..",
            "....OOPPPOO....",
            "......OPO......",
        ]
        /// Eyes turned to the side.
        static let headLook = [
            ".OO.........OO.",
            "ObbOOOOOOOOObbO",
            "ObbBBBBLBBBBbbO",
            "OBBBBBBLBBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBeEBBLLLeEBBBO",
            "OBeeBBLLLeeBBBO",
            "OBBBBLLLLLBBBBO",
            "OBBBLLKKKLLBBBO",
            "OKBBLLKKKLLBBKO",
            "OBKBLLLKLLLBKBO",
            ".OBKKKKKKKKKBO.",
            "..OOKKPPPKKOO..",
            "....OOPPPOO....",
            "......OPO......",
        ]
        /// Mouth wide open, barking.
        static let headBark = [
            ".OO.........OO.",
            "ObbOOOOOOOOObbO",
            "ObbBBBBLBBBBbbO",
            "OBBBBBBLBBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBeEBLLLBeEBBO",
            "OBBeeBLLLBeeBBO",
            "OBBBBLLLLLBBBBO",
            "OBBBLLKKKLLBBBO",
            "OKBBLLKKKLLBBKO",
            "OBKBLLLKLLLBKBO",
            ".OBKKKKKKKKKBO.",
            "..OBKKKKKKKBO..",
            "...OBKPPPKBO...",
            "....OOOOOOO....",
        ]
        /// Eyes squeezed shut with joy ("^ ^"), enjoying being petted.
        static let headContent = [
            ".OO.........OO.",
            "ObbOOOOOOOOObbO",
            "ObbBBBBLBBBBbbO",
            "OBBBBBBLBBBBBBO",
            "OBBOOBLLLBOOBBO",
            "OBOBBOLLLOBBOBO",
            "OBBBBBLLLBBBBBO",
            "OBBBBLLLLLBBBBO",
            "OBBBLLKKKLLBBBO",
            "OKBBLLKKKLLBBKO",
            "OBKBLLLKLLLBKBO",
            ".OBKKKKKKKKKBO.",
            "..OOKKPPPKKOO..",
            "....OOPPPOO....",
            "......OPO......",
        ]
        /// Eyes closed and the mouth wide open, yawning.
        static let headYawn = [
            ".OO.........OO.",
            "ObbOOOOOOOOObbO",
            "ObbBBBBLBBBBbbO",
            "OBBBBBBLBBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBeeBLLLBeeBBO",
            "OBBBBLLLLLBBBBO",
            "OBBBLLKKKLLBBBO",
            "OKBBLLKKKLLBBKO",
            "OBKBLLLKLLLBKBO",
            ".OBKKKKKKKKKBO.",
            "..OBKKKKKKKBO..",
            "...OBKPPPKBO...",
            "....OOOOOOO....",
        ]
        /// Eyes and mouth closed, asleep.
        static let headAsleep = [
            ".OO.........OO.",
            "ObbOOOOOOOOObbO",
            "ObbBBBBLBBBBbbO",
            "OBBBBBBLBBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBBBBLLLBBBBBO",
            "OBBeeBLLLBeeBBO",
            "OBBBBLLLLLBBBBO",
            "OBBBLLKKKLLBBBO",
            "OKBBLLKKKLLBBKO",
            "OBKBLLLKLLLBKBO",
            ".OBBKKKKKKKBBO.",
            "..OOBBBBBBBOO..",
            "....OOOOOOO....",
            "...............",
        ]

        // Effect glyphs in the sheep's palette (`SheepSprites.palette`), about one and a half times the sheep's so they
        // look the same size in the finer pixels. Drawn without outline; it is added when building the sprite.

        static let exclamation = [
            "RR",
            "RR",
            "RR",
            "..",
            "RR",
        ]

        static let question = [
            ".QQQ.",
            "QQ.QQ",
            "...QQ",
            "..QQ.",
            ".QQ..",
            ".QQ..",
            ".....",
            ".QQ..",
        ]

        static let smallZ = [
            "ZZZZZ",
            "...Z.",
            "..Z..",
            ".Z...",
            "ZZZZZ",
        ]

        static let largeZ = [
            "ZZZZZZZ",
            ".....Z.",
            "....Z..",
            "...Z...",
            "..Z....",
            ".Z.....",
            "ZZZZZZZ",
        ]

        static let smallHeart = [
            ".HH.HH.",
            "HHHHHHH",
            "HHHHHHH",
            ".HHHHH.",
            "..HHH..",
            "...H...",
        ]

        static let largeHeart = [
            ".HHH.HHH.",
            "HHHHHHHHH",
            "HHHHHHHHH",
            "HHHHHHHHH",
            ".HHHHHHH.",
            "..HHHHH..",
            "...HHH...",
            "....H....",
        ]

        static let smallDust = [
            ".ww",
            "www",
        ]

        static let largeDust = [
            "..w..",
            ".www.",
            "wwwww",
        ]

        /// A flying fleck, deliberately without outline.
        static let fleck = [
            "WW",
            "WW",
        ]

        /// With its outline; the tail points down to the dog's head.
        static let checkBubble = [
            ".OOOOOOOOOO.",
            "OWWWWWWWWWWO",
            "OWWWWWWWWGWO",
            "OWWWWWWWGGWO",
            "OWWWWWWGGWWO",
            "OWGWWWGGWWWO",
            "OWGGWGGWWWWO",
            "OWWGGGWWWWWO",
            "OWWWGWWWWWWO",
            ".OOWOOOOOOO.",
            "..OWO.......",
            "..OO........",
        ]
    }

    /// Every grid of the dog with a name, for validation in tests (in `palette`).
    static let allGrids: [(name: String, rows: [String])] = [
        ("bodyStand", Grid.bodyStand),
        ("bodyTrotA", Grid.bodyTrotA),
        ("bodyTrotB", Grid.bodyTrotB),
        ("bodyGallop", Grid.bodyGallop),
        ("bodyJump", Grid.bodyJump),
        ("bodyLying", Grid.bodyLying),
        ("headNormal", Grid.headNormal),
        ("headBlink", Grid.headBlink),
        ("headLook", Grid.headLook),
        ("headBark", Grid.headBark),
        ("headContent", Grid.headContent),
        ("headYawn", Grid.headYawn),
        ("headAsleep", Grid.headAsleep),
    ]

    /// Every effect glyph with a name, for validation in tests (in `SheepSprites.palette`).
    static let allEffectGrids: [(name: String, rows: [String])] = [
        ("exclamation", Grid.exclamation),
        ("question", Grid.question),
        ("smallZ", Grid.smallZ),
        ("largeZ", Grid.largeZ),
        ("smallHeart", Grid.smallHeart),
        ("largeHeart", Grid.largeHeart),
        ("smallDust", Grid.smallDust),
        ("largeDust", Grid.largeDust),
        ("fleck", Grid.fleck),
        ("checkBubble", Grid.checkBubble),
    ]

    enum Effect {
        static let exclamation = outlined(Grid.exclamation)
        static let question = outlined(Grid.question)
        static let smallZ = outlined(Grid.smallZ)
        static let largeZ = outlined(Grid.largeZ)
        static let smallHeart = outlined(Grid.smallHeart)
        static let largeHeart = outlined(Grid.largeHeart)
        static let smallDust = outlined(Grid.smallDust)
        static let largeDust = outlined(Grid.largeDust)
        static let fleck = PixelSprite(rows: Grid.fleck, palette: SheepSprites.palette)
        static let checkBubble = PixelSprite(rows: Grid.checkBubble, palette: SheepSprites.palette)

        private static func outlined(_ rows: [String]) -> PixelSprite {
            PixelSprite(rows: rows, palette: SheepSprites.palette).outlined(with: SheepSprites.outline)
        }
    }

    // MARK: Frames and clips

    private static func sprite(_ rows: [String]) -> PixelSprite {
        PixelSprite(rows: rows, palette: palette)
    }

    private static func makeSprites() -> BuddySprites {
        let stand = sprite(Grid.bodyStand)
        let trotA = sprite(Grid.bodyTrotA)
        let trotB = sprite(Grid.bodyTrotB)
        let gallop = sprite(Grid.bodyGallop)
        let jump = sprite(Grid.bodyJump)
        let lying = sprite(Grid.bodyLying)
        let normal = sprite(Grid.headNormal)
        let blink = sprite(Grid.headBlink)
        let look = sprite(Grid.headLook)
        let bark = sprite(Grid.headBark)
        let content = sprite(Grid.headContent)
        let yawn = sprite(Grid.headYawn)
        let asleepHead = sprite(Grid.headAsleep)

        /// Body and head layers; `dy` moves the whole dog (negative is up), `headDY` only the head.
        func dog(
            _ body: PixelSprite = stand, head: PixelSprite = normal, dy: Int = 0, headDY: Int = 0
        )
            -> [SpriteLayer]
        {
            [
                SpriteLayer(sprite: body, x: bodyX, y: bodyY + dy),
                SpriteLayer(sprite: head, x: bodyX + headX, y: bodyY + headY + dy + headDY),
            ]
        }

        // The head is high on the canvas, so the bubble, the question mark, the hearts and the "z"s float above
        // the back; only "!" sits over the head (between the ears even at the top of a jump).
        let checkBubble = SpriteLayer(sprite: Effect.checkBubble, x: 16, y: 0)
        let exclamation = SpriteLayer(sprite: Effect.exclamation, x: 6, y: 0)
        /// Lying with the head resting on the front paws.
        let asleep = dog(lying, head: asleepHead, headDY: 6)
        let smallZ = SpriteLayer(sprite: Effect.smallZ, x: 16, y: 9)
        let largeZ = SpriteLayer(sprite: Effect.largeZ, x: 23, y: 1)
        let largeDust = SpriteLayer(sprite: Effect.largeDust, x: 26, y: 25)
        let smallDust = SpriteLayer(sprite: Effect.smallDust, x: 28, y: 26)
        func fleck(_ x: Int, _ y: Int) -> SpriteLayer { SpriteLayer(sprite: Effect.fleck, x: x, y: y) }
        func smallHeart(_ y: Int) -> SpriteLayer { SpriteLayer(sprite: Effect.smallHeart, x: 18, y: y) }
        func largeHeart(_ y: Int) -> SpriteLayer { SpriteLayer(sprite: Effect.largeHeart, x: 17, y: y) }
        func question(_ y: Int) -> SpriteLayer { SpriteLayer(sprite: Effect.question, x: 18, y: y) }
        func spriteFrame(_ layers: [SpriteLayer], opacity: Double = 1) -> SpriteFrame {
            SpriteFrame(layers: layers, canvasWidth: canvasWidth, canvasHeight: canvasHeight, opacity: opacity)
        }
        func frame(_ milliseconds: Int, _ layers: [SpriteLayer], opacity: Double = 1) -> AnimationFrame {
            AnimationFrame(sprite: spriteFrame(layers, opacity: opacity), duration: .milliseconds(milliseconds))
        }
        func still(_ sprite: SpriteFrame) -> AnimationClip {
            AnimationClip([AnimationFrame(sprite: sprite, duration: .milliseconds(500))])
        }
        let unknownOpacity = BuddySprites.unknownOpacity

        // Keep every clip short (well under 1.5 s): a clip always plays to its end before the state machine
        // switches.
        let idleRest = AnimationClip([
            frame(1_000, dog())
        ])
        let idleBlink = AnimationClip([
            frame(150, dog(head: blink)),
            frame(250, dog()),
        ])
        let idleLook = AnimationClip([
            frame(700, dog(head: look, headDY: -1)),
            frame(300, dog()),
        ])
        let sleeping = AnimationClip([
            frame(700, asleep + [smallZ]),
            frame(700, asleep + [smallZ, largeZ]),
        ])
        let working = AnimationClip([
            frame(150, dog(trotA) + [largeDust, fleck(29, 8)]),
            frame(150, dog(dy: -1) + [smallDust, fleck(31, 5), fleck(27, 7)]),
            frame(150, dog(trotB) + [largeDust, fleck(30, 4)]),
            frame(150, dog(dy: -1) + [smallDust, fleck(29, 2)]),
        ])
        let blocked = AnimationClip([
            frame(150, dog(head: bark) + [exclamation]),
            frame(120, dog(jump, head: bark, dy: -2) + [exclamation]),
            frame(120, dog(jump, dy: -3)),
            frame(120, dog(jump, dy: -2)),
            frame(150, dog() + [exclamation]),
            frame(340, dog()),
        ])
        let doneJump = AnimationClip([
            frame(150, dog() + [checkBubble]),
            frame(120, dog(jump, dy: -2) + [checkBubble]),
            frame(120, dog(jump, dy: -3) + [checkBubble]),
            frame(120, dog(jump, dy: -2) + [checkBubble]),
            frame(290, dog(head: content) + [checkBubble]),
        ])
        let doneHold = AnimationClip([
            frame(600, dog(head: content) + [checkBubble]),
            frame(400, dog() + [checkBubble]),
        ])
        let unknown = AnimationClip([
            frame(800, dog() + [question(4)], opacity: unknownOpacity),
            frame(800, dog() + [question(3)], opacity: unknownOpacity),
        ])
        // Still poses: one picture per state that still shows the state's sign, mostly a frame of its clip.
        let workingStill = still(spriteFrame(dog(trotA) + [largeDust, fleck(29, 8), fleck(30, 4)]))

        func clip(_ id: SheepClipID) -> AnimationClip {
            switch id {
            case .idleRest: idleRest
            case .idleBlink: idleBlink
            case .idleLook: idleLook
            case .sleeping: sleeping
            case .working: working
            case .blocked: blocked
            case .doneJump: doneJump
            case .doneHold: doneHold
            case .unknown: unknown
            case .idleStill: still(idleRest.frames[0].sprite)
            case .sleepingStill: still(sleeping.frames[1].sprite)
            case .workingStill: workingStill
            case .blockedStill: still(blocked.frames[0].sprite)
            case .doneStill: still(doneHold.frames[1].sprite)
            case .unknownStill: still(unknown.frames[1].sprite)
            }
        }

        let escape = BuddySprites.Escape(
            // A startled bark and hop before running away.
            startle: AnimationClip([
                frame(120, dog(head: bark)),
                frame(100, dog(jump, head: bark, dy: -2)),
                frame(100, dog(jump, head: bark, dy: -3)),
                frame(100, dog(jump, dy: -2)),
                frame(80, dog()),
            ]),
            // A slow yawn with the head raised before wandering off.
            yawn: AnimationClip([
                frame(200, dog()),
                frame(150, dog(head: blink, headDY: -1)),
                frame(600, dog(head: yawn, headDY: -1)),
                frame(200, dog(head: blink)),
                frame(200, dog()),
            ]),
            turn: AnimationClip([
                frame(100, dog())
            ]),
            run: AnimationClip([
                frame(80, dog(gallop) + [largeDust]),
                frame(80, dog(jump, dy: -1) + [smallDust]),
                frame(80, dog(trotB)),
                frame(80, dog(jump, dy: -1)),
            ]),
            // A slow walk with the head hanging and bobbing.
            walk: AnimationClip([
                frame(180, dog(trotA, headDY: 1)),
                frame(180, dog()),
                frame(180, dog(trotB, headDY: 1)),
                frame(180, dog()),
            ]),
            arrive: AnimationClip([
                frame(150, dog(head: bark)),
                frame(150, dog(head: blink)),
                frame(200, dog()),
            ]))

        // The dog squeezes its eyes shut with joy, a heart rises over its back and it gives a small happy hop.
        let petted = AnimationClip([
            frame(120, dog(head: content, headDY: 1)),
            frame(160, dog(head: content) + [smallHeart(7)]),
            frame(160, dog(head: content, headDY: 1) + [smallHeart(6)]),
            frame(160, dog(head: content) + [largeHeart(4)]),
            frame(160, dog(head: content, headDY: 1) + [largeHeart(3)]),
            frame(120, dog(jump, head: content, dy: -1) + [largeHeart(3)]),
            frame(200, dog(head: content) + [largeHeart(3)]),
            frame(200, dog()),
        ])

        return BuddySprites(
            canvasWidth: canvasWidth, canvasHeight: canvasHeight, clip: clip, escape: escape, petted: petted)
    }
}
