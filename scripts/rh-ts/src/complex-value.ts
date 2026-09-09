export interface ComplexValue {
  readonly re: number;
  readonly im: number;
}

export const addComplex = (left: ComplexValue, right: ComplexValue): ComplexValue => ({
  re: left.re + right.re,
  im: left.im + right.im,
});

export const absOfComplex = (value: ComplexValue): number =>
  Math.hypot(value.re, value.im);
