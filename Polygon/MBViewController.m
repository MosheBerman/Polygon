//
//  MBViewController.m
//  Polygon
//
//  Created by Moshe Berman on 7/22/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "MBViewController.h"

#import "MBPolygonView.h"


@interface MBViewController ()
@property (strong, nonatomic) NSMutableArray *arr;
@end

@implementation MBViewController

const float kScale = 20;
const float gridSize = 100;

@synthesize arr;
@synthesize numberOfSidesLabel;
@synthesize rotationLabel;
@synthesize stepper;
@synthesize rotationStepper;
@synthesize shapeImageView;
@synthesize shapeScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.arr = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addShape:(id)sender {
    
    //
    //  Clean out the old shapes
    //
    
    for (UIView *view in self.shapeScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    //
    //  Set up the new frame
    //
    
    CGRect f = self.view.frame;
    f.size.height = gridSize;
    f.size.width = gridSize;
    f.origin.y = self.view.frame.size.height/2-f.size.height/2;
    f.origin.x = self.view.frame.size.width/2-f.size.width/2;
    
    //
    //  Create the rendered polygon
    //
    
    MBPolygonView *p = [[MBPolygonView alloc] initWithFrame:f numberOfSides:self.stepper.value andRotation:self.rotationStepper.value andScale:kScale];
    
    //
    //  Maintain a reference to the poly in an array
    //
    
    [self.arr insertObject:p atIndex:0];
    
    //
    //  Resize the scroll view to hold the polygon
    //
    
    [self.shapeScrollView setContentSize:CGSizeMake(self.arr.count*gridSize, gridSize)];

    //
    //  Render the polygons
    //
    
    for (NSInteger i =0; i<self.arr.count; i++) {
        [[self.arr objectAtIndex:i] setFrame:CGRectMake(i*gridSize, 0, gridSize, gridSize)];
        [self.shapeScrollView addSubview:[self.arr objectAtIndex:i]];
    }

}

- (IBAction)adjustSides:(id)sender {
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"Polygon has %.0f sides",self.stepper.value];
}

- (IBAction)adjustRotation:(id)sender {
    self.rotationLabel.text = [NSString stringWithFormat:@"Polygon is rotated %.0fº", self.rotationStepper.value];
}

- (IBAction)showRotatingShape:(id)sender {
    
    
    [self.shapeImageView stopAnimating];
    
    NSMutableArray *shapes = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i<360; i++) {
        MBPolygonView *p = [[MBPolygonView alloc] initWithFrame:self.shapeImageView.frame numberOfSides:self.stepper.value andRotation:i andScale:kScale];
        [shapes addObject:[p polyImage]];
    }
    
    [self.shapeImageView setAnimationImages:shapes];
    [self.shapeImageView setAnimationRepeatCount:0];
    [self.shapeImageView setAnimationDuration:1];
    
    [self.shapeImageView startAnimating];
    
    
    
}


- (void)viewDidUnload {
    [self setShapeImageView:nil];
    [super viewDidUnload];
}
@end
