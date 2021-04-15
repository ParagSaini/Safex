class Files {
  int _selectedGender = 1; // 1-male, 2-female, 3-other

  String getGender(int index) {
    String gender = 'male';
    switch (_selectedGender) {
      case 1:
        gender = 'male';
        break;
      case 2:
        gender = 'female';
        break;
      case 3:
        gender = 'other';
        break;
      default:
        gender = 'male';
        break;
    }
    return gender;
  }

  // String gender = getGender(_selectedGender);
  void notNeeded() {
    // GenderSelection(
    //   getGender: (index) {
    //     _selectedGender = index;
    //   },
    // )
    // ,
  }
}
