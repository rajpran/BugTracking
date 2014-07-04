//
//  AzSegmentationController.m
//  ESM
//
//  Created by Nivas on 1/6/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "AzSegmentationController.h"

@implementation AzSegmentationController

-(void)awakeFromNib
{
    [super awakeFromNib];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
//                                                           forKey:NSFontAttributeName];
    [self setBackgroundImage:[UIImage imageNamed:@"Resources.bundle/Images/Calendar/Tab_other-MR-event"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self setBackgroundImage:[UIImage imageNamed:@"Resources.bundle/Images/Calendar/Tab_my-event"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:12.0],UITextAttributeFont,
                                      [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                      nil];
    [self setTitleTextAttributes:normalAttributes
                                    forState:UIControlStateNormal];
    
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:12.0],UITextAttributeFont,
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        [UIColor clearColor], UITextAttributeTextShadowColor,
                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                        nil] ;
    [self setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    CGRect frame= self.frame;
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [self setBackgroundImage:[UIImage imageNamed:@"Tab_other-MR-event"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self setBackgroundImage:[UIImage imageNamed:@"Tab_my-event"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self setTintColor:[UIColor grayColor]];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              NSForegroundColorAttributeName : [UIColor blackColor]
                                                              } forState:UIControlStateNormal];
}
*/

@end
