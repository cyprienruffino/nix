{ pkgs, ... }:

{
  home.packages = [
    (pkgs.python3.withPackages (ps: with ps; [
      pillow
      opencv4
      python-ffmpeg
      scipy
      scikit-image
      tqdm
      llm
      llm-anthropic
    ]))
  ];
}
