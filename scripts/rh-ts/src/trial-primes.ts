export const trialPrimesUpTo = (limit: number): readonly number[] => {
  const isComposite: boolean[] = new Array<boolean>(limit + 1).fill(false);
  forIndexlessSieve(isComposite, limit);
  return collectSurvivors(isComposite, limit);
};

const markMultiplesOf = (isComposite: boolean[], prime: number, limit: number, shouldMark: boolean): void => {
  let multiple: number = prime * prime;
  while (shouldMark && multiple <= limit) {
    isComposite[multiple] = true;
    multiple += prime;
  }
};

const forIndexlessSieve = (isComposite: boolean[], limit: number): void => {
  let candidate: number = 2;
  while (candidate * candidate <= limit) {
    markMultiplesOf(isComposite, candidate, limit, !isComposite[candidate]!);
    candidate += 1;
  }
};

const collectSurvivors = (isComposite: boolean[], limit: number): number[] => {
  let collected: number[] = [];
  let candidate: number = 2;
  while (candidate <= limit) {
    collected = isComposite[candidate] ? collected : [...collected, candidate];
    candidate += 1;
  }
  return collected;
};
