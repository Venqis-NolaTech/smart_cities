import 'package:flutter/widgets.dart';

class AppImagePaths {
  static const _basePath = 'res/images';

  static const logo = '$_basePath/logo.png';
  static const splashBackground = '$_basePath/background_splash.png';
  static const iconCar = '$_basePath/icon_car.png';
  static const iconPay = '$_basePath/icon_pay.png';
  static const iconReports = '$_basePath/icon_reports.png';
  static const homeBackground = '$_basePath/home_background.png';

  static const step1 = '$_basePath/group_step_1.png';
  static const step2 = '$_basePath/group_step_2.png';
  static const step3 = '$_basePath/group_step_3.png';
  static const step4 = '$_basePath/group_step_4.png';
  static const step5 = '$_basePath/group_step_5.png';

  static const ellipse = '$_basePath/ellipse_icon.png';
  static const ellipseHome = '$_basePath/ellipse.png';
  static const photo = '$_basePath/photo.png';
  static const iconMap = '$_basePath/icon_map.png';


  static const iconRoute = '$_basePath/find_route.png';
  static const iconReport = '$_basePath/report_icon.png';

  static const iconPayFact = '$_basePath/icon_pay_fact.png';
  static const eye = '$_basePath/eye.png';
  static const eyeOff = '$_basePath/eye_off.png';


  static const iconPass = '$_basePath/icon_pass.png';
  static const iconUser = '$_basePath/icon_user.png';
  static const iconMail = '$_basePath/icon_mail.png';
  static const iconFacebook = '$_basePath/icon_facebook.png';

  static const defaultImage = '$_basePath/default_image.png';
  static const mapPoint = '$_basePath/map_point.png';

  static const camera = '$_basePath/photo_camera.png';
  static const rectangle = '$_basePath/rectangle.png';
  static const createReport = '$_basePath/img_create_report.png';
  static const createComment= '$_basePath/img_create_comment.png';

  // status icon map

  static const closeStatus = '$_basePath/close_status.png';
  static const openStatus = '$_basePath/done_status.png';
  static const inProgressStatus = '$_basePath/in_progress_status.png';
  static const mapIcon = '$_basePath/pin_map.png';
 
   static const closeStatusiOS = '$_basePath/close_status_1.png';
  static const openStatusiOS = '$_basePath/done_status_1.png';
  static const inProgressStatusiOS = '$_basePath/in_progress_status_1.png';
  static const mapIconiOS = '$_basePath/pin_map_1.png';

  static const iconMessage = '$_basePath/icon_message.png';
  static const iconComment = '$_basePath/comment.png';

  static const iconGallery = '$_basePath/gallery.png';

  static const empyteComment = '$_basePath/empyte_comment.png';

  static const tune = '$_basePath/tune.png';

  static const backgroundProfile = '$_basePath/backgroung_profile.png';

  //services
  static const gazebo = '$_basePath/gazebo.png';
  static const security = '$_basePath/security.png';
  static const bicycle = '$_basePath/bicycle.png';
  static const running = '$_basePath/running.png';

  static const games = '$_basePath/two_swings.png';
  static const dish = '$_basePath/dish.png';// plato
  static const bath = '$_basePath/toilet.png'; // baño
  static const cleanning = '$_basePath/shape.png';
  static const camionIcon = '$_basePath/camion_icon.png';

  static const iconTrash = '$_basePath/trash.png';
  static const iconStar = '$_basePath/star.png';
  static const iconFailed = '$_basePath/img_icon_failed.png';

  //static const success = '$_basePath/success.png';
  //static const failure = '$_basePath/failure.png';
  //static const noConnection = '$_basePath/no_connection.png';
  //static const warning = '$_basePath/warning.png';


/*
  static const addUser = '$_basePath/add_user.png';
  static const removeUser = '$_basePath/remove_user.png';
  static const inviteUser = '$_basePath/invite_user.png';

  static const registerSuccess = '$_basePath/register_success.png';
  static const registerFailure = '$_basePath/register_failure.png';

  static const background = '$_basePath/background.png';


  static const exitChannel = '$_basePath/exit_channel.png';
  static const acceptedChannel = '$_basePath/accepted_channel.png';
  static const requestSend = '$_basePath/request_send.png';

  static const placeholder = '$_basePath/placeholder.png';
  static const myChannelEmptyBackdground =
      '$_basePath/my_channel_empty_background.png';

  static const excel = '$_basePath/excel.png';
  static const folder = '$_basePath/folder.png';
  static const image = '$_basePath/image.png';
  static const pdf = '$_basePath/pdf.png';
  static const powerPoint = '$_basePath/power_point.png';
  static const world = '$_basePath/world.png';
  static const emptyComments = '$_basePath/empty_comments.png';



  static const removePost = '$_basePath/remove_post.png';*/
}

