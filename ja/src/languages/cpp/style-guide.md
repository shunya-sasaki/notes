# C++ Style Guide

![C++](https://img.shields.io/badge/C++-00599C?logo=cplusplus&labelColor=gray&logoColor=white)

このドキュメントは、C++ のスタイルガイドを提供します。

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

以下は、プログラミングで一般的に使用されるフォーマット方式です。

- snake_case
- kebab-case
- MACRO_CASE (SCREAMING_SNAKE_CASE)
- camelCase
- PascalCase (UpperCamelCase)

### Formats for C++ programs

| 項目                   | 方式                     | 例                   |
| ---------------------- | ------------------------ | -------------------- |
| ファイル名             | snake_case or kebab-case | `my-useful-class.cc` |
| 型名                   | PascalCase               | `MyExistingClass`    |
| コンセプト             | PascalCase               | `MyConcept`          |
| 一般的な変数名         | snake_case               | `table_name`         |
| クラスのデータメンバ   | snake_case\_             | `table_name_`        |
| 構造体のデータメンバ   | snake_case               | `table_name`         |
| 定数名                 | kPascalCase              | `kDaysInAWeek`       |
| 関数名                 | PascalCase               | `AddTableEntry`      |
| アクセサとミューテータ | snake_case               | `set_count`          |
| 名前空間名             | snake_case               | `my_namespace`       |
| 列挙子                 | kPascalCase              | `kOk`                |
| マクロ名               | MACRO_CASE               | `MY_PROJECT_ROUND`   |

## 💡 Recommendations

### Formatter

- C++ コードのフォーマットには [clang-format](https://clang.llvm.org/docs/ClangFormat.html) を使用します。

### Linter

- C++ コードの Lint には [clang-tidy](https://clang.llvm.org/extra/clang-tidy/) を使用します。

> [!TIP]
> エディタや IDE では、clangd を使用してフォーマットと Lint の両方を行うことができます。

## 📚 Reference

- [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
