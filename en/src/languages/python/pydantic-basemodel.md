# Pydantic BaseModel

This document explains how to use BaseModel class in pydantic.

<!-- toc -->

- [BaseModel](#basemodel)

<!-- /toc -->

## BaseModel

The following an example that defines a class form BaseModel.

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

The attribute `model_config` is a special attibute that defines
options of the model.

`ConfigDict` is a helper class introduced in Pydantic
for specifying model configuration in a type-safe way.
You use `ConfigDict` to set options such as alias generation,
field population rules, validation behavior, and more.
These options control how your model behaves during parsing,
serialization, and validation.

Common `ConfigDict` options include:

- `alias_generator`: Function to generate field aliases.
- `populate_by_name`: Allow population of fields by their Python names.
- `extra`: Controls handling of extra fields (`"allow"`, `"forbid"`, `"ignore"`).
- `str_strip_whitespace`: Automatically strip whitespace from string fields.

This example uses `FormatConverter.snake_to_camel` as the `alias_generator`.
The function converts `snake_case` to `camelCase`.
With this approach, the class loads camelCase-style JSON data and provides variables in snake_case style.
