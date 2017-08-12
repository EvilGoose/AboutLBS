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
#import "EGPOIAnnotation.h"
#import "EGPOIAnnotationView.h"
#import "EGOverlayRenderer.h"
#import "GradientPolylineRenderer.h"

@interface ViewController ()
<
MKMapViewDelegate,
CLLocationManagerDelegate,
EGAnnotationViewDelegate,
EGPOIAnnotationViewDelegate
>

@property (strong, nonatomic)MKMapView *mapView;

/**action state*/
@property (assign, nonatomic)UserSelectedAction actionState;

/**annotations*/
@property (copy, nonatomic)NSMutableArray<CLLocation *> *annotations;

/**point*/
@property (copy, nonatomic)NSMutableArray <id<MKAnnotation>>*points;

/**覆盖*/
@property (copy, nonatomic)NSMutableArray <id<MKOverlay>>*overlays;

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
	[self.view addSubview:self.mapView];

    self.title = @"地图开发";
    
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"操作" style:UIBarButtonItemStyleDone target:self action:@selector(presentAlert)];
    
	UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(showSettings)];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAll)];
    self.navigationItem.rightBarButtonItems = @[settingItem, clearItem];
    

    
    self.actionState = kUserSelectedNone;
}

#pragma mark - setter

- (void)setPresentInfo:(NSString *)presentInfo {
    _presentInfo = presentInfo;
    self.locationLabel.text = presentInfo;
    [self.mapView addSubview:self.locationLabel];
}

- (void)setActionState:(UserSelectedAction)actionState {
    _actionState = actionState;
    if (actionState == kUserSelectedNone) {
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor lightGrayColor];
    }else {
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blueColor];
    }
}

#pragma mark - actions

- (void)getGPSWithLocation:(CLLocation *)location {
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    //这个值越小越准确
    self.presentInfo = [NSString stringWithFormat:@"GPS失准度 %f", horizontalAccuracy];
}

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
    
    [self addLineToPoint:annotation.coordinate];
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
    
        //构造多边形数据对象
    CLLocationCoordinate2D coordinates[6];
    coordinates[0].latitude = 30.493777;
    coordinates[0].longitude = 114.380868;
    
    coordinates[1].latitude = 30.476847;
    coordinates[1].longitude = 114.415938;
    
    coordinates[2].latitude = 30.45842;
    coordinates[2].longitude = 114.382018;
    
    coordinates[3].latitude = 30.453439;
    coordinates[3].longitude = 114.341774;
    
    coordinates[4].latitude = 30.466887;
    coordinates[4].longitude = 114.325101;
    
    coordinates[5].latitude = 30.482823;
    coordinates[5].longitude = 114.33315;
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coordinates count:6];
    [self.mapView addOverlay:polygon];

//    MKMapRect rect = {
//        {0	, 0},
//        {100, 100}
//    };
//    EGOverlay  *overlay = [[EGOverlay alloc]initWithRect:rect];
//    [self.mapView addOverlay:overlay];
//    MKMapRect mapRect = MKMapRectNull;
//    for (id<MKAnnotation> obj in self.points) {
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(obj.coordinate.latitude, obj.coordinate.longitude);
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
//        
//        if (MKMapRectIsNull(mapRect)) {
//            mapRect = pointRect;
//        } else {
//            mapRect = MKMapRectUnion(mapRect, pointRect);
//        }
//    }
//    mapRect = [self.mapView mapRectThatFits:mapRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.mapView setVisibleMapRect:mapRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:NO];
//    [self.mapView addOverlay:[[EGOverlay alloc] initWithRect:mapRect] level:1];
    
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
        CLCircularRegion *region = (CLCircularRegion *)placemarks.firstObject.region;
        self.presentInfo = [NSString stringWithFormat:@"湖北 武汉 => \n %f %f ",
                                   region.center.latitude,
                                   region.center.longitude];
    }];
 }

- (void)getCurrentHeading {
    [self.locationManager startUpdatingHeading];
    self.presentInfo = [NSString stringWithFormat:@"北偏 %f", self.locationManager.heading.trueHeading];
}

- (void)monitorEnterRegion {
    CGFloat radius = 600;
    CLLocationCoordinate2D center =  CLLocationCoordinate2DMake(30.46800722, 114.42189969);
    
    MKCircle *effectiveCircle = [MKCircle circleWithCenterCoordinate:center
                                                              radius:radius];
    [self.mapView addOverlay:effectiveCircle];
    
    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:center
                                                                radius:radius
                                                            identifier:@"monitorRegionID"];
    if ([region containsCoordinate:self.mapView.userLocation.coordinate]) {
        self.presentInfo = @"已经在区域内";
    }else {
        self.presentInfo = @"当前不在区域内";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.locationManager startMonitoringForRegion:region];
        });
    }
}

