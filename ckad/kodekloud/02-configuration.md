# Docker Images

## Why create your Own Image?

- **Customisation**: You create your own image when a service you need isn't available on Docker Hub or when you want to "Dockerise" your own applicaiton for easier shipping and deployment.
- **Manual to Automated**: To build an image, you first think about the manual steps (e.g., choosing an OS, installing dependencies, copying code) and then translate those into a **Dockerfile**.

## The Dockerfile Basics

- **Instruction Format**: A Dockerfile is a text file using an **INSTRUCTION argument** format (e.g., `FROM Ubuntu`).
- **Key Instruction**:
    - `FROM`: Every Dockerfile must start with this; it defines the **base operating system** or image.
    - `RUN`: Tells Docker to run specific commands (like installing packages) while the image is being built.
    - `COPY`: Moves files from your local system into the image.
    - `ENTRYPOINT`: Specifies the main command that will run when the container starts up.

## The Layered Architecture

- **Stacking Layers**: Docker builds images in layers; **each line of instruction creates a new layer** that only stores the changes from the previous one.
- **Caching for Speed**: Docker **caches** these layers. If a build fails or you change only the top layer (like source code), Docker reuses the existing bottom layers from the cache to make the process much faster.

## Container Lifecycle

- **Task-Oriented**: Unlike a Virtual Machine, a container is meant to run a **specific task** (like a web server or database) rather than an entire OS.
- **The "Stay Alive" Rule**: A container only stays alive as long as the **process inside it is running**. If the task finishes or the service crashes, the container exits immediately.

## Commands vs Entry Points

- `CMD` (Command): This defines the default program to run. However, if you add a command to your `docker run` instruction, it **completely replaces** the CMD defined in the image.
- `ENTRYPOINT`: This defines the permanent executable. Anything you type at the end of the `docker run` command will be **appended** to the entry point rather than replacing it.
- **Best Practice**: Use `ENTRYPOINT` for the main command (like `sleep`) and `CMD` for the default parameter (like 5 seconds). This allows users to easily change the parameter without re-typing the whole command.

# Docker Commands, Entrypoints and Arguments

## The Purpose of a Container

- **Process-Driven**: Unlike virtual machines, containers are not designed to host a full operating system; they are meant to run a **speciic task or process**, such as a web server or database.
- **Lifecycle**: A container's life is tied directly to the process inside it. It **only lives as long as that process is alive**; if the process stops or crashes, the container exits immediately.
- **The Ubuntu Example**: If you run a plain Ubuntu container, it exits quickly because its default command is bash. Since Docker doesn't usually attach a terminal by default, bash finds no input and terminates, causing the container to exit.

## The `CMD` Instruction

- **Defining the Default**: The `CMD` (command) instruction in a Dockerfile sets the program that runs when the container starts.
- **Overriding at Runtime**: You can easily override the default `CMD` by **appending a new command** to the `docker run` instruction (e.g., `docker run ubuntu sleep 5`).
- **Replacement Rule**: If you provide parameters at the command line, they **entirely replace** the `CMD` instruction defined in the image.

## The `ENTRYPOINT` Instruction

- **Defining the Fixed Executable**: `ENTRYPOINT` is used to specify the main executable for the container.
- **Appending Rule**: Unlike `CMD`, any parameters you pass via the command line are **appended** to the `ENTRYPOINT` rather than replacing it.
- **Use Case**: This is ideal for "sleeper" images where you want the command to always be `sleep`, but you want to allow the user to easily provide the number of seconds as an argument.

```Dockerfile
ENTRYPOINT [ "sleep" ]
CMD [ "5" ]
```

## Combining `ENTRYPOINT` and `CMD`

- You can use both instructions together to create a **default value** that can still be overridden.
- **How it Works**: In this setup, `ENTRYPOINT` defines the program (e.g., sleep) and `CMD` provides the **default arguments** (e.g., 5). If the user provides no input, it runs `sleep 5`. If the user provides `10`, it runs `sleep 10`.
- **Override Flag**: If you need to change the actual executable at runtime (e.g., changing `sleep` to something else), you must use the `--entrypoint` flag in your command.

## Syntax requirements

- **JSON Format**: For `ENTRYPOINT` and `CMD` to work together correctly, they should be written in **JSON array format**.
- **Separation**: Each element (the executable and its parameters) must be a **separate string** within the array (e.g., `["sleep", "5"]`).

# Cheatsheet for Commands and Arguments

## Docker

| Dockerfile | `docker run ...` | What actually runs |
|--|--|:-:|
| `CMD ["sleep"]` | `docker run <image>` | `sleep` *(no args → usually exits “missing operand”)* |
| `CMD ["sleep","5"]` | `docker run <image>` | `sleep 5` |
| `CMD ["sleep","5"]` | `docker run <image> sleep 10` | `sleep 10` *(replaces CMD entirely)* |
| `CMD ["sleep","5"]` | `docker run <image> 10` | `10` *(tries to exec `10` → fails; because it replaces CMD, not “append args”)* |
| `ENTRYPOINT ["sleep"]` | `docker run <image>` | `sleep` *(no args → usually exits “missing operand”)* |
| `ENTRYPOINT ["sleep"]` + `CMD ["5"]` | `docker run <image>` | `sleep 5` |
| `ENTRYPOINT ["sleep"]` + `CMD ["5"]` | `docker run <image> 10` | `sleep 10` *(overrides CMD args)* |
| `ENTRYPOINT ["sleep"]` + `CMD ["5"]` | `docker run --entrypoint sleep2 <image> 15` | `sleep2 15` *(overrides ENTRYPOINT, overrides CMD)* |
| `ENTRYPOINT ["sleep"]` + `CMD ["5"]` | `docker run --entrypoint sleep2 <image>` | `sleep2 5` *(overrides ENTRYPOINT, keeps CMD as args)* |
