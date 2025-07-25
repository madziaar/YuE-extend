<p align="center">
    <img src="./assets/logo/白底.png" width="400" />
</p>

<p align="center">
    <a href="https://map-yue.github.io/">Demo 🎶</a> &nbsp;|&nbsp; 📑 <a href="">Paper (coming soon)</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-cot">YuE-s1-7B-anneal-en-cot 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-icl">YuE-s1-7B-anneal-en-icl 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-cot">YuE-s1-7B-anneal-jp-kr-cot 🤗</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-icl">YuE-s1-7B-anneal-jp-kr-icl 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-cot">YuE-s1-7B-anneal-zh-cot 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-icl">YuE-s1-7B-anneal-zh-icl 🤗</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s2-1B-general">YuE-s2-1B-general 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-upsampler">YuE-upsampler 🤗</a>
</p>

---

# YuE-extend: MP3 Extension with ExLlamaV2 and GPU-Poor Optimization

**YuE (乐)** is a groundbreaking series of open-source foundation models designed for music generation, specifically for transforming lyrics into full songs (lyrics2song). Our model's name means "music" and "happiness" in Chinese. Some of you may find words that start with Yu hard to pronounce. If so, you can just call it "yeah."

This repository combines multiple optimization approaches:
- **MP3 Extension**: Can extend any uploaded mp3 with voice cloning and music continuation
- **ExLlamaV2 Integration**: Up to 500% speedup with Flash Attention 2 and BF16 support
- **GPU-Poor Optimization**: Performance profiles for different VRAM configurations (as low as 6GB)
- **Web UI**: Gradio interface for easy configuration and music generation

