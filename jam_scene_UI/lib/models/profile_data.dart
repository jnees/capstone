class ProfileData {
  final String id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String city;
  final String state;
  final String zipcode;
  final String influences;
  final String recordings;
  final String description;
  final DateTime joinDate;
  final bool availMonAm;
  final bool availMonPm;
  final bool availTueAm;
  final bool availTuePm;
  final bool availWedAm;
  final bool availWedPm;
  final bool availThuAm;
  final bool availThuPm;
  final bool availFriAm;
  final bool availFriPm;
  final bool availSatAm;
  final bool availSatPm;
  final bool availSunAm;
  final bool availSunPm;
  final String profilePhoto;
  final List instruments;

  const ProfileData(
      {required this.id,
      required this.email,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.city,
      required this.state,
      required this.zipcode,
      required this.influences,
      required this.recordings,
      required this.description,
      required this.joinDate,
      required this.availMonAm,
      required this.availMonPm,
      required this.availTueAm,
      required this.availTuePm,
      required this.availWedAm,
      required this.availWedPm,
      required this.availThuAm,
      required this.availThuPm,
      required this.availFriAm,
      required this.availFriPm,
      required this.availSatAm,
      required this.availSatPm,
      required this.availSunAm,
      required this.availSunPm,
      required this.profilePhoto,
      required this.instruments});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      city: json['city'],
      state: json['state'],
      zipcode: json['zipcode'],
      influences: json['influences'],
      recordings: json['recordings'],
      description: json['description'],
      joinDate: DateTime.parse(json['join_date']),
      availMonAm: json['avail_mon_am'],
      availMonPm: json['avail_mon_pm'],
      availTueAm: json['avail_tue_am'],
      availTuePm: json['avail_tue_pm'],
      availWedAm: json['avail_wed_am'],
      availWedPm: json['avail_wed_pm'],
      availThuAm: json['avail_thu_am'],
      availThuPm: json['avail_thu_pm'],
      availFriAm: json['avail_fri_am'],
      availFriPm: json['avail_fri_pm'],
      availSatAm: json['avail_sat_am'],
      availSatPm: json['avail_sat_pm'],
      availSunAm: json['avail_sun_am'],
      availSunPm: json['avail_sun_pm'],
      profilePhoto: json['profile_photo'],
      instruments: json['instruments'],
    );
  }
}
