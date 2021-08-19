import 'package:molex/model_api/process1/getBundleListGl.dart';

import '../model_api/crimping/bundleDetail.dart';

class PreparationScan{
  String employeeId;
  String bundleId;
  String status;
  String binId;
  BundlesRetrieved bundleDetail;
  PreparationScan({this.bundleId,this.bundleDetail,this.employeeId,this.status,this.binId});
}