class AppImages {
  static final logo = Image.asset(AppImagePaths.logo);
  static final splashBackground = Image.asset(AppImagePaths.splashBackground, fit: BoxFit.cover);
  static final homeBackground = Image.asset(AppImagePaths.homeBackground);
  static final iconCar = Image.asset(AppImagePaths.iconCar);
  static final iconPay = Image.asset(AppImagePaths.iconPay);
  static final iconReports = Image.asset(AppImagePaths.iconReports);

  static final step1 = Image.asset(AppImagePaths.step1, fit: BoxFit.fitWidth);
  static final step2 = Image.asset(AppImagePaths.step2, fit: BoxFit.fitWidth);
  static final step3 = Image.asset(AppImagePaths.step3, fit: BoxFit.fitWidth);
  static final step4 = Image.asset(AppImagePaths.step4, fit: BoxFit.fitWidth);
  static final step5 = Image.asset(AppImagePaths.step5, fit: BoxFit.fitWidth);

  static final ellipse = Image.asset(AppImagePaths.ellipse, fit: BoxFit.cover);

  static final iconPass = Image.asset(AppImagePaths.iconPass);
  static final iconMail = Image.asset(AppImagePaths.iconMail);
  static final iconUser = Image.asset(AppImagePaths.iconUser);
  static final iconFacebook = Image.asset(AppImagePaths.iconFacebook);

  static final eye = Image.asset(AppImagePaths.eye);
  static final eyeOff = Image.asset(AppImagePaths.eyeOff);
  static final iconPayFact = Image.asset(AppImagePaths.iconPayFact);


  static final defaultImage = Image.asset(AppImagePaths.defaultImage);
  static final mapPoint = Image.asset(AppImagePaths.mapPoint);


  static final closeStatus = Image.asset(AppImagePaths.closeStatus);
  static final openStatus = Image.asset(AppImagePaths.openStatus);
  static final inProgressStatus = Image.asset(AppImagePaths.inProgressStatus);
  static final mapIcon = Image.asset(AppImagePaths.mapIcon);
  static final iconMessage = Image.asset(AppImagePaths.iconMessage);
  static final iconComment = Image.asset(AppImagePaths.iconComment);

  static final iconGallery = Image.asset(AppImagePaths.iconGallery);
  static final empyteComment = Image.asset(AppImagePaths.empyteComment);
  static final iconTune = Image.asset(AppImagePaths.tune);

  static final backgroundProfile = Image.asset(AppImagePaths.backgroundProfile);

  static final family = Image.asset(AppImagePaths.gazebo);
  static final security = Image.asset(AppImagePaths.security);
  static final bicycle = Image.asset(AppImagePaths.bicycle);
  static final running = Image.asset(AppImagePaths.running);

  static final games = Image.asset(AppImagePaths.games);
  static final restaurant = Image.asset(AppImagePaths.dish);
  static final bath = Image.asset(AppImagePaths.bath);
  static final cleanning = Image.asset(AppImagePaths.cleanning);
  static final camionIcon = Image.asset(AppImagePaths.camionIcon);

  static final iconTrash = Image.asset(AppImagePaths.iconTrash);
  static final iconStar = Image.asset(AppImagePaths.iconStar);
  static final iconFailed = Image.asset(AppImagePaths.iconFailed);
  static final success = Image.asset(AppImagePaths.createComment);



  //static final failure = Image.asset(AppImagePaths.failure);
  //static final warning = Image.asset(AppImagePaths.warning);
  //static final noConnection = Image.asset(AppImagePaths.noConnection);
  //static final success = Image.asset(AppImagePaths.success);



 /* static final addUser = Image.asset(AppImagePaths.addUser);
  static final removeUser = Image.asset(AppImagePaths.removeUser);
  static final inviteUser = Image.asset(AppImagePaths.inviteUser);


  static final registerFailure = Image.asset(AppImagePaths.registerFailure);
  static final registerSuccess = Image.asset(AppImagePaths.registerSuccess);



  static final background = Image.asset(AppImagePaths.background, fit: BoxFit.cover);



  static final exitChannel = Image.asset(AppImagePaths.exitChannel);
  static final acceptedChannel = Image.asset(AppImagePaths.acceptedChannel);

  static final requestSend = Image.asset(AppImagePaths.requestSend);
  static final placeholder = Image.asset(AppImagePaths.placeholder, fit: BoxFit.cover);
  static final myChannelEmptyBackdground =
  Image.asset(AppImagePaths.myChannelEmptyBackdground);


  static final excel = Image.asset(AppImagePaths.excel);
  static final folder = Image.asset(AppImagePaths.folder);
  static final image = Image.asset(AppImagePaths.image);
  static final pdf = Image.asset(AppImagePaths.pdf);
  static final powerPoint = Image.asset(AppImagePaths.powerPoint);
  static final world = Image.asset(AppImagePaths.world);
  static final emptyComments = Image.asset(AppImagePaths.emptyComments);


  static final removePost = Image.asset(AppImagePaths.removePost);*/
}
