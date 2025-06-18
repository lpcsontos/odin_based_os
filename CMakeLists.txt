cmake_minimum_required(VERSION 3.16)
project(x86_64_kernel NONE)

# Enable ASM language
enable_language(ASM_NASM)

# Set ASM compiler to NASM
set(CMAKE_ASM_NASM_COMPILER nasm)
set(CMAKE_ASM_NASM_COMPILE_OBJECT "<CMAKE_ASM_NASM_COMPILER> -f elf64 <SOURCE> -o <OBJECT>")

# Find all ASM source files
file(GLOB_RECURSE x86_64_asm_source_files "src/impl/x86_64/*.asm")

# Create object files from ASM sources
set(x86_64_asm_object_files "")
foreach(asm_file ${x86_64_asm_source_files})
    # Get relative path from src/impl/x86_64/
    file(RELATIVE_PATH rel_path ${CMAKE_SOURCE_DIR}/src/impl/x86_64 ${asm_file})
    # Change extension from .asm to .o and prepend build path
    string(REGEX REPLACE "\\.asm$" ".o" obj_file ${rel_path})
    set(obj_file "${CMAKE_SOURCE_DIR}/build/x86_64/${obj_file}")
    list(APPEND x86_64_asm_object_files ${obj_file})
    
    # Get the directory for the object file
    get_filename_component(obj_dir ${obj_file} DIRECTORY)
    
    # Create custom command to compile ASM file
    add_custom_command(
        OUTPUT ${obj_file}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${obj_dir}
        COMMAND nasm -f elf64 ${asm_file} -o ${obj_file}
        DEPENDS ${asm_file}
        COMMENT "Compiling ASM file ${asm_file}"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
endforeach()

# Odin kernel compilation
set(ODIN_KERNEL_OBJECTS
    "${CMAKE_SOURCE_DIR}/build/x86_64/kernel/builtin.o"
    "${CMAKE_SOURCE_DIR}/build/x86_64/kernel/kernel.o"
    "${CMAKE_SOURCE_DIR}/build/x86_64/kernel/runtime.o"
)

add_custom_command(
    OUTPUT ${ODIN_KERNEL_OBJECTS}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/build/x86_64/kernel
    COMMAND odin build src/impl/x86_64/kernel/ -out:build/x86_64/kernel -build-mode:obj -target:freestanding_amd64_sysv -disable-assert -no-crt -default-to-nil-allocator
    DEPENDS src/impl/x86_64/kernel/
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Compiling Odin kernel"
)

# Kernel binary linking
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/dist/x86_64/kernel.bin
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/dist/x86_64
    COMMAND x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld ${x86_64_asm_object_files} ${ODIN_KERNEL_OBJECTS}
    DEPENDS ${x86_64_asm_object_files} ${ODIN_KERNEL_OBJECTS} targets/x86_64/linker.ld
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Linking kernel binary"
)

# Copy kernel binary to ISO directory
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/targets/x86_64/iso/boot/kernel.bin
    COMMAND ${CMAKE_COMMAND} -E copy dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin
    DEPENDS ${CMAKE_SOURCE_DIR}/dist/x86_64/kernel.bin
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Copying kernel binary to ISO directory"
)

# Create ISO image
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/dist/x86_64/kernel.iso
    COMMAND grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso
    DEPENDS ${CMAKE_SOURCE_DIR}/targets/x86_64/iso/boot/kernel.bin
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Creating ISO image"
)

# Build target - only builds the kernel
add_custom_target(build
    DEPENDS ${CMAKE_SOURCE_DIR}/dist/x86_64/kernel.iso
    COMMENT "Building kernel"
)

# Default target just shows help
add_custom_target(help_text ALL
    COMMAND ${CMAKE_COMMAND} -E echo "Available targets:"
    COMMAND ${CMAKE_COMMAND} -E echo "  make build          - Build the kernel"
    COMMAND ${CMAKE_COMMAND} -E echo "  make run            - Build and run kernel with QEMU"
    COMMAND ${CMAKE_COMMAND} -E echo "  make clean-all      - Clean build artifacts"
    COMMENT "Showing available targets"
)

# QEMU run target (builds and runs)
add_custom_target(run
    COMMAND qemu-system-x86_64 dist/x86_64/kernel.iso
    DEPENDS ${CMAKE_SOURCE_DIR}/dist/x86_64/kernel.iso
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Building and running kernel with QEMU"
)

# Clean target
add_custom_target(clean-all
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/build
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/dist
    COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_SOURCE_DIR}/targets/x86_64/iso/boot/kernel.bin
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Cleaning build artifacts"
)
