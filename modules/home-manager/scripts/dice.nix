{
  pkgs,
  ...
}:
{
  config =
    let
      dice =
        pkgs.writers.writePython3Bin "dice"
          {
            # Declare required Python libraries here
            libraries = with pkgs.python3Packages; [
              pyfiglet
            ];
          }
          ''
            import os
            import random
            import shutil
            import sys

            import pyfiglet


            def dice(sides=6):
                os.system("cls" if os.name == "nt" else "clear")

                num = random.randint(1, int(sides))
                ascii_art = pyfiglet.figlet_format(str(num))

                terminal_columns = shutil.get_terminal_size().columns
                for line in ascii_art.splitlines():
                    print(line.center(terminal_columns))


            def main():
                dice(*sys.argv[1:])


            if __name__ == "__main__":
                main()
          '';
    in
    {
      home.packages = [ dice ];
    };
}
