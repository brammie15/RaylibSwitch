# RaylibSwitch

A C++20 raylib app for Nintendo Switch homebrew, built with [raylib-nx](https://github.com/luizpestana/raylib-nx) 
## Using this template

1. On GitHub, click **Use this template → Create a new repository**.
2. On the first push, the *Template cleanup* workflow renames the project from `RaylibSwitch` to your repository's name and sets the author to your account.
3. Every push builds the `.nro`

## Requirements

- devkitPro at `C:\devkitPro` with `switch-dev`, `switch-mesa` and `switch-libdrm_nouveau`:
  ```
  C:\devkitPro\msys2\usr\bin\bash.exe -lc "pacman -S --needed switch-dev switch-mesa switch-libdrm_nouveau"
  ```
- CMake 3.25+ and Ninja
- git (duh)

## Command line

```
cmake --preset switch-debug
cmake --build --preset switch-debug      # build debug
cmake --build --preset deploy            # build + nxlink upload
cmake --build --preset run               # build + upload + stream stdout
```

### Options

| Cache variable     | Default | Meaning                                               |
|--------------------|---------|-------------------------------------------------------|
| `NXLINK_IP`        | empty   | Switch IP address. |
| `NXLINK_RETRIES`   | 3       | Number of connection retries                          |
| `NXLINK_ON_BUILD`  | OFF     | Upload after every build                              |
| `NXLINK_REQUIRED`  | OFF     | Make an auto-upload failure fail the build            |
| `APP_TITLE` / `APP_AUTHOR` | | Metadata shown in the Homebrew Menu                  |
| `FETCHCONTENT_SOURCE_DIR_RAYLIB` | | Use a local raylib-nx checkout                  |
