---
title: "Complete Guide to LaTeX Label Prefixes and Naming Conventions"
date: 2026-01-03
author: "ScholarNote"
categories: [LaTeX, Academic Writing, Best Practices]
tags: [latex, labels, references, cross-referencing, documentation]
description: "A comprehensive guide to LaTeX label prefixes for tables, figures, equations, theorems, and more. Learn the standard conventions used in academic writing."
---

## Introduction

One of LaTeX's most powerful features is its automatic cross-referencing system. You create a `\label{}` for an element and reference it anywhere with `\ref{}` or `\autoref{}`. But as your document grows, managing hundreds of labels becomes challenging without a consistent naming system.

This guide presents the **standard label prefix conventions** used across academic LaTeX documents. Following these conventions makes your documents more maintainable, especially in collaborative projects.

## Why Use Label Prefixes?

**Without prefixes:**
```latex
\label{results}
\label{methodology}
\label{important}
```
Which one is the table? Which is the section? You can't tell without looking at the source.

**With prefixes:**
```latex
\label{tab:results}
\label{sec:methodology}
\label{fig:important}
```
Now it's immediately clear what each label refers to!

## Benefits of Consistent Labeling

✅ **Instant recognition** - Know the element type at a glance  
✅ **Avoid conflicts** - `fig:results` and `tab:results` can coexist  
✅ **Better searching** - Find all figure labels with one grep command  
✅ **Team collaboration** - Everyone follows the same system  
✅ **Automated checking** - Scripts can verify reference completeness  
✅ **Editor support** - Autocomplete works better with prefixes  

## Standard Floats and Tables

### Tables

**Prefix:** `tab:`

```latex
\begin{table}[htbp]
\centering
\caption{Performance comparison across methods}
\label{tab:performance_comparison}
\begin{tabular}{lcc}
...
\end{tabular}
\end{table}

Reference in text: As shown in Table~\ref{tab:performance_comparison}...
% Or with autoref: As shown in \autoref{tab:performance_comparison}...
```

**Naming tips:**
- Use descriptive names: `tab:accuracy_results` not `tab:table1`
- Separate words with underscores: `tab:model_comparison`
- Be specific: `tab:training_accuracy` vs just `tab:accuracy`

### Figures

**Prefix:** `fig:`

```latex
\begin{figure}[htbp]
\centering
\includegraphics[width=0.8\textwidth]{architecture.pdf}
\caption{System architecture overview}
\label{fig:system_architecture}
\end{figure}

Reference: \autoref{fig:system_architecture} shows the overall design.
```

**Common figure labels:**
- `fig:architecture` - System diagrams
- `fig:workflow` - Process flows
- `fig:results_plot` - Data visualizations
- `fig:screenshot_interface` - UI screenshots

### Algorithms

**Prefix:** `alg:`

**Packages:** algorithm2e, algorithmic, algorithm

```latex
\begin{algorithm}[htbp]
\caption{Gradient Descent Optimization}
\label{alg:gradient_descent}
\begin{algorithmic}[1]
\State Initialize $\theta \gets 0$
\For{$i = 1$ to $n$}
    \State $\theta \gets \theta - \alpha \nabla J(\theta)$
\EndFor
\end{algorithmic}
\end{algorithm}

Reference: \autoref{alg:gradient_descent} presents our optimization approach.
```

### Code Listings

**Prefix:** `lst:`

**Package:** listings

```latex
\begin{lstlisting}[
    language=Python,
    caption={Data preprocessing pipeline},
    label=lst:preprocessing
]
def preprocess(data):
    data = normalize(data)
    return data
\end{lstlisting}

Reference: The implementation in \autoref{lst:preprocessing} shows...
```

**Alternative listings package (minted):**
```latex
\begin{listing}[htbp]
\begin{minted}{python}
def hello():
    print("Hello, World!")
\end{minted}
\caption{Hello world example}
\label{lst:hello_world}
\end{listing}
```

## Document Structure

### Sections

**Prefix:** `sec:`

```latex
\section{Introduction}
\label{sec:introduction}

The rest of this paper is organized as follows. 
\autoref{sec:methodology} describes our approach...

\section{Methodology}
\label{sec:methodology}
```

**Best practices:**
- Label main sections for cross-referencing
- Use descriptive names matching section titles
- Examples: `sec:related_work`, `sec:conclusion`, `sec:experiments`

### Subsections

**Prefixes:** `subsec:` or `ssec:`

```latex
\subsection{Data Collection}
\label{subsec:data_collection}

% Alternative shorter prefix
\subsection{Experimental Setup}
\label{ssec:experimental_setup}
```

