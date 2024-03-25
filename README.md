# buildkit-nvidia

Docker provides a way to use GPUs using [`--gpus`](https://docs.docker.com/config/containers/resource_constraints/#access-an-nvidia-gpu) flag but this only works for `docker run`, not for `docker build`. There are previous workarounds but it requires disabling buildkit with `DOCKER_BUILDKIT=0`.

If you are looking to build artifacts (such as using `--output`) that require a GPU, this is not possible today officially.

This repo provides a workaround to be able to use NVIDIA GPUs with `docker build`.

## How it works

- Must run with `--security=insecure` to access to the NVIDIA devices. This works with `docker-container`, `kubernetes` drivers and containerd image store, but they have to be configured to able to run in `security=insecure`. For example: `docker buildx create --name my-builder --use --buildkitd-flags '--allow-insecure-entitlement security.insecure'`.
- It'll install dependencies to download and install NVIDIA drivers.
- It'll install NVIDIA drivers inside the container since we can't mount from host.
- Creates device nodes for known NVIDIA devices and runs `nvidia-smi` as an example. You must run `mknod` everytime GPU is being accessed if it's in a different `RUN` command.

Dockerfile: https://github.com/sozercan/buildkit-nvidia/blob/main/Dockerfile

### Limitations

- NVIDIA driver version must match the host version otherwise NVIDIA will provide an error.
- This does not work with WSL2 as it does not use `/dev/nvidia*` devices, but instead uses `/dev/dxg`. Also, `/proc/driver/nvidia/version` does not exist in WSL2.

## Usage

See https://gist.github.com/sozercan/28dfa71da896989cd573d1e0a7511246

## Example

AIKit (https://github.com/sozercan/aikit) fine tuning implementation uses the technique described in this repository to produce artifacts that require GPU with `docker build --output`.

For more information: https://sozercan.github.io/aikit/fine-tune
