import Testing

@testable import Buddr

struct NamePlateScrollTests {
    @Test func loopsThroughTheTextAndTheGap() {
        let scroll = NamePlateScroll(textWidth: 120, gap: 16)
        #expect(scroll.period == 136)
        #expect(scroll.offset(after: 0) == 1)
        #expect(scroll.offset(after: 134) == 135)
        #expect(scroll.offset(after: 135) == 0)
    }

    @Test func pausesOnlyWhileTheStartIsInPlace() {
        let scroll = NamePlateScroll(textWidth: 120)
        #expect(scroll.duration(of: 0) == NamePlateScroll.pause)
        #expect(scroll.duration(of: 1) == NamePlateScroll.step)
        #expect(scroll.duration(of: 135) == NamePlateScroll.step)
        #expect(NamePlateScroll.step < NamePlateScroll.pause)
    }
}

@MainActor
struct NamePlateScrollerTests {
    private let sleeper = ManualSleeper()
    private let offsets: AsyncStream<Int>
    private let report: @MainActor @Sendable (Int) -> Void

    init() {
        let (offsets, continuation) = AsyncStream.makeStream(of: Int.self)
        self.offsets = offsets
        report = { continuation.yield($0) }
    }

    @Test func reportsEveryOffsetForItsDurationAndStartsOverAfterThePeriod() async {
        // Period 3: offsets 0, 1, 2, then 0 again with its pause.
        let scroller = NamePlateScroller(NamePlateScroll(textWidth: 2, gap: 1), sleep: sleeper.sleep(for:))
        var sleeps = sleeper.sleeps.makeAsyncIterator()
        var offsets = offsets.makeAsyncIterator()

        scroller.start(onOffset: report)
        for (offset, duration) in [
            (0, NamePlateScroll.pause), (1, NamePlateScroll.step), (2, NamePlateScroll.step),
            (0, NamePlateScroll.pause),
        ] {
            #expect(await offsets.next() == offset)
            #expect(await sleeps.next() == duration)
            sleeper.wake()
        }
        #expect(await offsets.next() == 1)
        scroller.stop()
    }

    @Test func stopsAtOnceAndStartsFromTheBeginningAgain() async {
        let scroller = NamePlateScroller(NamePlateScroll(textWidth: 50), sleep: sleeper.sleep(for:))
        var sleeps = sleeper.sleeps.makeAsyncIterator()
        var offsets = offsets.makeAsyncIterator()
        scroller.start(onOffset: report)
        #expect(await offsets.next() == 0)
        _ = await sleeps.next()
        sleeper.wake()
        #expect(await offsets.next() == 1)
        _ = await sleeps.next()

        scroller.stop()
        #expect(!scroller.isRunning)

        // Started again: from offset 0, and the stopped loop reports nothing more.
        scroller.start(onOffset: report)
        #expect(scroller.isRunning)
        #expect(await offsets.next() == 0)
        #expect(await sleeps.next() == NamePlateScroll.pause)
        sleeper.wake()
        #expect(await offsets.next() == 1)
        scroller.stop()
    }

    @Test func startWhileRunningChangesNothing() async {
        let scroller = NamePlateScroller(NamePlateScroll(textWidth: 50), sleep: sleeper.sleep(for:))
        var sleeps = sleeper.sleeps.makeAsyncIterator()
        var offsets = offsets.makeAsyncIterator()
        scroller.start(onOffset: report)
        #expect(await offsets.next() == 0)
        _ = await sleeps.next()

        scroller.start(onOffset: report)
        sleeper.wake()

        // Only the first loop runs: the next offset is 1, not a second 0.
        #expect(await offsets.next() == 1)
        scroller.stop()
    }
}
