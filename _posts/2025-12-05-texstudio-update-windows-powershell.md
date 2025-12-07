---
title: উইন্ডোজে PowerShell দিয়ে TeXstudio আপডেট করার সম্পূর্ণ গাইড
description: উইন্ডোজে Winget কমান্ড ব্যবহার করে কীভাবে খুব সহজে এবং দ্রুত TeXstudio সফটওয়্যার আপডেট করবেন তার ধাপে ধাপে বিস্তারিত নির্দেশনা।
date: 2025-12-04 10:00:00 +0900
categories: [Tutorial, LaTeX]
tags: [texstudio, windows, powershell, winget, latex, update]
pin: false
---

LaTeX ব্যবহারকারীদের কাছে TeXstudio একটি অত্যন্ত জনপ্রিয় ও শক্তিশালী এডিটর। তবে অনেক ব্যবহারকারীই জানেন না কীভাবে দ্রুত ও সহজে এটি আপডেট করা যায়। এই গাইডে আমরা দেখব কীভাবে Windows PowerShell এবং winget কমান্ড ব্যবহার করে TeXstudio আপডেট করতে হয়।

## শুরু করার আগে যা যা প্রয়োজন

কাজ শুরু করার আগে নিশ্চিত করুন যে:

- আপনার Windows 10/11 আপডেট করা আছে (সবচেয়ে ভালো হয় 21H2 বা তার পরের ভার্সন হলে)
- App Installer ইনস্টল করা আছে (এটি winget কমান্ড চালানোর জন্য দরকার)
- PowerShell থেকে winget কমান্ড ঠিকমতো কাজ করছে

যাচাই করার জন্য PowerShell খুলে এই কমান্ডটি চালান:

```powershell
winget --version
```

যদি একটি ভার্সন নম্বর দেখতে পান, তাহলে বুঝবেন সবকিছু ঠিকঠাক আছে।

## ধাপ ১: এখন কোন ভার্সন ইনস্টল করা আছে দেখুন

আপনার কম্পিউটারে বর্তমানে কোন ভার্সনের TeXstudio ইনস্টল করা আছে তা দেখতে:

```powershell
winget list TeXstudio
```

যদি TeXstudio ম্যানুয়ালি ইনস্টল করা থাকে (অর্থাৎ winget দিয়ে নয়), তাহলে সফটওয়্যার খুলেও দেখতে পারেন:

TeXstudio খুলুন → Help → About TeXstudio

## ধাপ ২: নতুন ভার্সন পাওয়া যাচ্ছে কিনা চেক করুন

নতুন আপডেট আছে কিনা দেখতে এই কমান্ড চালান:

```powershell
winget upgrade TeXstudio.TeXstudio --include-unknown
```

যদি নতুন আপডেট পাওয়া যায়, তাহলে সর্বশেষ ভার্সনের তথ্য স্ক্রিনে দেখাবে।

## ধাপ ৩: TeXstudio আপডেট করুন

আপডেট করার জন্য এই কমান্ডটি চালান:

```powershell
winget upgrade TeXstudio.TeXstudio
```

যদি ইনস্টলার administrator পারমিশন চায়, তাহলে PowerShell অবশ্যই Administrator হিসেবে খুলতে হবে।

## ধাপ ৪: আপগ্রেড না হলে কী করবেন

মাঝেমধ্যে winget দিয়ে সরাসরি আপগ্রেড করা যায় না, বিশেষ করে যদি সফটওয়্যারটি ম্যানুয়ালি ইনস্টল করা থাকে।

সেক্ষেত্রে এভাবে করুন:

**আগে পুরাতন ভার্সনটি আনইনস্টল করুন:**

```powershell
winget uninstall TeXstudio.TeXstudio
```

**তারপর নতুন ভার্সন ইনস্টল করুন:**

```powershell
winget install TeXstudio.TeXstudio
```

## ধাপ ৫: আপডেট হয়েছে কিনা নিশ্চিত হন

ইনস্টল শেষ হলে ভার্সন দেখে নিশ্চিত হয়ে নিন:

```powershell
winget list TeXstudio
```

অথবা TeXstudio খুলে দেখুন: Help → About TeXstudio

## অতিরিক্ত টিপস: পুরাতন ফাইল পরিষ্কার করুন (ঐচ্ছিক)

Winget কিছু cached installer ফাইল রেখে দিতে পারে। সেগুলো মুছে ফেলতে চাইলে:

```powershell
winget source update
winget cache delete
```

## সাধারণ সমস্যা ও সমাধান

### "winget is not recognized" এরর দেখাচ্ছে

Microsoft Store থেকে App Installer ইনস্টল করুন বা আপডেট করুন।

### "No applicable installer found" এরর আসছে

এই কমান্ড চেষ্টা করে দেখুন:

```powershell
winget upgrade --include-unknown
```

না হলে আনইনস্টল করে আবার ইনস্টল করুন।

### Winget ইনস্টলার অ্যাক্সেস করতে পারছে না

PowerShell অবশ্যই Administrator হিসেবে চালাতে হবে।

## শেষ কথা

এই সহজ পদ্ধতি অনুসরণ করলে আপনি খুব সহজেই TeXstudio সবসময় আপডেট রাখতে পারবেন। Winget ব্যবহারের সবচেয়ে বড় সুবিধা হলো এটি দ্রুত এবং কমান্ড লাইন থেকেই সব কাজ করা যায়—বারবার ওয়েবসাইটে গিয়ে ইনস্টলার ডাউনলোড করার ঝামেলা নেই।

> **দরকারি টিপস:** নিয়মিত `winget upgrade --all` কমান্ড চালিয়ে আপনার কম্পিউটারের সব সফটওয়্যার একবারে আপডেট করে নিতে পারেন। এতে সময়ও বাঁচবে, সবকিছু আপডেটও থাকবে।
{: .prompt-tip }
