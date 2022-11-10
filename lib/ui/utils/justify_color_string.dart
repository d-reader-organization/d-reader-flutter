String justifyColorString(String color) {
  color = color.replaceAll('#', '');
  if (color.length == 3) {
    color = color.split('').map((e) => '$e$e').join('');
  }
  return color;
}
