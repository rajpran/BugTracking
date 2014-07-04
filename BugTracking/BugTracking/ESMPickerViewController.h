//
//  ESMPickerViewController.h
//  ESM
//
//  Created by Administrator on 1/8/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

@interface PickerViewParams : NSObject
@property (assign, nonatomic) UIButton* button;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;
@end

@protocol ESMPickerViewControllerDelegate <NSObject>
@required
-(void)selectedItem:(NSString*)itemId itemName:(NSString*)text tag:(NSInteger)tag;
@end

@interface ESMPickerViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) id<ESMPickerViewControllerDelegate> delegate;
-(void)setItems:(NSArray *)items tag:(NSInteger)tag;
-(void)setSize:(NSInteger)width height:(NSInteger)height;
-(void)setSelectedItem:(NSString*)item;
@end
