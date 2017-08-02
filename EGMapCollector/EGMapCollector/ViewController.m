//
//  ViewController.m
//  EGMapCollector
//
//  Created by EG on 2017/7/25.
//  Copyright © 2017年 EGMade. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "SettingTableViewController.h"

#import "EGAnnotation.h"

@interface ViewController ()
<
MKMapViewDelegate,
CLLocationManagerDelegate,
EGAnnotationViewDelegate
>

@property (strong, nonatomic)MKMapView *mapView;

/**action state*/
@property (assign, nonatomic)UserSelectedAction actionState;

/**annotations*/
@property (copy, nonatomic)NSMutableArray<CLLocation *> *annotations;

/**point*/
@property (copy, nonatomic)NSMutableArray <id<MKAnnotation>>*points;

/**location manager*/
@property (strong, nonatomic)CLLocationManager *locationManager;

/**center*/
@property (strong, nonatomic)UIButton *centerButton;

/**location label	*/
@property (strong, nonatomic)UILabel *locationLabel;

/**coder*/
@property (strong, nonatomic)CLGeocoder *geocoder;

/**展示文字*/
@property (copy, nonatomic)NSString *presentInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    self.actionState = kUserSelectedNone;
	[self.view addSubview:self.mapView];

    self.title = @"地图开发";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"操作" style:UIBarButtonItemStyleDone target:self action:@selector(presentAlert)];
    
     UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(showSettings)];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAll)];
    self.navigationItem.rightBarButtonItems = @[settingItem, clearItem];
}

- (void)setPresentInfo:(NSString *)presentInfo {
    _presentInfo = presentInfo;
    self.locationLabel.text = presentInfo;
    [self.mapView addSubview:self.locationLabel];
}

- (void)presentAlert {
     if (self.actionState == kUserSelectedNone) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"功能项" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    switch (self.actionState) {
        case kUserSelectedLocation:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"开始定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getUserCurrentLocation];
        }];
        [alert addAction:action];
      }
            break;
            
        case kUserSelectedCaculateDistance:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"计算距离" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self caculateDistanceBetweenTwoLocation];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedGetDirection:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"获取方向" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentHeading];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedJudgeZone:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"区域判断" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self monitorEnterRegion];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedAddAnnotation:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"添加大头针" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addAnnotation];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedAddCustomAnnotation:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"添加自定义大头针" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addCustomAnnotation];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedAddOverlay:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"添加覆盖" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addOverlays];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedGeocoder:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"对武汉地理编码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self userLocationGeocode];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedDegeocoder:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"开始反地理编码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self userLocationReverseGeocode];
        }];
        [alert addAction:action];
      }
            break;
        default:
            break;
    } 
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSettings {
    SettingTableViewController *settingController = [SettingTableViewController new];
    [self.navigationController pushViewController:settingController animated:YES];
    
    __weak typeof(self) weakSelf = self;
    settingController.callBack = ^(UserSelectedAction action) {
        weakSelf.actionState = action;
    };
}

- (void)clearAll {
    [self.mapView removeAnnotations:self.points];
}

#pragma mark - actions

- (void)getUserCurrentLocation {
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [self.locationManager startUpdatingLocation];
}

- (void)addAnnotation {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.title = @"大头针";
    annotation.subtitle = @"来自系统";
    annotation.coordinate = CLLocationCoordinate2DMake(30.52 + arc4random_uniform(100)/100.0, 114.31 + arc4random_uniform(100)/100.0);
    
    [self.annotations addObject:[[CLLocation alloc]initWithLatitude: annotation.coordinate.latitude longitude: annotation.coordinate.longitude]];
    [self.mapView addAnnotation:annotation];
}

- (void)addCustomAnnotation {
    EGAnnotation *annotation = [[EGAnnotation alloc]init];
    annotation.title = @"大头针";
    annotation.subtitle = @"自定义";
    annotation.speed = 10;
    annotation.height = 5;
    annotation.coordinate = CLLocationCoordinate2DMake(30.52 + arc4random_uniform(100)/100.0, 114.31 + arc4random_uniform(100)/100.0);
    
  [self.annotations addObject:[[CLLocation alloc]initWithLatitude: annotation.coordinate.latitude longitude: annotation.coordinate.longitude]];
    [self.mapView addAnnotation:annotation];
    
}

- (void)addLineToPoint:(CLLocationCoordinate2D)point {
    if (self.annotations.count == 0) return;
    
	CLLocationCoordinate2D *pointsCoordinate = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * 2);
	pointsCoordinate[0] = self.annotations.lastObject.coordinate;
    pointsCoordinate[1] = point;
    
    MKPolyline *ployLine = [MKPolyline polylineWithCoordinates:pointsCoordinate count:2];
    [self.mapView addOverlay:ployLine];
}

- (void)addOverlays {
    MKCircle *effectiveCircle = [MKCircle circleWithCenterCoordinate:self.mapView.userLocation.coordinate
                                                              radius:5000];
    [self.mapView addOverlay:effectiveCircle];
    
    if (self.points.count > 1) {
        CLLocationCoordinate2D *points = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * self.points.count);
        [self.points enumerateObjectsUsingBlock:^(id<MKAnnotation>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            points[idx] = CLLocationCoordinate2DMake(obj.coordinate.latitude, obj.coordinate.longitude);
        }];
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:points count:self.points.count];
        [self.mapView addOverlay:polyline];
     }
 }