It incorporates work from:
- Original YuE: [official repository](https://github.com/multimodal-art-projection/YuE)
- ExLlamaV2 module: [YuE-Exllamav2](https://github.com/sgsdxzy/YuE-exllamav2)  
- GPU-Poor optimization: [YuEGP](https://github.com/deepbeepmeep/YuEGP)
- Web UI: [YuE-exllamav2-UI](https://github.com/alisson-anjos/YuE-exllamav2-UI)

<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/6555e8d8a0c34cd61a6b9ce3/rG-ELxMyzDU7zH-inB9DV.mpga"></audio>

YuE can generate complete songs, lasting several minutes, that include both catchy vocal tracks and complementary accompaniment. It's capable of modeling diverse genres/vocal styles:

Pop: Quiet Evening
<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/640701cb4dc5f2846c91d4eb/gnBULaFjcUyXYzzIwXLZq.mpga"></audio>

Metal: Step Back  
<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/6555e8d8a0c34cd61a6b9ce3/kmCwl4GRS70UYDEELL-Tn.mpga"></audio>



## Updates

### Latest Features
* **2025.02.22 🔥**: --extend_current_segment (use with --extend_mp3) to continue first(0) segment. Can also be used to generate TTS (use speech.mp3 + some_melody.mp3)
* **2025.02.16 🔥**: Free Google colab with COT and mp3-extend: https://colab.research.google.com/github/Mozer/YuE-extend/blob/main/colab/Yue_extend_with_exllama.ipynb
* **2025.02.14 🔥**: --extend_mp3 feature by Mozer. It will create new verses after segment 0, taken from mp3.
* **2025.02.14 🔥**: Continue previous generation feature (--resume_after_n) by Mozer

### GPU-Poor Optimization Updates  
* **2025.02.10 🔥**: V3.0 DeepBeepMeep: Multiple songs per genre prompt, progression bar, abort button, experimental turbo stage 2
* **2025.02.08 🔥**: V2.21 DeepBeepMeep: Aligned infer.py with gradio server.py and added robustness improvements
* **2025.02.06 🔥**: V2.1 DeepBeepMeep: 3x faster with 12+ GB VRAM GPUs thanks to optimized transformers library

### Performance & Integration Updates
* **2025.02.03**: Added ExLlamaV2 integration with up to 500% speedup by sgsdxzy (https://github.com/sgsdxzy/YuE-exllamav2)
* **2025.01.30**: DeepBeepMeep GPU-Poor version with In-Context Learning support
* **2025.01.30**: Initial release with BF16 model support
* **2025.01.26**: Original YuE series release

## Key Features & Notes

### MP3 Extension
- --extend_mp3 works best with segments <= 30s. Long mp3s can cause OOM error. Recommend extending right after first verse end
- --extend_mp3 takes 2 separate tracks as input: vocal.mp3 + instrumental.mp3. To split your mp3 use: [python-audio-separator](https://huggingface.co/spaces/theneos/audio-separator) or [audiostrip.com](https://www.audiostrip.com/isolate) or [lalal.ai](https://www.lalal.ai/) or [vocalremover.org](https://vocalremover.org/)
- Seeding is currently not working with exllama

### GPU Memory Management
- For low VRAM setups, try: `export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True`
- **YuE-Exllamav2** delivers exceptional performance on modern NVIDIA GPUs like RTX 4090 and RTX 3060
- GPU-Poor profiles support GPUs from 6GB to 80GB+ VRAM

## Interface

![Gradio Interface Preview](/preview.png)

---

## Installation

### Quick Start (GPU-Poor Profiles)

Python 3.10 is recommended (some issues reported on 3.12/3.13). Python 3.11 might work as well.

#### 1) Install source code
```bash
# Make sure you have git-lfs installed (https://git-lfs.com)
git lfs install
git clone https://github.com/madziaar/YuE-extend.git
cd YuE-extend/inference/
git clone https://huggingface.co/m-a-p/xcodec_mini_infer
```

#### 2) Install PyTorch and requirements

**For NVIDIA GPUs:**
```bash
pip install torch==2.5.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124
```

**For AMD GPUs:**
```bash
pip3 install torch torchaudio triton --index-url https://download.pytorch.org/whl/rocm6.2
# Then run with: TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL=1 python gradio_server.py --profile 1 --sdpa
```

Then install dependencies:
```bash
pip install -r requirements.txt
```

#### 3) (Optional) Install FlashAttention 2
```bash
pip install flash-attn --no-build-isolation
```

If unable to install Flash Attention (common on Windows), use `--sdpa` switch instead.

#### 4) (Optional) Apply Transformers Patches
For low VRAM profiles and 2x faster generation:

**Linux:**
```bash
source patchtransformers.sh
```

**Windows:**
```bash
patchtransformers.bat
```

### Alternative: ExLlamaV2 Installation (Windows)

For high-performance ExLlamaV2 optimization:

#### Requirements
- Python 3.9 (3.10 also works)  
- Torch 2.4.0 (ExLlamaV2 compiled for specific versions)
- CUDA toolkit 12.4+

```cmd
conda create -n yue python=3.9
conda activate yue

# torch, exllama and flash_attn-2
pip install torch==2.4.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
pip install https://github.com/turboderp-org/exllamav2/releases/download/v0.2.7/exllamav2-0.2.7+cu121.torch2.4.0-cp39-cp39-win_amd64.whl
pip install https://github.com/bdashore3/flash-attention/releases/download/v2.7.1.post1/flash_attn-2.7.1.post1+cu124torch2.4.0cxx11abiFALSE-cp39-cp39-win_amd64.whl

pip install -r requirements.txt

# Download ExL2 models (5.7 + 5.7 + 1.8 GB) into workspace\models:
huggingface-cli download Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-8.0bpw --local-dir workspace\models\YuE-s1-7B-anneal-en-cot-exl2-8.0bpw
huggingface-cli download Ftfyhh/YuE-s1-7B-anneal-en-icl-8.0bpw-exl2 --local-dir workspace\models\YuE-s1-7B-anneal-en-icl-8.0bpw-exl2
huggingface-cli download Alissonerdx/YuE-s2-1B-general-exl2-8.0bpw --local-dir workspace\models\YuE-s2-1B-general-exl2-8.0bpw
```

Run: `start-gui.bat` or visit http://127.0.0.1:7860/



## Usage

### YuE Versions and Performance Profiles

#### GPU-Poor Gradio Interface

**Lyrics + Genre prompts (default):**
```bash
cd inference
python gradio_server.py
```

**In-Context Learning (with audio prompts):**
```bash
cd inference  
python gradio_server.py --icl
```

**Performance profiles:**
- Profile 1 (16GB+ VRAM, fastest): `python gradio_server.py --profile 1`
- Profile 3 (12GB VRAM, 8-bit quantized): `python gradio_server.py --profile 3`
- Profile 4 (<10GB VRAM, sequential offloading): `python gradio_server.py --profile 4`
- Profile 5 (minimum VRAM): `python gradio_server.py --profile 5`

**Additional options:**
- `--compile`: Enable PyTorch compilation (Linux/WSL/Windows with Triton)
- `--sdpa`: Use SDPA attention instead of Flash Attention
- `--turbo-stage2`: Experimental 2x faster stage 2 (16GB+ VRAM)

### MP3 Extension (ExLlamaV2 Interface)

Three methods for mp3-extend:
1. **COT model** (simplest, most proven)
2. **ICL model + 2 additional tracks**  
3. **ICL model + 1 additional common track**

In the web UI:
- Stage 1 model: YuE-s1-7B-anneal-en-cot-exl2-8.0bpw
- Lyrics: Full song text with first [verse] segment containing everything to skip
- Check "Extend mp3"
- Upload vocal.mp3 + instrumental.mp3 (split using audio separator tools)
- Set "Seconds to take from mp3" to exact time when first verse vocals end
- Generate

**Advanced options:**
- "Use Dual Tracks Audio Prompt?" and "Use Audio Prompt? (both vocal and instrumental)" provide full song context but make generation harder to control
- Try setting "Audio prompt End Time" to 1-3 seconds more than "Seconds to take from mp3"
- Experiment with different segments to balance similarity and novelty

### Command Line Interface

```bash
cd inference/
python infer.py \
    --stage1_model m-a-p/YuE-s1-7B-anneal-en-cot \
    --stage2_model m-a-p/YuE-s2-1B-general \
    --genre_txt prompt_examples/genre.txt \
    --lyrics_txt prompt_examples/lyrics.txt \
    --run_n_segments 2 \
    --stage2_batch_size 4 \
    --output_dir ./output \
    --cuda_idx 0 \
    --max_new_tokens 3000
```

**With audio prompt:**
```bash
python infer.py \
    --stage1_model m-a-p/YuE-s1-7B-anneal-en-icl \
    --stage2_model m-a-p/YuE-s2-1B-general \
    --genre_txt prompt_examples/genre.txt \
    --lyrics_txt prompt_examples/lyrics.txt \
    --run_n_segments 2 \
    --stage2_batch_size 4 \
    --output_dir ./output \
    --cuda_idx 0 \
    --max_new_tokens 3000 \
    --audio_prompt_path {YOUR_AUDIO_FILE} \
    --prompt_start_time 0 \
    --prompt_end_time 30 \
    --use_audio_prompt
```

## Performance Benchmarks

### ExLlamaV2 Performance (High-End GPUs)

**RTX 4090 24GB:**
| Stage         | Original | ExLlamaV2 | Speedup |
|---------------|----------|-----------|---------|
| Stage 1       | 282s     | 125s      | 2.25x   |
| Stage 2       | 666s     | 49s       | 13.6x   |
| **Total**     | 948s     | 174s      | **5.45x** |

*Configuration: BF16 models, Flash Attention 2 enabled, CFG enabled, batch size 4, 64k cache.*

**RTX 3060 Mobile 6GB:**
| Stage         | ExLlamaV2 |
|---------------|-----------|
| Stage 1       | 317s      |
| Stage 2       | 350s      |
| **Total**     | 667s      |

*Configuration: Quantized models with Q4/Q8 cache, Flash Attention 2 enabled.*

### GPU-Poor Performance
- **H800 GPU**: 30s audio takes ~150 seconds
- **RTX 4090**: 30s audio takes ~360 seconds (standard), ~240s (with optimizations)
- **RTX 4090 (Profile 1 + patches)**: ~120s for 30s audio (3x improvement)

## Docker Deployment

### Prerequisites

### Docker

Ensure you have Docker installed on your system. Follow the official Docker installation guides for your platform:

- [Install Docker on Windows](https://docs.docker.com/desktop/windows/install/)
- [Install Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

### NVIDIA GPU Support

This interface **requires NVIDIA GPUs** for acceleration. Ensure you have the necessary hardware and drivers set up.

1. **Linux**:
   - Install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).
   - Ensure your NVIDIA drivers are properly installed and up to date.

2. **Windows/macOS**:
   - Refer to the respective Docker and NVIDIA documentation for GPU passthrough (e.g., WSL2 on Windows).
   - **Note**: GPU support is mandatory. Without compatible NVIDIA GPUs, the container will not function correctly.

### Docker Compose

To simplify the setup and management of the YuE-Exllamav2-UI, you can use Docker Compose. Docker Compose allows you to define and run multi-container Docker applications with a single configuration file (`docker-compose.yml`). Below are the steps to get started.

> **Note**: This **docker-compose.yml** file already exists in the root of the repository, you just need to download or copy the file and replace the directory mapping and run the command in the same directory as the file, see the explanation below.

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  yue-exllamav2:
    image: alissonpereiraanjos/yue-exllamav2-interface:latest
    container_name: yue-exllamav2
    restart: unless-stopped
    ports:
      - "7860:7860"
    environment:
      - DOWNLOAD_MODELS=all_bf16
    volumes:
      - /path/to/models:/workspace/models
      - /path/to/outputs:/workspace/outputs
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
```

Run the container:

```bash
docker-compose up -d
```

**Access the Interface**: Once the container is running, access the Gradio UI at `http://localhost:7860`.

### Explanation of the Configuration

- **`image`**: Specifies the Docker image to use (`alissonpereiraanjos/yue-exllamav2-interface:latest`).
- **`container_name`**: Sets a name for the container (`yue-interface`).
- **`restart: unless-stopped`**: Ensures the container restarts automatically unless manually stopped.
- **`ports`**: Maps container ports to the host:
  - `7860:7860`: Port for accessing the Gradio UI.
  - `8888:8888`: Optional additional port (JupyterLab).
- **`environment`**: Defines environment variables:
  - `DOWNLOAD_MODELS=all`: Downloads all available models. Replace `all` with specific model keys (e.g., `YuE-s2-1B-general,YuE-s1-7B-anneal-en-cot`) to download only selected models.
- **`volumes`**: Maps host directories to the container:
  - `/path/to/models:/workspace/models`: Directory where models will be stored.
  - `/path/to/outputs:/workspace/outputs`: Directory where generated outputs will be saved.
  - Replace `/path/to/models` and `/path/to/outputs` with the actual paths on your system.
- **`deploy.resources.reservations.devices`**: Enables GPU support in the container (requires NVIDIA GPU and drivers).

### Customization

- **Specific models**: To download only specific models, modify the `DOWNLOAD_MODELS` environment variable in the `docker-compose.yml` file. For example:

  ```yaml
  environment:
    - DOWNLOAD_MODELS=YuE-s2-1B-general,YuE-s1-7B-anneal-en-cot,YuE-s1-7B-anneal-en-icl,YuE-upsampler
  ```

- **Different ports**: If you need to use different ports, adjust the port mappings under the `ports` section.
---

### Direct Docker Run

To run without Docker Compose:

```bash
docker run --gpus all -d \
  -p 7860:7860 \
  -e DOWNLOAD_MODELS=all_bf16 \
  -v /path/to/models:/workspace/models \
  -v /path/to/outputs:/workspace/outputs \
  alissonpereiraanjos/yue-exllamav2-interface:latest
```

- `--gpus all`: Enables NVIDIA GPU support.
- `-d`: Runs the container in detached mode (background).
- `-p 7860:7860`: Exposes port `7860` for accessing the Gradio UI at [http://localhost:7860](http://localhost:7860).
- `-p 8888:8888`: Exposes port `8888` for additional services if applicable.
- `-e DOWNLOAD_MODELS=all_bf16`: Downloads all bf16 available models upon initialization.

## Environment Variables

- **DOWNLOAD_MODELS**: Determines which models to download.
  - Set to `all_bf16` to download all available models (BF16).
  - Alternatively, specify a comma-separated list of model keys to download specific models (e.g., `DOWNLOAD_MODELS=YuE-s2-1B-general,YuE-s1-7B-anneal-en-cot`).


---

## Supported Models

| Model Key                         | Model HF Repository                             | Container Path                                      | Quantization |
|-----------------------------------|------------------------------------------------|----------------------------------------------------|--------------|
| `xcodec_mini_infer`               | [`m-a-p/xcodec_mini_infer`](https://huggingface.co/m-a-p/xcodec_mini_infer) | `/workspace/YuE-Interface/inference/xcodec_mini_infer` | N/A          |
| `YuE-s1-7B-anneal-en-cot`         | [`m-a-p/YuE-s1-7B-anneal-en-cot`](https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-cot) | `/workspace/models/YuE-s1-7B-anneal-en-cot`       | BF16         |
| `YuE-s1-7B-anneal-en-icl`         | [`m-a-p/YuE-s1-7B-anneal-en-icl`](https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-icl) | `/workspace/models/YuE-s1-7B-anneal-en-icl`       | BF16         |
| `YuE-s1-7B-anneal-jp-kr-cot`      | [`m-a-p/YuE-s1-7B-anneal-jp-kr-cot`](https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-cot) | `/workspace/models/YuE-s1-7B-anneal-jp-kr-cot`    | BF16         |
| `YuE-s1-7B-anneal-jp-kr-icl`      | [`m-a-p/YuE-s1-7B-anneal-jp-kr-icl`](https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-icl) | `/workspace/models/YuE-s1-7B-anneal-jp-kr-icl`    | BF16         |
| `YuE-s1-7B-anneal-zh-cot`         | [`m-a-p/YuE-s1-7B-anneal-zh-cot`](https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-cot) | `/workspace/models/YuE-s1-7B-anneal-zh-cot`       | BF16         |
| `YuE-s1-7B-anneal-zh-icl`         | [`m-a-p/YuE-s1-7B-anneal-zh-icl`](https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-icl) | `/workspace/models/YuE-s1-7B-anneal-zh-icl`       | BF16         |
| `YuE-s2-1B-general`               | [`m-a-p/YuE-s2-1B-general`](https://huggingface.co/m-a-p/YuE-s2-1B-general) | `/workspace/models/YuE-s2-1B-general`             | BF16         |
| `YuE-upsampler`                   | [`m-a-p/YuE-upsampler`](https://huggingface.co/m-a-p/YuE-upsampler) | `/workspace/models/YuE-upsampler`                 | BF16         |
| `YuE-s1-7B-anneal-en-cot-exl2-3.0bpw` | [`Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-3.0bpw`](https://huggingface.co/Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-3.0bpw) | `/workspace/models/YuE-s1-7B-anneal-en-cot-exl2-3.0bpw` | EXL2 (3.0bpw) |
| `YuE-s1-7B-anneal-en-cot-exl2-4.0bpw` | [`Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-4.0bpw`](https://huggingface.co/Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-4.0bpw) | `/workspace/models/YuE-s1-7B-anneal-en-cot-exl2-4.0bpw` | EXL2 (4.0bpw) |
| `YuE-s1-7B-anneal-en-cot-exl2-5.0bpw` | [`Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-5.0bpw`](https://huggingface.co/Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-5.0bpw) | `/workspace/models/YuE-s1-7B-anneal-en-cot-exl2-5.0bpw` | EXL2 (5.0bpw) |
| `YuE-s1-7B-anneal-en-cot-exl2-6.0bpw` | [`Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-6.0bpw`](https://huggingface.co/Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-6.0bpw) | `/workspace/models/YuE-s1-7B-anneal-en-cot-exl2-6.0bpw` | EXL2 (6.0bpw) |
| `YuE-s1-7B-anneal-en-cot-exl2-8.0bpw` | [`Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-8.0bpw`](https://huggingface.co/Alissonerdx/YuE-s1-7B-anneal-en-cot-exl2-8.0bpw) | `/workspace/models/YuE-s1-7B-anneal-en-cot-exl2-8.0bpw` | EXL2 (8.0bpw) |
| `YuE-s2-1B-general-exl2-3.0bpw`   | [`Alissonerdx/YuE-s2-1B-general-exl2-3.0bpw`](https://huggingface.co/Alissonerdx/YuE-s2-1B-general-exl2-3.0bpw) | `/workspace/models/YuE-s2-1B-general-exl2-3.0bpw` | EXL2 (3.0bpw) |
| `YuE-s2-1B-general-exl2-4.0bpw`   | [`Alissonerdx/YuE-s2-1B-general-exl2-4.0bpw`](https://huggingface.co/Alissonerdx/YuE-s2-1B-general-exl2-4.0bpw) | `/workspace/models/YuE-s2-1B-general-exl2-4.0bpw` | EXL2 (4.0bpw) |
| `YuE-s2-1B-general-exl2-5.0bpw`   | [`Alissonerdx/YuE-s2-1B-general-exl2-5.0bpw`](https://huggingface.co/Alissonerdx/YuE-s2-1B-general-exl2-5.0bpw) | `/workspace/models/YuE-s2-1B-general-exl2-5.0bpw` | EXL2 (5.0bpw) |
| `YuE-s2-1B-general-exl2-6.0bpw`   | [`Alissonerdx/YuE-s2-1B-general-exl2-6.0bpw`](https://huggingface.co/Alissonerdx/YuE-s2-1B-general-exl2-6.0bpw) | `/workspace/models/YuE-s2-1B-general-exl2-6.0bpw` | EXL2 (6.0bpw) |
| `YuE-s2-1B-general-exl2-8.0bpw`   | [`Alissonerdx/YuE-s2-1B-general-exl2-8.0bpw`](https://huggingface.co/Alissonerdx/YuE-s2-1B-general-exl2-8.0bpw) | `/workspace/models/YuE-s2-1B-general-exl2-8.0bpw` | EXL2 (8.0bpw) |

---

### Mapping Directories for Models and Output

You can mount host directories to store models and outputs outside the container:

```bash
docker run --gpus all -it \
  -v /path/to/models:/workspace/models \
  -v /path/to/outputs:/workspace/outputs \
  -p 7860:7860 \
  -p 8888:8888 \
  -e DOWNLOAD_MODELS=false \
  alissonpereiraanjos/yue-exllamav2-interface:latest
```

- `-v /path/to/models:/workspace/models`: Mounts the host's `/path/to/models` directory to `/workspace/models` inside the container.
- `-v /path/to/outputs:/workspace/outputs`: Mounts the host's `/path/to/outputs` directory to `/workspace/outputs` inside the container.
- `-e DOWNLOAD_MODELS=false`: Skips automatic model downloads (useful if models are already present in the mounted directories).

## RunPod Deployment

If you prefer to use **RunPod**, you can quickly deploy an instance based on this image by using the following template link:

[**Deploy on RunPod**](https://runpod.io/console/deploy?template=nah47krmt0&ref=8t518hht)

This link directs you to the RunPod console, allowing you to set up a machine directly with the YuE Interface image. Configure your GPU, volume mounts, and environment variables as needed.

**Tip**: If you generate music frequently, consider creating a **Network Volume** in RunPod. This allows you to store models and data persistently, avoiding repeated downloads and saving time.

**Recommended Settings:**
- GPU: RTX 4090 or A100
- Network Volume: Minimum 100GB for model storage
- Environment Variables: `DOWNLOAD_MODELS=all_bf16`

## Update Docker Image (Important)

To update the Docker image with the latest changes, run:

```bash
docker pull alissonpereiraanjos/yue-exllamav2-interface:latest
```

**Note**: Always update the image before running the container to ensure you have the latest features and fixes. This is especially important when deploying on RunPod, as it pulls the latest image upon creating a new pod.

### Model Suffixes Explained

The suffixes in the model keys indicate specific training or optimization techniques applied to the models:

| Suffix | Meaning               | Description                                                                                     |
|--------|-----------------------|-------------------------------------------------------------------------------------------------|
| `COT`  | **Chain-of-Thought**  | Models trained with *Chain-of-Thought* to enhance reasoning and logical generation capabilities.|
| `ICL`  | **In-Context Learning** | Models optimized for *In-Context Learning*, allowing dynamic adaptation based on the provided context.|

**Examples:**

- `YuE-s1-7B-anneal-en-cot`: A model trained with *Chain-of-Thought* techniques.
- `YuE-s1-7B-anneal-en-icl`: A model optimized for *In-Context Learning*.

## Acknowledgements

A special thanks to the [YuE-exllamav2](https://github.com/sgsdxzy/YuE-exllamav2) repository for their incredible optimization work, which made this project possible.

---

## Support

For technical support or questions:
- [GitHub Issues](https://github.com/alissonpereiraanjos/YuE-Exllamav2-UI/issues)
- [CivitAI Profile](https://civitai.com/user/alissonerdx)

---

## Citation

If you use this project in your research, please consider citing:

```bibtex
@misc{yuan2025yue,
  title={YuE: Open Music Foundation Models for Full-Song Generation},
  author={Ruibin Yuan et al.},
  year={2025},
  howpublished={\url{https://github.com/multimodal-art-projection/YuE}}
}
```

---

**Experience music generation with accelerated performance!** 🎵🚀

---
||||||| f7f27e9
<p align="center">
    <img src="./assets/logo/白底.png" width="400" />
</p>

<p align="center">
    <a href="https://map-yue.github.io/">Demo 🎶</a> &nbsp;|&nbsp; 📑 <a href="">Paper (coming soon)</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-cot">YuE-s1-7B-anneal-en-cot 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-icl">YuE-s1-7B-anneal-en-icl 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-cot">YuE-s1-7B-anneal-jp-kr-cot 🤗</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-icl">YuE-s1-7B-anneal-jp-kr-icl 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-cot">YuE-s1-7B-anneal-zh-cot 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-icl">YuE-s1-7B-anneal-zh-icl 🤗</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s2-1B-general">YuE-s2-1B-general 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-upsampler">YuE-upsampler 🤗</a>
</p>

---
Our model's name is **YuE (乐)**. In Chinese, the word means "music" and "happiness." Some of you may find words that start with Yu hard to pronounce. If so, you can just call it "yeah." We wrote a song with our model's name.

<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/6555e8d8a0c34cd61a6b9ce3/rG-ELxMyzDU7zH-inB9DV.mpga"></audio>

YuE is a groundbreaking series of open-source foundation models designed for music generation, specifically for transforming lyrics into full songs (lyrics2song). It can generate a complete song, lasting several minutes, that includes both a catchy vocal track and complementary accompaniment, ensuring a polished and cohesive result. YuE is capable of modeling diverse genres/vocal styles. Below are examples of songs in the pop and metal genres. For more styles, please visit the demo page.

Pop:Quiet Evening
<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/640701cb4dc5f2846c91d4eb/gnBULaFjcUyXYzzIwXLZq.mpga"></audio>
Metal: Step Back
<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/6555e8d8a0c34cd61a6b9ce3/kmCwl4GRS70UYDEELL-Tn.mpga"></audio>

## News and Updates

* **2025.01.26 🔥**: We have released the **YuE** series.

<br>

## Requirements

Python >=3.8 is recommended.

Install dependencies with the following command:

```
pip install -r requirements.txt
```

### **Important: Install FlashAttention 2**
For saving GPU memory, **FlashAttention 2 is mandatory**. Without it, large sequence lengths will lead to out-of-memory (OOM) errors, especially on GPUs with limited memory. Install it using the following command:
```
pip install flash-attn --no-build-isolation
```
Before installing FlashAttention, ensure that your CUDA environment is correctly set up. 
For example, if you are using CUDA 11.8:
- If using a module system:
``` module load cuda11.8/toolkit/11.8.0 ```
- Or manually configure CUDA in your shell:
```
    export PATH=/usr/local/cuda-11.8/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH
```

---

## GPU Memory Usage and Sessions

YuE requires significant GPU memory for generating long sequences. Below are the recommended configurations:

- **For GPUs with 24GB memory or less**: Run **up to 2 sessions** concurrently to avoid out-of-memory (OOM) errors.
- **For full song generation** (many sessions, e.g., 4 or more): Use **GPUs with at least 80GB memory**. This can be achieved by combining multiple GPUs and enabling tensor parallelism.

To customize the number of sessions, the interface allows you to specify the desired session count. By default, the model runs **2 sessions** for optimal memory usage.

---

## Quickstart

```
# Make sure you have git-lfs installed (https://git-lfs.com)
git lfs install
git clone https://github.com/multimodal-art-projection/YuE.git

cd YuE/inference/
git clone https://huggingface.co/m-a-p/xcodec_mini_infer
```

Here’s a quick guide to help you generate music with **YuE** using 🤗 Transformers. Before running the code, make sure your environment is properly set up, and that all dependencies are installed.

### Running the Script

In the following example, customize the `genres` and `lyrics` in the script, then execute it to generate a song with **YuE**.

Notice: Set `--run_n_segments` to the number of lyric sections if you want to generate a full song. Additionally, you can increase `--stage2_batch_size` based on your available GPU memory.

```bash
cd YuE/inference/
python infer.py \
    --stage1_model m-a-p/YuE-s1-7B-anneal-en-cot \
    --stage2_model m-a-p/YuE-s2-1B-general \
    --genre_txt prompt_examples/genre.txt \
    --lyrics_txt prompt_examples/lyrics.txt \
    --run_n_segments 2 \
    --stage2_batch_size 4 \
    --output_dir ./output \
    --cuda_idx 0 \
    --max_new_tokens 3000 
```

If you want to use audio prompt, enable `--use_audio_prompt`, and provide audio prompt:
```bash
cd YuE/inference/
python infer.py \
    --stage1_model m-a-p/YuE-s1-7B-anneal-en-icl \
    --stage2_model m-a-p/YuE-s2-1B-general \
    --genre_txt prompt_examples/genre.txt \
    --lyrics_txt prompt_examples/lyrics.txt \
    --run_n_segments 2 \
    --stage2_batch_size 4 \
    --output_dir ./output \
    --cuda_idx 0 \
    --max_new_tokens 3000 \
    --audio_prompt_path {YOUR_AUDIO_FILE} \
    --prompt_start_time 0 \
    --prompt_end_time 30 
```


---

### **Execution Time**
On an **H800 GPU**, generating 30s audio takes **150 seconds**.
On an **RTX 4090 GPU**, generating 30s audio takes approximately **360 seconds**.  

**Tips:**
1. `genres` should include details like instruments, genre, mood, vocal timbre, and vocal gender.
2. The length of `lyrics` segments and the `--max_new_tokens` value should be matched. For example, if `--max_new_tokens` is set to 3000, the maximum duration for a segment is around 30 seconds. Ensure your lyrics fit this time frame.
3. If using audio prompt，the duration around 30s will be fine.
---

### Notice
1. A suitable [Genre] tag consists of five components: genre, instrument, mood, gender, and timbre. All five should be included if possible, separated by spaces. The values of timbre should include "vocal" (e.g., "bright vocal").

2. Although our tags have an open vocabulary, we have provided the 200 most commonly used [tags](./wav_top_200_tags.json). It is recommended to select tags from this list for more stable results.

3. The order of the tags is flexible. For example, a stable genre control string might look like: "[Genre] inspiring female uplifting pop airy vocal electronic bright vocal vocal."

4. Additionally, we have introduced the "Mandarin" and "Cantonese" tags to distinguish between Mandarin and Cantonese, as their lyrics often share similarities.

## License Agreement

Creative Commons Attribution Non Commercial 4.0

---

## Citation

If you find our paper and code useful in your research, please consider giving a star :star: and citation :pencil: :)

```BibTeX
@misc{yuan2025yue,
  title={YuE: Open Music Foundation Models for Full-Song Generation},
  author={Ruibin Yuan and Hanfeng Lin and Shawn Guo and Ge Zhang and Jiahao Pan and Yongyi Zang and Haohe Liu and Xingjian Du and Xeron Du and Zhen Ye and Tianyu Zheng and Yinghao Ma and Minghao Liu and Lijun Yu and Zeyue Tian and Ziya Zhou and Liumeng Xue and Xingwei Qu and Yizhi Li and Tianhao Shen and Ziyang Ma and Shangda Wu and Jun Zhan and Chunhui Wang and Yatian Wang and Xiaohuan Zhou and Xiaowei Chi and Xinyue Zhang and Zhenzhu Yang and Yiming Liang and Xiangzhou Wang and Shansong Liu and Lingrui Mei and Peng Li and Yong Chen and Chenghua Lin and Xie Chen and Gus Xia and Zhaoxiang Zhang and Chao Zhang and Wenhu Chen and Xinyu Zhou and Xipeng Qiu and Roger Dannenberg and Jiaheng Liu and Jian Yang and Stephen Huang and Wei Xue and Xu Tan and Yike Guo}, 
  howpublished={\url{https://github.com/multimodal-art-projection/YuE}},
  year={2025},
  note={GitHub repository}
}
```
<br>
=======
<p align="center">
    <img src="./assets/logo/白底.png" width="400" />
</p>

<p align="center">
    <a href="https://map-yue.github.io/">Demo 🎶</a> &nbsp;|&nbsp; 📑 <a href="">Paper (coming soon)</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-cot">YuE-s1-7B-anneal-en-cot 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-en-icl">YuE-s1-7B-anneal-en-icl 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-cot">YuE-s1-7B-anneal-jp-kr-cot 🤗</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-jp-kr-icl">YuE-s1-7B-anneal-jp-kr-icl 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-cot">YuE-s1-7B-anneal-zh-cot 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-s1-7B-anneal-zh-icl">YuE-s1-7B-anneal-zh-icl 🤗</a>
    <br>
    <a href="https://huggingface.co/m-a-p/YuE-s2-1B-general">YuE-s2-1B-general 🤗</a> &nbsp;|&nbsp; <a href="https://huggingface.co/m-a-p/YuE-upsampler">YuE-upsampler 🤗</a>
</p>

---
Our model's name is **YuE (乐)**. In Chinese, the word means "music" and "happiness." Some of you may find words that start with Yu hard to pronounce. If so, you can just call it "yeah." We wrote a song with our model's name.

<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/6555e8d8a0c34cd61a6b9ce3/rG-ELxMyzDU7zH-inB9DV.mpga"></audio>

YuE is a groundbreaking series of open-source foundation models designed for music generation, specifically for transforming lyrics into full songs (lyrics2song). It can generate a complete song, lasting several minutes, that includes both a catchy vocal track and complementary accompaniment, ensuring a polished and cohesive result. YuE is capable of modeling diverse genres/vocal styles. Below are examples of songs in the pop and metal genres. For more styles, please visit the demo page.

Pop:Quiet Evening
<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/640701cb4dc5f2846c91d4eb/gnBULaFjcUyXYzzIwXLZq.mpga"></audio>
Metal: Step Back
<audio controls src="https://cdn-uploads.huggingface.co/production/uploads/6555e8d8a0c34cd61a6b9ce3/kmCwl4GRS70UYDEELL-Tn.mpga"></audio>

## YuE GP for the GPU Poor by DeepBeepMeep

Please first follow the instructions to install the app below.

### YuE versions

There are two versions of the YuE GP which each will download a different huggingspace model:

- Lyrics + Genre prompts (default) : the song will be generated based on the Lyrics and a genre's description
```bash
cd inference
python gradio_server.py
```

- In Context Learning (default), you can provide also audio prompts (either a mixed audio prompt or a vocal and instrumental prompt) to describe your expectations.
```bash
cd inference
python gradio_server.py --icl
```

### Performance profiles
You have access to numerous performance profiles depending on the performance of your GPU:\

To run the Gradio app with profile 1 (default profile, the fastest but requires 16 GB of VRAM):
```bash
cd inference
python gradio_server.py --profile 1
```

To run the Gradio app with profile 3 (default profile, a bit slower and the model is quantized to 8 bits but requires 12 GB of VRAM):
```bash
cd inference
python gradio_server.py --profile 3
```

To run the Gradio app with less than 10 GB of VRAM  profile 4 (very slow as this will incur sequencial offloading):
```bash
cd inference
python gradio_server.py --profile 4
```

If some reason the system seems to be frozen you may be short in VRAM and your GPU is swapping inefficiently data between the RAM and the VRAM. Something consuming even less VRAM makes it faster, it is why I have added a profile 5 which has the minimum possible VRAM consumption:
```bash
cd inference
python gradio_server.py --profile 5
```


If you have a Linux based system / Windows WSL or  were able to install Triton on Windows, you can also turn on Pytorch compilation with '--compile' for a faster generation.  
```bash
cd inference
python gradio_server.py --profile 4 --compile
```
To install Triton on Windows: https://github.com/woct0rdho/triton-windows/releases/download/v3.1.0-windows.post8/triton-3.1.0-cp310-cp310-win_amd64.whl

Likewise if you were not able to install flash attention on Windows, you can force the application to use sdpa attention instead by using the '--sdpa' switch. Be aware that this may requires more VRAM
```bash
cd inference
python gradio_server.py --profile 4 --sdpa
```

You can try a new experimental turbo stage 2 with profile 1 (16 GB+ RAM) that makes stage two times faster. However it is not clear whether this has some impact on the quality of the generated song:
```bash
cd inference
python gradio_server.py --profile 1 --turbo-stage2
```

You may check the mmgp git homepage  (https://github.com/deepbeepmeep/mmgp)  if you want to design your own profiles.

### Other applications for the GPU Poors
If you enjoy this application, you will certainly appreciate these ones too:
- Hunyuan3D-2GP: https://github.com/deepbeepmeep/Hunyuan3D-2GP :\
A great image to 3D or text to 3D tool by the Tencent team. Thanks to mmgp it can run with less than 6 GB of VRAM

- HuanyuanVideoGP: https://github.com/deepbeepmeep/HunyuanVideoGP :\
One of the best open source Text to Video generator

- FluxFillGP: https://github.com/deepbeepmeep/FluxFillGP :\
One of the best inpainting / outpainting tools based on Flux that can run with less than 12 GB of VRAM.

- Cosmos1GP: https://github.com/deepbeepmeep/Cosmos1GP :\
This application include two models: a text to world generator and a image / video to world (probably the best open source image to video generator).

- OminiControlGP: https://github.com/deepbeepmeep/OminiControlGP :\
A flux derived image generator that will allow you to transfer an object of your choosing in a prompted scene. It is optimized to run with ony 6 GB of VRAM.

## News and Updates
* **2025.02.10 🔥**: V3.0 DeepBeepMeep: Added possibility to generate multiple songs per Genres prompt and to generate multiple Genres songs in a row based on the same lyrics. Added also a progression bar and an Abort button. You will need to update the transformers patch for the progression bar to work. I have also added an experimental turbo stage 2 that makes this stage two times faster (use the --turbo-stage2 switch). It will work with 16GB+ VRAM and may produce lesser quality songs.
* **2025.02.08 🔥**: V2.21 DeepBeepMeep: Thanks to olilanz for aligning infer.py with gradio server.py and addding code to reinforce robustness 
* **2025.02.06 🔥**: V2.2 DeepBeepMeep: forgot to remove test code that was slowing down profile 1 and 3
* **2025.02.06 🔥**: V2.1 DeepBeepMeep: 3 times faster with 12+ GB VRAM GPUs (requires Flash Attention 2) thanks to a new optimized transformers libary. You will need to reapply the patchtransformers.sh. Generating a 1 min song takes now only 4 minutes on a RTX 4090 ! Added also progression info in terminal to provide feedback (pending real progression bars).

* **2025.01.30 🔥**: V1.3 DeepBeepMeep: Added support for In Context Learning, now you can provide audio samples prompts to drive the song generation.
* **2025.01.30 🔥**: V1.2 DeepBeepMeep: Speed improvements for low VRAM profiles + patch for transformers library.
* **2025.01.29 🔥**: V1.1 DeepBeepMeep: GPU Poor version.
* **2025.01.26 🔥**: V1.0 We have released the **YuE** series.

<br>

# Installation instructions


Python 3.10 is recommended as some issues have been reported on python 3.12 and 3.13. Python 3.11 might work as well. 

##  1) Install source code
Make sure you have git-lfs installed (https://git-lfs.com)

```
git lfs install
git clone https://github.com/deepbeepmeep/YuEGP/

cd YuEGP/inference/
git clone https://huggingface.co/m-a-p/xcodec_mini_infer
```

## 2) Install torch and requirements
Create a Venv or use Conda and Install torch 2.5.1 with Cuda 12.4 :
```
pip install torch==2.5.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/test/cu124
```

Alternatively if you have an AMD GPU please do the following (many thanks to Hackey for sharing these install instructions): 
```
pip3 install torch torchaudio triton --index-url https://download.pytorch.org/whl/rocm6.2
TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL=1 python gradio_server.py --profile 1 --sdpa
```


Then install dependencies with the following command:

```
pip install -r requirements.txt
```

## 3) (optional) Install FlashAttention
For saving GPU memory, **FlashAttention 2 is recommended**. Without it, large sequence lengths will lead to out-of-memory (OOM) errors, especially on GPUs with limited memory. Install it using the following command:
```
pip install flash-attn --no-build-isolation
```

Before installing FlashAttention, ensure that your CUDA environment is correctly set up. 
For example, if you are using CUDA 12.4:
- If using a module system:
``` module load cuda12.4/toolkit/12.4.0 ```
- Or manually configure CUDA in your shell:

```
    export PATH=/usr/local/cuda-12.4/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda-12.4/lib64:$LD_LIBRARY_PATH
```


**As an alternative if you were unable to install Flash attention (usually a pain on Windows) you can use sdpa attention instead by adding the *--sdpa* switch when running the gradio server. However this may consume more VRAM.**


## 4) (optional) Transformers Patches for Low VRAM (< 10 GB of VRAM) and 2x faster genration with more than 16 GB of VRAM
If you have no choice but to use a low VRAM profile (profile 4 or profile 5), I am providing a patch for the transformers libray that should double the speed of the transformers libary (note this patch offers little little improvements on other profiles), this patch overwrites two files from the transformers libary. You can either copy and paste my 'transformers' folder in your venv or run the script below if the venv directory is just below the app directory:

Update: I have added another patch which double the speed of stage 2 of the generation process for all profiles and also triple the speed of stage 1 for profile 1 and 3 (16 GB VRAM +). You will need to install Flash Attention 2 for this second patch to work.

For Linux:
```
source patchtransformers.sh
```

For Windows:
```
patchtransformers.bat
```
## GPU Memory Usage and Sessions

Without the optimizations, YuE requires significant GPU memory for generating long sequences. 

If you have out of memory errors while a lot memory still seems to be free,  please try the following before lauching the app (many thanks to olilanz for this finding)  :  
```
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
```


Below are the recommended configurations:

- **For GPUs with 24GB memory or less**: Run **up to 2 sessions** concurrently to avoid out-of-memory (OOM) errors.
- **For full song generation** (many sessions, e.g., 4 or more): Use **GPUs with at least 80GB memory**. This can be achieved by combining multiple GPUs and enabling tensor parallelism.

To customize the number of sessions, the interface allows you to specify the desired session count. By default, the model runs **2 sessions** for optimal memory usage.

---


### Running the Script
Here’s a quick guide to help you generate music with **YuE** using 🤗 Transformers. Before running the code, make sure your environment is properly set up, and that all dependencies are installed.
In the following example, customize the `genres` and `lyrics` in the script, then execute it to generate a song with **YuE**.

Notice: Set `--run_n_segments` to the number of lyric sections if you want to generate a full song. Additionally, you can increase `--stage2_batch_size` based on your available GPU memory.

```bash
cd YuE/inference/
python infer.py \
    --stage1_model m-a-p/YuE-s1-7B-anneal-en-cot \
    --stage2_model m-a-p/YuE-s2-1B-general \
    --genre_txt prompt_examples/genre.txt \
    --lyrics_txt prompt_examples/lyrics.txt \
    --run_n_segments 2 \
    --stage2_batch_size 4 \
    --output_dir ./output \
    --cuda_idx 0 \
    --max_new_tokens 3000 
```

If you want to use audio prompt, enable `--use_audio_prompt`, and provide audio prompt:
```bash
cd YuE/inference/
python infer.py \
    --stage1_model m-a-p/YuE-s1-7B-anneal-en-icl \
    --stage2_model m-a-p/YuE-s2-1B-general \
    --genre_txt prompt_examples/genre.txt \
    --lyrics_txt prompt_examples/lyrics.txt \
    --run_n_segments 2 \
    --stage2_batch_size 4 \
    --output_dir ./output \
    --cuda_idx 0 \
    --max_new_tokens 3000 \
    --audio_prompt_path {YOUR_AUDIO_FILE} \
    --prompt_start_time 0 \
    --prompt_end_time 30 
```


---

### **Execution Time**
On an **H800 GPU**, generating 30s audio takes **150 seconds**.
On an **RTX 4090 GPU**, generating 30s audio takes approximately **360 seconds**.  

**Tips:**
1. `genres` should include details like instruments, genre, mood, vocal timbre, and vocal gender.
2. The length of `lyrics` segments and the `--max_new_tokens` value should be matched. For example, if `--max_new_tokens` is set to 3000, the maximum duration for a segment is around 30 seconds. Ensure your lyrics fit this time frame.
3. If using audio prompt，the duration around 30s will be fine.
---

### Notice
1. A suitable [Genre] tag consists of five components: genre, instrument, mood, gender, and timbre. All five should be included if possible, separated by spaces. The values of timbre should include "vocal" (e.g., "bright vocal").

2. Although our tags have an open vocabulary, we have provided the 200 most commonly used [tags](./wav_top_200_tags.json). It is recommended to select tags from this list for more stable results.

3. The order of the tags is flexible. For example, a stable genre control string might look like: "[Genre] inspiring female uplifting pop airy vocal electronic bright vocal vocal."

4. Additionally, we have introduced the "Mandarin" and "Cantonese" tags to distinguish between Mandarin and Cantonese, as their lyrics often share similarities.

## License Agreement

Creative Commons Attribution Non Commercial 4.0

---

## Citation

If you find our paper and code useful in your research, please consider giving a star :star: and citation :pencil: :)

```BibTeX
@misc{yuan2025yue,
  title={YuE: Open Music Foundation Models for Full-Song Generation},
  author={Ruibin Yuan and Hanfeng Lin and Shawn Guo and Ge Zhang and Jiahao Pan and Yongyi Zang and Haohe Liu and Xingjian Du and Xeron Du and Zhen Ye and Tianyu Zheng and Yinghao Ma and Minghao Liu and Lijun Yu and Zeyue Tian and Ziya Zhou and Liumeng Xue and Xingwei Qu and Yizhi Li and Tianhao Shen and Ziyang Ma and Shangda Wu and Jun Zhan and Chunhui Wang and Yatian Wang and Xiaohuan Zhou and Xiaowei Chi and Xinyue Zhang and Zhenzhu Yang and Yiming Liang and Xiangzhou Wang and Shansong Liu and Lingrui Mei and Peng Li and Yong Chen and Chenghua Lin and Xie Chen and Gus Xia and Zhaoxiang Zhang and Chao Zhang and Wenhu Chen and Xinyu Zhou and Xipeng Qiu and Roger Dannenberg and Jiaheng Liu and Jian Yang and Stephen Huang and Wei Xue and Xu Tan and Yike Guo}, 
  howpublished={\url{https://github.com/multimodal-art-projection/YuE}},
  year={2025},
  note={GitHub repository}
}
```

---

**Experience accelerated music generation across all GPU ranges!** 🎵🚀
