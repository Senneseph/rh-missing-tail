#!/usr/bin/env python3
"""Derive FACTS[101] numeric fields from the W101 window JSON (machine-computed, no hand-typed numbers).

Usage: python3 derive_facts_101.py      (after window101_b101.json + .verify.json exist)
Prints a python-dict fragment ready to paste as FACTS[101] (the prose fields are templated).
"""
import json, math, sys

BASE = "/home/jsmille/Projects/rh-missing-tail/tmp/ce2/ce1_window_H0_v1"
TPT2 = 3000175332800          # the record height anchor (gap base)
TCE100 = 3000175800092        # FACTS[100]
CENSUS100 = 2000000

d = json.load(open(f"{BASE}/window101_b101.json"))
log = d["log"]
v = json.load(open(f"{BASE}/window101_b101.verify.json"))

# ---- exact dyadic arithmetic on g_b = mant * 2^exp
gm, ge = log["g_b"][0], log["g_b"][1]
assert ge == -86, f"unexpected exponent {ge} (expect -86 family)"
# g_b = mant * 5^86 / 10^86  exactly
num = gm * (5 ** 86)
den = 10 ** 86
tCE = num // den
frac_num = num - tCE * den
# frac as 25-digit string + '...'  (project convention: ~22-25 sig digits)
frac_digits = (frac_num * 10 ** 30) // den
frac = "0." + f"{frac_digits:030d}"[:25]              # NO lstrip: leading zero after the point matters
# x100 rep: galstr = floor(g_b * 100); fracmargin = frac mod 0.01 (exact dyadic)
x100 = gm * 100 * (5 ** 86)
gal = x100 // den
f100_floor = (frac_num * 100) // den
margin_num = frac_num * 100 - f100_floor * den        # scaled by 100: margin = margin_num / (100 den)
margin_digits = (margin_num * 10 ** 28) // den          # margin = margin_num/(100*den); *10^30 => /100*den
margin_str = f"{margin_digits:030d}"[:22]
gap = tCE - TPT2
incr = tCE - TCE100
census = CENSUS100 + (log["b"] - log["a"])

a_str = f"{log['a']:,}".replace(",", " ")
b_str = f"{log['b']:,}".replace(",", " ")

sign_changes = log["sign_changes_in_window"]
rosser_fail = log["rosser_failures"]
print("// ---- machine-derived numeric fields (W101) ----")
print(f"sign_changes = {sign_changes}   (b - a = {log['b']-log['a']})  match: {sign_changes == log['b']-log['a']}")
print(f"rosser_failures = {rosser_fail}")
print(f"tCE = {tCE}")
print(f"gap = {gap}   prevgap = {TCE100 - TPT2}")
print(f"gal = {gal}   gden = 100   galstr = \"{gal} / 100\"")
print(f"frac = \"{frac}... (exact, exponent -86 dyadic terminator)\"")
print(f"fracmargin = \"0.{margin_str} (exact, exponent -86 dyadic arithmetic, center-minus-radius)\"")
print(f"a = \"{a_str}\"   b = \"{b_str}\"")
print(f"ga_b = \"{log['g_a']}\"")
print(f"gb_b = \"{log['g_b']}\"")
print(f"width = 20 000   widthnum = {log['b']-log['a']}   census = \"{census:,}\".replace  censusnum = {census}")
print(f"evals = {log['evals']:,}   seconds = {log['seconds']}   cache = {log['resumed_from_cache']:,}")
print(f"runs = \"{log['consecutive_rosser_blocks_left_of_a']} / {log['consecutive_rosser_blocks_right_of_b']}\"")
print(f"incr = {incr}")
# milestone arithmetic: round marks on the gap scale (multiples of 5 000, as recorded)
marks = [m for m in range(465000, 480000, 5000)]
carried = [(m, m - (TCE100 - TPT2)) for m in marks if (TCE100 - TPT2) < m <= gap]
print(f"new round marks crossed in W101: {carried}")
print(f"verify: CERTIFIED = {v['CERTIFIED']}   turing_ok = {v['turing_ok']}   roesser_failures_inside = {v['rosser_failures_inside']}   sign_changes_inside = {v['sign_changes_inside']}")
print(f"verify g_b = {v['g_b']}")
phase = v["max_phase_contribution_4sqrtN_rad_theta"]
print(f"phase = \"{phase}\"")
print(f"subcent margin ~ {margin_num*10**2/(100*den):.2e} (frac mod 0.01)")
