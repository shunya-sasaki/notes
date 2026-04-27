# C++ Style Guide

![C++](https://img.shields.io/badge/C++-00599C?logo=cplusplus&labelColor=gray&logoColor=white)

This document provides a style guide for C++.

<!-- toc -->

- [📝 Rules](#-rules)
  - [Format methods](#format-methods)
  - [Formats for C++ programs](#formats-for-c-programs)
- [💡 Recommendations](#-recommendations)
  - [Formatter](#formatter)
  - [Linter](#linter)
- [📚 Reference](#-reference)

<!-- /toc -->

## 📝 Rules

### Format methods

The following are format methods commonly used in programming:

- snake_case
- kebab-case
- MACRO_CASE (SCREAMING_SNAKE_CASE)
- camelCase
- PascalCase (UpperCamelCase)

### Formats for C++ programs

| Item                   | Method                   | Example              |
| ---------------------- | ------------------------ | -------------------- |
| File Names             | snake_case or kebab-case | `my-useful-class.cc` |
| Type Names             | PascalCase               | `MyExistingClass`    |
| Concepts               | PascalCase               | `MyConcept`          |
| Common Variable Names  | snake_case               | `table_name`         |
| Class Data Members     | snake_case\_             | `table_name_`        |
| Struct Data Members    | snake_case               | `table_name`         |
| Constant Names         | kPascalCase              | `kDaysInAWeek`       |
| Function Names         | PascalCase               | `AddTableEntry`      |
| Accessors and Mutators | snake_case               | `set_count`          |
| Namespace Name         | snake_case               | `my_namespace`       |
| Enumerator             | kPascalCase              | `kOk`                |
| Macro Names            | MACRO_CASE               | `MY_PROJECT_ROUND`   |

## 💡 Recommendations

### Formatter

- Use [clang-format](https://clang.llvm.org/docs/ClangFormat.html) to format C++ code.

### Linter

- Use [clang-tidy](https://clang.llvm.org/extra/clang-tidy/) to lint C++ code.

> [!TIP]
> You can use clangd for both formatting and linting in your editor or IDE.

## 📚 Reference

- [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
