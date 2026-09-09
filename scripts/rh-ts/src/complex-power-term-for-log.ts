import type { ComplexValue } from "./complex-value.js";

export const complexPowerTermForLog = (
  realPartOfExponent: number,
  imaginaryPartOfExponent: number,
  logOfBase: number,
): ComplexValue => {
  const magnitude: number = Math.exp(-realPartOfExponent * logOfBase);
  const phase: number = -imaginaryPartOfExponent * logOfBase;
  return {
    re: magnitude * Math.cos(phase),
    im: magnitude * Math.sin(phase),
  };
};
