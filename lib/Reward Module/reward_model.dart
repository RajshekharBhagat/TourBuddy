class Reward{
  final String name;
  final String description;
  final String reqPoints;
  bool claimed;
  Reward({required this.name,required this.description, required this.reqPoints, required this.claimed});

  static List<Reward> Rewards = [
    Reward(name: 'Free Coffee', description: 'Enjoy a complimentary cup of coffee at our partnered cafes.', reqPoints: "50", claimed: false),
    Reward(name: 'Discount Coupon', description: 'Get a discount on your next purchase at select stores.', reqPoints: "100", claimed: false),
    Reward(name: 'Movie Ticket Voucher', description: 'Watch your favorite movie with a free ticket at participating theaters.', reqPoints: "150", claimed: false),
    Reward(name: 'Flipkart Voucher', description: 'Redeem this voucher for discounts on your purchases on Flipkart.', reqPoints: '1500', claimed: true)
  ];
  void changeClaim(bool value, int index){
    print('Changing claim status for index $index');
    Rewards[index].claimed = value;
    print('New claim status for index $index: ${Rewards[index].claimed}');
  }
}
class Point{
  static int point = 1000;
  void setPoint(int newPoint){
    point = newPoint;
  }
}