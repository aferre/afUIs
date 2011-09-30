//
//  afListViewContainer.m
//  afLibBrowser
//
//  Created by Adrien Ferré on 27/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "afListViewContainer.h"
#import "afHorizontalListView.h"

#define PGHeight 20
#define TITLEHeight 20
#define SUBTITLEHeight 20

@implementation afListViewContainer

@synthesize theTitle,theSubtitle,theListView,style,delegate;
@synthesize hasTitle,hasSubtitle,hasPageControl,pageControls;

#pragma mark -
#pragma mark == Init ==
#pragma mark -

- (id) initWithFrame:(CGRect)frame
	 andListViewSize:(CGSize)listViewSize{
	
    if ((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;
		
		theListView = [[afHorizontalListView alloc] initWithFrame:CGRectMake(0, 0, listViewSize.width, listViewSize.height) 
													andDataSource:self 
													 hasNavArrows:YES];
		theListView.selectionDelegate = self;
		[self addSubview:theListView];
		
    }
    return self;
}

- (id) initWithOrigin:(CGPoint)origin
	  andListViewSize:(CGSize)listViewSize
			 andStyle:(afListViewStyle)s{
	
	CGFloat h = listViewSize.height + [self computeViewHeightForStyle:s];
	
    if ((self = [self initWithFrame:CGRectMake(origin.x, origin.y, listViewSize.width, h)
					andListViewSize:listViewSize])) {
		
		[self setStyle:s];
		
    }
    return self;
}

#pragma mark -
#pragma mark == listView DataSource Delegate ==
#pragma mark -

- (int) numberOfItems:(afListView *)listView{
	return 25;
}

- (UIView *) listView:(afListView *)listView 
		 viewForIndex:(int)theIndex{
	UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",theIndex]];
	UIImageView *iv = [[UIImageView alloc] initWithImage:img];
	iv.userInteractionEnabled = YES;
	return [iv autorelease];
}

#pragma mark -
#pragma mark == listView selection Delegate ==
#pragma mark -

- (void) isUnderSelection:(int) index{
    
	if (pageControls){
        
        if ([pageControls count] !=0 ) {
            [self updatePageControlsWithIndex:index];
        }
    }
	if (theTitle) {
		theTitle.text = [NSString stringWithFormat:@"%d",index];
	}
	if (theSubtitle) {
		theSubtitle.text = [NSString stringWithFormat:@"%d",index];
	}
}

- (void) selectedIndex:(int) index{
    
}

- (void) hasBeenSelected:(NSString *) theID{
	
}

- (void) clicked{
    
}

- (void) updatePageControlsWithIndex:(int) index{
    
    int itemsPerRow = [self itemsNumberPerPageControlForWidth:self.frame.size.width];
    
    int indexRow = 1;
    
    while (indexRow*itemsPerRow < index + 1) {
        indexRow ++;
    }
    
    int pageControlIndex = index - (indexRow - 1) * itemsPerRow;
    
    UIPageControl *concernedPG = [pageControls objectAtIndex:indexRow - 1];
    
    concernedPG.currentPage = pageControlIndex;
}

- (CGFloat) computeViewHeightForStyle:(afListViewStyle) s{
	
	switch (s) {
		case PageControl:
			return PGHeight + 5;
			break;
		case Title:
			return 5 + 20;
			break;
		case PageControl_Title:
			return PGHeight + 5 + 5 + 20;
			break;
		case PageControl_Title_Subtitle:
			return PGHeight + 5 + 5 + 20 + 5 + 20;
			break;
		case Title_Subtitle:
			return 5 + 20 + 5 + 20;
			break;
		default:
			return 0;
			break;
	}
	
}

- (void) pageChanged:(UIPageControl *)sender{
    int row = [pageControls indexOfObject:sender];
    
    int selection = sender.currentPage + 1;
    
    int itemsPerRow = [self itemsNumberPerPageControlForWidth:self.frame.size.width];
    
    int finalIndex = row * itemsPerRow + selection;
    
	[theListView setSelectedAndAnimate: finalIndex];
}

- (int) computePageControlsNumberForWidth:(CGFloat)width itemsNumber:(int) itemsNumber{
    
    int rowsYouWillNeedToDisplayAllDots = ceil((double)itemsNumber/(double)[self itemsNumberPerPageControlForWidth:width]);
    
    return rowsYouWillNeedToDisplayAllDots;
}

- (int) itemsNumberPerPageControlForWidth:(CGFloat)width{
    
    //you can fit 20 page control dots on a full width view on a 320 px screen (iphone).
    
    int ratio = floor(320/19);
    
    int pgDotsYouCanFitInOnePG = width / ratio;
    
    return pgDotsYouCanFitInOnePG;
}

- (void) setupSubtitleLabel:(UIView *)previousView{
    
    if (!theSubtitle) {
        
        theSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                                previousView.frame.size.height + previousView.frame.origin.y + 5, 
                                                                self.frame.size.width,
                                                                20)];
        [theSubtitle setTextColor:[UIColor blackColor]];
        [theSubtitle setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [theSubtitle setBackgroundColor:[UIColor clearColor]];
        [theSubtitle setTextAlignment:UITextAlignmentCenter];
        [theSubtitle setLineBreakMode:UILineBreakModeTailTruncation];
        theSubtitle.numberOfLines = 1;
        theSubtitle.hidden = NO;
    }
    
    [theSubtitle setText:@"subtitle"];
    
    if (!theSubtitle.superview) {
        [self addSubview:theSubtitle];
    }
    
}

