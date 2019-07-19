class Transport {

  String currency;
  
  double price;
  double co2;

  DateTime departureAt;
  DateTime arrivalAt;

  Transport(
    {
      this.currency, 
      this.price, 
      this.departureAt, 
      this.arrivalAt, 
      this.co2
    }
  );

  double co2Pollution(int peopleCount) {
    return co2;
  }

  double co2Saving(int peopleCount) {
    return 0;
  }

  double money(int peopleCount) {
    return peopleCount * price;
  }

  double moneySaving(int peopleCount) {
    return 0;
  }

}