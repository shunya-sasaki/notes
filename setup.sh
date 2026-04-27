#!/bin/bash

BASE_DIR=".third-party"
JS_DIR="$BASE_DIR/js"
CSS_DIR="$BASE_DIR/css"
THEME_DIR="$BASE_DIR/theme"
RUNTIME_THEME_DIR="./assets/theme"

# Create directories if they don't exist
mkdir -p "$JS_DIR" "$CSS_DIR" "$THEME_DIR" "$RUNTIME_THEME_DIR"

download_if_missing() {
    local url="$1"
    local output="$2"
    
    if [ ! -f "$output" ]; then
        echo "Downloading $url..."
        curl -L -o "$output" "$url"
    else
        echo "File $output already exists, skipping download."
    fi
}

# Third party CSS
download_if_missing \
    "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" \
    "$CSS_DIR/fontawesome-all.min.css"
 
download_if_missing \
    "https://cdn.jsdelivr.net/gh/devicons/devicon@latest/devicon.min.css" \
    "$CSS_DIR/devicon.min.css"

# Third party JS
download_if_missing \
    "https://code.iconify.design/iconify-icon/3.0.0/iconify-icon.min.js" \
    "$JS_DIR/iconify-icon.min.js"

download_if_missing \
    "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js" \
    "${THEME_DIR}/highlight.min.js"

HLJS_LANGUAGES=(
    \ diff
    \ dockerfile
    \ lua
    \ markdown
    \ nginx
    \ nix
    \ shell
    \ vim
    \ )

for lang in "${HLJS_LANGUAGES[@]}"; do
    lang="${lang// /}"
    [[ -z "$lang" ]] && continue
    download_if_missing \
        "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/languages/${lang}.min.js" \
        "${THEME_DIR}/${lang}.min.js"
done

# Mermaid.js
if [[ ! -f "${JS_DIR}/mermaid.min.js" ]]; then
    current_dir=$(pwd)
    echo "Installing Mermaid assets via mdbook-mermaid..."
    cd en && mdbook-mermaid install .

    if [[ -f "mermaid-init.js" ]]; then
        mv "mermaid-init.js" "../${JS_DIR}/mermaid-init.js"
    else
        echo "Error: Mermaid initialization script not found after installation."
        exit 1
    fi

    if [[ -f "mermaid.min.js" ]]; then
        mv "mermaid.min.js" "../${JS_DIR}/mermaid.min.js"
    else
        echo "Error: Mermaid minified script not found after installation."
        exit 1
    fi
    cd "${current_dir}"
else
    echo "Mermaid assets already exist, skipping installation."
fi

init_js='document.addEventListener("DOMContentLoaded", function() {
    if (window.hljs) {
        hljs.highlightAll();
    }
});'

{
    cat "${THEME_DIR}"/highlight.min.js
    echo
    for lang in "${HLJS_LANGUAGES[@]}"; do
        lang="${lang// /}"
        [[ -z "$lang" ]] && continue
        cat "${THEME_DIR}/${lang}.min.js"
        echo
    done
    printf '%s\n' "$init_js"
}> ./.assets/theme/highlight.js

echo "Done."