Pick one convention and stick with it throughout your document!

### Subsubsections

**Prefix:** `sssec:`

```latex
\subsubsection{Hyperparameter Tuning}
\label{sssec:hyperparameter_tuning}
```

**Note:** Subsubsections are less commonly referenced, so labels are optional.

### Chapters (Books/Theses)

**Prefix:** `chap:`

```latex
\chapter{Literature Review}
\label{chap:literature_review}

% In document class: book, report, memoir
```

### Appendices

**Prefixes:** `app:` or `appx:`

```latex
\appendix

\section{Supplementary Results}
\label{app:supplementary_results}

% Alternative
\section{Proof of Theorem 1}
\label{appx:proof_theorem1}
```

Both prefixes are widely used - choose one for consistency.

## Equations

**Prefix:** `eq:`

```latex
\begin{equation}
E = mc^2
\label{eq:mass_energy}
\end{equation}

% Reference with special \eqref (adds parentheses automatically)
Einstein's famous equation \eqref{eq:mass_energy} states...

% Regular reference
Equation~\ref{eq:mass_energy} shows...
```

**Multiple equations:**
```latex
\begin{align}
f(x) &= x^2 + 2x + 1 \label{eq:quadratic} \\
g(x) &= \sin(x) + \cos(x) \label{eq:trigonometric}
\end{align}
```

**Naming tips:**
- Describe the equation: `eq:loss_function`, `eq:update_rule`
- Include context: `eq:forward_pass`, `eq:backward_prop`
- For numbered sets: `eq:system1`, `eq:system2`, `eq:system3`

## Mathematical Environments (amsthm package)

These require the `amsthm` package and environment definitions.

### Theorems

**Prefix:** `thm:`

```latex
\begin{theorem}[Convergence]
\label{thm:convergence}
Under assumptions A1-A3, the algorithm converges to the global optimum.
\end{theorem}

Reference: By \autoref{thm:convergence}, we know that...
```

### Lemmas

**Prefix:** `lem:`

```latex
\begin{lemma}
\label{lem:helper_bound}
For all $x > 0$, we have $f(x) \leq g(x)$.
\end{lemma}

Reference: Using \autoref{lem:helper_bound}, we can show...
```

### Propositions

**Prefix:** `prop:`

```latex
\begin{proposition}
\label{prop:uniqueness}
The solution is unique.
\end{proposition}
```

### Corollaries

**Prefix:** `cor:`

```latex
\begin{corollary}
\label{cor:special_case}
When $n=2$, the result simplifies to $O(n)$.
\end{corollary}

Reference: \autoref{cor:special_case} shows that...
```

### Definitions

**Prefix:** `def:`

```latex
\begin{definition}[Feature Space]
\label{def:feature_space}
A \emph{feature space} is a vector space where each dimension represents 
a specific feature of the data.
\end{definition}

Reference: According to \autoref{def:feature_space}...
```

### Remarks

**Prefix:** `rem:`

```latex
\begin{remark}
\label{rem:computational_note}
The computational complexity can be reduced using dynamic programming.
\end{remark}
```

### Examples

**Prefix:** `ex:`

```latex
\begin{example}
\label{ex:linear_regression}
Consider a simple linear regression problem with one predictor variable...
\end{example}

Reference: \autoref{ex:linear_regression} illustrates this concept.
```

## Specialized Mathematical Elements

### Assumptions/Hypotheses

**Prefix:** `hyp:` or `assum:`

```latex
\begin{assumption}
\label{hyp:normality}
The error terms are normally distributed with mean zero.
\end{assumption}

% Alternative
\begin{hypothesis}
\label{assum:independence}
Observations are independent and identically distributed.
\end{hypothesis}
```

### Conjectures

**Prefix:** `conj:`

```latex
\begin{conjecture}[Riemann Hypothesis]
\label{conj:riemann}
All non-trivial zeros of the Riemann zeta function have real part 1/2.
\end{conjecture}
```

### Claims

**Prefix:** `claim:`

```latex
\begin{claim}
\label{claim:bounds_tight}
The bounds derived in Theorem~\ref{thm:main} are tight.
\end{claim}
```

### Notations

**Prefix:** `nota:`

```latex
\begin{notation}
\label{nota:symbols}
We use $\mathbb{R}$ for real numbers, $\mathbb{N}$ for natural numbers, 
and $\mathcal{X}$ for the input space.
\end{notation}
```

## List Items and Special Elements

### Enumerate Items

**Prefix:** `item:`

