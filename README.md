# Evaluating the Impact of Canada's 2016 Child Benefit Reform on Child Poverty

This repository contains the data, analysis code, and paper for a project examining whether the Canada Child Benefit (CCB), introduced in July 2016, reduced child poverty (measured by the Low Income Measure After Tax, LIM-AT), and whether this effect differed between lone-parent and two-parent families.

## Research Questions

- **RQ1:** Did the introduction of the CCB reduce LIM-AT rates among children in lone-parent families?
- **RQ2:** Did the introduction of the CCB reduce LIM-AT rates among children in two-parent families?
- **RQ3:** Was the post-CCB reduction in LIM-AT rates larger for children in lone-parent families than for children in two-parent families?

We use a difference-in-differences (DiD) design, comparing lone-parent and two-parent families before (2007–2015) and after (2016–2024) the CCB's introduction, with a supplementary specification isolating the 2020–2021 CERB-driven anomaly, and a provincial extension using Quebec as the reference category.

## Data Source

Statistics Canada Table 11-10-0135-01, *Low Income Statistics by Age, Gender and Economic Family Type*, retrieved programmatically via the [`{cansim}`](https://cran.r-project.org/package=cansim) R package. See [Statistics Canada's page for this table](https://doi.org/10.25318/1110013501-eng) for full documentation.

## Repository Structure

```
├── scripts/
│   ├── 01-download_data.R                  # Downloads raw data via {cansim}
│   ├── 02-clean_data.R                     # Standardizes and cleans the raw data
│   ├── 03-prepare_data.R                   # Filters/reshapes into analysis-ready panels
│   ├── 04-exploratory_data_analysis.R      # Exploratory data analysis and figures
│   └── 05-model_data.R                     # Estimates the DiD models
├── outputs/                                # Cleaned data, figures, and saved models
├── paper/
│   └── INF2167_Group3_Paper.qmd            # Final paper (Quarto)
├── proposal/
│   └── INF2167_Group3_ProjectProposal.qmd  # Project proposal (Quarto)
├── INF2167-FinalProject.Rproj
├── LICENSE
└── README.md
```

## Reproducing the Analysis

1. Clone this repository and open `INF2167-FinalProject.Rproj` in RStudio.
2. Install required packages:
```r
   install.packages(c("tidyverse", "cansim", "here", "broom", "knitr"))
```
3. Run the scripts in `scripts/` in numbered order (01 through 05). Each script depends on the outputs of the previous one:
   - `01-download_data.R` downloads the raw Statistics Canada table
   - `02-clean_data.R` cleans and standardizes it
   - `03-prepare_data.R` filters and reshapes it into national, provincial, and benchmark panels
   - `04-exploratory_data_analysis.R` produces exploratory figures
   - `05-model_data.R` estimates the DiD models and saves them to `outputs/models/`
4. Render the paper:
```bash
   quarto render paper/INF2167_Group3_Paper.qmd --to pdf
```

## License

This project is licensed under the MIT License, see [LICENSE](LICENSE) for details.
