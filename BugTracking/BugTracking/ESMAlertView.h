//
//  ESMAlertView.h
//  ESM
//
//  Created by Administrator on 1/10/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

@protocol ESMAlertViewDelegate

- (void)ESMdialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ESMAlertView : UIView<ESMAlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

@property (nonatomic, assign) id<ESMAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;

@property (copy) void (^onButtonTouchUpInside)(ESMAlertView *alertView, int buttonIndex) ;

- (id)init;

/*!
 DEPRECATED: Use the [ESMAlertView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));

- (void)show;
- (void)close;

- (IBAction)ESMdialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(ESMAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;

@end