```latex
\begin{enumerate}
\item First contribution: Novel architecture \label{item:contrib1}
\item Second contribution: Efficient training \label{item:contrib2}
\item Third contribution: State-of-the-art results \label{item:contrib3}
\end{enumerate}

Our main contributions are items \ref{item:contrib1} and \ref{item:contrib2}.
```

**When to label items:**
- When you reference them later in the text
- For numbered requirements or conditions
- In multi-part proofs or derivations

### Algorithm Lines

**Prefix:** `line:`

```latex
\begin{algorithmic}[1]
\State Initialize parameters $\theta$ \label{line:init}
\For{each epoch}
    \State Compute gradient \label{line:gradient}
    \State Update parameters \label{line:update}
\EndFor
\State Return $\theta$ \label{line:return}
\end{algorithmic}

In line~\ref{line:gradient}, we compute the gradient...
```

## Complete Prefix Reference Table

| Prefix | Element Type | Package/Environment | Example |
|--------|-------------|---------------------|---------|
| `tab:` | Tables | Standard | `\label{tab:results}` |
| `fig:` | Figures | Standard | `\label{fig:architecture}` |
| `eq:` | Equations | Standard | `\label{eq:loss}` |
| `alg:` | Algorithms | algorithm2e, algorithmic | `\label{alg:training}` |
| `lst:` | Code listings | listings, minted | `\label{lst:code}` |
| `sec:` | Sections | Standard | `\label{sec:intro}` |
| `subsec:`, `ssec:` | Subsections | Standard | `\label{subsec:methods}` |
| `sssec:` | Subsubsections | Standard | `\label{sssec:details}` |
| `chap:` | Chapters | book, report | `\label{chap:background}` |
| `app:`, `appx:` | Appendices | Standard | `\label{app:proofs}` |
| `thm:` | Theorems | amsthm | `\label{thm:main}` |
| `lem:` | Lemmas | amsthm | `\label{lem:helper}` |
| `prop:` | Propositions | amsthm | `\label{prop:property}` |
| `cor:` | Corollaries | amsthm | `\label{cor:result}` |
| `def:` | Definitions | amsthm | `\label{def:term}` |
| `rem:` | Remarks | amsthm | `\label{rem:note}` |
| `ex:` | Examples | amsthm | `\label{ex:case}` |
| `hyp:`, `assum:` | Assumptions | amsthm | `\label{hyp:normal}` |
| `conj:` | Conjectures | amsthm | `\label{conj:hypothesis}` |
| `claim:` | Claims | amsthm | `\label{claim:bounds}` |
| `nota:` | Notations | amsthm | `\label{nota:symbols}` |
| `item:` | List items | enumerate | `\label{item:first}` |
| `line:` | Algorithm lines | algorithmic | `\label{line:init}` |

## Best Practices for Label Names

### DO ✅

```latex
\label{tab:performance_comparison}      % Descriptive
\label{fig:neural_network_architecture} % Clear and specific
\label{eq:cross_entropy_loss}          % Indicates content
\label{sec:related_work}               % Matches section title
\label{thm:convergence_rate}           % Describes theorem
```

### DON'T ❌

```latex
\label{table1}              % No prefix
\label{fig:1}               % Not descriptive
\label{important}           % Ambiguous type
\label{sec:Section 2}       % Has spaces
\label{eq:eq1}              % Redundant prefix
\label{results-table}       % Use underscores, not hyphens
```

### Naming Guidelines

1. **Always use prefixes** - Makes the type immediately clear
2. **Be descriptive** - Future you will thank present you
3. **Use underscores** - Not spaces, hyphens, or camelCase
4. **Keep it concise** - But not cryptic (`perf_comp` vs `performance_comparison`)
5. **Match content** - Label should hint at what the element shows
6. **Be consistent** - Pick one style and stick to it
7. **Lowercase** - Standard convention is all lowercase
8. **No special characters** - Stick to alphanumeric and underscores

### Multi-level Naming

For related elements, use hierarchical naming:

```latex
\label{fig:experiment_setup}
\label{fig:experiment_results_accuracy}
\label{fig:experiment_results_loss}
\label{fig:experiment_comparison}
```

Or for a series:

```latex
\label{tab:dataset_statistics}
\label{tab:dataset_distribution}
\label{tab:dataset_preprocessing}
```

## Working with Label Prefixes

### Using autoref (hyperref package)

The `\autoref` command automatically adds the element type:

```latex
\usepackage{hyperref}

\autoref{tab:results}    % produces "Table 1"
\autoref{fig:plot}       % produces "Figure 2"
\autoref{eq:formula}     % produces "Equation 3"
\autoref{sec:intro}      % produces "Section 1"
```

