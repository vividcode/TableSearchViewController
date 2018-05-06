//
//  TableSearchViewController.h
//  iphonegamezone
//
//  Created by Nirav Bhatt on 5/25/16.
//  Copyright © 2016 iphonegamezone.net. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ACCESSORY_ACTION
{
    ACCESSORY_ACTION_CHECK=1,
    ACCESSORY_ACTION_DELETE,
    ACCESSORY_ACTION_NAVIGATE
} ACCESSORY_ACTION;

typedef enum CELLCOLORSTYLE
{
    CELL_COLOR_STYLE_NONE=0,
    CELL_COLOR_STYLE_UNIFORM,
    CELL_COLOR_STYLE_ALTERNATE_DOUBLE,
    CELL_COLOR_STYLE_ALTERNATE_TRIPLE
} CELLCOLORSTYLE;

typedef enum SECTIONCOLORSTYLE
{
    SECTION_COLOR_STYLE_NONE=0,
    SECTION_COLOR_STYLE_UNIFORM=1
} SECTIONCOLORSTYLE;

@protocol TableSearchViewControllerDelegate <NSObject>

@optional
- (BOOL) rowShouldbePreSelectedForKVCObject : (_Nonnull id) kvcObject;

@end

@interface WrapperObject : NSObject

@property (nonatomic) BOOL selected;
@property (nonatomic, retain) NSObject * _Nonnull kvcObject;


@end


@interface TableSearchViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate>

@property (nonatomic, assign, nullable) id <TableSearchViewControllerDelegate> delegate;

-(instancetype) initWithCellColorStyle:(CELLCOLORSTYLE)cellColorStyle andSectionColorStyle:(SECTIONCOLORSTYLE) sectionColorStyle andAllowSelectionCheckMark:(BOOL)bAllowSelectionCheckMark andAllowSelectAllCheckBox:(BOOL)bAllowSelectAllCheckBox andAllowSearch:(BOOL)bAllowSearch andAccessoryAction:(ACCESSORY_ACTION)accessoryAction andFooterText:(NSString*)footerText andResultsArray:(NSArray*)resultsArray;

@property (nonatomic, retain) NSArray<NSDictionary<NSString *, NSArray<NSObject*>*> *> *  _Nonnull resultsArray;

@property (nonatomic, retain) NSArray * _Nullable cellColorArray;
@property (nonatomic, retain) NSArray * _Nullable cellTextColorArray;

@property (nonatomic, retain) NSArray * _Nullable sectionColorArray;
@property (nonatomic, assign) UIColor * _Nullable seperatorColor;

@property (nonatomic) SECTIONCOLORSTYLE sectionColorStyle;
@property (nonatomic) CELLCOLORSTYLE cellColorStyle ;

@property (nonatomic, retain) NSString * _Nonnull textLabelSeperator;
@property (nonatomic, retain) NSString * _Nonnull subTitleSeperator;

@property (nonatomic, retain) NSArray * _Nonnull searchKeys;
@property (nonatomic, retain) NSArray * _Nonnull textLabelKeys;
@property (nonatomic, retain) NSArray * _Nonnull subTitleKeys;
@property (nonatomic, retain) NSArray * _Nonnull textLableFormats;
@property (nonatomic, retain) NSArray * _Nonnull subTitleFormats;


@property (nonatomic, retain) UITableView * _Nonnull tableView;
@property (nonatomic, retain) NSString * _Nullable checkBoxText;
@property (nonatomic, retain) NSString * _Nullable selectionDoneButtonTitle;
@property (nonatomic, retain) NSString * _Nullable dismissButtonTitle;
@property (nonatomic, retain) NSString * _Nullable searchBarPlaceHolderText;
@property (nonatomic, retain) NSArray * _Nullable accessoryImages;
@property (nonatomic, retain) NSArray * _Nullable selectAllImages;

@property (nonatomic) BOOL allowSelectAllCheckBox;
@property (nonatomic) BOOL allowSelectionCheckMark;
@property (nonatomic) BOOL allowSelectionCheckImage;

@property (nonatomic) BOOL allowSearch;
@property (nonatomic) BOOL allowMultiSelect;

@property (nonatomic) BOOL showGroupedView;

@property (nonatomic) NSUInteger rowHeight;
@property (nonatomic) NSUInteger sectionHeaderHeight;
@property (nonatomic) NSUInteger sectionFooterHeight;

@property (nonatomic, retain) NSString * _Nullable accessoryPromptMessageTitle;
@property (nonatomic, retain) NSString * _Nullable accessoryPromptMessageText;
@property (nonatomic, retain) NSString * _Nullable accessoryPromptOKButtonTitle;
@property (nonatomic, retain) NSString * _Nullable accessoryPromptCancelButtonTitle;
@property (nonatomic) ACCESSORY_ACTION accessoryAction;

@property (nonatomic) BOOL isSearching;
@property (strong, nonatomic) UISearchBar * _Nullable searchBar;

@property (nonatomic, copy, nonnull) void (^selectionDoneBlock)( NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag);
@property (nonatomic, copy, nonnull) void (^cancelBlock)(NSString* _Nullable info);
@property (nonatomic, copy, nonnull) void (^accessoryActionDoneBlock)( NSArray* _Nullable  accessoryActionKVCObjects);

@end
