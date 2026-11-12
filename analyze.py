"""Reproduce the U.S.–U.K. productivity estimates from the supplied annual data."""
from pathlib import Path
import json
import numpy as np
import pandas as pd
from statsmodels.api import OLS
from statsmodels.tsa.api import VAR

ROOT = Path(__file__).resolve().parents[1]
out = ROOT / 'results'
out.mkdir(exist_ok=True)
df = pd.read_csv(ROOT / 'data/ExamStataData.csv').sort_values('year')
assert df.year.is_unique and np.all(np.diff(df.year) == 1), 'Years must be unique and consecutive'
summary = {}
for country in ['us', 'uk']:
    columns = [f'{v}_{country}' for v in ['y', 'h', 'k', 'pop15plus', 'labsh', 'g', 'delta']]
    assert df[columns].notna().all().all(), 'Missing input values'
    assert (df[[f'{v}_{country}' for v in ['y','h','k','pop15plus']]] > 0).all().all()
    alpha = df[f'labsh_{country}'].mean()
    # Constant returns to scale makes aggregate and per-population residuals identical.
    adjusted_output = (np.log(df[f'y_{country}']) - alpha*np.log(df[f'h_{country}'])
                       - (1-alpha)*np.log(df[f'k_{country}']))
    fit = OLS(adjusted_output, np.ones((len(df), 1))).fit()
    df[f'log_{country}_zpop'] = fit.resid
    summary[country] = {'labor_share': float(alpha), 'log_scaling_constant': float(fit.params.iloc[0]),
                        'scaling_constant': float(np.exp(fit.params.iloc[0])),
                        'intercept_pvalue': float(fit.pvalues.iloc[0]),
                        'government_output_ratio': float((df[f'g_{country}']/df[f'y_{country}']).mean())}
series = df[['log_us_zpop', 'log_uk_zpop']]
model = VAR(series)
selection = model.select_order(maxlags=10)
lag = min(v for v in selection.selected_orders.values() if v is not None)
assert lag > 0, 'Zero-lag selection requires revisiting the productivity process'
fit = model.fit(lag)
fit.params.to_csv(out / 'var_coefficients.csv')
fit.sigma_u.to_csv(out / 'residual_covariance.csv')
df[['year',*series.columns]].to_csv(out / 'productivity.csv',index=False)
summary.update({'start_year':int(df.year.min()), 'end_year':int(df.year.max()), 'observations':len(df),
                'selected_orders':{k:int(v) for k,v in selection.selected_orders.items()},'used_lag':int(lag),'var_stable':bool(fit.is_stable()),
                'residual_correlation':float(fit.resid.corr().iloc[0,1]),
                'us_predicts_uk_pvalue':float(fit.test_causality('log_uk_zpop',['log_us_zpop'],kind='f').pvalue),
                'uk_predicts_us_pvalue':float(fit.test_causality('log_us_zpop',['log_uk_zpop'],kind='f').pvalue)})
(out/'summary.json').write_text(json.dumps(summary,indent=2))
(out/'var_output.txt').write_text(str(selection.summary())+'\n'+str(fit.summary()))
print(json.dumps(summary,indent=2))