No need to type "Table" or "Figure" - `\autoref` does it automatically!

### Using cleveref (even smarter)

The `cleveref` package is even more powerful:

```latex
\usepackage{cleveref}

\cref{tab:results}              % produces "table 1"
\Cref{tab:results}              % produces "Table 1" (capitalized)
\cref{eq:first,eq:second}       % produces "equations 1 and 2"
\crefrange{fig:a}{fig:c}        % produces "figures 1 to 3"
```

**Customizing names:**
```latex
\crefname{equation}{eq.}{eqs.}
\Crefname{equation}{Eq.}{Eqs.}
```

### Finding Labels with grep

With consistent prefixes, finding labels is easy:

```bash
# Find all table labels
grep -o '\\label{tab:[^}]*}' paper.tex

# Find all theorem labels
grep -o '\\label{thm:[^}]*}' paper.tex

# Count figure labels
grep -o '\\label{fig:[^}]*}' paper.tex | wc -l

# List all equation labels
grep -o '\\label{eq:[^}]*}' paper.tex | sed 's/.*{\(.*\)}/\1/'
```

## Multi-file Projects

### Organizing large documents

```latex
% main.tex
\documentclass{article}
\begin{document}

\include{chapters/introduction}    % Contains \label{sec:intro}
\include{chapters/methodology}     % Contains \label{sec:methods}
\include{chapters/results}         % Contains \label{sec:results}

\end{document}
```

### Checking labels across files

```bash
# Find all labels in all files
find . -name "*.tex" -exec grep -H '\\label{' {} \;

# Count total figure labels in project
cat *.tex chapters/*.tex | grep -o '\\label{fig:[^}]*}' | wc -l
```

### Namespace prefixes for multi-file projects

For very large projects, add file prefixes:

```latex
% In introduction.tex
\label{intro:sec:motivation}
\label{intro:fig:overview}

% In methods.tex
\label{methods:sec:algorithm}
\label{methods:alg:main}
```

This prevents label conflicts when combining files.

## Package-specific Considerations

### algorithm2e package

```latex
\begin{algorithm}
\caption{My Algorithm}
\label{alg:my_algorithm}
...
\end{algorithm}
```

### listings package

```latex
\lstinputlisting[
    language=Python,
    caption={Data loader},
    label=lst:dataloader
]{code/dataloader.py}
```

### subcaption package (subfigures)

```latex
\begin{figure}
\centering
\begin{subfigure}{0.45\textwidth}
    \includegraphics{plot1.pdf}
    \caption{Training loss}
    \label{fig:subfig_training}
\end{subfigure}
\begin{subfigure}{0.45\textwidth}
    \includegraphics{plot2.pdf}
    \caption{Validation loss}
    \label{fig:subfig_validation}
\end{subfigure}
\caption{Loss curves during training}
\label{fig:loss_curves}
\end{figure}

% Reference: \autoref{fig:loss_curves} shows...
% Reference subfigure: \autoref{fig:subfig_training} shows training loss...
```

**Subfigure naming:**
- Main figure: `fig:main_name`
- Subfigures: `fig:subfig_description` or `fig:main_name_a`, `fig:main_name_b`

## Common Pitfalls to Avoid

### 1. No prefix
```latex
% BAD
\label{results}
```

### 2. Duplicate labels
```latex
% BAD - Both labeled the same
\label{tab:results}  % in Table 1
...
\label{tab:results}  % in Table 2 - CONFLICT!
```

LaTeX will give a warning: "Label multiply defined"

### 3. Labels in wrong place

```latex
% BAD - label before caption in table
\begin{table}
\label{tab:results}  % TOO EARLY
\caption{Results}
...
\end{table}

% GOOD
\begin{table}
\caption{Results}
\label{tab:results}  % After caption
...
\end{table}
```

### 4. Unreferenced labels

