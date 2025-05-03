import os
from pathlib import Path

def generate_exports():
    root_dir = Path(__file__).parent
    lib_dir = root_dir / 'lib'

    print("\n######################## \n")
    print("Generating exports... \n")

    # Walk through all directories in lib
    for dirpath, dirnames, filenames in os.walk(lib_dir):
        # Skip if no dart files in this directory
        dart_files = [f for f in filenames if f.endswith('.dart') and f != 'exports.dart']

        # Debug Prints

        # print(dirpath)
        # print(dirnames)
        # print(filenames)

        exports_content = []
        filename = dirpath.split('\\')[-1] + '.dart' # {directory}.dart

        if filename == 'lib.dart':
            filename = 'imports.dart'
        else:
            for file in dart_files:
                if file == f'{dirpath.split("\\")[-1]}.dart': # {directory}.dart
                    continue

                export_statement = f'export "{file}";'
                exports_content.append(export_statement)

        for directory in dirnames:
            export_statement = f'export "{directory}/{directory}.dart";'
            exports_content.append(export_statement)

        # Create the exports.dart file in the current directory
        exports_file = os.path.join(dirpath, filename)

        # Write the export statements to the file
        with open(exports_file, 'w') as f:
            f.write('\n'.join(exports_content))

        print(f'Created {exports_file}')

    print("\nFinished generating exports.")
    print("\n######################## \n")

if __name__ == '__main__':
    generate_exports()