- (void) setupTitleLabel:(UIView *)previousView{
    if (!theTitle) {
        theTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                             previousView.frame.size.height + previousView.frame.origin.y + 5, 
                                                             self.frame.size.width,
                                                             20)];
        [theTitle setTextColor:[UIColor blackColor]];
        [theTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [theTitle setBackgroundColor:[UIColor clearColor]];
        [theTitle setTextAlignment:UITextAlignmentCenter];
        [theTitle setLineBreakMode:UILineBreakModeTailTruncation];
        theTitle.numberOfLines = 1;	
        theTitle.hidden = NO;
    }
    [theTitle setText:@"title"];
    if (!theTitle.superview) {
        [self addSubview:theTitle];
    }
}

- (void) setupPageControl:(UIView *)previousView{
    int pageControlNumber = [self computePageControlsNumberForWidth:self.frame.size.width itemsNumber:[theListView.listViews.subviews count]];
    int itemsPerPageControl = [self itemsNumberPerPageControlForWidth:self.frame.size.width];
    UIPageControl *lastPageControl = nil;
    
    if (!pageControls){
        pageControls = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < pageControlNumber ; i++){
            
            int remainingPGs = pageControlNumber - i;
            UIPageControl *pg ;
            
            if (!lastPageControl)
                pg = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                     previousView.frame.size.height + previousView.frame.origin.y + 5, 
                                                                     self.frame.size.width, 
                                                                     PGHeight)];
            else
                pg = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                     lastPageControl.frame.size.height + lastPageControl.frame.origin.y + 5, 
                                                                     self.frame.size.width, 
                                                                     PGHeight)];
            pg.backgroundColor = [UIColor blackColor];
            [pg addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
            pg.userInteractionEnabled = YES;
            pg.hidden = NO;
            if (remainingPGs > 1){
                pg.numberOfPages = itemsPerPageControl;
            }
            else{
                pg.numberOfPages = [theListView.listViews.subviews count] - (pageControlNumber - 1) * itemsPerPageControl;
            }
            [self addSubview:pg];
            [pageControls addObject:pg];
            [pg release];
            lastPageControl = [pageControls lastObject];
        }
    }
    
}

- (void) setStyle:(afListViewStyle)theStyle{
	style = theStyle;
	switch (theStyle) {
		case PageControl:{
			[self setupPageControl:theListView];
		}
			break;
		case Title:
		{
            [self setupTitleLabel:theListView];
			
		}
			break;
		case PageControl_Title:
		{
			[self setupPageControl:theListView];            
            UIPageControl *lastPageControl = [pageControls lastObject];
			
            [self setupTitleLabel:lastPageControl];
			
		}
			break;
		case PageControl_Title_Subtitle:
		{
            [self setupPageControl:theListView];            
            
            UIPageControl *lastPageControl = [pageControls lastObject];
			
            [self setupTitleLabel:lastPageControl];
			[self setupSubtitleLabel:theTitle];
        }
            break;
        case Title_Subtitle:
        {
            [self setupTitleLabel:theListView];
            [self setupSubtitleLabel:theTitle];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc {
    
    delegate = nil;
    
    [theTitle release];
    theTitle = nil;
    
    [theSubtitle release];
    theSubtitle = nil;
    
	[super dealloc];
}


@end
