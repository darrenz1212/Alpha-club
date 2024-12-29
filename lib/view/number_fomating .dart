String formatLargeNumber(num value) {
  if (value >= 1e12) {
    return '${(value / 1e12).toStringAsFixed(1)} Trillion'; 
  } else if (value >= 1e9) {
    return '${(value / 1e9).toStringAsFixed(1)} bio'; 
  } else if (value >= 1e6) {
    return '${(value / 1e6).toStringAsFixed(1)} Mio'; 
  } else if (value >= 1e3) {
    return '${(value / 1e3).toStringAsFixed(1)} K'; 
  } else {
    return value.toString();
  }
}
