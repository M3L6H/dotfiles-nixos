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
              readchar
            ];
          }
          ''
            import argparse
            import os
            import random
            import shutil

            import pyfiglet
            import readchar


            def dice(sides=6):
                os.system('cls' if os.name == 'nt' else 'clear')

                num = random.randint(1, int(sides))
                ascii_art = pyfiglet.figlet_format(str(num))

                terminal_size = shutil.get_terminal_size()
                lines = ascii_art.splitlines()
                before = (terminal_size.lines - len(lines)) // 2
                for _ in range(before):
                    print()
                for line in lines:
                    print(line.center(terminal_size.columns))


            def main():
                parser = argparse.ArgumentParser(description='Terminal-based die')
                parser.add_argument(
                    'sides',
                    type=int,
                    default=6,
                    nargs='?',
                    help="Sides of the dice")
                args = vars(parser.parse_args())

                while True:
                    dice(**args)
                    char = readchar.readchar()

                    if char == 'q':
                        return


            if __name__ == '__main__':
                main()
          '';
    in
    {
      home.packages = [ dice ];
    };
}
