---
name: sync-en-and-ja
description: "Sync English and Japanese content in a directory."
---

## Procedure

1. Copy `en/src/SUMMARY.md` to `ja/src/SUMMARY.md`.
2. Read files and directories sturcture in `en/src/` and `ja/src/`.
3. Compare the timestamp of files in `en/src/` and `ja/src/`.
4. If a file in `en/src/` is newer than the corresponding file in `ja/src/`,
   translate the file of `en/src/` to Japanese and save it to `ja/src/`.
5. If a file is not in `ja/src/` but exists in `en/src/`,
   translate the file of `en/src/` to Japanese and save it to `ja/src/`.

## Additional Notes

- Use desu, masu style for Japanese translation.
- Keep the same file structure in `ja/src/` as in `en/src/`.
- Keep the section titles in English in `ja/src/`
  to maintain consistency with `en/src/`.
