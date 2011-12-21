#import "MCMFacebookCommentsView.h"

#import "constants.h"

static const CGFloat authenticateButtonHeight = 44.0f;
static const CGFloat kGutter = 20.0f;
static NSString * const kCommentCell = @"MCMCommentCell";

@interface MCMFacebookCommentsView()
@property (weak) UIButton *authenticateButton;
@property (weak) UITableView *tableView;
@property (strong) id facebookDidLogInObserver;

-(IBAction)authenticateButtonTapped:(id)sender;

-(void)commonInit;
-(BOOL)isAuthenticated;
-(void)reloadButtons;
@end


@implementation MCMFacebookCommentsView
@synthesize delegate, dataSource;
@synthesize authenticateButton, tableView;
@synthesize facebookDidLogInObserver;

-(void)commonInit{
	[self setBackgroundColor:[UIColor redColor]];
	UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self setAuthenticateButton:aButton]; //weak
	[[self authenticateButton] setTitle:@"Authenticate" forState:UIControlStateNormal];
	[[self authenticateButton] addTarget:self action:@selector(authenticateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[[self authenticateButton] setHidden:YES];
	[self addSubview:[self authenticateButton]];
	
	UITableView *aTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[aTableView setDelegate:self];
	[aTableView setDataSource:self];
	[self setTableView:aTableView];
	[self addSubview:[self tableView]];
	[[self tableView] registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:kCommentCell];
	
	[self reloadButtons];
	
	[self setFacebookDidLogInObserver:[[NSNotificationCenter defaultCenter] addObserverForName:MCMFacebookDidLogInNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		[self reloadButtons];
	}]];
}


-(id)initWithFrame:(CGRect)frame{
	if((self = [super initWithFrame:frame])){
		[self commonInit];
	}
	return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
	if((self = [super initWithCoder:aDecoder])){
		[self commonInit];
	}
	return self;
}


//We create subviews in init, but can't set their frames until we know self's bounds here.
-(void)willMoveToSuperview:(UIView *)newSuperview{
	CGSize size = [self bounds].size;
	[[self authenticateButton] setFrame:CGRectMake(0.0f, 0.0f, size.width, authenticateButtonHeight)];
	[[self authenticateButton] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
	
	[[self tableView] setFrame:CGRectMake(0.0f, authenticateButtonHeight + kGutter, size.width, size.height - (authenticateButtonHeight+kGutter))];
}


-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:[self facebookDidLogInObserver]];
	[self setFacebookDidLogInObserver:nil];
}


#pragma mark - ACTIONS
-(IBAction)reload:(id)sender{
	[[self tableView] reloadData];
}


-(IBAction)authenticateButtonTapped:(id)sender{
	if([[self delegate] respondsToSelector:@selector(commentsViewDidRequestAuthentication:)]){
		[[self delegate] commentsViewDidRequestAuthentication:self];	
	}
}


#pragma mark - TABLE VIEW DELEGATES
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//+1 for the "add a comment" cell
	return [[self dataSource] numberOfComments:self] + 1;
}


-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:kCommentCell];
	return cell;
}

#pragma mark - PRIVATE
-(void)reloadButtons{	
	NSLog(@"reload");
	[[self authenticateButton] setHidden:[self isAuthenticated]];
}


-(BOOL)isAuthenticated{
	return [[self dataSource] respondsToSelector:@selector(commentsViewIsAuthenticated:)] && [[self dataSource] commentsViewIsAuthenticated:self];
}

@end
