# Preparation notes

- Preserved the supplied original notebooks, Part d scripts, Part e model, report, and handwritten derivation.
- Replaced machine-specific notebook paths with a repository-relative Python entry point.
- Removed unused cross-assigned labor-share constraints from the cleaned analysis. The executed estimation uses each country's own mean share.
- Added year-order and missing-input checks, actual Granger F-tests, VAR stability checking, and exported results. The original narrative used coefficient significance to discuss Granger relationships.
- Used the U.S.-to-U.K. hours ratio target as specified by the assignment; an original unused notebook variable computes its inverse.
- Matched the MATLAB residual function filename and declaration to its driver call. Added a solver convergence/residual check and used declared spending ratios in equations.
- Replaced two duplicate resource-accounting equations in the Dynare draft with the missing country production functions. Used lagged capital in production, consistent with the existing investment and Euler-equation timing.
- Retained original rounded Dynare calibration and shock variances. Their disagreement with empirical residual variances is documented in README.
- Enabled 20-period IRFs and a fixed random seed as a portfolio extension. The submitted code used irf=0.
- Successfully reran the complete cleaned Python analysis on all 54 annual observations. Original production estimates and VAR coefficients were reproduced.
- MATLAB/Dynare execution, determinacy, and simulation validation remain pending because neither runtime is installed here.
- No claim of original authorship of course-provided templates or upstream data is made. Publication rights require confirmation before a public upload.
