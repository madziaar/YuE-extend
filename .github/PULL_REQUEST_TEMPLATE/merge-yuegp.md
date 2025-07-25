# Merge YuEGP into YuE-extend

## Summary
This PR merges the codebase from [madziaar/YuEGP](https://github.com/madziaar/YuEGP) into the current repository (YuE-extend). The goal is to unify features for full-song generation and mp3 extension, exllama integration, and GPU-poor optimization enhancements.

## Changes
- All files and directories from YuEGP have been integrated.
- Conflicting files have been resolved and merged appropriately.
- Dependencies (`requirements.txt`) have been merged with both ExLlamaV2 and GPU-Poor optimizations.
- Documentation has been updated to reflect combined functionality.
- Added GPU-Poor performance profiles supporting 6GB+ VRAM configurations.
- Integrated transformers patches for improved low-VRAM performance.
- Added assets, logos, and tokenizer files from YuEGP.

## Testing
- [ ] Verified that all tests pass after merge.
- [ ] Validated core functionalities from both codebases.
- [ ] Confirmed compatibility of dependencies.
- [ ] Tested GPU-Poor profiles on different VRAM configurations.
- [ ] Verified ExLlamaV2 integration still works correctly.

## Key Features Added
- **GPU-Poor Optimization**: Performance profiles for 6GB, 12GB, 16GB+ VRAM configurations
- **Transformers Patches**: 2x faster generation for low VRAM profiles  
- **Enhanced Gradio Interface**: Multiple model support with profile selection
- **In-Context Learning**: Audio prompt support in addition to text prompts
- **Progressive Generation**: Progress bars and abort functionality
- **Experimental Turbo Mode**: 2x faster stage 2 processing for high-VRAM setups

## Integration Points
Reviewers should focus on:
- Integration between ExLlamaV2 and GPU-Poor optimization paths
- Dependency compatibility between mmgp and existing packages
- Functionality overlap between inference approaches
- Documentation accuracy for both optimization approaches

## Additional Notes
- Users can now choose between high-performance (ExLlamaV2) and low-VRAM (GPU-Poor) optimization
- Both approaches support MP3 extension capabilities
- See updated README.md for comprehensive installation and usage instructions
- Transformers patches are optional but recommended for low-VRAM users

---

Closes # (if there's an issue tracking this merge)
