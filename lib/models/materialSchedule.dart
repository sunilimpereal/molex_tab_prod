class MaterialSchedule {
  String orderId;
  String fgPart;
  String scheduleId;
  String locationId;
  String totalBin;
  String routeId;
  MaterialSchedule({
    required this.fgPart,
    required this.locationId,
    required this.orderId,
    required this.routeId,
    required this.scheduleId,
    required this.totalBin,
  });
}
