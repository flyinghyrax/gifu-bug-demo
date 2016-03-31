Sample project that demonstrates some problems in the Gifu animated UIImage library.

Project created and built in Xcode 7.3 (7D175) and run on iOS 9.3 simulators and devices.

## Setup

Requires CocoaPods to include the Gifu dependency

- `git clone https://github.com/mr-seiler/gifu-bug-demo.git`
- `cd gifu-bug-demo`
- `pod install`
- `open gifu-test.xcworkspace`

The two different issues have their own tags, listed below.

Checkout the appropriate tag and run the project to observe the issue.

## Issues Demonstrated

### memory leak

**Tag:** `repro-memory-leak`

**Method:**

1. `git checkout repro-memory-leak`
2. Open the workspace in Xcode
3. Run the project on any simulator or device
4. Open the Debug Navigator (⌘+6) and select "Memory" to open the Memory report
5. In the running application, tap "Go Places" to push the view controller containing the Gif onto the navigation stack, then tap the back button on the navigation bar.
6. Repeat step 5 while observing memory graph

For more detail, use Instruments:

0. Edit build scheme > Profile > select Debug build configuration
1. Xcode > Open Developer Tool > Instruments
2. Select the "Allocations" profiling template
3. Start recording
4. Mark Generation before pushing the view controller containing the Gifu AnimatableImageView and after going back (can repeat for multiple generations)
5. Retained objects can be inspected in the Generations list

### retain/release crash

**Tag:** `repro-zombie-bug`

**Method:**

1. `git checkout repro-zombie-bug`
2. Edit build scheme > Run > Diagnostics > Enable Zombie Objects (this allows us to see which object is causing the crash)
3. Run the project
4. In the app, tap "Go Places" to push the view controller containg the AnimatableImageView, then the back button in the navigation bar to pop and deallocate
5. Observe crash

**Analysis:**

The crash occurs in cases when the AnimatableImageView is deallocated without having ever loaded any image data.

The `AnimatableImageView` creates a `CADisplayLink` as a lazily initialized property, passing itself as the object to be retained by the display link. the `AnimatableImageView`s `deinit` block calls `displayLink.invalidate()`, which instructs the `CADisplayLink` to release its retained object.

If `prepareForAnimation(imageData:)` is never called, then `attachDisplayLink()` is never called, the lazy property is never accessed and the `CADisplayLink` instance is not created.
If no other accesses to that property ever occur before the `AnimatableImageView` is deallocated, the first access of the lazy property will be inside the `deinit` block, so the display link will be created _while the Gifu view is being deinitialized_. The CADisplay link immediately tries to retain and release an object which is already being deallocated and a crash occurs.