- (void)caculateDistanceBetweenTwoLocation {
    [self clearAll];
    
    [self addAnnotation];
    [self addCustomAnnotation];
    
    CLLocation *firstLocation = [[CLLocation alloc]initWithLatitude:self.annotations.firstObject.coordinate.latitude longitude:self.annotations.firstObject.coordinate.longitude];

    CLLocation *lastLocation = [[CLLocation alloc]initWithLatitude:self.annotations.lastObject.coordinate.latitude longitude:self.annotations.lastObject.coordinate.longitude];
    
    self.presentInfo = [NSString stringWithFormat:@"两点间距 %f",
                        [firstLocation distanceFromLocation:lastLocation]];
    
    MKCoordinateRegion region =
    {CLLocationCoordinate2DMake(
                                .5 * (self.annotations.firstObject.coordinate.latitude + self.annotations.lastObject.coordinate.latitude),
                                .5 * (self.annotations.firstObject.coordinate.longitude + self.annotations.lastObject.coordinate.longitude)),
      {
        1.3 * fabs(self.annotations.firstObject.coordinate.latitude - self.annotations.lastObject.coordinate.latitude),
        1.3 * fabs(self.annotations.firstObject.coordinate.longitude - self.annotations.lastObject.coordinate.longitude)
      }
    };
    
    [self.mapView setRegion:region animated:YES];
}

- (void)beginConfigurePath:(NSString *)goalName {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];//导航请求
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    [self.geocoder geocodeAddressString:@"武夷山" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error)  return ;
        
            //终点
         request.destination = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithPlacemark: placemarks.lastObject]];
        
        MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            if (error)  return ;
            for (MKRoute *route in response.routes) {
                [self.mapView addOverlay:route.polyline];
            }
        }];
    }];
}

- (void)addGradientLine {
    CLLocationCoordinate2D *pointsCoordinate = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * self.annotations.count);
    [self.annotations enumerateObjectsUsingBlock:^(CLLocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        pointsCoordinate[idx] = obj.coordinate;
    }];
    
    GradientPolylineOverlay *polyline = [[GradientPolylineOverlay alloc] initWithPoints:pointsCoordinate velocity:malloc(sizeof(float)*self.annotations.count) count:self.annotations.count];
    [self.mapView addOverlay:polyline];
}

- (void)showPOIS {
        //创建一个位置信息对象，第一个参数为经纬度，第二个为纬度检索范围，单位为米，第三个为经度检索范围，单位为米
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 3000, 3000);
    
        //初始化一个检索请求对象
    MKLocalSearchRequest * req = [[MKLocalSearchRequest alloc]init];
    
    req.region=region;
    req.naturalLanguageQuery = @"餐厅";
    
        //初始化检索
    MKLocalSearch * ser = [[MKLocalSearch alloc]initWithRequest:req];
    
        //开始检索，结果返回在block中
    [ser startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSArray * array = [NSArray arrayWithArray:response.mapItems];
        for (int i=0; i<array.count; i++) {
            MKMapItem * item=array[i];
            EGPOIAnnotation * point = [[EGPOIAnnotation alloc]init];
            point.title = item.name;
            point.subtitle = item.phoneNumber;
            point.coordinate=item.placemark.coordinate;
            [self.mapView addAnnotation:point];
        }
    }];
}

- (void)clearAll {
    [self.mapView removeAnnotations:self.points];
    [self.points removeAllObjects];
    [self.annotations removeAllObjects];
    
    [self.mapView removeOverlays:self.overlays];
    [self.overlays removeAllObjects];
}

#pragma mark - private method

- (void)presentAlert {
    if (self.actionState == kUserSelectedNone) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作" message:@"点击开始" preferredStyle:UIAlertControllerStyleActionSheet];
    
    switch (self.actionState) {
        case kUserSelectedLocation:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"开始定位当前位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getUserCurrentLocation];
        }];
        [alert addAction:action];
      }
            break;
            
        case kUserSelectedCaculateDistance:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"计算随机两点距离" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self caculateDistanceBetweenTwoLocation];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedGetDirection:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"获取手机方向" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentHeading];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedJudgeZone:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"判断区域" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self monitorEnterRegion];
        }];
        [alert addAction:action];
      }
            break;
        case kUserSelectedAddAnnotation:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"添加系统大头针" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"添加各种系统覆盖" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"反地理编码所在位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self userLocationReverseGeocode];
        }];
        [alert addAction:action];
      }
            break;
            
        case kUserSelectedGuide:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"到武夷山的路线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self beginConfigurePath:@"武夷山"];
        }];
        [alert addAction:action];
      }
            break;
            
        case kUserSelectedGradientLine:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"自定义连线添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addGradientLine];
        }];
        [alert addAction:action];
      }
            break;
            
        case kUserSelectedShowPOIS:
      {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"附近三千米的餐厅" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showPOIS];
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

- (void)backCenter {
    MKCoordinateRegion  region = {
        self.mapView.userLocation.coordinate,
        {0.3, 0.3}
    };
    [self.mapView setRegion:region animated:YES];
}

