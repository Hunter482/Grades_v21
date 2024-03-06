




/*import SwiftUI

struct RangedSliderView: View {
    let currentValue: Binding<ClosedRange<Float>>
    let sliderBounds: ClosedRange<Int>
    
    public init(value: Binding<ClosedRange<Float>>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }
    
    var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }
    
        
    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(.red)
                .frame(height: 4)
            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)
                
                // Calculate Left Thumb initial position
                let leftThumbLocation: CGFloat = currentValue.wrappedValue.lowerBound == Float(sliderBounds.lowerBound)
                    ? 0
                    : CGFloat(currentValue.wrappedValue.lowerBound - Float(sliderBounds.lowerBound)) * stepWidthInPixel
                
                // Calculate right thumb initial position
                let rightThumbLocation = CGFloat(currentValue.wrappedValue.upperBound) * stepWidthInPixel
                
                // Path between both handles
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))
                
                // Left Thumb Handle
                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
                thumbView(position: leftThumbPoint, value: Float(currentValue.wrappedValue.lowerBound))
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)
                        
                        let newValue = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel)
                        
                        // Stop the range thumbs from colliding each other
                        if newValue < currentValue.wrappedValue.upperBound {
                            currentValue.wrappedValue = newValue...currentValue.wrappedValue.upperBound
                        }
                    })
                
                // Right Thumb Handle
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.wrappedValue.upperBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation.x), sliderSize.width)
                        
                        var newValue = Float(xThumbOffset / stepWidthInPixel) // convert back the value bound
                        newValue = min(newValue, Float(sliderBounds.upperBound))
                        
                        // Stop the range thumbs from colliding each other
                        if newValue > currentValue.wrappedValue.lowerBound {
                            currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...newValue
                        }
                    })
            }
        }
    }
    
    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(.blue, lineWidth: 4)
    }
    
    @ViewBuilder func thumbView(position: CGPoint, value: Float) -> some View {
        ZStack {
            Text(String(value))
//                .font(.secondaryFont(weight: .semibold, size: 10))
                .offset(y: -20)
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.green)
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .position(x: position.x, y: position.y)
    }
}

#Preview {
    @State var sliderPosition: ClosedRange<Float> = 3...8
    RangedSliderView(value: $sliderPosition, bounds: 1...10)
}

*/
/*
import SwiftUI

struct RangeSlider: View {
    @ObservedObject var viewModel: ViewModel
    @State private var isActive: Bool = false
    let sliderPositionChanged: (ClosedRange<Float>) -> Void

    var body: some View {
        GeometryReader { geometry in
            sliderView(sliderSize: geometry.size,
                       sliderViewYCenter: geometry.size.height / 2)
        }
        .frame(height: 20)
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize, sliderViewYCenter: CGFloat) -> some View {
        lineBetweenThumbs(from: viewModel.leftThumbLocation(width: sliderSize.width,
                                                            sliderViewYCenter: sliderViewYCenter),
                          to: viewModel.rightThumbLocation(width: sliderSize.width,
                                                           sliderViewYCenter: sliderViewYCenter))

        thumbView(position: viewModel.leftThumbLocation(width: sliderSize.width,
                                                        sliderViewYCenter: sliderViewYCenter),
                  value: Float(viewModel.sliderPosition.lowerBound))
        .highPriorityGesture(DragGesture().onChanged { dragValue in
            let newValue = viewModel.newThumbLocation(dragLocation: dragValue.location,
                                                      width: sliderSize.width)
            
            if newValue < viewModel.sliderPosition.upperBound {
                viewModel.sliderPosition = newValue...viewModel.sliderPosition.upperBound
                sliderPositionChanged(viewModel.sliderPosition)
                isActive = true
            }
        })

        thumbView(position: viewModel.rightThumbLocation(width: sliderSize.width,
                                                         sliderViewYCenter: sliderViewYCenter),
                  value: Float(viewModel.sliderPosition.upperBound))
        .highPriorityGesture(DragGesture().onChanged { dragValue in
            let newValue = viewModel.newThumbLocation(dragLocation: dragValue.location,
                                                      width: sliderSize.width)
            
            if newValue > viewModel.sliderPosition.lowerBound {
                viewModel.sliderPosition = viewModel.sliderPosition.lowerBound...newValue
                sliderPositionChanged(viewModel.sliderPosition)
                isActive = true
            }
        })
    }

    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color("lightgray"))
                .frame(height: 4)

            Path { path in
                path.move(to: from)
                path.addLine(to: to)
            }
            .stroke(.blue,
                    lineWidth: 4)
        }
    }

    @ViewBuilder func thumbView(position: CGPoint, value: Float) -> some View {
        Rectangle()
            .frame(width: 5, height: 20)
            .foregroundColor(.blue)
            .contentShape(Rectangle())
            .position(x: position.x, y: position.y)
            .animation(.spring(), value: isActive)
        
     /*Circle()
        .frame(width: 20)//.rangeSliderThumb)
        .foregroundColor(.blue)
        .contentShape(Rectangle())
        .position(x: position.x, y: position.y)
        .animation(.spring(), value: isActive)*/
    }
}

extension RangeSlider {
    final class ViewModel: ObservableObject {
        @Published var sliderPosition: ClosedRange<Float>
        let sliderBounds: ClosedRange<Int>

        let sliderBoundDifference: Int

        init(sliderPosition: ClosedRange<Float>,
             sliderBounds: ClosedRange<Int>) {
            self.sliderPosition = sliderPosition
            self.sliderBounds = sliderBounds
            self.sliderBoundDifference = sliderBounds.count - 1
        }

