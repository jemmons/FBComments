#import "MCMFacebookCommentsViewController.h"
#import "MCMCommentCell.h"

static NSString * const kCommentCellIdentifier = @"MCM Facebook comment cell identifier";

@interface MCMFacebookCommentsViewController ()
@property (weak) UITableView *tableView;
@property (weak) UIButton *authenticateButton;
@property (strong) id facebookDidLogInObserver;
-(IBAction)authenticateButtonTapped:(id)sender;
-(void)reloadButtons;
@end

@implementation MCMFacebookCommentsViewController
@synthesize tableView, authenticateButton;
@synthesize facebookDidLogInObserver;

-(id)init{
  if((self = [super initWithNibName:nil bundle:nil])){
    //
  }
  return self;
}

-(void)loadView{
  UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  [aView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [self setView:aView];
}


-(void)viewDidLoad{  
  CGRect bounds = [[self view] bounds];
  CGFloat commentHeight = 64.0f;
  CGRect commentsFrame = CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height - commentHeight);
  CGRect replyFrame = CGRectMake(0.0f, CGRectGetMaxY(commentsFrame), bounds.size.width, commentHeight);

  [[self view] setBackgroundColor:[UIColor redColor]];
  UIView *commentView = [[UIView alloc] initWithFrame:replyFrame];
  [commentView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
  [commentView setBackgroundColor:[UIColor blueColor]];
  [[self view] addSubview:commentView];
  
  
//	UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[aButton setTitle:@"Authenticate" forState:UIControlStateNormal];
//	[aButton addTarget:self action:@selector(authenticateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//  [aButton setFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
//	[aButton setHidden:NO];
//  [self setAuthenticateButton:aButton]; //weak
//	[[self view] addSubview:[self authenticateButton]];
	
	UITableView *aTableView = [[UITableView alloc] initWithFrame:commentsFrame style:UITableViewStylePlain];
	[aTableView setDelegate:self];
	[aTableView setDataSource:self];
  [aTableView setRowHeight:70.0f];
  [aTableView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
  //TODO: Remove this dependency on an external nib.
  [aTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:kCommentCellIdentifier];
	[self setTableView:aTableView]; //weak
	[[self view] addSubview:[self tableView]];
	
//	[self setFacebookDidLogInObserver:[[NSNotificationCenter defaultCenter] addObserverForName:MCMFacebookDidLogInNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
//		[self reloadButtons];
//	}]];
}

-(void)viewDidUnload{
//  [[NSNotificationCenter defaultCenter] removeObserver:[self facebookDidLogInObserver]];
//  [self setFacebookDidLogInObserver:nil];
}


#pragma mark - ACTIONS
-(IBAction)authenticateButtonTapped:(id)sender{
//	if([[self delegate] respondsToSelector:@selector(commentsViewDidRequestAuthentication:)]){
//		[[self delegate] commentsViewDidRequestAuthentication:[self parent]];	
//	}
}


#pragma mark - TABLE VIEW DELEGATES
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//	return [[self dataSource] numberOfComments:[self parent]];
  return 3;
}


-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	MCMCommentCell *cell = [aTableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
  [[cell label] setText:@"foo"];
	return cell;
}


#pragma mark - PRIVATE
-(void)reloadButtons{	
	[[self authenticateButton] setHidden:[self isAuthenticated]];
}


-(BOOL)isAuthenticated{
  BOOL isAuthenticated = NO;
//  if([[self dataSource] respondsToSelector:@selector(commentsViewIsAuthenticated:)]){
//    isAuthenticated = [[self dataSource] commentsViewIsAuthenticated:[self parent]];
//  }
	return isAuthenticated;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
  return YES;
}


@end