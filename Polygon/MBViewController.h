//
//  MBViewController.h
//  Polygon
//
//  Created by Moshe Berman on 7/22/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rotationLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIStepper *rotationStepper;
@property (weak, nonatomic) IBOutlet UIImageView *shapeImageView;
@property (weak, nonatomic) IBOutlet UILabel *noPolygonsLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *shapeScrollView;
- (IBAction)addShape:(id)sender;
- (IBAction)adjustSides:(id)sender;
- (IBAction)adjustRotation:(id)sender;
- (IBAction)showRotatingShape:(id)sender;

@end
