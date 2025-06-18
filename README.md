A simple x86_64 kernel written in Odin with assembly components.

### Required Tools

1. **CMake** (version 3.16 or higher)
   ```bash
   # Ubuntu/Debian
   sudo apt install cmake
   
   # Arch Linux
   sudo pacman -S cmake
   
   # macOS
   brew install cmake
   ```

2. **NASM** (Netwide Assembler)
   ```bash
   # Ubuntu/Debian
   sudo apt install nasm
   
   # Arch Linux
   sudo pacman -S nasm
   
   # macOS
   brew install nasm
   ```

3. **Odin Programming Language**
   - Download from: https://odin-lang.org/
   - Follow installation instructions for your platform
   - Make sure `odin` is in your PATH

4. **Cross-compilation toolchain** (x86_64-elf-ld)
   ```bash
   # Ubuntu/Debian
   sudo apt install binutils-x86-64-linux-gnu
   # Create symlink if needed:
   sudo ln -s /usr/bin/x86_64-linux-gnu-ld /usr/local/bin/x86_64-elf-ld
   
   # Arch Linux
   sudo pacman -S x86_64-elf-binutils
   
   # macOS - install via homebrew-cross
   brew tap messense/macos-cross-toolchains
   brew install x86_64-elf-gcc
   ```

5. **GRUB tools** (for creating bootable ISO)
   ```bash
   # Ubuntu/Debian
   sudo apt install grub-pc-bin grub-common xorriso
   
   # Arch Linux
   sudo pacman -S grub xorriso
   
   # macOS
   brew install grub xorriso
   ```

6. **QEMU** (for running the kernel)
   ```bash
   # Ubuntu/Debian
   sudo apt install qemu-system-x86
   
   # Arch Linux
   sudo pacman -S qemu-full
   
   # macOS
   brew install qemu
   ```

## Project Structure

```
.
├── src/
│   └── impl/
│       └── x86_64/
│           ├── *.asm          # Assembly source files
│           └── kernel/
│               └── kernel.odin # Odin kernel source
├── targets/
│   └── x86_64/
│       ├── linker.ld          # Linker script
│       └── iso/               # ISO directory structure
├── build/                     # Build artifacts (generated)
├── dist/                      # Distribution files (generated)
└── CMakeLists.txt            # Build configuration
```

## Building and Running

### 1. Clone and Setup
```bash
git clone <your-repo-url>
cd <project-directory>
mkdir build
cd build
```

### 2. Configure with CMake
```bash
cmake ..
```

### 3. Build the Kernel
```bash
make build
```

### 4. Run with QEMU
```bash
make run
```

### 5. Clean Build Artifacts
```bash
make clean
```

## Available Make Targets

- `make` - Shows help with available targets
- `make build` - Build the kernel (creates ISO file)
- `make run` - Build and run the kernel with QEMU
- `make clean` - Clean all build artifacts

## Troubleshooting

### Common Issues

1. **"odin: command not found"**
   - Make sure Odin is installed and in your PATH
   - Test with: `odin version`

2. **"x86_64-elf-ld: command not found"**
   - Install the cross-compilation toolchain (see prerequisites)
   - On some systems, you might need to create a symlink as shown above

3. **"grub-mkrescue: command not found"**
   - Install GRUB tools (see prerequisites)
   - Make sure `/usr/lib/grub/i386-pc` exists

4. **QEMU fails to start**
   - Make sure QEMU is installed: `qemu-system-x86_64 --version`
   - Check if the ISO file was created in `dist/x86_64/kernel.iso`

### Platform-Specific Notes

**Linux**: Should work out of the box with the package installations above.

**macOS**: You might need to adjust some paths or install additional dependencies through Homebrew.

**Windows**: Consider using WSL2 (Windows Subsystem for Linux) for easier setup.

## Development

The kernel is written in Odin with assembly language components for low-level functionality. The build system uses CMake to orchestrate the compilation of both assembly and Odin sources.

### Adding New Files

- **Assembly files**: Place in `src/impl/x86_64/` directory (they'll be auto-detected)
- **Odin files**: Modify the kernel source in `src/impl/x86_64/kernel/`

## License
///in progress
[Add your license information here]
