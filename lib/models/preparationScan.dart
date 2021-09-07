import '../model_api/process1/getBundleListGl.dart';

import '../model_api/crimping/bundleDetail.dart';

class PreparationScan{
  String employeeId;
  String bundleId;
  String status;
  String binId;
  BundlesRetrieved bundleDetail;
  PreparationScan({required this.bundleId,required this.bundleDetail,required this.employeeId,required this.status,required this.binId});
}