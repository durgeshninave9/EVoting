class ElectionModel {
  String? accessId;
  String? name;
  String? desc;
  String? startDate;
  String? endDate;
  List<dynamic>? options;
  List<dynamic>? voted;
  String? id;
  String? owner;

  ElectionModel(
      { this.accessId,
       this.name,
       this.desc,
       this.startDate,
       this.endDate,
       this.options,
       this.voted,
       this.owner,
       this.id});
}
