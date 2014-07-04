//
//  ESMImagePickerViewController.h
//  ESM
//
//  Created by Administrator on 1/22/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//


@protocol ESMImagePickerViewControllerDelegate <NSObject>
@required
-(void)setEventMaterialImage:(UIImage*)materialImage;
-(void)showImagePicker:(UIImagePickerController*)cameraImagePicker;

@end

@interface ESMImagePickerViewController : UIViewController
@property (nonatomic, weak) id<ESMImagePickerViewControllerDelegate> delegate;
-(id)init:(id)sender;
-(void)takePictureUsingCamera:(UIButton *)sender;
-(void)pickFromGallery:(UIButton *)sender;
@end
