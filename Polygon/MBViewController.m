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
@property (strong, nonatomic) NSMutableArray *polygonsToShowInScrollView;
@end

@implementation MBViewController

const float kScale = 20;
const float gridSize = 100;

@synthesize polygonsToShowInScrollView;
@synthesize numberOfSidesLabel;
@synthesize rotationLabel;
@synthesize stepper;
@synthesize rotationStepper;
@synthesize shapeImageView;
@synthesize noPolygonsLabel;
@synthesize shapeScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.polygonsToShowInScrollView = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addShape:(id)sender {
    
    //
    //  Set up the new frame
    //
    
    CGRect frame = self.view.frame;
    frame.size.height = gridSize;
    frame.size.width = gridSize;
    frame.origin.y = self.view.frame.size.height/2-frame.size.height/2;
    frame.origin.x = self.view.frame.size.width/2-frame.size.width/2;
    
    //
    //  Create the rendered polygon
    //
    
    MBPolygonView *polygon = [[MBPolygonView alloc] initWithFrame:frame numberOfSides:self.stepper.value andRotation:self.rotationStepper.value andScale:kScale];
    
    //
    //  Observe polygon deletions
    //
    
    [polygon addObserver:self forKeyPath:@"isDeleted" options:NSKeyValueObservingOptionNew context:nil];
    
    //
    //  Maintain a reference to the poly in an array
    //
    
    [self.polygonsToShowInScrollView insertObject:polygon atIndex:0];
    
    //
    //  Render the polygons
    //
    
    [self renderPolygons];

}

- (IBAction)adjustSides:(id)sender {
    self.numberOfSidesLabel.text = [NSString stringWithFormat:@"Polygon has %.0f sides",self.stepper.value];
}

- (IBAction)adjustRotation:(id)sender {
    self.rotationLabel.text = [NSString stringWithFormat:@"Polygon is rotated %.0fº", self.rotationStepper.value];
}

- (IBAction)showRotatingShape:(id)sender {
    
    //Stop the previous shape from animating
    [self.shapeImageView stopAnimating];
    
    // Create a new array of polygons
    NSMutableArray *polygons = [[NSMutableArray alloc] init];
    
    //  Create 360 frames
    for (NSInteger i = 0; i<360; i++) {
        MBPolygonView *polygon = [[MBPolygonView alloc] initWithFrame:self.shapeImageView.frame numberOfSides:self.stepper.value andRotation:i andScale:kScale];
        [polygons addObject:[polygon polyImage]];
    }
    
    //
    //  Set up the animation
    //
    
    [self.shapeImageView setAnimationImages:polygons];
    [self.shapeImageView setAnimationRepeatCount:0];    //animate infinitely
    [self.shapeImageView setAnimationDuration:1];
    
    //  Play it
    [self.shapeImageView startAnimating];
    
}


- (void)viewDidUnload {
    [self setShapeImageView:nil];
    [self setNoPolygonsLabel:nil];
    [super viewDidUnload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isDeleted"] && [object isDeleted]) {
        [self removePolygon:object];
    }
}

//
//  Remove a polygon from the array of
//  polygons and re-render
//

- (void) removePolygon:(MBPolygonView *)polygon{
    [polygon removeObserver:self forKeyPath:@"isDeleted"];
    [self.polygonsToShowInScrollView removeObject:polygon];
    [self renderPolygons];
}

//
//
//

- (void) renderPolygons{
    
    //
    //  Hide/Show the label as appropriate
    //
    
    CGFloat targetAlpha = 1.0;
    
    if (self.polygonsToShowInScrollView.count > 0) {
        targetAlpha = 0.0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.noPolygonsLabel.alpha = targetAlpha;
    }
     completion:^(BOOL finished) {
         //
         //  Clean out the old shapes
         //
         
         for (UIView *view in self.shapeScrollView.subviews) {
             [view removeFromSuperview];
         }
         
         //
         //  Resize the scroll view to hold the polygon
         //
         
         [self.shapeScrollView setContentSize:CGSizeMake(self.polygonsToShowInScrollView.count*gridSize, gridSize)];
         
         //
         //  Render the polygons
         //
         
         for (NSInteger i =0; i<self.polygonsToShowInScrollView.count; i++) {
             [[self.polygonsToShowInScrollView objectAtIndex:i] setFrame:CGRectMake(i*gridSize, 0, gridSize, gridSize)];
             [self.shapeScrollView addSubview:[self.polygonsToShowInScrollView objectAtIndex:i]];
         }
     }];
}

@end
