class City {
  final String name;
  final String imagePath;
  final String description;
  final List<Hotel> hotels;
  final List<Place> places;

  City({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.hotels,
    required this.places,
  });
}

class Hotel {
  final String image;
  final String name;
  final double rating;
  final String address;
  final String amenity;
  final String description;
  final double latitude;
  final double longitude;

  Hotel({
    required this.image,
    required this.name,
    required this.rating,
    required this.address,
    required this.amenity,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

class Place {
  final String image;
  final String name;
  final double rating;
  final String address;
  final String description;
  final double latitude;
  final double longitude;

  Place({
    required this.image,
    required this.name,
    required this.rating,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}
