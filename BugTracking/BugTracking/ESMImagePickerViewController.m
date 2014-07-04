//
//  ESMImagePickerViewController.m
//  ESM
//
//  Created by Administrator on 1/22/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "ESMImagePickerViewController.h"

@interface ESMImagePickerViewController ()<UIScrollViewDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *originalImage;
    CGFloat cx ;
    UIImagePickerController *cameraImagePicker;
}
@property(nonatomic,weak)UIButton *btn;
@property(nonatomic,strong)UIPopoverController *getImagePopover;
@property(nonatomic,strong)UIPopoverController *pickImageFromGalleryPopover;
@property(nonatomic,strong)UIScrollView *imageCarousel;
@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation ESMImagePickerViewController
@synthesize getImagePopover;
@synthesize btn;
@synthesize pickImageFromGalleryPopover;
@synthesize imageCarousel;
static int fileName;

-(id)init:(id)sender
{
	self.btn=(UIButton *)sender;
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIView *topView = [self.btn superview];
	[topView addSubview:self.view];
    cx=0;
	fileName=1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)takePictureUsingCamera:(UIButton *)sender{
    cameraImagePicker = [[UIImagePickerController alloc] init];
    cameraImagePicker.delegate = self;
    cameraImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.delegate showImagePicker:cameraImagePicker];
}

-(void)pickFromGallery:(UIButton *)sender
{
    self.btn=(UIButton *)sender;
	UIImagePickerController *galleryImagePicker = [[UIImagePickerController alloc] init];
	self.pickImageFromGalleryPopover=[[UIPopoverController alloc]initWithContentViewController:galleryImagePicker];
	self.pickImageFromGalleryPopover.delegate=self;
    galleryImagePicker.delegate = self;
    galleryImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	//[self.getImagePopover dismissPopoverAnimated:YES];
	[self.pickImageFromGalleryPopover presentPopoverFromRect:self.btn.frame inView:[self.btn superview] permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES ];
}

#pragma UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.pickImageFromGalleryPopover dismissPopoverAnimated:YES];
    //CGFloat	height= self.btn.center.y+self.btn.bounds.size.height;
    //CGFloat width = self.view.frame.size.width;
    [cameraImagePicker dismissViewControllerAnimated:YES completion:nil];

//    [SVProgressHUD showWithStatus:AzLocalizedString(@"Saving", nil)];

    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
        originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        [self.delegate setEventMaterialImage:originalImage];

    });
    
	/*[self.imageDictionary addObject:originalImage];
	// Convert UIImage to JPEG
	NSData *imgData = UIImageJPEGRepresentation(originalImage, 1); // 1 is compression quality
	
	// Identify the home directory and file name
	NSString *fileNameString=[NSString stringWithFormat:@"%d", fileName];
	fileName++;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
	NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
	NSString *jpgPath=[dataPath stringByAppendingString:fileNameString];
	jpgPath=[jpgPath stringByAppendingString:@".jpeg"];
	
	// Write the file.  Choose YES atomically to enforce an all or none write. Use the NO flag if partially written files are okay which can occur in cases of corruption
	[imgData writeToFile:jpgPath atomically:YES];
    [photoPicker dismissViewControllerAnimated:YES completion:NULL];
    self.imageView = [[UIImageView alloc] initWithImage:originalImage];
    CGRect rect = self.imageView.frame;
    rect.size.height = 80;
    rect.size.width = 80;
    rect.origin.x = cx;
    rect.origin.y = 0;
    self.imageView.frame = rect;
    cx += self.imageView.frame.size.width+5;
    if(!self.imageCarousel)
    {
        self.imageCarousel=[[UIScrollView alloc] initWithFrame:self.view.frame];
		self.imageCarousel.delegate=self;
		[self.imageCarousel setScrollEnabled:YES];
        [self.imageCarousel setShowsHorizontalScrollIndicator:YES];
        [self.imageCarousel setShowsVerticalScrollIndicator:NO];
		self.imageCarousel.frame=CGRectMake(0, 0, width, 100);
		self.view.frame=CGRectMake(0, height, width, 104);
        [self.delegate setEventMaterialImage:originalImage];
		//[self.view addSubview:self.imageCarousel];
        
    }
	[self.imageCarousel addSubview:self.imageView];
	self.imageCarousel.contentSize=CGSizeMake(cx, 80);*/
}

#pragma UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}
-(void)completionCallback{

}
@end
