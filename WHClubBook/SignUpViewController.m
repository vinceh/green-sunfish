//
//  SignUpViewController.m
//  WHClubBook
//
//  Created by yong choi on 2014. 4. 19..
//  Copyright (c) 2014년 whispr. All rights reserved.
//

#import "SignUpViewController.h"



@interface SignUpViewController () {
    
    UITableViewCell *cell;
}

@property(nonatomic,weak) UITextField  *firstname;
@property(nonatomic,weak) UITextField  *lastname;
@property(nonatomic,weak) UITextField  *email;
@property(nonatomic,weak) UITextField  *birthday;
@property(nonatomic,weak) UITextField  *gender;
@property(nonatomic,weak) NSString     *genderForServer;

@property(nonatomic,strong) UIButton     *registerButton;
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) UIPickerView *picker;
@property(nonatomic,strong) UIToolbar    *toolbar;
@property(nonatomic,strong) UITextField  *activeTextField;
@property(nonatomic,strong) NSString  *response;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end


@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sign Up";
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"com.whispr.signUpTableCell"];
//    self.tableview.layer.borderColor =[[UIColor blackColor]CGColor];
//    self.tableview.layer.borderWidth= 1.0f;
    //
   // self.signUpButton.enabled = NO;
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UISegmentedControl *leftItems = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" < ", @" > ", nil]];
    [leftItems setEnabled:YES forSegmentAtIndex:0];
    [leftItems setEnabled:YES forSegmentAtIndex:1];
    leftItems.momentary = YES; // do not preserve button's state
    [leftItems addTarget:self action:@selector(nextPrevHandlerDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //prev next
    UIBarButtonItem *nextPrevButton = [[UIBarButtonItem alloc] initWithCustomView:leftItems];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    self.toolbar.items = @[nextPrevButton,flexSpace,doneButton];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.picker = [[UIPickerView alloc] init];
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"com.whispr.signUpTableCell";
    
    cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier
                             forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.cornerRadius = 10.0f;
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (indexPath.row == 0) {
        self.firstname = [self textFieldFactory:@"First name"];
        self.firstname.inputAccessoryView = self.toolbar;
        [self.firstname becomeFirstResponder];
        self.firstname.tag = 0;
        self.firstname.frame = CGRectMake(20, 0, 138, 40);
		[cell.contentView addSubview:self.firstname];

        self.lastname = [self textFieldFactory:@"Last name"];
        self.lastname.inputAccessoryView = self.toolbar;
        self.lastname.tag = 1;
        self.lastname.frame = CGRectMake(160, 0, 138, 40);
		[cell.contentView addSubview:self.lastname];
	} else if (indexPath.row == 1) {
        self.email = [self textFieldFactory:@"Email"];
        self.email.inputAccessoryView = self.toolbar;
        self.email.tag = 2;
        self.email.keyboardType = UIKeyboardTypeEmailAddress;
		[cell.contentView addSubview:self.email];
	} else if (indexPath.row == 2)  {
        self.birthday = [self textFieldFactory:@"Birthday"];
        self.birthday.inputView = self.datePicker;
        self.birthday.inputAccessoryView = self.toolbar;
        self.birthday.tag = 3;
        [cell.contentView addSubview:self.birthday];
    } else if (indexPath.row == 3)  {
        self.gender = [self textFieldFactory:@"Gender"];
        self.gender.tag = 4;
        self.gender.inputView   = self.picker;
        self.gender.inputAccessoryView   = self.toolbar;
        [cell.contentView addSubview:self.gender];
    }
    
    return cell;
    
}

#pragma mark- textfield delegations

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
    textField.layer.borderColor = [UIColor redColor].CGColor;
    textField.layer.borderWidth = 1.0f;
    [self animateView:[textField tag]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //birth day ,,gender  shoud return NO;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 1.0f;

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
        if(textField == self.email)  {
            BOOL validForm  = [self validateEmailWithString:self.email.text];
            if(!validForm)  {
                [self alertView:@"Invalid email" withParam1:@"try again" withParam2:textField];
            }
        }
    
        if(textField ==self.birthday)  {
            NSTimeInterval today    = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval birthday     = [self.datePicker.date timeIntervalSince1970];
            if(birthday > today)  {
                [self alertView:@"Invalid birthday" withParam1:@"cannot greater than today" withParam2:textField];
            }
            
        }
}



#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *image = row == 0 ? [UIImage imageNamed:@"male.png"] : [UIImage imageNamed:@"female.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 32, 32);
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 32)];
    genderLabel.text = [row == 0 ? @"male" : @"female" uppercaseString];
    self.gender.text = @"Male";
    genderLabel.textAlignment = NSTextAlignmentLeft;
    genderLabel.backgroundColor = [UIColor clearColor];
    
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    [rowView insertSubview:imageView atIndex:0];
    [rowView insertSubview:genderLabel atIndex:1];
    
    return rowView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ([self.picker selectedRowInComponent:0] == 0) {
        self.gender.text = @"Male";
    } else {
        self.gender.text = @"Female";
    }
}