- (void)remove {
    [self.locationLabel removeFromSuperview];
}

- (void)addLineToPoint:(CLLocationCoordinate2D)point {
    if (self.annotations.count == 0) return;
    
    CLLocationCoordinate2D *pointsCoordinate = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * 2);
    pointsCoordinate[0] = self.annotations.lastObject.coordinate;
    pointsCoordinate[1] = point;
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:pointsCoordinate count:2];
    [self.mapView addOverlay:polyline];
}

#pragma mark - location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations  {
    NSLog(@"%@", locations.firstObject);
    [self getGPSWithLocation:locations.firstObject];
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
        EGAnnotationView *view = (EGAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[EGAnnotation reusedID]];
        if (!view) {
            view = [[EGAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:[EGAnnotation reusedID]];
            view.delegate = self;
        }
        return view;
        
    }else if([annotation isKindOfClass:EGPOIAnnotation.class]){
        EGPOIAnnotationView *view = (EGPOIAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[EGAnnotation reusedID]];
        if (!view) {
            view = [[EGPOIAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:[EGPOIAnnotation reusedID]];
            view.delegate = self;
        }
        return view;
    }
    return  nil;//对于系统的大头针，我们直接可以返回nil，仍然会被渲染
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    [self.overlays addObject:overlay];
    
     if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRend = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRend.lineWidth = 3.f;
         if (self.actionState == kUserSelectedJudgeZone) {
             circleRend.strokeColor = [UIColor redColor];
             circleRend.fillColor = [UIColor colorWithRed:1 green:.1 blue:.1 alpha:.1];;

         }else {
             circleRend.strokeColor = [UIColor blueColor];
             circleRend.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.1];;
         }

        return circleRend;
         
    }else if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 3.f;
        if ((self.actionState == kUserSelectedGuide) || (self.actionState == kUserSelectedShowPOIS)) {
            render.strokeColor = [UIColor purpleColor];
        }else {
            render.strokeColor = [UIColor orangeColor];
            render.lineDashPattern = @[@3, @10];//虚线
        }
        
        return render;
        
    }else if([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth = 3.f;
        polygonRenderer.strokeColor = [UIColor greenColor];
        polygonRenderer.fillColor = [UIColor colorWithRed:.4 green:.2 blue:.8 alpha:.3];
        
        return polygonRenderer;
        
    }else if([overlay isKindOfClass:[EGOverlay class]]){
        EGOverlayRenderer *render = [[EGOverlayRenderer alloc] initWithOverlay:overlay];
        return render;
        
    }else if([overlay isKindOfClass:[GradientPolylineOverlay class]]){
        GradientPolylineRenderer *render = [[GradientPolylineRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 8.f;
        
        return render;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState {
    switch (newState) {
        case MKAnnotationViewDragStateNone:
            NSLog(@"MKAnnotationViewDragStateNone");
            break;
            
        case MKAnnotationViewDragStateStarting:
            NSLog(@"MKAnnotationViewDragStateStarting");
            break;
            
        case MKAnnotationViewDragStateDragging:
            NSLog(@"MKAnnotationViewDragStateDragging");
            break;
            
        case MKAnnotationViewDragStateCanceling:
            NSLog(@"MKAnnotationViewDragStateCanceling");
            view.dragState = MKAnnotationViewDragStateNone;
            break;
            
        case MKAnnotationViewDragStateEnding:
            NSLog(@"MKAnnotationViewDragStateEnding");
            view.dragState = MKAnnotationViewDragStateNone;
            break;
            
        default:
            break;
    }
}

#pragma mark - custom annotation delegate

- (void)didSelectedAnnotationView:(EGAnnotationView *)view {
    NSLog(@"%@被选中", view);
    
}

- (void)didDeselectedAnnotationView:(EGAnnotationView *)view {
    NSLog(@"%@不再选中", view);
}

- (void)didClickedAnnotationViewButton:(EGAnnotationView *)view {
    NSLog(@"点击了按钮");
}

- (void)didClickedAnnotationViewPathConfigureButton:(EGPOIAnnotationView *)view {
//    NSLog(@"路线到 %@ %f %f", view.POIAnnotation.title,  view.POIAnnotation.coordinate.latitude, view.POIAnnotation.coordinate.longitude);
    
    [self.mapView removeOverlays:self.overlays];
    [self.overlays removeAllObjects];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];//导航请求
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    //终点
    request.destination = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:view.POIAnnotation.coordinate]];
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (error)  return ;
        for (MKRoute *route in response.routes) {
            [self.mapView addOverlay:route.polyline];
        }
    }];

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
        _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 95, 120, 40)];
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

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return _locationManager;
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

- (NSMutableArray <id<MKOverlay>>*)overlays {
    if (!_overlays) {
        _overlays = [NSMutableArray array];
    }
    return _overlays;
}

@end
