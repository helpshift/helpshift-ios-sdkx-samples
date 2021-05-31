//
//  ViewController.m
//  HSSDKXObjcSample
//
//  Created by Sagar Dagdu on 24/05/21.
//  Copyright © 2021 Sagar Dagdu. All rights reserved.
//

#import "ViewController.h"
#import <HelpshiftX/HelpshiftX.h>

static NSString *const kHsDemoCellIdentifier = @"DemoCellIdentifier";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *actionsTableView;
@property (strong, nonatomic) NSArray<NSString *> *actionNames;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    self.actionNames = @[@"Show Conversation",
                         @"Show FAQs",
                         @"Show FAQ Section",
                         @"Show Single FAQ!",
                         @"Set Language"];
}

- (void)setupUI {
    self.title = @"SDK-X Objc Demo";
    [self.actionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHsDemoCellIdentifier];
    self.actionsTableView.dataSource = self;
    self.actionsTableView.delegate = self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell =  [self.actionsTableView dequeueReusableCellWithIdentifier:kHsDemoCellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [self.actionNames objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionNames.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            [Helpshift showConversationWith:self config:nil];
            break;
        case 1:
            [Helpshift showFAQsWith:self config:nil];
        case 2:
#warning TODO: Replace the SECTION-ID with appropriate section id
            [Helpshift showFAQSection:@"SECTION-ID" with:self config:nil];
        case 3:
#warning TODO: Replace the FAQ-PUBLISH-ID with appropriate faq publish id
            [Helpshift showSingleFAQ:@"FAQ-PUBLISH-ID" with:self config:nil];
        case 4:
            [self openSetLanguageAlert];
            break;
        default:
            break;
    }
}

- (void)openSetLanguageAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter language code"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.keyboardType = UIKeyboardTypeDefault;
         textField.delegate = self;
     }];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    NSString *languageCode = alert.textFields.firstObject.text;
                                    [Helpshift setLanguage:languageCode];
                                }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
