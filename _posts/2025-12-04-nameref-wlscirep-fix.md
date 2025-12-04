---
title: "LaTeX wlscirep class ব্যবহার করলে \\nameref সমস্যার সমাধান: Unnumbered Sections-এ কাজ করানোর উপায়"
description: "Scientific Reports আর্টিকেলের জন্য ব্যবহৃত wlscirep LaTeX ক্লাসে \\nameref কমান্ড unnumbered sections-এ কাজ না করার সমস্যা এবং তার সমাধান।"
date: 2025-12-04 10:00:00 +0900
categories: [LaTeX, Tips]
tags: [latex, wlscirep, scientific reports, nameref, troubleshooting]
pin: false
---

Scientific Reports জার্নালে আর্টিকেল সাবমিট করতে গেলে `wlscirep` LaTeX ক্লাস ব্যবহার করতে হয়। কিন্তু এই ক্লাসে একটি বিরক্তিকর সমস্যা রয়েছে—`\nameref` কমান্ড unnumbered sections (`\section*{}`) এর সাথে কাজ করে না।

## সমস্যাটি কী?

Scientific Reports জার্নালের `wlscirep` ক্লাসে সব সেকশন unnumbered (`\section*{}`)। অর্থাৎ Introduction, Methods, Results, Discussion—কোনো সেকশনেরই নম্বর নেই। তাই পেপারের কোনো অংশে অন্য সেকশন উল্লেখ করতে চাইলে `\ref{sec:results}` লিখে "Section 3" দেখানোর উপায় নেই। এক্ষেত্রে `\nameref` ব্যবহার করে সেকশনের নাম (যেমন "Results") দেখানোই একমাত্র বিকল্প।

কিন্তু সমস্যা হলো, `wlscirep` ক্লাস অভ্যন্তরীণভাবে `titlesec` প্যাকেজ `[explicit]` অপশন সহ ব্যবহার করে। এর ফলে `\nameref{label}` ব্যবহার করলে সেকশনের নামের বদলে ফাঁকা আউটপুট আসে।

উদাহরণস্বরূপ, আপনি যদি লেখেন:

{% raw %}
```latex
\section*{Results}
\label{sec:results}

% অন্যত্র রেফারেন্স করলে
As shown in \nameref{sec:results}, our findings...
```
{% endraw %}

এটি আউটপুট দেবে: "As shown in , our findings..." — অর্থাৎ সেকশনের নাম "Results" দেখাবে না।

## সমাধান

একটি কাস্টম `\namedlabel` কমান্ড তৈরি করে এই সমস্যার সমাধান করা যায়।

### ধাপ ১: Preamble-এ কোড যোগ করুন

`\documentclass{wlscirep}` এর পরে নিচের কোডটি যোগ করুন:

{% raw %}
```latex
\makeatletter
\newcommand{\namedlabel}[2]{%
    \begingroup
    \def\@currentlabelname{#2}%
    \label{#1}%
    \endgroup
}
\makeatother 
```
{% endraw %}

### ধাপ ২: Unnumbered Sections-এ ব্যবহার করুন

সাধারণ পদ্ধতির বদলে:

{% raw %}
```latex
\section*{Results}
\label{sec:results}  % এটি nameref-এ কাজ করবে না
```
{% endraw %}

এভাবে লিখুন:

{% raw %}
```latex
\section*{Results}
\namedlabel{sec:results}{Results}
\addcontentsline{toc}{section}{Results}  % ঐচ্ছিক: Table of Contents-এ যোগ করে
```
{% endraw %}

### ধাপ ৩: সেকশন রেফারেন্স করুন

{% raw %}
```latex
As shown in \nameref{sec:results}, our findings indicate...
```
{% endraw %}

এবার সঠিক আউটপুট পাবেন: "As shown in Results, our findings indicate..."

## সম্পূর্ণ উদাহরণ

{% raw %}
```latex
\documentclass[fleqn,10pt]{wlscirep}

% Unnumbered sections-এ nameref সমস্যার সমাধান
\makeatletter
\newcommand{\namedlabel}[2]{%
    \begingroup
    \def\@currentlabelname{#2}%
    \label{#1}%
    \endgroup
}
\makeatother

\title{My Scientific Report}
\author{Author Name}

\begin{abstract}
This is the abstract.
\end{abstract}

\begin{document}

\maketitle

\section*{Introduction}
\namedlabel{sec:introduction}{Introduction}
\addcontentsline{toc}{section}{Introduction}
This is the introduction.

\section*{Methods}
\namedlabel{sec:methods}{Methods}
\addcontentsline{toc}{section}{Methods}
We describe our methodology here.

\section*{Results}
\namedlabel{sec:results}{Results}
\addcontentsline{toc}{section}{Results}
Our results are presented here.

\section*{Discussion}
\namedlabel{sec:discussion}{Discussion}
\addcontentsline{toc}{section}{Discussion}
As shown in \nameref{sec:results}, our findings support 
the hypothesis discussed in \nameref{sec:introduction}.

\end{document}
```
{% endraw %}

## গুরুত্বপূর্ণ টিপস

**দুইবার কম্পাইল করুন:** রেফারেন্স সঠিকভাবে resolve হতে `pdflatex` (অথবা `latexmk -pdf`) দুইবার রান করুন।

**Label Naming Convention:** বিভ্রান্তি এড়াতে descriptive prefix ব্যবহার করুন, যেমন sections-এর জন্য `sec:`, figures-এর জন্য `fig:`, tables-এর জন্য `tab:`।

**সব ফাইলে যোগ করুন:** যদি আপনার ডকুমেন্টের একাধিক ভার্সন থাকে (যেমন original এবং track-changes), তাহলে সব ফাইলে `\namedlabel` definition যোগ করতে হবে।

**Auxiliary Files মুছুন:** রেফারেন্স আপডেট না হলে auxiliary files মুছে পুনরায় কম্পাইল করুন:

```bash
rm -f *.aux *.log *.toc *.out
pdflatex yourfile.tex
pdflatex yourfile.tex
```

## সাধারণ পদ্ধতিগুলো কেন কাজ করে না?

| পদ্ধতি | ব্যর্থতার কারণ |
|--------|---------------|
| `\phantomsection` + `\label` | `titlesec` এর `[explicit]` অপশন `\@currentlabelname` সেট করে না |
| `\addcontentsline` + `\label` | একই সমস্যা—label name capture হয় না |
| শুধু `\usepackage{nameref}` | প্যাকেজ লোড হয়, কিন্তু unnumbered sections-এ সমস্যা থাকে |

## দ্রুত রেফারেন্স

{% raw %}
```latex
% Preamble-এ একবার (বাধ্যতামূলক)
\makeatletter
\newcommand{\namedlabel}[2]{%
    \begingroup
    \def\@currentlabelname{#2}%
    \label{#1}%
    \endgroup
}
\makeatother

% প্রতিটি unnumbered section-এ
\section*{Section Title}
\namedlabel{sec:label}{Section Title}

% রেফারেন্স করতে
\nameref{sec:label}
```
{% endraw %}

## পরীক্ষিত সংস্করণ

- **wlscirep.cls:** v1.4 (08/08/2020)
- **LaTeX distribution:** TeX Live 2023
- **তারিখ:** ডিসেম্বর ২০২৫

> এই সমাধান Scientific Reports ছাড়াও অন্যান্য জার্নালে যেখানে `titlesec` প্যাকেজ `[explicit]` অপশন সহ ব্যবহৃত হয়, সেখানেও কাজ করবে।
{: .prompt-info }