- (void)userLocationReverseGeocode {
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        self.presentInfo = [NSString stringWithFormat:@"%f %f  \n => %@",
                                   self.mapView.userLocation.coordinate.latitude,
                                   self.mapView.userLocation.coordinate.longitude,
                                    placemarks.firstObject.addressDictionary[@"City"]];
    }];
}

- (void)userLocationGeocode {
    [self.geocoder geocodeAddressString:@"湖北 武汉" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.presentInfo = [NSString stringWithFormat:@"湖北 武汉 => \n  %f %f ",
                                   placemarks.firstObject.region.center.latitude,
                                   placemarks.firstObject.region.center.longitude
                                 ];
    }];
}

- (void)getCurrentHeading {
    [self.locationManager startUpdatingHeading];
    self.presentInfo = [NSString stringWithFormat:@"北偏 %f", self.locationManager.heading.trueHeading];
}

- (void)monitorEnterRegion {
    CLRegion *region = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(31.00, 114.00) radius:300 identifier:@"monitorRegionID"];
    [self.locationManager startMonitoringForRegion:region];
 }

- (void)caculateDistanceBetweenTwoLocation {
    [self addAnnotation];
    [self addCustomAnnotation];
    
    NSLog(@"%@", self.annotations);
    CLLocation *firstLocation = [[CLLocation alloc]initWithLatitude:self.annotations.firstObject.coordinate.latitude longitude:self.annotations.firstObject.coordinate.longitude];

    CLLocation *lastLocation = [[CLLocation alloc]initWithLatitude:self.annotations.lastObject.coordinate.latitude longitude:self.annotations.lastObject.coordinate.longitude];
    
    self.presentInfo = [NSString stringWithFormat:@"两点间距 %f",
                        [firstLocation distanceFromLocation:lastLocation]];
}

#pragma mark - location delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations  {
    NSLog(@"%@", locations.firstObject);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.locationLabel.text = [NSString stringWithFormat:@"北偏 %f", newHeading.trueHeading];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    self.presentInfo = @"开始检测是否进入观察区域";
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    self.presentInfo = @"检测到进入观察区域";
}

#pragma mark - mapview delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    [self.points addObject:annotation];
    
    if ([annotation isKindOfClass:EGAnnotation.class]) {
        EGAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:[EGAnnotation reusedID]];
        if (!view) {
            view = [[EGAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:[EGAnnotation reusedID]];
            view.image = [UIImage imageNamed:@"fence"];
            view.delegate = self;
        }
        return view;
    }else {
        return  nil;//对于系统的大头针，我们直接可以返回nil，仍然会被渲染
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRend = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRend.lineWidth = 3;
        circleRend.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.1];;
        circleRend.strokeColor = [UIColor blueColor];
        return circleRend;
    }else if ([overlay isKindOfClass:[MKPolyline class]]) {
            //MKPolylineView iOS8 废弃了
        MKOverlayPathRenderer *render = [[MKOverlayPathRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 3.f;
        render.strokeColor = [UIColor orangeColor];
        render.fillColor = [UIColor clearColor];
        render.lineDashPattern = @[@3, @10];
        
        return render;
    }
    
    return nil;
}

#pragma mark - custom annotation delegate

- (void)didSelectedAnnotationView:(EGAnnotationView *)view {
    NSLog(@"我被选中");
}

- (void)didDeselectedAnnotationView:(EGAnnotationView *)view {}

- (void)didClickedAnnotationViewButton:(EGAnnotationView *)view {
    NSLog(@"点击了按钮");
}

- (void)backCenter {
    MKCoordinateRegion  region = {
        self.mapView.userLocation.coordinate,
      	{0.3, 0.3}
    };
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - lazy

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.showsCompass = YES;
        _mapView.showsScale = YES;
        _mapView.showsTraffic = YES;
        _mapView.delegate = self;
        _mapView.translatesAutoresizingMaskIntoConstraints = YES;
        
        [_mapView addSubview:self.centerButton];
    }
    return _mapView;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return _locationManager;
}

- (UIButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _centerButton.tintColor = [UIColor blackColor];
        _centerButton.center = CGPointMake(20, [UIScreen mainScreen].bounds.size.height - 30);
        [_centerButton addTarget:self action:@selector(backCenter) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerButton;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 120, 40)];
        _locationLabel.font = [UIFont systemFontOfSize:10];
        _locationLabel.numberOfLines = 2;
        _locationLabel.backgroundColor = [UIColor whiteColor];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [_locationLabel addGestureRecognizer:tap];
    }
    return _locationLabel;
}

- (void)remove {
    [self.locationLabel removeFromSuperview];
}

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (NSMutableArray<CLLocation *> *)annotations {
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}

- (NSMutableArray <id<MKAnnotation>>*)points {
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

@end
