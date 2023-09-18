class Participant {
  String name = "NO_NAME";
  int age = 99;
  bool checkedIn = false;

  Participant(this.name, this.age);

  Participant.fromJSON(Map<String, dynamic> participantMap) {
    name = participantMap["name"];
    age = participantMap["age"];
    checkedIn = participantMap["checkedIn"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "age": age,
      "checkedIn": checkedIn,
    };
  }
}
