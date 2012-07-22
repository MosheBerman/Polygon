//
//  MBPolygonView.m
//  Polygon
//
//  Created by Moshe Berman on 7/22/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "MBPolygonView.h"
#import "Math.h"

@interface MBPolygonView ()
@property NSInteger numberOfSides;
    @property CGFloat scalingFactor;
    @property CGFloat rotation;
@end

@implementation MBPolygonView

//
//  Convenience method to convert between Degrees and Radians
//

float degToRad(float deg){
    return deg*(M_PI/180);
}

//
//  Designated initializer
//

- (id)initWithFrame:(CGRect)frame numberOfSides:(NSInteger)numberOfSides andRotation:(CGFloat)rotation andScale:(CGFloat) scale{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.numberOfSides = numberOfSides;
        self.scalingFactor = scale;
        self.rotation = rotation;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //Get a context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Set the stroke to white
    [[UIColor whiteColor] set];
    
    //Define the number of degrees in a polygon
    const CGFloat kDegreesInPoly = 360;
    
    //  Calculate the angle in degrees.
    CGFloat angle = (kDegreesInPoly/self.numberOfSides);
    
    //  Calculate the starting point
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //  We draw an extra line to connect the start and end points
    for(int i=0; i<=self.numberOfSides; i++){
        
        //  Calculate the working angle in degrees
        CGFloat workingAngle = i*angle;
        
        //  Convert to radians
        CGFloat angleInRadians = degToRad(workingAngle+self.rotation);
        
        //  Calculate the x and Y coordinates
        point.x = sin(angleInRadians);
        point.y = cos(angleInRadians);
        
        point.x *= self.scalingFactor;
        point.y *= self.scalingFactor;
        
        //  Offset to the center
        point.x += self.frame.size.width/2;
        point.y +=self.frame.size.height/2;
    
        //  Set the starting point if we're working
        //  the inital point. Core Graphics needs this.
        if (i == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        }
        
        //  Add the new line to the context
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    
    //  Render it all out
    CGContextStrokePath(context);
    
}


@end
