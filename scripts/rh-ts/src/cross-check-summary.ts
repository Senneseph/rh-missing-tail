export interface CrossCheckRecord {
  readonly label: string;
  readonly measured: number;
  readonly expected: number;
  readonly tolerance: number;
}

export interface CrossCheckSummary {
  readonly passed: boolean;
  readonly records: readonly CrossCheckRecord[];
}

export const evaluateCrossCheckRecord = (record: CrossCheckRecord): boolean =>
  Math.abs(record.measured - record.expected) <= record.tolerance;

export const summarizeCrossChecks = (records: readonly CrossCheckRecord[]): CrossCheckSummary => ({
  passed: records.every(evaluateCrossCheckRecord),
  records,
});
