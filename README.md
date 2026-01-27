# 📌 How to Use Stow for Managing Dotfiles  

Easily manage and organize your configuration files using **GNU Stow**!  

---

## 📂 Directory Structure  

```
dotfiles/
├── nvim/
│   └── .config/
│       └── nvim/
│           ├── init.lua
│           └── lua/
├── alacritty/
│   └── .config/
│       └── alacritty/
├── zsh/
│   └── .zshrc
└── tmux/
    └── .tmux.conf
```

---

## 🔄 Moving Existing Config Files (If Necessary)  

Move your current configuration files into the **dotfiles** directory:  

```sh
mv ~/.config/nvim /dotfiles/nvim/.config/
mv ~/.config/alacritty /dotfiles/alacritty/.config/
mv ~/.zshrc /dotfiles/zsh/.zshrc
```

---

## ⚙️ Installing Stow  

Install **GNU Stow** based on your Linux distribution:  

- **Debian/Ubuntu**  
  ```sh
  sudo apt install stow
  ```  
- **Arch Linux**  
  ```sh
  sudo pacman -S stow
  ```  
- **Void Linux**  
  ```sh
  sudo xbps-install -S stow
  ```
- **Fedora**  
  ```sh
  sudo dnf install stow
  ```

---

## 🚀 Applying Dotfiles with Stow  

To symlink the configuration files, run:  

```sh
cd /path/to/dotfiles
stow nvim
stow zsh
stow alacritty
stow tmux  # Optional, if you have a tmux config
```

✅ **Done!** Now your dotfiles are neatly managed and easily restorable! 🎉