Creating labels you never reference clutters your source. Use our [reference checking script](https://scholarnote.org) to find them!

### 5. Space in labels

```latex
% BAD
\label{fig:my figure}  % Spaces cause errors

% GOOD
\label{fig:my_figure}  % Use underscores
```

## Editor Support

### VS Code (LaTeX Workshop)

LaTeX Workshop provides:
- Autocomplete for labels
- "Go to definition" for references
- Hover to preview labeled elements
- Warning for undefined references

### Overleaf

Overleaf offers:
- Real-time label suggestions
- Click to jump to labeled element
- Compilation warnings for issues

### TeXstudio

TeXstudio features:
- Smart label completion
- Reference checking
- Label management panel

All work better with consistent prefixes!

## Automated Checking

Check your labels systematically:

```bash
#!/bin/bash
# check_labels.sh

echo "=== Label Statistics ==="
echo "Tables: $(grep -o '\\label{tab:[^}]*}' *.tex | wc -l)"
echo "Figures: $(grep -o '\\label{fig:[^}]*}' *.tex | wc -l)"
echo "Equations: $(grep -o '\\label{eq:[^}]*}' *.tex | wc -l)"
echo "Sections: $(grep -o '\\label{sec:[^}]*}' *.tex | wc -l)"
echo "Theorems: $(grep -o '\\label{thm:[^}]*}' *.tex | wc -l)"
```

For comprehensive reference checking, see our companion post: [Finding Unreferenced Tables, Figures, and Equations in LaTeX]([https://scholarnote.org](https://www.scholarsnote.org/posts/latex-reference-checker-blog/).

## Real-world Example

Here's a complete example showing proper labeling:

```latex
\documentclass{article}
\usepackage{amsmath,amsthm,graphicx,hyperref}

\newtheorem{theorem}{Theorem}
\newtheorem{lemma}{Lemma}

\begin{document}

\section{Introduction}
\label{sec:introduction}

As shown in \autoref{sec:methodology}, our approach improves 
upon existing methods. The main result is stated in 
\autoref{thm:main_result}.

\section{Methodology}
\label{sec:methodology}

We propose the loss function in \eqref{eq:loss_function}:

\begin{equation}
\mathcal{L} = \frac{1}{n}\sum_{i=1}^n \ell(y_i, \hat{y}_i)
\label{eq:loss_function}
\end{equation}

\autoref{fig:architecture} illustrates the network structure.

\begin{figure}[htbp]
\centering
\includegraphics[width=0.7\textwidth]{arch.pdf}
\caption{Proposed neural network architecture}
\label{fig:architecture}
\end{figure}

\section{Results}
\label{sec:results}

\autoref{tab:performance} summarizes our experimental results.

\begin{table}[htbp]
\centering
\caption{Performance comparison on benchmark datasets}
\label{tab:performance}
\begin{tabular}{lcc}
\hline
Method & Accuracy & F1-Score \\
\hline
Baseline & 0.85 & 0.83 \\
Ours & \textbf{0.92} & \textbf{0.90} \\
\hline
\end{tabular}
\end{table}

\section{Theoretical Analysis}
\label{sec:theory}

\begin{theorem}[Convergence]
\label{thm:main_result}
Under assumptions stated in \autoref{hyp:smoothness}, the algorithm 
converges at rate $O(1/t)$.
\end{theorem}

\begin{proof}
The proof follows from \autoref{lem:descent_property}.
\end{proof}

\begin{lemma}
\label{lem:descent_property}
Each iteration decreases the objective function.
\end{lemma}

\end{document}
```

**Notice:**
- Every label has an appropriate prefix
- Labels are descriptive (not `tab:1`, `fig:1`)
- References use `\autoref` for automatic type names
- Labels placed correctly (after captions in floats)

## Summary

Following consistent label prefix conventions:

✅ Makes your LaTeX source more readable  
✅ Prevents label conflicts  
✅ Enables automated checking  
✅ Improves collaboration  
✅ Works better with modern LaTeX editors  
✅ Saves time in the long run  

**Start using prefixes today!** Your future self (and collaborators) will thank you.

## Additional Resources

- [LaTeX Wikibooks - Labels and Cross-referencing](https://en.wikibooks.org/wiki/LaTeX/Labels_and_Cross-referencing)
- [CTAN - hyperref package](https://ctan.org/pkg/hyperref)
- [CTAN - cleveref package](https://ctan.org/pkg/cleveref)
- [Our LaTeX Reference Checker Tool](https://scholarnote.org)

---

**Found this guide helpful?** Follow us on [Facebook @scholarsnote](https://facebook.com/scholarsnote) for more LaTeX tips, academic writing guides, and research productivity tools!

**Have questions or suggestions?** Join the discussion on our [Facebook page](https://facebook.com/scholarsnote) or share your own LaTeX tips with the community.

**Related Posts:**
- [Finding Unreferenced Tables, Figures, and Equations in LaTeX Documents](https://scholarnote.org)
- [LaTeX Best Practices for Academic Writing](https://scholarnote.org)
- [Automating Your LaTeX Workflow](https://scholarnote.org)

📘 **ScholarNote** - Making academic writing easier, one post at a time.
