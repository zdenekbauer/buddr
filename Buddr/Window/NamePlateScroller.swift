/// How a name plate text that is longer than the plate scrolls: one plate pixel at a time to the left, in a loop
/// (the text, `SheepSprites.Plate.scrollGap`, the text again), with a pause whenever its start is in place so it can be
/// read.
struct NamePlateScroll: Equatable, Sendable {
    /// How long the start of the text stays in place.
    static let pause: Duration = .seconds(2)
    /// How long each one-pixel step is shown: 25 plate pixels a second, about four characters.
    static let step: Duration = .milliseconds(40)

    /// Offsets repeat after this many pixels: the text and the gap after it.
    let period: Int

    init(textWidth: Int, gap: Int = SheepSprites.Plate.scrollGap) {
        period = textWidth + gap
    }

    /// The offset shown after `offset`.
    func offset(after offset: Int) -> Int {
        (offset + 1) % period
    }

    /// How long `offset` is shown.
    func duration(of offset: Int) -> Duration {
        offset == 0 ? Self.pause : Self.step
    }
}

/// Plays a `NamePlateScroll` in real time: reports every offset, starting with 0, until `stop()`.
@MainActor
final class NamePlateScroller {
    private let scroll: NamePlateScroll
    private let sleep: @Sendable (Duration) async throws -> Void
    private var task: Task<Void, Never>?

    /// `sleep` is replaced in tests to step through the offsets.
    init(
        _ scroll: NamePlateScroll,
        sleep: @escaping @Sendable (Duration) async throws -> Void = { try await Task.sleep(for: $0) }
    ) {
        self.scroll = scroll
        self.sleep = sleep
    }

    var isRunning: Bool {
        task != nil
    }

    /// Reports offset 0 right away, then every next offset after the current one's duration. Starts from 0 again
    /// when it was stopped; does nothing while running.
    func start(onOffset: @escaping @MainActor (Int) -> Void) {
        guard task == nil else { return }
        onOffset(0)
        task = Task { [scroll, sleep] in
            var offset = 0
            while true {
                do {
                    try await sleep(scroll.duration(of: offset))
                } catch {
                    return
                }
                // A sleep cancelled by `stop()` may still return; nothing is reported after it.
                guard !Task.isCancelled else { return }
                offset = scroll.offset(after: offset)
                onOffset(offset)
            }
        }
    }

    /// Stops at once: nothing is reported after it.
    func stop() {
        task?.cancel()
        task = nil
    }
}
