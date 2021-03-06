#import "MCMFacebookCommentsViewController.h"

#import "MCMComment.h"
#import "MCMCommentCell.h"
#import "Facebook.h"
#import "Facebook+Comments.h"

static NSString * const kCommentCellIdentifier = @"MCM Facebook comment cell identifier";

@interface MCMFacebookCommentsViewController ()
@property (weak) UITableView *tableView;
@property (weak) UIButton *authenticateButton;
@property (copy, nonatomic) NSArray *comments;

@property (strong) id facebookDidLogInObserver;
@property (strong) id commentDidUpdateDataObserver;

-(IBAction)authenticateButtonTapped:(id)sender;
-(void)reloadButtons;
-(NSArray *)mergeFacebookQuery:(NSArray *)oneThing with:(NSArray *)anotherThing;
@end

@implementation MCMFacebookCommentsViewController
@synthesize commentsURL, facebook;
@synthesize tableView, authenticateButton, comments;
@synthesize facebookDidLogInObserver, commentDidUpdateDataObserver;

-(id)initWithURL:(NSURL *)aCommentsURL andFacebook:(Facebook *)aFacebook{
  if((self = [super initWithNibName:nil bundle:nil])){
    [self setFacebook:aFacebook];
    [self setCommentsURL:aCommentsURL];
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
  
  [self setCommentDidUpdateDataObserver:[[NSNotificationCenter defaultCenter] addObserverForName:MCMCommentDidUpdateDataNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    MCMComment *updatedComment = [note object];
    NSUInteger updatedIndex = [[self comments] indexOfObject:updatedComment];
    NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:updatedIndex inSection:0];
    MCMCommentCell *cell = (MCMCommentCell *)[[self tableView] cellForRowAtIndexPath:updatedIndexPath];
    if(cell){
      [[cell image] setImage:[updatedComment profileImage]];
    }
  }]];
  
  [[self facebook] fetchCommentsForURL:[self commentsURL] delegate:self];
}

-(void)viewDidUnload{
//  [[NSNotificationCenter defaultCenter] removeObserver:[self facebookDidLogInObserver]];
//  [self setFacebookDidLogInObserver:nil];
}


#pragma mark - ACCESSORS
-(void)setComments:(NSArray *)someComments{
  comments = someComments;
  [[self tableView] reloadData];
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
	return [[self comments] count];
}


-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	MCMCommentCell *cell = [aTableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
  NSInteger row = [indexPath row];
  MCMComment *comment = [[self comments] objectAtIndex:row];

  [[cell comment] setText:[comment comment]];
  [[cell name] setText:[comment name]];
  [[cell image] setImage:[comment profileImage]];
  [cell setIndented:[comment isIndented]];
	return cell;
}


#pragma mark - FACEBOOK DELEGATE
-(void)request:(FBRequest *)request didLoad:(id)result{
  NSArray *fbComments = [[result objectAtIndex:0] objectForKey:@"fql_result_set"];
  NSArray *fbUsers = [[result objectAtIndex:1] objectForKey:@"fql_result_set"];
  [self setComments:[self mergeFacebookQuery:fbComments with:fbUsers]];
}


#pragma mark - PRIVATE
-(NSArray *)mergeFacebookQuery:(NSArray *)someComments with:(NSArray *)someUsers{
  NSMutableArray *newComments = [NSMutableArray arrayWithCapacity:[someComments count]];
  
  [someComments enumerateObjectsUsingBlock:^(id aComment, NSUInteger idx, BOOL *stop) {
    NSDictionary *aUser = [someUsers objectAtIndex:idx];
    
    MCMComment *newComment = [[MCMComment alloc] init];
    [newComment setName:[aUser objectForKey:@"name"]];
    [newComment setComment:[aComment objectForKey:@"text"]];
    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [aUser valueForKey:@"id"]];
    [newComment setProfileImageURL:[NSURL URLWithString:urlString]];
    [newComments addObject:newComment];
    
    NSDictionary *replies = [aComment objectForKey:@"comments"];
    //Goofy JSONness here. «comments» is sometimes a dictionary. But sometimes it's also an empty array. Both dictionaries and arrays respond to «count», so we're testing with that.
    if([replies count]){
      [[replies objectForKey:@"data"] enumerateObjectsUsingBlock:^(id aReply, NSUInteger idx, BOOL *stop) {
        MCMComment *newReply = [[MCMComment alloc] init];
        [newReply setComment:[aReply objectForKey:@"message"]];
        [newReply setName:[[aReply objectForKey:@"from"] objectForKey:@"name"]];
        NSString *replyURLString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [[aReply objectForKey:@"from"] objectForKey:@"id"]];
        [newReply setProfileImageURL:[NSURL URLWithString:replyURLString]];
        [newReply setIndented:YES];
        [newComments addObject:newReply];
      }];
    }
  }];
  return newComments;
}


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