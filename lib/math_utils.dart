import 'dart:math';

double tanh(double angle) {
  if (angle > 19.1) {
    return 1.0;
  }

  if (angle < -19.1) {
    return -1.0;
  }

  var e1 = exp(angle);
  var e2 = exp(-angle);
  return (e1 - e2) / (e1 + e2);
}