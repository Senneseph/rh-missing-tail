# s3 single-zero sweep interpretation

## x = 3.232171e+09   (120 grid pts, 119 steps)
- margin  |dm| per 0.025 step:  median 7.01e-03,  mean 1.31e-02,  p99 1.08e-01,  max 1.68e-01
- S-side  |dS| per 0.025 step:  median 0.080,  mean 0.250,  p99 1.920,  max 1.920
- net S change over the 2.98-unit grid: +12.503
- top-5 |dm| steps within 1 of an S-crossing step: 2/5
- contrast max|dm| / median|dS|:  2.1e+00

## x = 7.536256e+09   (120 grid pts, 119 steps)
- margin  |dm| per 0.025 step:  median 5.13e-03,  mean 1.13e-02,  p99 8.52e-02,  max 9.73e-02
- S-side  |dS| per 0.025 step:  median 0.083,  mean 0.237,  p99 1.917,  max 1.917
- net S change over the 2.98-unit grid: +10.102
- top-5 |dm| steps within 1 of an S-crossing step: 1/5
- contrast max|dm| / median|dS|:  1.2e+00

## x = 2.788428e+10   (120 grid pts, 119 steps)
- margin  |dm| per 0.025 step:  median 5.79e-05,  mean 8.41e-03,  p99 7.00e-02,  max 7.20e-02
- S-side  |dS| per 0.025 step:  median 0.088,  mean 0.242,  p99 1.912,  max 1.912
- net S change over the 2.97-unit grid: +9.482
- top-5 |dm| steps within 1 of an S-crossing step: 0/5
- contrast max|dm| / median|dS|:  8.2e-01

## band-wide (all three sweeps)
|dm|:  median 4.36e-03, p99 8.74e-02, max 1.68e-01  (n=357)
|dS|:  median 0.083, p99 1.920, max 1.920  (n=357)

DOOR VERDICT:
- |dm| p99 <= 1e-4: False ;  |dm| max >= 1e-2: True
- -> MARGIN CARRIES ZERO-SCALE STRUCTURE (Door B): re-scope.