#pragma mark - target action
-(UITextField*) textFieldFactory:(NSString*)placeholder  {

	UITextField *textField = [[UITextField alloc] init];
	textField.keyboardType = UIKeyboardTypeAlphabet;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.placeholder = placeholder;
    textField.delegate = self;
    textField.frame = CGRectMake(20, 1, 280, 40);
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    textField.layer.borderWidth = 1.0f;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:18], NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];

    return textField;
}


- (void)nextPrevHandlerDidChange:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case 0:
            [self gotoPrevField];
            break;
        case 1:
            [self gotoNextField];
            break;
        default:
            break;
    }
}

-(void)gotoNextField  {
    
    if (_activeTextField == self.firstname) {
        [self.lastname becomeFirstResponder];
    } else if (_activeTextField == self.lastname) {
        [self.email becomeFirstResponder];
    } else if (_activeTextField==  self.email) {
        [self.birthday becomeFirstResponder];
    } else if (_activeTextField==  self.birthday) {
        [self.gender becomeFirstResponder];
    }else if (_activeTextField==  self.gender) {
        [self.firstname becomeFirstResponder];
    }
}

-(void)gotoPrevField {
    
    if (_activeTextField == self.firstname) {
        [self.gender becomeFirstResponder];
    } else if (_activeTextField == self.gender) {
        [self.birthday becomeFirstResponder];
    } else if (_activeTextField == self.birthday) {
        [self.email becomeFirstResponder];
    } else if (_activeTextField==  self.email) {
        [self.lastname becomeFirstResponder];
    } else if (_activeTextField==  self.lastname) {
        [self.firstname becomeFirstResponder];
    }
}

-(void)done:(id)sender{
    
    [_activeTextField resignFirstResponder];
    [self animateView:1];
}


- (void)animateView:(NSUInteger)tag
{
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect rect = self.view.frame;
        if (tag > 3) {
            rect.origin.y = -44.0f * (tag - 3);
        } else {
            rect.origin.y = 0;
        }
        self.view.frame = rect;
        
    } completion:nil];
    
    
}

- (IBAction) dateValueChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    self.birthday.text = [dateFormatter stringFromDate:[_datePicker date]];
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL) checkTextFieldFilled {
    
    UITextField  *emptyTextField;
    
    if([self.firstname.text length] == 0 ||
       [self.lastname.text length]  == 0 ||
       [self.email.text length] == 0  ||
       [self.birthday.text  length] == 0 ||
       [self.gender.text length] == 0){
                                             
        [self alertView:@"Empty field" withParam1:@"Pleas fill all the fields" withParam2:emptyTextField];
        return NO;
    }
    
    self.genderForServer = ([self.gender.text isEqualToString:@"Male"]) ? @"M" : @"F";
    
    return YES;
}


-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {
   
    
    if ([identifier isEqualToString:@"photoSegue"]) {
        return [self checkTextFieldFilled];
    }
    return YES;
    
}



#pragma mark - cloud integration
//
//- (IBAction)register:(id)sender {
//    
//    NSArray  *values = @[self.email.text, self.gender.text, self.birthday.text, self.firstname.text, self.lastname.text];
//    [[CommonDataManager sharedInstance] setSignUpParameters:values];
//}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    NSArray  *values = @[self.email.text, self.genderForServer, self.birthday.text, self.firstname.text, self.lastname.text];
    [[CommonDataManager sharedInstance] setSignUpParameters:values];
}


-(void) alertView:(NSString*) title  withParam1:(NSString*) msg  withParam2:(UITextField*) textField {

     [UIAlertView showWithTitle:title
                           message:msg
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@[@"OK"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex == [alertView cancelButtonIndex]) {
                                  [textField becomeFirstResponder];
                              }else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
                                  [textField becomeFirstResponder];
                              }
                          }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