        func leftThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat = 0) -> CGPoint {
            let sliderLeftPosition = CGFloat(sliderPosition.lowerBound - Float(sliderBounds.lowerBound))
            
            
            
            return .init(x: sliderLeftPosition * stepWidthInPixel(width: width),
                         y: sliderViewYCenter)
        }

        func rightThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat = 0) -> CGPoint {
            let sliderRightPosition = CGFloat(sliderPosition.upperBound - Float(sliderBounds.lowerBound))
            
            return .init(x: sliderRightPosition * stepWidthInPixel(width: width),
                         y: sliderViewYCenter)
        }

        func newThumbLocation(dragLocation: CGPoint, width: CGFloat) -> Float {
            let xThumbOffset = min(max(0, dragLocation.x), width)
            return Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel(width: width))
        }

        private func stepWidthInPixel(width: CGFloat) -> CGFloat {
            width / CGFloat(sliderBoundDifference)
        }
    }
}

#Preview {
    RangeSlider(viewModel: .init(sliderPosition: 2...8,
                                 sliderBounds: 1...10),
                sliderPositionChanged: { _ in })
}

*/
/*
import SwiftUI

struct RangedSliderView: View {
    let currentValue: Binding<ClosedRange<Int>>
    let sliderBounds: ClosedRange<Int>

    public init(value: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }

    var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.blue)
                .frame(height: 4)
            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)

                // Calculate Left Thumb initial position
                let leftThumbLocation: CGFloat = currentValue.wrappedValue.lowerBound == sliderBounds.lowerBound
                    ? 0
                    : CGFloat(currentValue.wrappedValue.lowerBound - sliderBounds.lowerBound) * stepWidthInPixel

                // Calculate right thumb initial position
                let rightThumbLocation = CGFloat(currentValue.wrappedValue.upperBound) * stepWidthInPixel

                // Path between both handles
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))

                // Left Thumb Handle
                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
                thumbView(position: leftThumbPoint, value: currentValue.wrappedValue.lowerBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in

                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)

                        let newValue = sliderBounds.lowerBound + Int(xThumbOffset / stepWidthInPixel)

                        // Stop the range thumbs from colliding each other
                        if newValue < currentValue.wrappedValue.upperBound {
                            currentValue.wrappedValue = newValue...currentValue.wrappedValue.upperBound
                        }
                    })

                // Right Thumb Handle
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.wrappedValue.upperBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation.x), sliderSize.width)

                        var newValue = Int(xThumbOffset / stepWidthInPixel) // convert back the value bound
                        newValue = min(newValue, sliderBounds.upperBound)

                        // Stop the range thumbs from colliding each other
                        if newValue > currentValue.wrappedValue.lowerBound {
                            currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...newValue
                        }
                    })
            }
        }
    }

    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(Color.red, lineWidth: 4)
    }

    @ViewBuilder func thumbView(position: CGPoint, value: Int) -> some View {
        ZStack {
            Text(String(value))
                .font(.callout.bold())
                .offset(y: -20)
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.red)
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .position(x: position.x, y: position.y)
    }
}

struct RangedSliderView_Preview: PreviewProvider {
    @State static var sliderPosition: ClosedRange<Int> = 3...8
    
    static var previews: some View {
        RangedSliderView(value: $sliderPosition, bounds: 0...10)
    }
}
 */

import SwiftUI

struct RangedSliderView_Preview: PreviewProvider {
    @State static var sliderPosition: ClosedRange<Int> = 3...8
    
    static var previews: some View {
        RangedSliderView(value: $sliderPosition, bounds: 0...10)
    }
}

struct RangedSliderView: View {
    let currentValue: Binding<ClosedRange<Int>>
    let sliderBounds: ClosedRange<Int>

    public init(value: Binding<ClosedRange<Int>>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }

    var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.red)
                .frame(height: 4)
            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)

                // Calculate Left Thumb initial position
                let leftThumbLocation: CGFloat = CGFloat(currentValue.wrappedValue.lowerBound - sliderBounds.lowerBound) * stepWidthInPixel

                // Calculate right thumb initial position
                let rightThumbLocation = CGFloat(currentValue.wrappedValue.upperBound - sliderBounds.lowerBound) * stepWidthInPixel

                // Path between both handles
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))

                // Left Thumb Handle
                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
                thumbView(position: leftThumbPoint, value: currentValue.wrappedValue.lowerBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(0, dragLocation.x), rightThumbLocation - 20)
                        let newValue = Int((xThumbOffset + 10) / stepWidthInPixel) + sliderBounds.lowerBound
                        currentValue.wrappedValue = newValue...currentValue.wrappedValue.upperBound
                    })

                // Right Thumb Handle
                let rightThumbPoint = CGPoint(x: rightThumbLocation, y: sliderViewYCenter)
                thumbView(position: rightThumbPoint, value: currentValue.wrappedValue.upperBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(leftThumbLocation + 20, dragLocation.x), sliderSize.width)
                        let newValue = Int((xThumbOffset - 10) / stepWidthInPixel) + sliderBounds.lowerBound
                        currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...newValue
                    })
            }
        }
    }

    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(Color.red, lineWidth: 4)
    }

    @ViewBuilder func thumbView(position: CGPoint, value: Int) -> some View {
        ZStack {
            Text(String(value))
                .font(.callout.bold())
                .offset(y: -20)
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.red)
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .position(x: position.x, y: position.y)
    }
}

