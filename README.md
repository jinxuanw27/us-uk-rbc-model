# U.S.–U.K. Productivity Spillovers and Two-Country RBC Model

**Jinxuan Wang | Johns Hopkins University | International Macroeconomics coursework**

This project estimates U.S. and U.K. productivity dynamics and calibrates a two-country real business cycle model using Python, MATLAB, and Dynare. It builds on course-provided data and model templates from Francisco E. Ilabaca's International Macroeconomics assignment. Original submissions are preserved under `archive/original/` and `reports/`. The cleaned Python script and code repairs were prepared subsequently with AI assistance for portfolio presentation.

## Research questions

- Does lagged U.S. productivity help predict U.K. productivity, and vice versa?
- How can a two-country RBC steady state match government-spending shares and relative labor inputs?
- How can correlated productivity innovations be represented in a dynamic equilibrium model?

## Data

`data/ExamStataData.csv` contains 54 annual observations from 1960 through 2013 and 111 columns. The analysis uses U.S. and U.K. output, work hours, capital, population ages 15 and above, labor shares, government spending, and depreciation. The file was supplied with the course assignment. Its upstream statistical source and redistribution terms have not been established from the supplied materials. Confirm redistribution permission before publishing the dataset, course templates, or assignment answers.

## Methods and reproduced findings

Labor shares are fixed at their country-specific sample means. An intercept-only regression of log output minus the labor and capital contributions estimates the production scaling constant and productivity residual. Because the production function has constant returns to scale, using consistently normalized per-population quantities gives the same adjusted log output as using aggregate quantities.

A two-variable VAR uses the residual series ordered as U.S., U.K. AIC, BIC, HQIC, and FPE all select one lag with a maximum of ten. The reproduced VAR passes the stability check.

| Quantity | Reproduced value |
| --- | ---: |
| U.S. labor share | 0.6261774 |
| U.K. labor share | 0.6109430 |
| U.S. production scaling constant | 16.215226 |
| U.K. production scaling constant | 14.214441 |
| U.S. lag coefficient in the U.K. equation | 0.1561653 |
| U.K. lag coefficient in the U.S. equation | -0.0412054 |
| Residual correlation | 0.3846222 |
| U.S. predicts U.K., joint F-test p-value | 0.0006032 |
| U.K. predicts U.S., joint F-test p-value | 0.4509287 |

The results support asymmetric predictive relationships in this sample. A recursive contemporaneous ordering requires an additional identifying assumption. The cleaned analysis reports reduced-form VAR results and Granger tests. Statistical significance of the production intercept tests a zero log scaling constant under conventional OLS standard errors.

The MATLAB calibration targets `G/Y = 0.2102921`, `Gstar/Ystar = 0.2341014`, and `N/Nstar = 1.7212276`, with the United States as home. The original report gives `G = 1.833670`, `Gstar = 0.825665`, and `gamma = 1.285278`.

## Repository contents

| Location | Contents |
| --- | --- |
| `src/analyze.py` | Cleaned, executable production estimation and VAR pipeline |
| `data/` | Course input data |
| `matlab/` | Calibration driver and steady-state residual function |
| `dynare/` | Repaired dynamic model draft |
| `results/` | Recomputed Python estimates, covariance matrix, and diagnostics |
| `reports/` | Original answer report and handwritten steady-state derivation |
| `archive/original/` | Original notebooks and submitted MATLAB/Dynare code |
| `CHANGELOG.md` | Repairs, methodological choices, and validation limits |

## Run the Python analysis

From the repository root, use Python 3.11 or later with the packages in `requirements.txt`.

```bash
python -m pip install -r requirements.txt
python src/analyze.py
```

The script resolves paths relative to its own location, checks consecutive unique years and required inputs, estimates production residuals, chooses the shortest lag suggested by the information criteria, and exports results. It was successfully run with Python 3.12 and statsmodels 0.15.0. Small differences across package versions or statistical-test conventions are possible.

## Run the MATLAB calibration

Open MATLAB, change directory to `matlab/`, and run `calibrate`. The script requires `fsolve` from Optimization Toolbox and saves `calibrated_steady_state.mat`. It checks solver convergence and residual size. Calibration and Dynare remain separate steps. Compare calibrated values with the model's rounded parameter assignments before simulation.

## Run the Dynare draft

Configure your local Dynare MATLAB path, change directory to `dynare/`, then run the following in MATLAB.

```matlab
dynare two_country_rbc.mod
```

The model includes residual, steady-state, determinacy, and model-diagnostic commands, a fixed simulation seed, 20-period impulse responses, and 1,053 simulation periods. Capital follows Dynare's end-of-period convention, with lagged capital in current production.

**Validation status:** Python results have been recomputed. MATLAB and Dynare are unavailable in the preparation environment, so the repaired calibration and dynamic model have not been executed. Dynamic results and IRFs should be reviewed after a successful local run.

## Remaining reconciliation

The original report lists shock variances of 0.000057 and 0.000156. The original Dynare file specifies 0.00023 and 0.00032. The Dynare draft retains the original simulation values as an explicit assumption. The empirical covariance estimates are exported in `results/residual_covariance.csv`; resolve the discrepancy before interpreting simulation magnitudes.

The handwritten Part c uses rounded VAR coefficients. Small steady-state differences should be reconciled using a consistent precision. The empirical dataset, course templates, original coursework, later code repairs, and fresh Python output have distinct provenance as described above.
