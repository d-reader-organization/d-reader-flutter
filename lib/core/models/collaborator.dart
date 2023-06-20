class Collaborator {
  final String name, role;

  Collaborator({
    required this.name,
    required this.role,
  });

  factory Collaborator.fromJson(dynamic json) {
    return Collaborator(
      name: json['name'],
      role: json['role'],
    );
  }
}
  // Role
  // Writer: 'Writer',
  // Artist: 'Artist',
  // Colorist: 'Colorist',
  // Editor: 'Editor',
  // Letterer: 'Letterer',
  // CoverArtist: 'CoverArtist'