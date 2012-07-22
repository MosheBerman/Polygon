//
//  MBPolygonView.h
//  Polygon
//
//  Created by Moshe Berman on 7/22/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPolygonView : UIView

- (id)initWithFrame:(CGRect)frame numberOfSides:(NSInteger)numberOfSides andRotation:(CGFloat)rotation andScale:(CGFloat) scale;

@end
