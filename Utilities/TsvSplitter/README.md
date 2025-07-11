# TsvSplit Utility

The `TsvSplit` utility splits a combined language TSV translation changeset into separate files for intake processing of the translations as needed for mobile app localization.

_multi-language file_

| language | done | key_droid | key_apple | base_value | lang_value | base_note | lang_note |
|----------|-----|----------|----------|---------------------|---------------------|------|------|
| Catalan_ca | yes | `food_info_serving_sizes_beans_imperial.2` | `dozeBeans.Serving.imperial.2` | ⅓ cup tofu or tempeh | ⅓ tassa de tofu o tempeh | | |
| Czech_cs | yes | `food_info_serving_sizes_beans_imperial.2` | `dozeBeans.Serving.imperial.2` | ⅓ cup tofu or tempeh | ⅓ šálku tofu nebo tempehu | | |
| German_de | yes | `food_info_serving_sizes_beans_imperial.2` | `dozeBeans.Serving.imperial.2` | ⅓ cup tofu or tempeh | ⅓ Tasse Tofu oder Tempeh | | |

_single-language file (Catalan shown)_

| key_droid | key_apple | base_value | lang_value | base_note | lang_note |
|----------|------|----------------|----------------|----|----|
| `food_info_serving_sizes_beans_imperial.2` | `dozeBeans.Serving.imperial.2` | ⅓ cup tofu or tempeh | ⅓ tassa de tofu o tempeh | | |
