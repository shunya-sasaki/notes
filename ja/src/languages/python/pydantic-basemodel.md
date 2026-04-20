# Pydantic BaseModel

このドキュメントでは、pydantic の BaseModel クラスの使い方を説明します。

<!-- toc -->

- [BaseModel](#basemodel)

<!-- /toc -->

## BaseModel

以下は BaseModel からクラスを定義する例です。

```python
from pydantic import BaseModel
from pydantic import ConfigDict

class ModelClass(BaseModel):
    """ModelClass data model."""

    model_config = ConfigDict(
        alias_generator=FormatConverter.snake_to_camel, populate_by_name=True
    )

    host: str = "localhost"
    port: int = 8000

class FormatConverter:
    """A utility class for converting string formats."""

    @staticmethod
    def snake_to_camel(word: str) -> str:
        """Convert snake_case to camelCase."""
        components = word.split("_")
        return components[0] + "".join(x.capitalize() for x in components[1:])
```

属性 `model_config` はモデルのオプションを定義する特別な属性です。

`ConfigDict` は Pydantic で導入されたヘルパークラスで、
型安全な方法でモデル設定を指定するために使用します。
`ConfigDict` を使用して、エイリアス生成、フィールド入力ルール、
バリデーション動作などのオプションを設定できます。
これらのオプションは、パース、シリアライゼーション、
バリデーション時のモデルの動作を制御します。

よく使われる `ConfigDict` のオプションは以下の通りです:

- `alias_generator`: フィールドエイリアスを生成する関数。
- `populate_by_name`: Python のフィールド名でデータを入力できるようにします。
- `extra`: 追加フィールドの処理を制御します（`"allow"`, `"forbid"`, `"ignore"`）。
- `str_strip_whitespace`: 文字列フィールドの前後の空白を自動的に除去します。

この例では、`alias_generator` として `FormatConverter.snake_to_camel` を使用しています。
この関数は `snake_case` を `camelCase` に変換します。
このアプローチにより、クラスは camelCase 形式の JSON データを読み込み、snake_case 形式の変数として提供します。
