function  [scaled_x] = scale(x, maximum, minimum)

scaled_x = (x - minimum) / (maximum - minimum);
