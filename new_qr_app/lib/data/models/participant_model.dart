class Participant {
  String name = "NO_NAME";
  bool checkedIn = false;

  Participant(this.name);

  Participant.fromJSON(Map<String, dynamic> participantMap) {
    name = participantMap["name"];
    info = participantMap["info"];
    checkedIn = participantMap["checkedIn"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "info": info,
      "checkedIn": checkedIn,
    };
  }
}
