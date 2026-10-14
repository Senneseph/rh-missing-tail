# s3 ledger-reconstruction single-zero margin sweep


RECONSTRUCTION GATE vs certified ledger:  PASS (max |dmnew| = 9.576e-09 < 1e-5)
anchors (narrow-window >= 6 ledger rows): 3.2322e+09,  7.5363e+09,  2.7884e+10
anchor x=3.232171e+09: GATE over 6 ledger rows: PASS (max |dmnew| = 9.576e-09, 52.9s)

## x = 3.232171e+09   grid 120 pts in 1032.5 s
- |dmnew| per 0.025 step:  median=7.010e-03 mean=1.314e-02 p99=1.081e-01 max=1.681e-01
- |dresidf| per step:       median=2.442e-01 mean=3.108e-01 p99=1.538e+00 max=1.790e+00
- |dzabs| per step:         median=1.323e-01 mean=1.562e-01 p99=5.990e-01 max=6.341e-01
- |ddev| per step:          median=1.547e-11 mean=2.141e-10 p99=1.635e-09 max=1.239e-08
- |dS| per step (local):    median=7.981e-02 mean=2.079e-01 p99=1.920e+00 max=1.920e+00
- S-crossing steps (|dS|>0.5): 14;  big margin steps (>10x median): 5;  aligned within 1: 3
anchor x=7.536256e+09: GATE over 6 ledger rows: PASS (max |dmnew| = 9.576e-09, 50.7s)

## x = 7.536256e+09   grid 120 pts in 1017.7 s
- |dmnew| per 0.025 step:  median=5.125e-03 mean=1.133e-02 p99=8.516e-02 max=9.734e-02
- |dresidf| per step:       median=7.100e-01 mean=1.132e+00 p99=3.996e+00 max=4.460e+00
- |dzabs| per step:         median=4.031e-01 mean=6.556e-01 p99=2.638e+00 max=2.707e+00
- |ddev| per step:          median=6.633e-12 mean=9.181e-11 p99=7.011e-10 max=5.315e-09
- |dS| per step (local):    median=8.318e-02 mean=1.868e-01 p99=1.083e+00 max=1.917e+00
- S-crossing steps (|dS|>0.5): 12;  big margin steps (>10x median): 7;  aligned within 1: 1
anchor x=2.788428e+10: GATE over 6 ledger rows: PASS (max |dmnew| = 9.576e-09, 49.1s)

## x = 2.788428e+10   grid 120 pts in 987.4 s
- |dmnew| per 0.025 step:  median=5.792e-05 mean=8.406e-03 p99=6.996e-02 max=7.205e-02
- |dresidf| per step:       median=1.218e+00 mean=1.096e+02 p99=2.274e+03 max=3.946e+03
- |dzabs| per step:         median=5.493e-01 mean=8.655e-01 p99=2.863e+00 max=3.092e+00
- |ddev| per step:          median=1.793e-12 mean=2.481e-11 p99=1.895e-10 max=1.436e-09
- |dS| per step (local):    median=8.838e-02 mean=1.744e-01 p99=9.116e-01 max=1.912e+00
- S-crossing steps (|dS|>0.5): 11;  big margin steps (>10x median): 43;  aligned within 1: 15

DECISION RULES (docs/SOLUTION-SHAPE.md):
- |dmnew| median/p99 <= ~1e-4 at the 0.025 step while |dS| ~ 0.25:  structural flatness (Door A alive).
- |dmnew| rough (>= ~1e-2) and/or big steps aligned with S crossings: margin tracks zero-scale structure (Door B).
